set -g prompt_color_normal (set_color normal)
set -g prompt_color_pwd (set_color cyan)

function fish_prompt --description MyPrompt
  printf "$prompt_color_normal$prompt_color_pwd$_my_prompt_pwd"
  printf "$prompt_color_normal$_my_prompt_vm_host"
  printf "$prompt_color_normal $_my_prompt_color_git$$_my_prompt_git"
  printf "$prompt_color_normal$_my_prompt_color_duration$_my_prompt_cmd_duration"
  printf "$prompt_color_normal$_my_prompt_status$prompt_color_normal \n"
end
