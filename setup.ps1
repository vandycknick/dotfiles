<#

.SYNOPSIS
    Windows dev machine setup script

.DESCRIPTION
    This is my personal setup script to install and configure a new machine just the way I like it.
    It will set up environment variables variables, install applications and tools. It will also
    install a new wsl environment (Ubuntu-18.04) and run my linux configuration scripts in bash
    to configure my linux environment just the way I like it.

#>

#--- Init ---
if ($False -eq (Test-Path "$HOME/.dofiles/init"))
{
    . "$PSScriptRoot/windows/init.ps1"
}

#--- Variables ---
$PROFILEPATH = ($PROFILE | Split-Path)

#--- Powershell modules ---
Install-Module z -Scope CurrentUser -AllowClobber -Force
Install-Module posh-git -Scope CurrentUser -AllowPrerelease -Force

#--- User Profile ---
Copy-Item "$PSScriptRoot/windows/profile/Microsoft.PowerShell_profile.ps1" $PROFILEPATH

#--- User Scripts"
Copy-Item "$PSScriptRoot/windows/scripts/dotnet-install.ps1" "$PROFILEPATH/Scripts"
Copy-Item "$PSScriptRoot/windows/scripts/wsl-install.ps1" "$PROFILEPATH/Scripts"

#--- Environment Variables ---
[Environment]::SetEnvironmentVariable("_NT_SYMBOL_PATH", "srv*C:\symbols*http://msdl.microsoft.com/downloads/symbols", "User")
[Environment]::SetEnvironmentVariable("GNUPGHOME", "$HOME\.gnupg", "User")
[Environment]::SetEnvironmentVariable("GIT_SSH_COMMAND", "'C:\Windows\System32\OpenSSH\ssh.exe' -T", "User") # https://github.com/PowerShell/Win32-OpenSSH/wiki/Setting-up-a-Git-server-on-Windows-using-Git-for-Windows-and-Win32_OpenSSH
[Environment]::SetEnvironmentVariable("GIT_EDITOR", "'C:/Program Files (x86)/vim/vim80/vim.exe'", "User")

# $User = [System.Environment]::GetEnvironmentVariable("Path", "User")
# [System.Environment]::SetEnvironmentVariable("Path",  "$User;$PROFILEPATH/Scripts", "User")

#--- Reload path ---
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

#--- Remove Default Apps --
. "$PSScriptRoot/windows/remove-defaultapps.ps1"

#--- Apps ---
choco install docker-for-windows -y
choco install GoogleChrome -y

#--- Tools ---
choco install git -y --params "/GitOnlyOnPath /NoAutoCrlf /WindowsTerminal /NoShellIntegration"
choco install vim -y
choco install 7zip -y
choco install azure-cli -y
choco install ilspy -y
choco install sysinternals -y
choco install nvm -y

#--- Fonts ---
choco install FiraCode -y

#--- Configuration ---
Copy-Item "PSScriptRoot/common/config/.gitconfig" ~

#--- Configure vscode --
. "$PSScriptRoot/common/vscode/setup.ps1"

#--- Configure WSL ---
wsl-install -Distro "ubuntu-1804"
bash "setup.sh"
