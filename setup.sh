# copy paste this file in bit by bit.
# don't run it.
echo "do not run this script in one go. hit ctrl-c NOW"
read -n 1

#Install homebrew : http://brew.sh/
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/versions

#Install cask : http://caskroom.io/
brew install caskroom/cask/brew-cask
brew tap caskroom/versions

#Install the .NET Version Manager (DNVM)
#http://docs.asp.net/en/latest/getting-started/installing-on-mac.html
brew untap aspnet/dnx
brew tap aspnet/dnx

# Build and install msbuild (mono required)
cd ~/bin
git clone https://github.com/Microsoft/msbuild.git
cd ~/bin/msbuild
git checkout xplat
perl build.pl