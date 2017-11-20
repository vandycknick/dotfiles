function is_wsl() {
    if grep -q Microsoft /proc/version; then
        echo "Ubuntu on Windows"
    else
        echo "native Linux"
    fi
}

echo $(is_wsl)