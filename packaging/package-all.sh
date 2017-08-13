#!/bin/bash
set -e

if [ $# -ne "1" ]; then
    echo "Usage: `basename $0` version"
    exit 1
fi

command -v python >/dev/null 2>&1 || { echo >&2 "The OpenRA mod template requires python."; exit 1; }
OUTPUTDIR=$(python -c "import os; print(os.path.realpath('.'))")

# Set the working dir to the location of this script
cd "$(dirname $0)"

pushd windows >/dev/null
echo "Building Windows package"
./buildpackage.sh "$1" "$OUTPUTDIR"
if [ $? -ne 0 ]; then
    echo "Windows package build failed."
fi
popd >/dev/null

pushd osx >/dev/null
echo "Building macOS package"
./buildpackage.sh "$1" "$OUTPUTDIR"
if [ $? -ne 0 ]; then
    echo "macOS package build failed."
fi
popd >/dev/null

echo "Package build done."
