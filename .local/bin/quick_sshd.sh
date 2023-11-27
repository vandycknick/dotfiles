#!/bin/bash
#
# Create a separate user for tunneling
# sudo adduser tunnel
#
# Then tweak the passwd ever so slightly to
# tunnel:x:1001:1001:,,,:/home/tunnel:/usr/sbin/nologin

sshd_config=$(cat <<EOF
Port 2222
Protocol 2
PermitRootLogin no
PasswordAuthentication yes
AllowUsers tunnel
EOF
)

# Create a temporary file
temp_file=$(mktemp)
echo "$sshd_config" > "$temp_file"

sudo /usr/sbin/sshd -D -f "$temp_file" -e

rm "$temp_file"
