#!/bin/bash
set -e

if [ $# -ne "2" ]; then
    echo "Usage: `basename $0` version outputdir"
    exit 1
fi

command -v python >/dev/null 2>&1 || { echo >&2 "The OpenRA mod template requires python."; exit 1; }
command -v make >/dev/null 2>&1 || { echo >&2 "The OpenRA mod template requires make."; exit 1; }
command -v curl >/dev/null 2>&1 || { echo >&2 "The OpenRA mod template requires curl."; exit 1; }
command -v makensis >/dev/null 2>&1 || { echo >&2 "The OpenRA mod template requires makensis."; exit 1; }

# Set the working dir to the location of this script
cd "$(dirname $0)"

pushd windows >/dev/null
echo "Building Windows package"
./buildpackage.sh "$1" "$2"
if [ $? -ne 0 ]; then
    echo "Windows package build failed."
fi
popd >/dev/null

pushd osx >/dev/null
echo "Building macOS package"
./buildpackage.sh "$1" "$2"
if [ $? -ne 0 ]; then
    echo "macOS package build failed."
fi
popd >/dev/null

echo "Package build done."
