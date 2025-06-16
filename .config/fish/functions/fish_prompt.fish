set -g prompt_color_normal (set_color normal)
set -g prompt_color_pwd (set_color cyan)

set -g __mise_active true
set -g __mise_last_pwd ''
set -g __mise_inside_devenv false

function __check_inside_devenv
    if test "$PWD" != "$__mise_last_pwd"
        # Cache miss — update and re-check
        set -g __mise_last_pwd $PWD
        set -g __mise_inside_devenv false

        set dir $PWD
        while test "$dir" != "/"
            if test -f "$dir/devenv.nix"
                set -g __mise_inside_devenv true
                break
            end
            set dir (dirname "$dir")
        end
    end

    return (test "$__mise_inside_devenv" = true)
end

function __toggle_mise
  if __check_inside_devenv
      if test "$__mise_active" = true
          mise deactivate
          set -g __mise_active false
      end
  else
      if test "$__mise_active" = false
          mise activate | source
          set -g __mise_active true
      end
  end
end

function fish_prompt --description MyPrompt
  __toggle_mise

  printf "$prompt_color_normal$prompt_color_pwd$_hydro_pwd"
  printf "$prompt_color_normal $_hydro_color_git$$_hydro_git"
  printf "$prompt_color_normal$_hydro_color_duration$_hydro_cmd_duration"
  printf "$prompt_color_normal$_hydro_status$prompt_color_normal \n"
end
