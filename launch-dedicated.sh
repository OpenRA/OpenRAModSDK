#!/bin/sh
# example launch script, see https://github.com/OpenRA/OpenRA/wiki/Dedicated for details

# Usage:
#  $ ./launch-dedicated.sh # Launch a dedicated server with default settings
#  $ Mod="d2k" ./launch-dedicated.sh # Launch a dedicated server with default settings but override the Mod
#  Read the file to see which settings you can override

TEMPLATE_LAUNCHER=$(python -c "import os; print(os.path.realpath('$0'))")
TEMPLATE_ROOT=$(dirname "${TEMPLATE_LAUNCHER}")
source ${TEMPLATE_ROOT}/mod.config

MOD_SEARCH_PATHS="${TEMPLATE_ROOT}/mods"
if [ "${INCLUDE_DEFAULT_MODS}" = "True" ]; then
	MOD_SEARCH_PATHS="${TEMPLATE_PATHS},./mods"
fi

LAUNCH_MOD="${Mod:-"${MOD_ID}"}"

Name="${Name:-"Dedicated Server"}"
Mod="${Mod:-"${MOD_ID}"}"
ListenPort="${ListenPort:-"1234"}"
ExternalPort="${ExternalPort:-"1234"}"
AdvertiseOnline="${AdvertiseOnline:-"True"}"
EnableSingleplayer="${EnableSingleplayer:-"False"}"
Password="${Password:-""}"

cd engine
while true; do
     MOD_SEARCH_PATHS="${MOD_SEARCH_PATHS}" mono --debug OpenRA.Server.exe Game.Mod=$Mod \
     Server.Name="$Name" Server.ListenPort=$ListenPort Server.ExternalPort=$ExternalPort \
     Server.AdvertiseOnline=$AdvertiseOnline \
     Server.EnableSingleplayer=$EnableSingleplayer Server.Password=$Password
done
