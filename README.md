# My Dotfiles

My personal collection of dotfiles.

## Usage

```sh
./dot.sh
```

## TODO

This needs to be done somehow:

```sh
mkdir -p ~/.local/share/gnupg
find ~/.local/share/gnupg -type d -exec chmod 700 {} \;
find ~/.local/share/gnupg -type f -exec chmod 600 {} \;
```
