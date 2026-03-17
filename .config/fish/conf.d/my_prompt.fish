status is-interactive || exit

set --global _my_prompt_git _my_prompt_git_$fish_pid

function $_my_prompt_git --on-variable $_my_prompt_git
    commandline --function repaint
end

set -g cyan (set_color -o cyan)
set -g yellow (set_color -o yellow)
set -g red (set_color -o red)
set -g blue (set_color -o blue)
set -g green (set_color -o green)
set -g normal (set_color normal)

function _my_prompt_detect_vm --description "Cache VM status for this fish session"
    if set --query _my_prompt_vm_checked
        return
    end

    set --global _my_prompt_vm_checked 1
    set --global _my_prompt_vm_host

    if command -q systemd-detect-virt
        if systemd-detect-virt --quiet
            set --local host (prompt_hostname)
            set --global _my_prompt_vm_host " "(set_color brblack)"[$host]"$normal
            return
        end
    end

    switch (uname)
    case Linux
        if test -r /sys/class/dmi/id/product_name
            read --local --line product_name </sys/class/dmi/id/product_name
            set product_name (string lower (string trim $product_name))

            if string match -rq 'virtual|vmware|kvm|qemu|virtualbox|hyper-v|bochs|parallels' -- $product_name
                set --local host (prompt_hostname)
                set --global _my_prompt_vm_host " "(set_color brblack)"[$host]"$normal
            end
        end
    end
end

_my_prompt_detect_vm

function _my_prompt_pwd --on-variable PWD --on-variable my_prompt_ignored_git_paths --on-variable fish_prompt_pwd_dir_length
    set --local git_root (command git --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
    set --local git_base (string replace --all --regex -- "^.*/" "" "$git_root")
    set --local path_sep /

    test "$fish_prompt_pwd_dir_length" = 0 && set path_sep

    if set --query git_root[1] && ! contains -- $git_root $my_prompt_ignored_git_paths
        set --erase _my_prompt_skip_git_prompt
    else
        set --global _my_prompt_skip_git_prompt
    end

    set --global _my_prompt_pwd (
        string replace --ignore-case -- ~ \~ $PWD |
        string replace -- "/$git_base/" /:/ |
        string replace --regex --all -- "(\.?[^/]{"(
            string replace --regex --all -- '^$' 1 "$fish_prompt_pwd_dir_length"
        )"})[^/]*/" "\$1$path_sep" |
        string replace -- : "$git_base" |
        string replace --regex -- '([^/]+)$' "\x1b[1m\$1\x1b[22m" |
        string replace --regex --all -- '(?!^/$)/|^$' "\x1b[2m/\x1b[22m"
    )
end

function _my_prompt_postexec --on-event fish_postexec
    set --local last_status $pipestatus
    set --global _my_prompt_status "$_my_prompt_newline$_my_prompt_color_prompt$my_prompt_symbol_prompt"

    for code in $last_status
        if test $code -ne 0
            set --global _my_prompt_status "$_my_prompt_color_error| "(echo $last_status)" $_my_prompt_newline$_my_prompt_color_prompt$_my_prompt_color_error$my_prompt_symbol_prompt"
            break
        end
    end

    test "$CMD_DURATION" -lt $my_prompt_cmd_duration_threshold && set _my_prompt_cmd_duration && return

    set --local secs (math --scale=1 $CMD_DURATION/1000 % 60)
    set --local mins (math --scale=0 $CMD_DURATION/60000 % 60)
    set --local hours (math --scale=0 $CMD_DURATION/3600000)

    set --local out

    test $hours -gt 0 && set --local --append out $hours"h"
    test $mins -gt 0 && set --local --append out $mins"m"
    test $secs -gt 0 && set --local --append out $secs"s"

    set --global _my_prompt_cmd_duration "$out "
end

function _my_prompt_prompt --on-event fish_prompt
    set --query _my_prompt_status || set --global _my_prompt_status "$_my_prompt_newline$_my_prompt_color_prompt$my_prompt_symbol_prompt"
    set --query _my_prompt_pwd || _my_prompt_pwd

    command kill $_my_prompt_last_pid 2>/dev/null

    set --query _my_prompt_skip_git_prompt && set $_my_prompt_git && return

    fish --private --command "
        set branch (
            command git symbolic-ref --short HEAD 2>/dev/null ||
            command git describe --tags --exact-match HEAD 2>/dev/null ||
            command git rev-parse --short HEAD 2>/dev/null |
                string replace --regex -- '(.+)' '@\$1'
        )

        test -z \"\$$_my_prompt_git\" && set --universal $_my_prompt_git \"$blue($red\$branch$blue)$normal \"

        command git diff-index --quiet HEAD 2>/dev/null
        test \$status -eq 1 ||
            count (command git ls-files --others --exclude-standard (command git rev-parse --show-toplevel)) >/dev/null && set info \"$yellow$my_prompt_symbol_git_dirty$normal\"

        for fetch in $my_prompt_fetch false
            command git rev-list --count --left-right @{upstream}...@ 2>/dev/null |
                read behind ahead

            switch \"\$behind \$ahead\"
                case \" \" \"0 0\"
                case \"0 *\"
                    set upstream \" $my_prompt_symbol_git_ahead\$ahead\"
                case \"* 0\"
                    set upstream \" $my_prompt_symbol_git_behind\$behind\"
                case \*
                    set upstream \" $my_prompt_symbol_git_ahead\$ahead $my_prompt_symbol_git_behind\$behind\"
            end

            set --universal $_my_prompt_git \"$blue($red\$branch$blue)$normal \$info\$upstream \"

            test \$fetch = true && command git fetch --no-tags 2>/dev/null
        end
    " &

    set --global _my_prompt_last_pid $last_pid
end

function _my_prompt_fish_exit --on-event fish_exit
    set --erase $_my_prompt_git
end

#function _my_prompt_uninstall --on-event my_prompt_uninstall
#    set --names |
#        string replace --filter --regex -- "^(_?my_prompt_)" "set --erase \$1" |
#        source
#    functions --erase (functions --all | string match --entire --regex "^_?my_prompt_")
#end

set --global my_prompt_color_normal (set_color normal)

for color in my_prompt_color_{pwd,git,error,prompt,duration,start}
    function $color --on-variable $color --inherit-variable color
        set --query $color && set --global _$color (set_color $$color)
    end && $color
end

function my_prompt_multiline --on-variable my_prompt_multiline
    if test "$my_prompt_multiline" = true
        set --global _my_prompt_newline "\n"
    else
        set --global _my_prompt_newline ""
    end
end && my_prompt_multiline

set --query my_prompt_color_error || set --global my_prompt_color_error $fish_color_error
set --query my_prompt_symbol_prompt || set --global my_prompt_symbol_prompt ❱
set --query my_prompt_symbol_git_dirty || set --global my_prompt_symbol_git_dirty ✗
set --query my_prompt_symbol_git_ahead || set --global my_prompt_symbol_git_ahead ↑
set --query my_prompt_symbol_git_behind || set --global my_prompt_symbol_git_behind ↓
set --query my_prompt_multiline || set --global my_prompt_multiline false
set --query my_prompt_cmd_duration_threshold || set --global my_prompt_cmd_duration_threshold 1000
