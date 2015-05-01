#My Personal Dotfiles repo

##Installation

You can clone the repository wherever you want. (I like to keep it in `~/Projects/dotfiles`, with `~/dotfiles` as a symlink.) The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/vdyckn/dotfiles.git
```

Make sure dependencies are installed, run commands in dependencies.sh (please do not execute the script, copy pase commands).

To install or update:

```bash
source bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
set -- -f; source bootstrap.sh
```