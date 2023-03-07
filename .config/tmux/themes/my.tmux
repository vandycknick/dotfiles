#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/utils.sh"

main() {
    # Settings
    local refresh_interval=$(get_tmux_option "@my-theme-refresh-rate" 5)
    local show_flags=true
    local show_powerline=true
    local show_day_month=false
    local show_military=true
    local show_timezone=false

    # Plugins
    local plugins=("time")

    # Color Pallette
    local bg="#1d2026"
    local fg="#abb2bf"

    # Color Pallette
    local white='#fafafa'
    local black='#282c34'
    local gray='#5c6370'
    local dark_gray='#282a36'
    local light_purple='#c678dd'
    local dark_purple='#7d3991'
    local dark_purple='#87409c'
    local cyan='#56b6c2'
    local green='#98c379'
    local orange='#d19a66'
    local red='#e06c75'
    local yellow='#e5c07b'

    # Set refresh interval to every 5 seconds
    tmux set-option -g status-interval "$refresh_interval"

    tmux set-option -g clock-mode-style 12

    tmux set-option -g status-left-length 100
    tmux set-option -g status-right-length 100

    tmux set-option -g pane-active-border-style "fg=${light_purple}"
    tmux set-option -g pane-border-style "fg=${fg}"
    tmux set-option -g message-style "bg=${bg},fg=${fg}"

    # Set timezone unless hidden by configuration
    local timezone=""
    case $show_timezone in
        false)
            timezone="";;
        true)
            timezone="#(date +%Z)";;
    esac

    case $show_flags in
        false)
            flags=""
            current_flags="";;
        true)
            flags="#{?window_flags,#[fg=${dark_purple}]#{window_flags},}"
            current_flags="#{?window_flags,#[fg=${light_purple}]#{window_flags},}"
    esac

    # set the prefix + t time format
    if $show_military; then
        tmux set-option -g clock-mode-style 24
    else
        tmux set-option -g clock-mode-style 12
    fi

    # Status Bar
    tmux set-option -g status-style "bg=${bg},fg=${fg}"

    local left_separator=""
    local right_separator=""
    local left_icon="#S "

    if $show_powerline; then
        tmux set-option -g status-left "#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],} ${left_icon} #[fg=${green},bg=${bg}]#{?client_prefix,#[fg=${yellow}],}${left_separator}"
        powerbg=${bg}
    else
        tmux set-option -g status-left "#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],} ${left_icon}"
    fi
    
    # Right Status Bar
    local script=""
    tmux set-option -g status-right ""

    for plugin in "${plugins[@]}"; do
        local colors=()

        if [ $plugin = "battery" ]; then
            colors=($red $bg)
            script="#($CURRENT_DIR/battery.sh)"
        fi

        if [ $plugin = "time" ]; then
            colors=($yellow $bg)
            if $show_day_month && $show_military ; then # military time and dd/mm
                script="📅 %a %d/%m %R ${timezone} "
            elif $show_military; then # only military time
                script="📅 %a %m/%d %R ${timezone} "
            elif $show_day_month; then # only dd/mm
                script="📅 %a %d/%m %I:%M %p ${timezone} "
            else
                script="📅 %a %m/%d %I:%M %p ${timezone} "
            fi
        fi

        if $show_powerline; then
            tmux set-option -ga status-right "#[fg=${colors[0]},bg=${powerbg},nobold,nounderscore,noitalics]${right_separator}#[fg=${colors[1]},bg=${colors[0]}] $script "
            powerbg=${colors[0]}
        else
            tmux set-option -ga status-right "#[fg=${colors[1]},bg=${colors[0]}] $script "
        fi
    done

    if $show_powerline; then
        tmux set-window-option -g window-status-current-format "#[fg=${bg},bg=${dark_gray}]${left_separator}#[fg=${white},bg=${dark_gray}] #I #W${current_flags} #[fg=${dark_gray},bg=${bg}]${left_separator}"
    else
        tmux set-window-option -g window-status-current-format "#[fg=${white},bg=${dark_purple}] #I #W${current_flags} "
    fi

    tmux set-window-option -g window-status-format "#[fg=${fg}]#[bg=${bg}] #I #W${flags}"
    tmux set-window-option -g window-status-activity-style "bold"
    tmux set-window-option -g window-status-bell-style "bold"
}

main
