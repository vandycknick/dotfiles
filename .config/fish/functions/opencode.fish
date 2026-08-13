function opencode
  set -l agent_key "$HOME/.ssh/agent_ed25519"

  # Only override git behaviour on machines that have an agent key.
  if test -f "$agent_key"
    # Don't sign commits/tags made from opencode sessions.
    # NOTE: -fx (function scope), not -lx — -lx inside this if/end block is
    # discarded at `end` and never reaches the command below.
    set -fx GIT_CONFIG_COUNT 2
    set -fx GIT_CONFIG_KEY_0 commit.gpgsign
    set -fx GIT_CONFIG_VALUE_0 false
    set -fx GIT_CONFIG_KEY_1 tag.gpgsign
    set -fx GIT_CONFIG_VALUE_1 false

    # To sign with the SSH key instead, set COUNT to 4 and uncomment:
    # set -fx GIT_CONFIG_KEY_2 gpg.format
    # set -fx GIT_CONFIG_VALUE_2 ssh
    # set -fx GIT_CONFIG_KEY_3 user.signingkey
    # set -fx GIT_CONFIG_VALUE_3 $agent_key

    set -fx GIT_SSH_COMMAND "ssh -i $agent_key -o IdentitiesOnly=yes -o IdentityAgent=none"
  end

  command opencode $argv
end
