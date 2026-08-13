status is-interactive || exit

set -Ux GNUPGHOME "$XDG_DATA_HOME/gnupg"

set -x GPG_TTY (tty)
gpgconf --launch gpg-agent

# Preserve an agent socket inherited from sshd, which forwards signing requests
# to the host's SSH agent/YubiKey. Fall back to the local GPG agent otherwise.
if not set -q SSH_AUTH_SOCK; or not test -S "$SSH_AUTH_SOCK"
  set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end
