#!/usr/bin/env bash
function get_os() {
    case "$OSTYPE" in
        darwin*)  echo "MACOS" ;; 
        linux*)   echo "LINUX" ;;
        bsd*)     echo "BSD" ;;
        *)        echo "unknown: $OSTYPE" ;;
    esac
}

case "$(get_os)" in
    MACOS*) source ./macos/setup.sh ;;
    LINUX*) source ./linux/setup.sh ;;
    *) echo "dotfiles not configured for this enviroment" ;;
esac
