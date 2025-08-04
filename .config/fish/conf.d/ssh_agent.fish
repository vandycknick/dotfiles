status is-interactive || exit

# TODO: Make this configurable at soem point.
if not set -q ssh_agent_enabled
    exit
end

set --query ssh_env || set --global ssh_env "$XDG_CACHE_HOME/ssh/environment"
ssh_agent_start --ssh-add
