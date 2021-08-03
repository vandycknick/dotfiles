#!/usr/bin/env bash
set -e

case "$(uname -s)" in
    Darwin)
        # install Command Line Tools
        if [[ ! -x /usr/bin/gcc ]]; then
          echo "[i] Install macOS Command Line Tools"
          xcode-select --install
        fi

        # install homwbrew
        if [[ ! -x /usr/local/bin/brew ]]; then
          echo "[i] Install Homebrew"
          ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi

        # install ansible
        if [[ ! -x /usr/local/bin/ansible ]]; then
            echo "[i] Install Ansible"
            brew install ansible
        fi

        ;;

    Linux)
        if [ -f /etc/os-release ]
            then
                echo "[i] Ask for sudo password"
                sudo -v

                . /etc/os-release

                case "$ID" in
                    debian | ubuntu)
                        if [[ ! -x /usr/bin/ansible ]]; then
                            echo "[i] Install Ansible"
                            sudo apt-get update
                            sudo apt-get install -y ansible
                        fi
                        ;;

                    arch)
                        if [[ ! -x /usr/bin/ansible ]]; then
                            echo "[i] Install Ansible"
                            sudo pacman -S ansible --noconfirm
                        fi
                        ;;

                    *)
                        echo "[!] Unsupported Linux Distribution: $ID"
                        exit 1
                        ;;
                esac
            else
                echo "[!] Unsupported Linux Distribution"
                exit 1
            fi
        ;;

    *)
        echo "[!] Unsupported OS"
        exit 1
        ;;
esac

# Run main playbook
echo "[i] Run Playbook"
ansible-playbook -i hosts dotfiles.yml --ask-become-pass

echo "[i] Done."
