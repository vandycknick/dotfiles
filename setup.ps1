# Initialisation
$PROFILEPATH = ($PROFILE | Split-Path)

# Setup package providers
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install PowerShell modules
Install-Module z -Scope CurrentUser -AllowClobber -Force
Install-Module posh-git -Scope CurrentUser -Force

#--- User Profile ---
Copy-Item "$PSScriptRoot/powershell/Microsoft.PowerShell_profile.ps1" $PROFILEPATH

#--- User Scripts"
Copy-Item "$PSScriptRoot/scripts/get-uptime.ps1" "$PROFILEPATH/Scripts"
Copy-Item "$PSScriptRoot/scripts/dotnet-install.ps1" "$PROFILEPATH/Scripts"
Copy-Item "$PSScriptRoot/scripts/wsl-install.ps1" "$PROFILEPATH/Scripts"

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
Write-Host "Uninstall some applications that come with Windows out of the box" -ForegroundColor "Yellow"

# https://docs.microsoft.com/en-us/windows/application-management/remove-provisioned-apps-during-update
# https://github.com/jayharris/dotfiles-windows/blob/master/windows.ps1#L157
# https://gist.github.com/jessfraz/7c319b046daa101a4aaef937a20ff41f
# https://gist.github.com/alirobe/7f3b34ad89a159e6daa1
# https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/remove-default-apps.ps1

$applicationList = @(
    "Microsoft.BingFinance"
    "Microsoft.3DBuilder"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    "Microsoft.CommsPhone"
    "Microsoft.Getstarted"
    "Microsoft.WindowsMaps"
    "*MarchofEmpires*"
    "Microsoft.GetHelp"
    "Microsoft.Messaging"
    "*Minecraft*"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.OneConnect"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "*Solitaire*"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.Office.Sway"
    "Microsoft.XboxApp"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.FreshPaint"
    "Microsoft.Print3D"
    "*Autodesk*"
    "*BubbleWitch*"
    "king.com*"
    "G5*"
    "*Dell*"
    "*Dropbox*"
    "*Facebook*"
    "*Keeper*"
    "*Netflix*"
    "*Plex*"
    "*.Duolingo-LearnLanguagesforFree"
    "*.EclipseManager"
    "ActiproSoftwareLLC.562882FEEB491" # Code Writer
    "*.AdobePhotoshopExpress"
)

foreach ($app in $applicationList) {
    Write-Output "Trying to remove $app"
    Get-AppxPackage $app -AllUsers | Remove-AppxPackage
}

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
. "$PSScriptRoot/vscode/setup.ps1"

#--- Configure WSL ---
wsl-install -Distro "ubuntu-1804"
