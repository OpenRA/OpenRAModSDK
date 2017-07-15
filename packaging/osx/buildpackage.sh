#!/bin/bash
# OpenRA packaging script for macOS

command -v make >/dev/null 2>&1 || { echo >&2 "The OpenRA mod template requires make."; exit 1; }
command -v python >/dev/null 2>&1 || { echo >&2 "The OpenRA mod template requires python."; exit 1; }
command -v curl >/dev/null 2>&1 || { echo >&2 "The OpenRA mod template requires curl."; exit 1; }

if [ $# -ne "2" ]; then
	echo "Usage: `basename $0` tag outputdir"
	exit 1
fi

PACKAGING_DIR=$(python -c "import os; print(os.path.dirname(os.path.realpath('$0')))")
TEMPLATE_ROOT="${PACKAGING_DIR}/../../"

# shellcheck source=mod.config
. "${TEMPLATE_ROOT}/mod.config"

if [ -f "${TEMPLATE_ROOT}/user.config" ]; then
	# shellcheck source=user.config
	. "${TEMPLATE_ROOT}/user.config"
fi

if [ "${INCLUDE_DEFAULT_MODS}" = "True" ]; then
	echo "Cannot generate installers while INCLUDE_DEFAULT_MODS is enabled."
	echo "Make sure that this setting is disabled in both your mod.config and user.config."
	exit 1
fi

# Set the working dir to the location of this script
cd "${PACKAGING_DIR}"

TAG="$1"
OUTPUTDIR="$2"
BUILTDIR="$(pwd)/build"
PACKAGING_OSX_APP_NAME="OpenRA - ${PACKAGING_DISPLAY_NAME}.app"

modify_plist() {
	sed "s|$1|$2|g" "$3" > "$3.tmp" && mv "$3.tmp" "$3"
}

echo "Building launcher"
curl -s -L  -o "${PACKAGING_OSX_LAUNCHER_TEMP_ARCHIVE_NAME}" -O "${PACKAGING_OSX_LAUNCHER_SOURCE}" || exit 3

unzip -qq -d "${BUILTDIR}" "${PACKAGING_OSX_LAUNCHER_TEMP_ARCHIVE_NAME}"
rm "${PACKAGING_OSX_LAUNCHER_TEMP_ARCHIVE_NAME}"

modify_plist "{DEV_VERSION}" "${TAG}" "${BUILTDIR}/OpenRA.app/Contents/Info.plist"
modify_plist "{FAQ_URL}" "${PACKAGING_FAQ_URL}" "${BUILTDIR}/OpenRA.app/Contents/Info.plist"
echo "Building core files"

pushd ${TEMPLATE_ROOT} > /dev/null

if [ ! -f "${ENGINE_DIRECTORY}/Makefile" ]; then
	echo "Required engine files not found."
	echo "Run \`make\` in the mod directory to fetch and build the required files, then try again.";
	exit 1
fi

make version VERSION="${TAG}"

pushd ${ENGINE_DIRECTORY} > /dev/null
make osx-dependencies
make core SDK="-sdk:4.5"
make install-engine gameinstalldir="/Contents/Resources/" DESTDIR="${BUILTDIR}/OpenRA.app"
make install-common-mod-files gameinstalldir="/Contents/Resources/" DESTDIR="${BUILTDIR}/OpenRA.app"
popd > /dev/null
popd > /dev/null

# Add mod files
cp -r "${TEMPLATE_ROOT}/mods/"* "${BUILTDIR}/OpenRA.app/Contents/Resources/mods"
cp "${MOD_ID}.icns" "${BUILTDIR}/OpenRA.app/Contents/Resources/"

pushd "${BUILTDIR}" > /dev/null
mv "OpenRA.app" "${PACKAGING_OSX_APP_NAME}"

# Copy macOS specific files
modify_plist "{MOD_ID}" "${MOD_ID}" "${PACKAGING_OSX_APP_NAME}/Contents/Info.plist"
modify_plist "{MOD_NAME}" "${PACKAGING_DISPLAY_NAME}" "${PACKAGING_OSX_APP_NAME}/Contents/Info.plist"
modify_plist "{JOIN_SERVER_URL_SCHEME}" "openra-${MOD_ID}-${TAG}" "${PACKAGING_OSX_APP_NAME}/Contents/Info.plist"

echo "Packaging zip archive"

zip "${PACKAGING_INSTALLER_NAME}-${TAG}" -r -9 "${PACKAGING_OSX_APP_NAME}" --quiet --symlinks
mv "${PACKAGING_INSTALLER_NAME}-${TAG}.zip" ${OUTPUTDIR}

popd > /dev/null

# Clean up
rm -rf "${BUILTDIR}"
