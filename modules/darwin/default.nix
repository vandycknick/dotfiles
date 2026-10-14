{
  config,
  lib,
  pkgs,
  ...
}:
let
  brewfile = ./Brewfile;
in
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
  lib.mkMerge [
    {
      # ~/.docker/config.json uses credsStore osxkeychain.
      home.packages = [ pkgs.docker-credential-helpers ];
    }

    (lib.mkIf config.dotfiles.desktop {
      home.packages = [ pkgs._1password-cli ];

      targets.darwin.defaults = {
        # Keep AeroSpace stable: https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control
        "com.apple.dock".expose-group-apps = true;
        "com.apple.spaces".spans-displays = true;
        NSGlobalDomain.NSQuitAlwaysKeepsWindows = false;
      };

      # Nested keys; targets.darwin.defaults would replace all of DesktopViewSettings.
      home.activation.finderDesktopView = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        view=$(/usr/bin/defaults read com.apple.finder DesktopViewSettings 2>/dev/null || true)
        case "$view" in
          *"GroupBy = Kind"*"arrangeBy = dateAdded"* | *"arrangeBy = dateAdded"*"GroupBy = Kind"*) ;;
          *)
            plist="$HOME/Library/Preferences/com.apple.finder.plist"
            run /usr/bin/defaults write com.apple.finder DesktopViewSettings -dict-add GroupBy Kind
            if ! run /usr/bin/plutil -replace DesktopViewSettings.IconViewSettings.arrangeBy -string dateAdded "$plist" 2>/dev/null; then
              run /usr/bin/plutil -insert DesktopViewSettings.IconViewSettings -dictionary "$plist" 2>/dev/null || true
              run /usr/bin/plutil -insert DesktopViewSettings.IconViewSettings.arrangeBy -string dateAdded "$plist"
            fi
            run /usr/bin/killall Finder 2>/dev/null || true
            ;;
        esac
      '';

      # Installs the Brewfile and removes anything it doesn't list.
      home.activation.homebrewBundle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        brew=""
        for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
          if [ -x "$candidate" ]; then
            brew=$candidate
            break
          fi
        done
        if [ -z "$brew" ]; then
          warnEcho "Homebrew is not installed; skipping the Brewfile (dot init installs it)."
        else
          export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ENV_HINTS=1
          if ! "$brew" bundle check --file=${brewfile} --no-upgrade >/dev/null 2>&1; then
            run "$brew" bundle install --file=${brewfile} --no-upgrade
          fi
          run "$brew" bundle cleanup --file=${brewfile} --force
        fi
      '';
    })
  ]
)
