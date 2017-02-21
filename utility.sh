#!/bin/sh

# Don't edit below this line
MODLAUNCHER=$(python -c "import os; print(os.path.realpath('$0'))")
MOD_ROOT=$(dirname "$MODLAUNCHER")
ENGINE_ROOT="$MOD_ROOT/engine"
UTILITY="$ENGINE_ROOT/OpenRA.Utility.exe"

test -f "$UTILITY" || { echo "Please build the engine first!" ; exit 1 ; }
mono --debug "$UTILITY" "Engine.ModSearchPaths=$ENGINE_ROOT/mods,$MOD_ROOT/mods" "$@"
