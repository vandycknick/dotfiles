# State and colours come from conf.d/my_prompt.fish.
function fish_prompt --description 'pwd, Git, duration, status'
    echo -n -s \
        $_my_prompt_environment \
        $_my_prompt_c_pwd $_my_prompt_pwd $_my_prompt_c_normal ' ' \
        $$_my_prompt_git \
        $_my_prompt_cmd_duration \
        $_my_prompt_status $_my_prompt_c_normal ' '
end
