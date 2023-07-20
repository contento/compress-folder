<#
.SYNOPSIS
	Compress the current folder
.DESCRIPTION
	Compress the current folder
.INPUTS
	None
.OUTPUTS
	None
.NOTES
	None
.EXAMPLE
	Compress-This -Dev
#>

Param(
    [switch]$Dev = $false,
    [string]$BACKUP_PATH = "c:/backup/compressed",
    [string]$COMPRESSOR_NAME = "7z",
    [string]$COMPRESSOR_EXT = "7z",
    [string]$INCLUSIONS_FILENAME = "$PSScriptRoot\compress-folder.dev.i.lst",
    [string]$EXCLUSIONS_FILENAME = "$PSScriptRoot\compress-folder.dev.x.lst"
)

$PARTIAL_COMPRESSOR_PATH = "7-zip/$($COMPRESSOR_NAME).exe"

if (!(Test-Path -Path $BACKUP_PATH)) {
    Write-Output "Backup path does not exist"
    exit
}

$COMPRESSOR = $null
try {
    @( "c:\Tools", $env:ProgramFiles, "$env:ProgramFiles(x86)", $env:ProgramW6432 ) | ForEach-Object {
        $path = Join-Path -Path $_ -ChildPath $PARTIAL_COMPRESSOR_PATH
        if (Test-Path -Path $path) {
            $COMPRESSOR = $path
            throw # AWFUL: but I don't know better
        }
    }
}
catch {}

if (-not $COMPRESSOR) {
    Write-Output "Error: '$COMPRESSOR_NAME' does not exist!"
    exit
}

# Get Current Date and Time
$now = Get-Date
$YYYY = $now.ToString("yyyy")
$MM = $now.ToString("MM")
$DD = $now.ToString("dd")
$H = $now.ToString("HH")
$M = $now.ToString("mm")
$S = $now.ToString("ss")

# Get Current Folder Name, Build File Path
$FOLDER_NAME = Split-Path -Path $PWD -Leaf
$FILE_PATH = Join-Path -Path $BACKUP_PATH -ChildPath $FOLDER_NAME
$FILENAME = Join-Path -Path $FILE_PATH -ChildPath "$($FOLDER_NAME)_$YYYY-$MM-$($DD)_$H.$M.$S.$COMPRESSOR_EXT"

# create backup folder
if (!(Test-Path -Path $FILE_PATH)) {
    New-Item -ItemType Directory -Path $FILE_PATH | Out-Null
}

# Do it
Write-Output "Compressing"
Write-Output "Folder: $PWD"
Write-Output "To: $FILENAME"

if ($dev) {
    # Compress based on dev list of inclusions and exclusions
    & $COMPRESSOR a -mx9 -ir@"$INCLUSIONS_FILENAME" "$FILENAME" -xr@"$EXCLUSIONS_FILENAME"
}
else {
    # Compress all
    & $COMPRESSOR a -mx9 -ir!* "$FILENAME"
}

Write-Output "$FILENAME created"
