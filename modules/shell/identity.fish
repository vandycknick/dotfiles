# Sourced from the generated config.fish after the session variables, which
# provide MACHINE_IDENTITY (an inherited with-agent context wins).
switch "$MACHINE_IDENTITY"
  case agent
    set -l agent_socket ("$HOME/.local/bin/with-agent" printenv SSH_AUTH_SOCK)
    or return 1
    if test -z "$agent_socket"
      echo 'machine-identity: empty agent socket' >&2
      return 1
    end
    set -gx SSH_AUTH_SOCK "$agent_socket"
    set -gx GIT_CONFIG_GLOBAL "$HOME/.config/git/agent"
    set -gx GIT_SSH_COMMAND ssh
    return 0
  case personal
  case '*'
    echo 'machine-identity: expected personal or agent' >&2
    return 1
end

# Runs for non-interactive shells too (editors, agent tools like tern), so their
# git/ssh reach the YubiKey instead of launchd's empty ssh-agent.
gpgconf --launch gpg-agent
# Preserve an agent socket inherited from sshd, which forwards signing requests
# to the host's SSH agent/YubiKey. Fall back to the local GPG agent otherwise.
# Gate on SSH_CONNECTION, not on the socket existing: launchd sets SSH_AUTH_SOCK
# on every macOS GUI process to Apple's own (empty) ssh-agent, so a live socket
# does not distinguish "forwarded" from "local". Only sshd sets SSH_CONNECTION.
if not set -q SSH_CONNECTION; or not test -S "$SSH_AUTH_SOCK"
  set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end

status is-interactive || return 0

set -x GPG_TTY (tty)
