# Download

curl -O https://nodejs.org/dist/v6.9.5/node-v6.9.5-darwin-x64.tar.gz

# Make location directory
mkdir v6.9.5

# Unzip into the new directory
tar -C ./v6.9.5 --strip-components 1 -xzvf node-v6.9.5-darwin-x64.tar.gz


# Link node adn npm into path
ln -sf /Users/nickvd/.node-versions/v6.9.5/bin/node ~/.bin/node
ln -sf /Users/nickvd/.node-versions/v6.9.5/bin/npm ~/.bin/npm
