set -g prompt_color_normal (set_color normal)
set -g prompt_color_pwd (set_color cyan)
#set -g prompt_color_prompt (set_color green)

function fish_prompt --description MyPrompt
  printf "$prompt_color_normal$prompt_color_pwd$_hydro_pwd"
  printf "$prompt_color_normal $_hydro_color_git$$_hydro_git"
  printf "$prompt_color_normal$_hydro_color_duration$_hydro_cmd_duration"
  printf "$prompt_color_normal$_hydro_status$prompt_color_normal \n"
end
