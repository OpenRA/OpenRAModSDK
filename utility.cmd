@echo off

FOR /F "tokens=1,2 delims==" %%A IN (mod.config) DO (set %%A=%%B)

title OpenRA.Utility.exe %MOD_ID%

set MOD_SEARCH_PATHS=%~dp0mods
if %INCLUDE_DEFAULT_MODS% neq "True" goto start
set MOD_SEARCH_PATHS=%MOD_SEARCH_PATHS%,./mods

:start
cd engine

:loop
echo.
echo ----------------------------------------
echo.
echo Enter a utility command or --exit to exit.
echo Press enter to view a list of valid utility commands.
echo.

set /P command=Please enter a command: OpenRA.Utility.exe %MOD_ID% 
if /I "%command%" EQU "--exit" (exit)
echo.
echo ----------------------------------------
echo.
echo OpenRA.Utility.exe %MOD_ID% %command%
call OpenRA.Utility.exe %MOD_ID% %command%
goto loop