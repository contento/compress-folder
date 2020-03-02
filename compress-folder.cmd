@echo off
:: compress-folder.cmd
:: 7zip current folder.
::
:: * Syntax:
:: compress-folder [--dev]
::  - dev: create 7zip file based on inclusion/exclusion lists.
::
:: https://github.com/contento/compress-folder.git
:: Author : Gonzalo Contento
:: Version: 1.0.0
:: Date   : 2017-08-29

rem.-- Prepare the Command Processor
SETLOCAL ENABLEEXTENSIONS

:: Replace with your own folder or create a symbolic link
set BACKUP_PATH=c:\backup

:setCompressor
:: Set your own Compressor parameters here!
set COMPRESSOR_NAME=7Z
set COMPRESSOR_EXT=7z
set PARTIAL_COMPRESSOR_PATH=7-zip\%COMPRESSOR_NAME%.exe

:: Look for compressor: Try Util and all 'Program Files' environmental variables
set COMPRESSOR=c:\Util\%PARTIAL_COMPRESSOR_PATH%
if not exist "%COMPRESSOR%" set COMPRESSOR=%ProgramFiles%\%PARTIAL_COMPRESSOR_PATH%
if not exist "%COMPRESSOR%" set COMPRESSOR=%ProgramFiles(x86)%\%PARTIAL_COMPRESSOR_PATH%
if not exist "%COMPRESSOR%" set COMPRESSOR=%ProgramW6432%\%PARTIAL_COMPRESSOR_PATH%
if not exist "%COMPRESSOR%" (
    echo Error: '%COMPRESSOR_NAME%' does not exist!
    pause
    goto:eof
)

:getTargetFilename
:: Get Current Date and Time
for /f "tokens=2,3,4 delims=/ " %%i in ('echo %date%') do (
    set YYYY=%%k
    set MM=%%i
    set DD=%%j
)
for /f "tokens=1,2,3 delims=:." %%i in ('echo %time: =0%') do (
  	set H=%%i
	set M=%%j
	set S=%%k
)

:: Get Current Folder Name, Build File Path
for /F "delims=\" %%i in ('echo %CD%') do set FOLDER_NAME=%%~nxi
    
set FILE_PATH=%BACKUP_PATH%\%FOLDER_NAME%
set FILENAME=%FILE_PATH%\%FOLDER_NAME%_%YYYY%-%MM%-%DD%_%H%.%M%.%S%.%COMPRESSOR_EXT%
set EXE_FILENAME=%FILE_PATH%\%FOLDER_NAME%_%YYYY%-%MM%-%DD%_%H%.%M%.%S%.exe

:: create backup folder
md "%FILE_PATH%" 2> nul

:compress
:: Do it
echo Compressing 
echo.  Folder: "%CD%"
echo.  To:     "%FILENAME%" 
echo ---------------------------------------------------------------------------
    
set THIS_BATCH_PATH=%~d0%~p0

if "%1p"=="--devp" (
    goto :dev
)

if "%1p"=="p" (
    goto :all
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Compress all
:all
"%COMPRESSOR%" a -mx9 -ir!* "%FILENAME%" 
goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Compress based on dev list of inclusions and exclusions
:dev
call:createDevFileLists

echo. "%COMPRESSOR%" a -mx9 -ir@"%INCLUSIONS_FILENAME%" "%FILENAME%" -xr@"%EXCLUSIONS_FILENAME%"
"%COMPRESSOR%" a -mx9 -ir@"%INCLUSIONS_FILENAME%" "%FILENAME%" -xr@"%EXCLUSIONS_FILENAME%"
goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Got here, then go to the end of file
goto:eof

:end
echo. "%FILENAME%" created & pause
    
goto:eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::Helpers
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:createDevFileLists
set INCLUSIONS_FILENAME=%TEMP%\compress-folder.dev.i.lst
set EXCLUSIONS_FILENAME=%TEMP%\compress-folder.dev.x.lst

:: Inclusions
echo *.asax          > %INCLUSIONS_FILENAME% 
echo *.asmx         >> %INCLUSIONS_FILENAME%
echo *.aspx         >> %INCLUSIONS_FILENAME%
echo *.bat          >> %INCLUSIONS_FILENAME%
echo *.bdcm         >> %INCLUSIONS_FILENAME% 
echo *.bmp          >> %INCLUSIONS_FILENAME%
echo *.cer          >> %INCLUSIONS_FILENAME% 
echo *.cmd          >> %INCLUSIONS_FILENAME%
echo *.config       >> %INCLUSIONS_FILENAME%
echo *.c            >> %INCLUSIONS_FILENAME%
echo *.cpp          >> %INCLUSIONS_FILENAME% 
echo *.cs           >> %INCLUSIONS_FILENAME% 
echo *.css          >> %INCLUSIONS_FILENAME%
echo *.cshtml       >> %INCLUSIONS_FILENAME%
echo *.csproj       >> %INCLUSIONS_FILENAME% 
echo *.dbml         >> %INCLUSIONS_FILENAME% 
echo *.dbp          >> %INCLUSIONS_FILENAME%
echo *.doc          >> %INCLUSIONS_FILENAME%
echo *.docx         >> %INCLUSIONS_FILENAME%
echo *.eap          >> %INCLUSIONS_FILENAME%
echo .*config       >> %INCLUSIONS_FILENAME%
echo *.edmx         >> %INCLUSIONS_FILENAME%
echo *.eot          >> %INCLUSIONS_FILENAME%
echo *.gif          >> %INCLUSIONS_FILENAME%
echo .gitignore     >> %INCLUSIONS_FILENAME%
echo .gitkeep       >> %INCLUSIONS_FILENAME%
echo *.h            >> %INCLUSIONS_FILENAME%  
echo *.htm*         >> %INCLUSIONS_FILENAME%  
echo *.ico          >> %INCLUSIONS_FILENAME%
echo *.ini          >> %INCLUSIONS_FILENAME%
echo *.jpg          >> %INCLUSIONS_FILENAME%
echo *.js           >> %INCLUSIONS_FILENAME%
echo *.json         >> %INCLUSIONS_FILENAME%
echo *.licx         >> %INCLUSIONS_FILENAME%
echo license        >> %INCLUSIONS_FILENAME%
echo *.manifest     >> %INCLUSIONS_FILENAME%
echo *.map          >> %INCLUSIONS_FILENAME%
echo *.md           >> %INCLUSIONS_FILENAME%
echo *.mpp          >> %INCLUSIONS_FILENAME%
echo *.nuspec       >> %INCLUSIONS_FILENAME%
echo Pipfile        >> %INCLUSIONS_FILENAME%
echo *.pk*          >> %INCLUSIONS_FILENAME%
echo *.png          >> %INCLUSIONS_FILENAME%
echo *.psproj       >> %INCLUSIONS_FILENAME%
echo *.ps*1         >> %INCLUSIONS_FILENAME%
echo *.pfx          >> %INCLUSIONS_FILENAME%
echo *.ppt          >> %INCLUSIONS_FILENAME%
echo *.pptx         >> %INCLUSIONS_FILENAME%
echo *.pubxml       >> %INCLUSIONS_FILENAME%
echo *.puml         >> %INCLUSIONS_FILENAME%
echo *.pvk          >> %INCLUSIONS_FILENAME%
echo *.py           >> %INCLUSIONS_FILENAME%
echo *.resx         >> %INCLUSIONS_FILENAME%
echo *.rdl          >> %INCLUSIONS_FILENAME%
echo *.rdlc         >> %INCLUSIONS_FILENAME%
echo *.rptproj      >> %INCLUSIONS_FILENAME%
echo *.settings     >> %INCLUSIONS_FILENAME%
echo *.shfbproj     >> %INCLUSIONS_FILENAME%
echo *.sql          >> %INCLUSIONS_FILENAME%
echo *.sqlproj      >> %INCLUSIONS_FILENAME%
echo *.svg          >> %INCLUSIONS_FILENAME%
echo *.targets      >> %INCLUSIONS_FILENAME%
echo *.ts           >> %INCLUSIONS_FILENAME%
echo *.tt           >> %INCLUSIONS_FILENAME%
echo *.ttf          >> %INCLUSIONS_FILENAME%
echo *.txt          >> %INCLUSIONS_FILENAME%
echo *.pdf          >> %INCLUSIONS_FILENAME%
echo *.sln          >> %INCLUSIONS_FILENAME% 
echo *.svc          >> %INCLUSIONS_FILENAME% 
echo .tfignore      >> %INCLUSIONS_FILENAME% 
echo *.vbs          >> %INCLUSIONS_FILENAME% 
echo *.woff*        >> %INCLUSIONS_FILENAME%
echo *.xls          >> %INCLUSIONS_FILENAME%
echo *.xlsx         >> %INCLUSIONS_FILENAME%
echo *.xml          >> %INCLUSIONS_FILENAME%
echo *.xaml         >> %INCLUSIONS_FILENAME%
echo *.xsd          >> %INCLUSIONS_FILENAME%
echo *.xsl*         >> %INCLUSIONS_FILENAME%
echo *.yaml         >> %INCLUSIONS_FILENAME%
echo yarn.lock      >> %INCLUSIONS_FILENAME%
    
:: Exclusions
echo bin            >  %EXCLUSIONS_FILENAME%
echo dist           >> %EXCLUSIONS_FILENAME%
echo *.dotsettings  >> %EXCLUSIONS_FILENAME%
echo .git           >> %EXCLUSIONS_FILENAME%
echo lib            >> %EXCLUSIONS_FILENAME%
echo obj            >> %EXCLUSIONS_FILENAME%
echo node_modules   >> %EXCLUSIONS_FILENAME%
echo packages       >> %EXCLUSIONS_FILENAME%
echo *.suo          >> %EXCLUSIONS_FILENAME%
echo .svn           >> %EXCLUSIONS_FILENAME%
echo *.user         >> %EXCLUSIONS_FILENAME%
echo *.vs           >> %EXCLUSIONS_FILENAME%
echo venv           >> %EXCLUSIONS_FILENAME%

goto:eof
