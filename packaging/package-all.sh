#!/bin/bash

if [ $# -ne "2" ]; then
    echo "Usage: `basename $0` version outputdir"
    exit 1
fi

PACKAGING_DIR=$(python -c "import os; print(os.path.dirname(os.path.realpath('$0')))")
TEMPLATE_ROOT="${PACKAGING_DIR}/../"

# shellcheck source=mod.config
. "${TEMPLATE_ROOT}/mod.config"

if [ -f "${TEMPLATE_ROOT}/user.config" ]; then
	# shellcheck source=user.config
	. "${TEMPLATE_ROOT}/user.config"
fi

function build()
{
	TAG="$1"
	OUTPUTDIR="$2"
	DIRECTORY="$3"
	DISPLAYNAME="$4"
	ENABLED="$5"

	if [ "${ENABLED^^}" == "FALSE" ]; then
		echo "$DISPLAYNAME package build is disabled."
		return
	fi

	pushd $DIRECTORY >/dev/null
	echo "Building $DISPLAYNAME package"
	./buildpackage.sh "${TAG}" "${OUTPUTDIR}"
	if [ $? -ne 0 ]; then
	    echo "$DISPLAYNAME package build failed."
	fi
	popd >/dev/null
}


TAG="$1"
OUTPUTDIR="$2"

# Set the working dir to the location of this script
cd "$(dirname $0)"

build "${TAG}" "${OUTPUTDIR}" "windows" "Windows" "${PACKAGING_WINDOWS_ENABLED}"
build "${TAG}" "${OUTPUTDIR}" "osx" "macOS" "${PACKAGING_OSX_ENABLED}"
build "${TAG}" "${OUTPUTDIR}" "zip" ".zip" "${PACKAGING_ZIP_ENABLED}"

echo "Package builds done."
