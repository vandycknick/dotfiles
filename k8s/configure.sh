curl -L "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /tmp/kubectl
curl -L "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" -o /tmp/kubectl.sha256

pushd /tmp

RESULT=$(echo "$(<kubectl.sha256) kubectl" | sha256sum --check)

popd

if [[ "$RESULT" == "kubectl: OK" ]]; then
    sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
else
    echo "ERROR: can't install kubectl due to checksum missmatch!"
fi
