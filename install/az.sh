#!/usr/bin/env bash

echo ""
echo "Installing azure-cli"
if ! [ -x "$(command -v az)" ]; then
    echo "az cli not installed"
    curl -sL https://packages.microsoft.com/keys/microsoft.asc |
        gpg --dearmor |
        sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

    AZ_REPO=$(lsb_release -cs)
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
        sudo tee /etc/apt/sources.list.d/azure-cli.list

    sudo apt update
fi

sudo apt install -y azure-cli

echo ""
echo "Install azure functions cli"
if ! [ -x "$(command -v func)" ]; then
    curl -L https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -o /tmp/packages-microsoft-prod.deb
    sudo dpkg -i /tmp/packages-microsoft-prod.deb
    sudo apt update
fi

sudo apt install -y azure-functions-core-tools-3
