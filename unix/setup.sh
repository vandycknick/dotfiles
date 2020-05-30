# Synchronise configuration
function doIt() {
    rsync -avh --no-perms . ~
    source ~/.bash_profile
}

CURRENT_DIR="$(pwd)"
cd "$(dirname "${BASH_SOURCE[0]}")/profile"

echo ""
echo "Synchronise profile script"
if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi
unset doIt

cd $CURRENT_DIR