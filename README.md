# My dotfiles
My personal collection of dotfiles, with install instructions for windows and linux.

## Download
Download this respository with git or curl:

**Git:**

```sh
git clone https://github.com/nickvdyck/dotfiles
```

**Curl:**

```sh
curl -L -o "~/Downloads/dotfiles.zip" "https://github.com/nickvdyck/dotfiles/archive/master.zip"
```

or

```powershell
curl -L -o "$($env:HOME)/Downloads/dotfiles.zip" "https://github.com/nickvdyck/dotfiles/archive/master.zip"
```

If you used curl unzip the archive. All other commands should be run from inside the `dotfiles` directory.

## Windows
For windows there are a few manual steps that you need to execute before you can kick off the setup process.

### Install chocolatey
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
```
### Install the Windows Subsystem for Linux
The setup script will install a default linux subsystem. Run the following command to ensure that the "Windows Subsystem for Linux" optional feature is enabled:

1. Open PowerShell as Administrator and run:
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```
2.Restart your computer when prompted.

### Setup Machine
That is all for the manual part. Run the following command to finish off setting up your machine:
- Open powershell with administrative privileges
- Navigate to dotfiles directory and execute the following script
```powershell
Invoke-Expression ./setup.ps1
```


## Linux
The setup for linux is easy just run the following script:
```sh
./setup.sh
```

## Notes

When setting up windows box in a vm, enable nested vrtualization:
```powershell
Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true
```

## Ideas coming from:
- https://github.com/mathiasbynens/dotfiles
- https://github.com/paulirish/dotfiles
- https://github.com/sindresorhus/mathiasbynens-dotfiles
- https://github.com/necolas/dotfiles
