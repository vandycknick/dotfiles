status is-interactive || exit

set -Ux GNUPGHOME "$XDG_DATA_HOME/gnupg"

set -x GPG_TTY (tty)
gpgconf --launch gpg-agent

# Preserve an agent socket inherited from sshd, which forwards signing requests
# to the host's SSH agent/YubiKey. Fall back to the local GPG agent otherwise.
# Gate on SSH_CONNECTION, not on the socket existing: launchd sets SSH_AUTH_SOCK
# on every macOS GUI process to Apple's own (empty) ssh-agent, so a live socket
# does not distinguish "forwarded" from "local". Only sshd sets SSH_CONNECTION.
if not set -q SSH_CONNECTION; or not test -S "$SSH_AUTH_SOCK"
  set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end
