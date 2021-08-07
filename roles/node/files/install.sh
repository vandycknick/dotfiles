#!/usr/bin/env bash

echo ""
echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.38.0/install.sh | bash

echo ""
echo "Installing yarn"
if ! [ -x "$(command -v yarn)" ]; then
    echo "Yarn not installed"
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update
fi

sudo apt install -y yarn --no-install-recommends yarn
