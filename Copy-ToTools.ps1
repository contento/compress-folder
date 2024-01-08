[string[]]$Files = @(
  "Compress-This.ps1",
  "compress-folder.dev.i.lst",
  "compress-folder.dev.x.lst"
)

[string]$ToolsPath = "C:\Tools"

"Copy files to $ToolsPath ..."

foreach ($File in $Files) {
  Copy-Item -Path "$PSScriptRoot/$File" -Destination $ToolsPath -Force
}

"Done."
