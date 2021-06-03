#!/usr/bin/env bash

echo ""
echo "Installing vscode"
if ! [ -x "$(command -v code)" ]; then
    echo "az cli not installed"
    curl -L https://go.microsoft.com/fwlink/?LinkID=760868 -o /tmp/vscode.deb
    sudo apt install /tmp/vscode.deb
fi


echo ""
echo "Installing vscode extensions"
# Setup vscode extensions and preferences
# https://marketplace.visualstudio.com/items?itemName={extension_name}

# C#
code --install-extension ms-vscode.csharp
# Python
code --install-extension ms-python.python
# GitLens
code --install-extension eamodio.gitlens
# Docker
code --install-extension ms-azuretools.vscode-docker
# Studio Icons
code --install-extension jtlowe.vscode-icon-theme
# ESLint
code --install-extension dbaeumer.vscode-eslint
# Prettier
code --install-extension esbenp.prettier-vscode
# Code Spell Checker
code --install-extension streetsidesoftware.code-spell-checker
# Azure Storage
code --install-extension ms-azuretools.vscode-azurestorage
# Azure Functions
code --install-extension ms-azuretools.vscode-azurefunctions
# GitHub
code --install-extension github.vscode-pull-request-github
# EditorConfig
code --install-extension editorconfig.editorconfig
# Monokai Pro Theme
code --install-extension monokai.theme-monokai-pro-vscode
# Version Lens
code --install-extension pflannery.vscode-versionlens
# Golang
code --install-extension golang.go
# Terraform
code --install-extension hashicorp.terraform
