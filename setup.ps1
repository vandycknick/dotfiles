# Initialisation
$CURDIR = Get-Location
$PROFILEPATH = ($PROFILE | Split-Path)

# Setup package providers
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install PowerShell  modules
Install-Module z -Scope CurrentUser -AllowClobber -Force
Install-Module posh-git -Scope CurrentUser -Force

# Setup User Profile scripts
Copy-Item "$($CURDIR.Path)/powershell/Microsoft.PowerShell_profile.ps1" $PROFILEPATH
Copy-Item "$($CURDIR.Path)/powershell/Get-Uptime.ps1" $PROFILEPATH

# Setup environment variables
[Environment]::SetEnvironmentVariable("_NT_SYMBOL_PATH", "srv*C:\symbols*http://msdl.microsoft.com/downloads/symbols", "User")
[Environment]::SetEnvironmentVariable("GNUPGHOME", "$HOME\.gnupg", "User")
[Environment]::SetEnvironmentVariable("GIT_SSH_COMMAND", "'C:\Windows\System32\OpenSSH\ssh.exe' -T", "User") # https://github.com/PowerShell/Win32-OpenSSH/wiki/Setting-up-a-Git-server-on-Windows-using-Git-for-Windows-and-Win32_OpenSSH
[Environment]::SetEnvironmentVariable("GIT_EDITOR", "'C:/Program Files (x86)/vim/vim80/vim.exe'", "User")

# Install applications
choco install visualstudiocode -y --params "/NoDesktopIcon"
choco install git -y --params "/GitOnlyOnPath /NoAutoCrlf /WindowsTerminal /NoShellIntegration"
choco install vim -y
choco install dotnetcore-sdk -y
choco install docker-for-windows -y

# Download FiraCode
Invoke-WebRequest -Uri "https://github.com/tonsky/FiraCode/releases/download/1.204/FiraCode_1.204.zip" -OutFile "$HOME/Downloads/FiraCode.zip"
Expand-Archive -LiteralPath "$HOME/Downloads/FiraCode.zip" -DestinationPath "$HOME/Downloads/FiraCode"

# Reload path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Setup vscode extensions and preferences

# https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp
code --install-extension ms-vscode.csharp
# https://marketplace.visualstudio.com/items?itemName=ms-vscode.powershell
code --install-extension ms-vscode.powershell
# https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql
code --install-extension ms-mssql.mssql
# https://marketplace.visualstudio.com/items?itemName=ms-python.python
code --install-extension ms-python.python
# https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens
code --install-extension eamodio.gitlens
# https://marketplace.visualstudio.com/items?itemName=PeterJausovec.vscode-docker
code --install-extension PeterJausovec.vscode-docker
# https://marketplace.visualstudio.com/items?itemName=gerane.theme-monokai-cobalt
code --install-extension gerane.theme-monokai-cobalt
# https://marketplace.visualstudio.com/items?itemName=jtlowe.vscode-icon-theme
code --install-extension jtlowe.vscode-icon-theme
# https://marketplace.visualstudio.com/items?itemName=wayou.vscode-todo-highlight
code --install-extension wayou.vscode-todo-highlight

Copy-Item "$($CURDIR.Path)/vscode/settings.json" "$($env:APPDATA)/Code/User" -Force

# Install WSL Ubuntu 18.04
./scripts/wsl-install.ps1 -Distro "ubuntu-1804"
