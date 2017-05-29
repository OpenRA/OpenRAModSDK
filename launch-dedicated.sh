#!/bin/sh
# example launch script, see https://github.com/OpenRA/OpenRA/wiki/Dedicated for details

# Usage:
#  $ ./launch-dedicated.sh # Launch a dedicated server with default settings
#  $ Mod="d2k" ./launch-dedicated.sh # Launch a dedicated server with default settings but override the Mod
#  Read the file to see which settings you can override

TEMPLATE_LAUNCHER=$(python -c "import os; print(os.path.realpath('$0'))")
TEMPLATE_ROOT=$(dirname "${TEMPLATE_LAUNCHER}")
. "${TEMPLATE_ROOT}/mod.config"

MOD_SEARCH_PATHS="${TEMPLATE_ROOT}/mods"
if [ "${INCLUDE_DEFAULT_MODS}" = "True" ]; then
	MOD_SEARCH_PATHS="${TEMPLATE_PATHS},./mods"
fi

NAME="${Name:-"Dedicated Server"}"
LAUNCH_MOD="${Mod:-"${MOD_ID}"}"
LISTEN_PORT="${ListenPort:-"1234"}"
EXTERNAL_PORT="${ExternalPort:-"1234"}"
ADVERTISE_ONLINE="${AdvertiseOnline:-"True"}"
ENABLE_SINGLE_PLAYER="${EnableSingleplayer:-"False"}"
PASSWORD="${Password:-""}"

cd engine

while true; do
     MOD_SEARCH_PATHS="${MOD_SEARCH_PATHS}" mono --debug OpenRA.Server.exe Game.Mod="${LAUNCH_MOD}" \
     Server.Name="${NAME}" Server.ListenPort="${LISTEN_PORT}" Server.ExternalPort="${EXTERNAL_PORT}" \
     Server.AdvertiseOnline="${ADVERTISE_ONLINE}" \
     Server.EnableSingleplayer="${ENABLE_SINGLE_PLAYER}" Server.Password="${PASSWORD}"
done
