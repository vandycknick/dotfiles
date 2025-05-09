function fish_right_prompt
  if test "$fish_key_bindings" = fish_default_key_bindings
    return
  end

  set --local vi_mode_color
  set --local vi_mode_symbol
  switch $fish_bind_mode
  case default
    set vi_mode_color (set_color blue)
    set vi_mode_symbol N
  case insert
    set vi_mode_color (set_color green)
    set vi_mode_symbol I
  case replace replace_one
    set vi_mode_color (set_color normal)
    set vi_mode_symbol R
  case visual
    set vi_mode_color (set_color purple)
    set vi_mode_symbol V
  end
  echo -e "$vi_mode_color $vi_mode_symbol \x1b[0m"
end
