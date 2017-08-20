#!/bin/bash
# OpenRA packaging script for a platform independent .zip

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

LAUNCHER_LIBS="-r:System.dll -r:System.Drawing.dll -r:System.Windows.Forms.dll -r:${BUILTDIR}/OpenRA.Game.exe"

mkdir "${BUILTDIR}"

echo "Building core files"

pushd "${TEMPLATE_ROOT}" > /dev/null

if [ ! -f "${ENGINE_DIRECTORY}/Makefile" ]; then
	echo "Required engine files not found."
	echo "Run \`make\` in the mod directory to fetch and build the required files, then try again.";
	exit 1
fi

make version VERSION="${TAG}"

pushd "${ENGINE_DIRECTORY}" > /dev/null
SRC_DIR="$(pwd)"
make all-dependencies
make core SDK="-sdk:4.5"
make install-engine gameinstalldir="" DESTDIR="${BUILTDIR}"
make install-common-mod-files gameinstalldir="" DESTDIR="${BUILTDIR}"
popd > /dev/null
popd > /dev/null

# Add mod files
cp -r "${TEMPLATE_ROOT}/mods/"* "${BUILTDIR}/mods"

# Add mod files
cp -r "${TEMPLATE_ROOT}/mods/"* "${BUILTDIR}/mods"
cp "${TEMPLATE_ROOT}/icons/${MOD_ID}.ico" "${BUILTDIR}"
cp "${SRC_DIR}/OpenRA.Game.exe.config" "${BUILTDIR}"
cp "Eluant.dll.config" "${BUILTDIR}/"

echo "Compiling Windows launcher"
sed "s|DISPLAY_NAME|${PACKAGING_DISPLAY_NAME}|" "${SRC_DIR}/packaging/windows/WindowsLauncher.cs.in" | sed "s|MOD_ID|${MOD_ID}|" | sed "s|FAQ_URL|${PACKAGING_FAQ_URL}|" > "${BUILTDIR}/WindowsLauncher.cs"
mcs -sdk:4.5 "${BUILTDIR}/WindowsLauncher.cs" -warn:4 -codepage:utf8 -warnaserror -out:"${BUILTDIR}/${PACKAGING_WINDOWS_LAUNCHER_NAME}.exe" -t:winexe ${LAUNCHER_LIBS} -win32icon:"${BUILTDIR}/${MOD_ID}.ico"
rm "${BUILTDIR}/WindowsLauncher.cs"
mono "${SRC_DIR}/fixheader.exe" "${BUILTDIR}/${PACKAGING_WINDOWS_LAUNCHER_NAME}.exe" > /dev/null

pushd "${BUILTDIR}" > /dev/null

echo "Packaging zip archive"

zip "${PACKAGING_INSTALLER_NAME}-${TAG}" -r -9 * --quiet --symlinks
mv "${PACKAGING_INSTALLER_NAME}-${TAG}.zip" "${OUTPUTDIR}"

popd > /dev/null

# Clean up
#rm -rf "${BUILTDIR}"
