#!/usr/bin/env pwsh

<#
 .SYNOPSIS
    Install your Linux Distribution of Choice 

 .DESCRIPTION
    Script to help install different linux flavours onto your Windows 10 box.
    - https://docs.microsoft.com/en-us/windows/wsl/install-manual
    - https://docs.microsoft.com/en-us/windows/wsl/install-win10
    - https://docs.microsoft.com/en-us/windows/wsl/install-on-server (for local install)

    Use wslconfig.exe to manage wsl distributions and settings

 .PARAMETER Distro
    Linux flavour to install

 .PARAMETER DownloadDirectory
    Directory location to save file

#>

[CmdletBinding(PositionalBinding = $false)]
param(
    [Parameter(Position=0, Mandatory=$true)]
    [ValidateSet('ubuntu-1804','ubuntu-1604','debian', 'kali', 'opensuse', 'sles')]
    [string] $Distro,

    [Parameter(Position=1)]
    [string] $DownloadDirectory = "$env:HOME\Downloads",

    [Parameter(Position=2)]
    [switch] $Local,

    [Parameter(Position=3)]
    [string] $LocalDirectory = "$env:HOME\.wsl"
)

$target = ($DownloadDirectory | Resolve-Path)
$links = @{
    'ubuntu-1804'   = 'https://aka.ms/wsl-ubuntu-1804';
    'ubuntu-1604'   = 'https://aka.ms/wsl-ubuntu-1604';
    'debian'        = 'https://aka.ms/wsl-debian-gnulinux';
    'kali'          = 'https://aka.ms/wsl-kali-linux';
    'opensuse'      = 'https://aka.ms/wsl-opensuse-42';
    'sles'          = 'https://aka.ms/wsl-sles-12';
}

if ($Local) {
    $result = (Resolve-Path -Path "$LocalDirectory\$Distro\AppxManifest.xml" -ErrorAction SilentlyContinue)

    if ($null -ne $result) {
        throw "Linux distribution is already installed"
    }
}

Invoke-WebRequest -Uri $links[$Distro] -OutFile "$target\$Distro.appx" -UseBasicParsing

if ($Local) {
    New-Item -Path $LocalDirectory -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    Move-Item -Path "$target\$Distro.appx" -Destination "$LocalDirectory\$Distro.zip"
    Expand-Archive -Path "$LocalDirectory\$Distro.zip" -DestinationPath "$LocalDirectory\$Distro"

    $manifest = [xml](Get-Content "$LocalDirectory\$Distro\AppxManifest.xml")
    $extension = $manifest['Package']['Applications']['Application']['Extensions']['uap3:Extension']
    $executable = $extension.Executable

    Write-Host "$LocalDirectory\$Distro\$executable"

    Start-Process "$LocalDirectory\$Distro\$executable"
} else {
    & "$target/$Distro.appx"
}
