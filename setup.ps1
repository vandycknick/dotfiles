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
$PROFILEPATH = ($PROFILE | Split-Path)

#--- Setup package providers ---
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

#--- Powershell modules ---
Install-Module z -Scope CurrentUser -AllowClobber -Force
Install-Module posh-git -Scope CurrentUser -Force

#--- User Profile ---
Copy-Item "$PSScriptRoot/windows/profile/Microsoft.PowerShell_profile.ps1" $PROFILEPATH

#--- User Scripts"
Copy-Item "$PSScriptRoot/windows/scripts/get-uptime.ps1" "$PROFILEPATH/Scripts"
Copy-Item "$PSScriptRoot/windows/scripts/dotnet-install.ps1" "$PROFILEPATH/Scripts"
Copy-Item "$PSScriptRoot/windows/scripts/wsl-install.ps1" "$PROFILEPATH/Scripts"

#--- Fonts ---
Invoke-WebRequest -Uri "https://github.com/tonsky/FiraCode/releases/download/1.204/FiraCode_1.204.zip" -OutFile "$HOME/Downloads/FiraCode.zip"
Expand-Archive -LiteralPath "$HOME/Downloads/FiraCode.zip" -DestinationPath "$HOME/Downloads/FiraCode"

#--- Environment Variables ---
[Environment]::SetEnvironmentVariable("_NT_SYMBOL_PATH", "srv*C:\symbols*http://msdl.microsoft.com/downloads/symbols", "User")
[Environment]::SetEnvironmentVariable("GNUPGHOME", "$HOME\.gnupg", "User")
[Environment]::SetEnvironmentVariable("GIT_SSH_COMMAND", "'C:\Windows\System32\OpenSSH\ssh.exe' -T", "User") # https://github.com/PowerShell/Win32-OpenSSH/wiki/Setting-up-a-Git-server-on-Windows-using-Git-for-Windows-and-Win32_OpenSSH
[Environment]::SetEnvironmentVariable("GIT_EDITOR", "'C:/Program Files (x86)/vim/vim80/vim.exe'", "User")

#--- Reload path ---
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

#--- Remove Default Apps --
. "$PSScriptRoot/windows/remove-defaultapps.ps1"

#--- Apps ---
choco install visualstudiocode -y --params "/NoDesktopIcon"
choco install docker-for-windows -y

#--- Tools ---
choco install git -y --params "/GitOnlyOnPath /NoAutoCrlf /WindowsTerminal /NoShellIntegration"
choco install vim -y
choco install 7zip -y
choco install azure-cli -y
choco install ilspy -y
choco install kubernetes-cli -y
choco install sysinternals -y

#--- Configure vscode --
. "$PSScriptRoot/common/vscode/setup.ps1"

#--- Configure WSL ---
wsl-install -Distro "ubuntu-1804"
bash "./setup.sh"
