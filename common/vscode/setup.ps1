<#

.SYNOPSIS

.DESCRIPTION

#>

. "$PSScriptRoot/extensions.ps1"
Copy-Item "$PSScriptRoot/settings.json" "$($env:APPDATA)/Code/User" -Force
