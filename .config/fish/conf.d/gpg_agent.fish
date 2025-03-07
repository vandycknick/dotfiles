status is-interactive || exit

set -Ux GNUPGHOME "$XDG_DATA_HOME/gnupg"

set -x GPG_TTY (tty)
gpgconf --launch gpg-agent
