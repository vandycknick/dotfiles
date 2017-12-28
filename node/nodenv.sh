#!/bin/bash
function print_usage() {
  cat <<EOL
usage:
$(basename $0) setup
$(basename $0) install <version>
$(basename $0) -h|--help

Download and manage nodejs

Commands:
    install
    - nodenv install 9.3.0

Other options:
  -h, --help        output usage information and exit

EOL
  exit $1
}

if [ -z "$1" ]; then
  print_usage 1
fi

NODE_VERSION=$2

if [ $1 = "setup" ]; then

set -ex \
    && for key in \
        94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
        FD3A5288F042B6850C66B31F09FE44734EB7990E \
        71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
        DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
        C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
        B9AE9905FFD7803F25714661B63B535A4C206CA9 \
        56730D5401028683275BD23C23EFEFE93C4CFFFE \
        77984A986EBC2AA786BC0F66B01FBB92821C587A \
    ; do \
        gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
        gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
    done

elif [ $1 = "install" ]; then

curl -SL -o ~/.nodenv/node-v$NODE_VERSION-linux-x64.tar.xz "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz"
curl -SL -o ~/.nodenv/SHASUMS256.txt.asc --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc"
gpg --batch --decrypt --output ~/.nodenv/SHASUMS256.txt ~/.nodenv/SHASUMS256.txt.asc
(cd ~/.nodenv && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c -)
mkdir -p ~/.nodenv/v$NODE_VERSION
(cd ~/.nodenv && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C ./v$NODE_VERSION --strip-components=1)
rm ~/.nodenv/node-v$NODE_VERSION-linux-x64.tar.xz ~/.nodenv/SHASUMS256.txt ~/.nodenv/SHASUMS256.txt.asc

elif [ $1 = "set" ]; then

ln -sf $HOME/.nodenv/v$NODE_VERSION/bin/node ~/bin/node
ln -sf $HOME/.nodenv/v$NODE_VERSION/bin/npm ~/bin/npm
ln -sf $HOME/.nodenv/v$NODE_VERSION/bin/npx ~/bin/npx

elif [ $1 = "delete" ]; then
rm -rf "./v$NODE_VERSION"

else
  print_usage 1
fi


