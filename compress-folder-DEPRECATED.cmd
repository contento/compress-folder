@echo off
:: compress-folder.cmd
:: 7zip current folder.
::
:: * Syntax:
:: compress-folder [--dev] [--pause]
::  - dev: create 7zip file based on inclusion/exclusion lists.
::  - pause: use `pause` command.
::
:: https://github.com/contento/compress-folder.git
:: Author : Gonzalo Contento
:: Version: 2.0.0
:: Date   : 2023-05-19

setlocal enabledelayedexpansion enableextensions

set BACKUP_PATH=c:\backup\compressed
set COMPRESSOR_NAME=7Z
set COMPRESSOR_EXT=7z
set PARTIAL_COMPRESSOR_PATH=7-zip\%COMPRESSOR_NAME%.exe
set COMPRESSOR=

set INCLUSIONS_FILENAME="%~dp0\compress-folder.dev.i.lst"
set EXCLUSIONS_FILENAME="%~dp0\compress-folder.dev.x.lst"

for %%I in ("c:\Util" "%ProgramFiles%" "%ProgramFiles(x86)%" "%ProgramW6432%") do (
    if exist "%%I\%PARTIAL_COMPRESSOR_PATH%" (
        set COMPRESSOR="%%I\%PARTIAL_COMPRESSOR_PATH%"
        goto compressorFound
    )
)

echo Error: '%COMPRESSOR_NAME%' does not exist!
exit /b

:compressorFound
for /f "tokens=2,3,4 delims=/ " %%I in ("%date%") do (
    set YYYY=%%K
    set MM=%%I
    set DD=%%J
)

for /f "tokens=1,2,3 delims=:." %%I in ("%time: =0%") do (
    set H=%%I
    set M=%%J
    set S=%%K
)

echo "_%YYYY%-%MM%-%DD%_"
echo "It doesn't work because of the date format."
goto :processPause

for /F "delims=\" %%I in ("%CD%") do set FOLDER_NAME=%%~nxI

set FILE_PATH=%BACKUP_PATH%\%FOLDER_NAME%
set FILENAME=%FILE_PATH%\%FOLDER_NAME%_%YYYY%-%MM%-%DD%_%H%.%M%.%S%.%COMPRESSOR_EXT%

:: create backup folder
if not exist "%FILE_PATH%" mkdir "%FILE_PATH%"

echo Compressing
echo  Folder: "%CD%"
echo  To:     "%FILENAME%"
echo ----------------------------------

if /i "%~1" == "--dev" (
    "%COMPRESSOR%" a -mx9 -ir@"%INCLUSIONS_FILENAME%" "%FILENAME%" -xr@"%EXCLUSIONS_FILENAME%"
) else (
   "%COMPRESSOR%" a -mx9 "%FILENAME%"
)

echo "%FILENAME%" created

:processPause
:: Loop through all the arguments
:argloop
if "%~1"=="" goto endloop
if /i "%~1"=="--pause" pause
shift
goto argloop
:endloop

exit /b
