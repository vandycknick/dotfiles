#My dotfiles
My personal collection of dotfiles, with install instructions for windows and mac.Ideas stolen from various repo's: https://dotfiles.github.io/.

##Prerequisite
To setup the required bits and piecs run the commands in setup.sh.

##Installation
Clone the repo somewhere in your home folder.
```bash
git clone https://github.com/vdyckn/dotfiles.git
```

## Unix setup (MAC)

First manually setup some required binaries by running each line in the following script:
```sh
pre-bootstrap.sh
```

Then run the followin scripts to do the full setup

```bash
source src/unix/bootstrap.sh
source src/unix/brew.sh
source src/unix/brew-cask.sh
```

##Ideas coming from:
- https://github.com/mathiasbynens/dotfiles
- https://github.com/paulirish/dotfiles
- https://github.com/sindresorhus/mathiasbynens-dotfiles
- https://github.com/necolas/dotfiles
