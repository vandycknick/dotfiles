#!/usr/bin/env bash

echo ""
echo "Installing vscode extensions"
# Setup vscode extensions and preferences
# https://marketplace.visualstudio.com/items?itemName={extension_name}

codium \
    --user-data-dir $XDG_DATA_HOME/VSCodium \
    --extensions-dir $XDG_DATA_HOME/VSCodium/extensions \
    --install-extension ms-dotnettools.csharp \
    --install-extension ms-python.python \
    --install-extension ms-python.vscode-pylance \
    --install-extension ms-azuretools.vscode-docker \
    --install-extension ms-azuretools.vscode-azurestorage \
    --install-extension ms-azuretools.vscode-azurefunctions \
    --install-extension eamodio.gitlens \
    --install-extension jtlowe.vscode-icon-theme \
    --install-extension dbaeumer.vscode-eslint \
    --install-extension esbenp.prettier-vscode \
    --install-extension streetsidesoftware.code-spell-checker \
    --install-extension github.vscode-pull-request-github \
    --install-extension editorconfig.editorconfig \
    --install-extension monokai.theme-monokai-pro-vscode \
    --install-extension pflannery.vscode-versionlens \
    --install-extension golang.go \
    --install-extension hashicorp.terraform \
    --force
