# ─── nixpkgs quick search across channels ────────────────────────────────

# Latest stable NixOS release branch (e.g. nixos-26.05), detected once and
# cached in a universal var. Clear with `set -e __np_stable` after a new release.
function _np_stable --description 'Latest stable nixpkgs branch'
    if not set -q __np_stable
        set -U __np_stable (git ls-remote --heads https://github.com/NixOS/nixpkgs 'nixos-*' \
            | string match -rg 'refs/heads/(nixos-\d+\.\d+)$' \
            | sort -V | tail -1)
    end
    echo $__np_stable
end

# Resolve a channel keyword → flake ref. Anything unrecognised is passed through
# verbatim, so you can also give a raw branch name or an exact commit rev.
function _np_ref
    switch $argv[1]
        case master ''
            echo github:NixOS/nixpkgs/master
        case unstable
            echo github:NixOS/nixpkgs/nixos-unstable
        case stable
            echo github:NixOS/nixpkgs/(_np_stable)
        case '*'
            echo github:NixOS/nixpkgs/$argv[1]
    end
end

# nps <channel> <pkg>   e.g. `nps stable coder`   (defaults to master)
function nps --description 'Exact-match package search in a nixpkgs channel'
    set -l pkg $argv[-1]
    set -l ch (test (count $argv) -ge 2; and echo $argv[1]; or echo master)
    nix search (_np_ref $ch) "^$pkg\$"
end

# npv <channel> <pkg>   → just the version   e.g. `npv unstable coder`
function npv --description 'Package version in a nixpkgs channel'
    set -l pkg $argv[-1]
    set -l ch (test (count $argv) -ge 2; and echo $argv[1]; or echo master)
    nix eval --raw (_np_ref $ch)"#$pkg.version"; and echo
end

# npall <pkg>   → compare version across master, unstable, and latest stable
function npall --description 'Compare a package version across nixpkgs channels'
    for ch in master unstable stable
        printf '%-9s %-14s %s\n' $ch (_np_ref $ch | string replace 'github:NixOS/nixpkgs/' '') \
            (nix eval --raw (_np_ref $ch)"#$argv[1].version" 2>/dev/null; or echo 'n/a')
    end
end

# Usage:
#
# nps coder            # search master (default)
# nps stable coder     # search latest stable (auto-detected as nixos-26.05)
# npv unstable coder   # just the version on nixos-unstable
# npall coder          # side-by-side across all three
