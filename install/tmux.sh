#!/usr/bin/env bash

echo ""
echo "Configuring tmux"

install-tpm

install-tpm() {
    local TPM_DIR="$XDG_CONFIG_HOME/tmux/plugins/tpm"

    if [ ! -d "$TPM_DIR" ]; then
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    fi
}
