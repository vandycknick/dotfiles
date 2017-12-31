# My dotfiles
My personal collection of dotfiles, with install instructions for windows and mac.Ideas stolen from various repo's: https://dotfiles.github.io/.

## Installation

### Windows
Run the following command to download the configurations files to your system
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iwr "https://github.com/nickvdyck/dotfiles/archive/master.zip" -OutFile "$HOME/Downloads/dotfiles.zip"; Expand-Archive "$HOME/Downloads/dotfiles.zip" "$HOME/Downloads/dotfiles"
```

Install chocolatey
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

Run configuration and install scripts:
- Open powershell with administrative privileges
- Navigate to dotfiles directory and execute the following script
```powershell
Invoke-Expression $HOME\Downloads\dotfiles\dotfiles-master\configure.ps1
```

## Ideas coming from:
- https://github.com/mathiasbynens/dotfiles
- https://github.com/paulirish/dotfiles
- https://github.com/sindresorhus/mathiasbynens-dotfiles
- https://github.com/necolas/dotfiles
