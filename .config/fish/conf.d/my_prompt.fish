status is-interactive || exit

# Prompt state for functions/fish_prompt.fish. A background fish computes the
# Git part and hands it back through a per-shell universal variable, which
# repaints the prompt when it changes.

# Kanagawa's normal palette as hex. Tern draws bold named colours in the bright
# palette; hex keeps both terminals on the colours Ghostty shows.
set --global _my_prompt_c_pwd (set_color 6a9589)
set --global _my_prompt_c_paren (set_color --bold 7e9cd8)
set --global _my_prompt_c_branch (set_color --bold c34043)
set --global _my_prompt_c_dirty (set_color --bold c0a36e)
set --global _my_prompt_c_symbol (set_color 76946a)
set --global _my_prompt_c_error (set_color $fish_color_error)
set --global _my_prompt_c_normal (set_color normal)

set --global _my_prompt_git _my_prompt_git_$fish_pid

function $_my_prompt_git --on-variable $_my_prompt_git
    commandline --function repaint
end

# Shells that died without fish_exit leave their universal behind. One kill
# per shell costs ~10 ms, so a background fish erases them.
fish --private --command '
    for var in (set --universal --names | string match --regex "^_my_prompt_git_\d+\$")
        command kill -0 (string replace _my_prompt_git_ "" $var) 2>/dev/null ||
            set --erase --universal $var
    end
' &
builtin disown $last_pid 2>/dev/null

# An icon on SSH sessions.
set --global _my_prompt_environment
if set --query SSH_CONNECTION[1]; or set --query SSH_TTY[1]
    set _my_prompt_environment "$_my_prompt_c_dirty󰢹$_my_prompt_c_normal  "
end

function _my_prompt_pwd --on-variable PWD --on-variable fish_prompt_pwd_dir_length
    set --local git_root (command git --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
    set --local git_base (string replace --all --regex -- "^.*/" "" "$git_root")
    set --local path_sep /

    test "$fish_prompt_pwd_dir_length" = 0 && set path_sep

    if set --query git_root[1]
        set --erase _my_prompt_skip_git
    else
        set --global _my_prompt_skip_git
    end

    # Shortens every directory but the repository root and the last one, which
    # is bold; separators are dim.
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
    set --global _my_prompt_status "$_my_prompt_c_symbol❱"

    for code in $last_status
        if test $code -ne 0
            set _my_prompt_status "$_my_prompt_c_error| $last_status ❱"
            break
        end
    end

    if test "$CMD_DURATION" -lt 1000
        set --global _my_prompt_cmd_duration
        return
    end

    set --local secs (math --scale=1 $CMD_DURATION/1000 % 60)
    set --local mins (math --scale=0 $CMD_DURATION/60000 % 60)
    set --local hours (math --scale=0 $CMD_DURATION/3600000)
    set --local out

    test $hours -gt 0 && set --append out $hours"h"
    test $mins -gt 0 && set --append out $mins"m"
    test $secs -gt 0 && set --append out $secs"s"

    set --global _my_prompt_cmd_duration "$out "
end

function _my_prompt_prompt --on-event fish_prompt
    set --query _my_prompt_status || set --global _my_prompt_status "$_my_prompt_c_symbol❱"
    set --query _my_prompt_pwd || _my_prompt_pwd

    command kill $_my_prompt_last_pid 2>/dev/null

    if set --query _my_prompt_skip_git
        set --universal $_my_prompt_git
        return
    end

    set --local branch_fmt "$_my_prompt_c_paren($_my_prompt_c_branch\$branch$_my_prompt_c_paren)$_my_prompt_c_normal"

    # Shows the branch right away, then adds the dirty marker and the
    # ahead/behind counts.
    fish --private --command "
        set branch (
            command git symbolic-ref --short HEAD 2>/dev/null ||
            command git describe --tags --exact-match HEAD 2>/dev/null ||
            command git rev-parse --short HEAD 2>/dev/null |
                string replace --regex -- '(.+)' '@\$1'
        )

        test -z \"\$$_my_prompt_git\" && set --universal $_my_prompt_git \"$branch_fmt \"

        command git diff-index --quiet HEAD 2>/dev/null
        test \$status -eq 1 ||
            count (command git ls-files --others --exclude-standard (command git rev-parse --show-toplevel)) >/dev/null &&
            set info \"$_my_prompt_c_dirty✗$_my_prompt_c_normal\"

        command git rev-list --count --left-right @{upstream}...@ 2>/dev/null | read behind ahead
        switch \"\$behind \$ahead\"
            case ' ' '0 0'
            case '0 *'
                set upstream \" ↑\$ahead\"
            case '* 0'
                set upstream \" ↓\$behind\"
            case '*'
                set upstream \" ↑\$ahead ↓\$behind\"
        end

        set --universal $_my_prompt_git \"$branch_fmt \$info\$upstream \"
    " &

    set --global _my_prompt_last_pid $last_pid
end

function _my_prompt_fish_exit --on-event fish_exit
    set --erase --universal $_my_prompt_git
end
