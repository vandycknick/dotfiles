status is-interactive || exit

set --query ssh_env || set --global ssh_env "$XDG_CACHE_HOME/ssh/environment"

ssh_agent_start --ssh-add
