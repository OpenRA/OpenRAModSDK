#!/bin/sh
# Usage:
#  $ ./utility.sh # Launch the OpenRA.Utility with the default mod
#  $ Mod="d2k" ./launch-utility.sh # Launch a dedicated server with a specific mod

TEMPLATE_LAUNCHER=$(python -c "import os; print(os.path.realpath('$0'))")
TEMPLATE_ROOT=$(dirname "${TEMPLATE_LAUNCHER}")
. "${TEMPLATE_ROOT}/mod.config"

MOD_SEARCH_PATHS="${TEMPLATE_ROOT}/mods"
if [ "${INCLUDE_DEFAULT_MODS}" = "True" ]; then
	MOD_SEARCH_PATHS="${TEMPLATE_PATHS},./mods"
fi

LAUNCH_MOD="${Mod:-"${MOD_ID}"}"

cd engine
MOD_SEARCH_PATHS="${MOD_SEARCH_PATHS}" mono --debug OpenRA.Utility.exe "${LAUNCH_MOD}" "$@"
