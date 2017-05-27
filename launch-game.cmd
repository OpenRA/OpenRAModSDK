@echo off
title OpenRA
FOR /F "tokens=1,2 delims==" %%A IN (mod.config) DO (set %%A=%%B)

set TEMPLATE_LAUNCHER=%0
set MOD_SEARCH_PATHS=%~dp0mods
if %INCLUDE_DEFAULT_MODS% neq "True" goto launch
set MOD_SEARCH_PATHS=%MOD_SEARCH_PATHS%,./mods

:launch
cd engine
OpenRA.Game.exe Game.Mod=%MOD_ID% Engine.LaunchPath="%TEMPLATE_LAUNCHER%" "Engine.ModSearchPaths=%MOD_SEARCH_PATHS%"  "%*"
if %errorlevel% neq 0 goto crashdialog
cd ..
exit /b
:crashdialog
echo ----------------------------------------
echo OpenRA has encountered a fatal error.
echo   * Log Files are available in Documents\OpenRA\Logs
echo   * FAQ is available at https://github.com/OpenRA/OpenRA/wiki/FAQ
echo ----------------------------------------
pause