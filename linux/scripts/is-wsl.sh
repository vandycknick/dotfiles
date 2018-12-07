function is-wsl() {
    if grep -q Microsoft /proc/version; then
        echo "Ubuntu on Windows"
    else
        echo "Native Linux"
    fi
}

echo $(is-wsl)