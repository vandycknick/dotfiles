<#

.SYNOPSIS
    Setup task to auto mount source code virtual hard drive.

.DESCRIPTION
    Setup up the correct directories, scripts and task to autmatically mount SourceCode.vhdx at startup.
    # http://woshub.com/auto-mount-vhd-at-startup/

#>

New-Item "~/Drives" -Type Directory -ErrorAction SilentlyContinue
Copy-Item -Path "$PSScriptRoot/source-code-vhd" -Destination "~/Drives"

if (!(Test-Path "~\Drives\SourceCode.vhdx"))
{
    Write-Error "No virtual hard drive (SourceCode.vhdx) found in the drives folder in your user profile!"
    exit 1
}

schtasks /create `
    /tn "automountsourcecodevhdx" `
    /tr "diskpart.exe /s 'C:\Users\nickvd\Drives\source-code-vhd.txt'" `
    /sc ONLOGON `
    /ru SYSTEM 

