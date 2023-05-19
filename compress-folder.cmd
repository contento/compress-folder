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

set "BACKUP_PATH=c:\backup"
set "COMPRESSOR_NAME=7Z"
set "COMPRESSOR_EXT=7z"
set "PARTIAL_COMPRESSOR_PATH=7-zip\%COMPRESSOR_NAME%.exe"
set "COMPRESSOR="

for %%I in (c:\Util %ProgramFiles% %ProgramFiles(x86)% %ProgramW6432%) do (
    if exist "%%I\%PARTIAL_COMPRESSOR_PATH%" (
        set "COMPRESSOR=%%I\%PARTIAL_COMPRESSOR_PATH%"
        goto compressorFound
    )
)

echo Error: '%COMPRESSOR_NAME%' does not exist!
exit /b

:compressorFound
for /f "tokens=2,3,4 delims=/ " %%I in ("%date%") do (
    set "YYYY=%%K"
    set "MM=%%I"
    set "DD=%%J"
)

for /f "tokens=1,2,3 delims=:." %%I in ("%time: =0%") do (
    set "H=%%I"
    set "M=%%J"
    set "S=%%K"
)

for /F "delims=\" %%I in ("%CD%") do set "FOLDER_NAME=%%~nxi"
set "FILE_PATH=%BACKUP_PATH%\%FOLDER_NAME%"
set "FILENAME=%FILE_PATH%\%FOLDER_NAME%_%YYYY%-%MM%-%DD%_%H%.%M%.%S%.%COMPRESSOR_EXT%"
set "EXE_FILENAME=%FILE_PATH%\%FOLDER_NAME%_%YYYY%-%MM%-%DD%_%H%.%M%.%S%.exe"

:: create backup folder
if not exist "%FILE_PATH%" mkdir "%FILE_PATH%"

echo Compressing 
echo  Folder: "%CD%"
echo  To:     "%FILENAME%" 
echo ----------------------------------

if /i "%~1" == "--dev" (
    call :createDevFileLists
    "%COMPRESSOR%" a -mx9 -ir@"%INCLUSIONS_FILENAME%" "%FILENAME%" -xr@"%EXCLUSIONS_FILENAME%"
) else (
    "%COMPRESSOR%" a -mx9 -ir!* "%FILENAME%"
)

echo "%FILENAME%" created 

if /i "%~2" == "--pause" pause

exit /b

:createDevFileLists
set "INCLUSIONS_FILENAME=%TEMP%\compress-folder.dev.i.lst"
set "EXCLUSIONS_FILENAME=%TEMP%\compress-folder.dev.x.lst"

:: Inclusions
for %%I in (
    asax asmx aspx bat bdcm bmp cer cmd config c cpp cs css cshtml csproj csv dbml dbp
    doc docx eap *config edmx eot gif gitignore gitkeep h htm* ico ini ipynb jpg js json
    jmx licx license manifest map md mpp nuspec Pipfile pk* png psproj ps*1 pfx ppt pptx
    pubxml puml pvk py resx rdl rdlc rptproj settings shfbproj sql sqlproj svg targets tif
    ts tt ttf txt pdf sln svc tfignore vbs woff* xls xlsx xml xaml xsd xsl* yaml yarn.lock
) do (
    echo *%%I>>"%INCLUSIONS_FILENAME%"
)

:: Exclusions
for %%I in (
    bin dist *.dotsettings .git lib logs obj node_modules packages reports *.suo .svn *.user
    *.vs venv
) do (
    echo %%I>>"%EXCLUSIONS_FILENAME%"
)

exit /b
