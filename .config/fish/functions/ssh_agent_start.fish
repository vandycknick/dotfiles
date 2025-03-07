function __ssh_agent_is_started -d "check if ssh agent is already started"
  if test -n "$SSH_CONNECTION"
    # This is an SSH session
    ssh-add -l > /dev/null 2>&1
    if test $status -eq 0 -o $status -eq 1
      # An SSH agent was forwarded
      return 0
    end
  end

  if begin; test -f "$ssh_env"; and test -z "$SSH_AGENT_PID"; end
    source $ssh_env > /dev/null
  end

  if test -z "$SSH_AGENT_PID"
    return 1
  end

  ssh-add -l > /dev/null 2>&1
  if test $status -eq 2
    return 1
  end
end

function ssh_agent_start -d "start a new ssh agent"
  if __ssh_agent_is_started
    return
  end

  argparse 's/ssh-add' -- $argv

  mkdir -p (path dirname $ssh_env)
  ssh-agent -c | sed 's/^echo/#echo/' > $ssh_env
  chmod 600 $ssh_env
  source $ssh_env > /dev/null

  if set -q _flag_ssh_add
    ssh-add
  end
end
