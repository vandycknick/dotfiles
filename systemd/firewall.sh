#!/bin/sh
set -eu

TABLE="nvim-remote"
CLIENT_IP="100.97.238.41"
PORT="4560"

case "$1" in
  up)
    nft delete table inet "$TABLE" 2>/dev/null || true

    nft add table inet "$TABLE"
    nft 'add chain inet nvim-remote input {
      type filter hook input priority -100;
      policy accept;
    }'

    nft add rule inet "$TABLE" input \
      iifname tailscale0 \
      ip saddr "$CLIENT_IP" \
      tcp dport "$PORT" \
      accept

    nft add rule inet "$TABLE" input \
      iifname tailscale0 \
      tcp dport "$PORT" \
      drop
    ;;

  down)
    nft delete table inet "$TABLE" 2>/dev/null || true
    ;;
esac
