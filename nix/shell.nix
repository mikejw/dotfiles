{ pkgs ? import <nixpkgs> {} }:
  
pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs = with pkgs; [
    perl
    perlPackages.locallib
    perlPackages.Appcpanminus
    perlPackages.LWPProtocolHttps
    perlPackages.IOSocketSSL
    perlPackages.MozillaCA
    cacert

    caddy

    mariadb

    # Native deps for XML::Parser
    expat
    pkg-config

    # Native deps for LWP::UserAgent and friends
    openssl
    zlib

    which
    emacs-nox
    fish
    tmux
    fishPlugins.nvm
    virtualenv
    gitFull
    ansible
    curl
    docker
    docker-compose
    go
    wget
    packer

    imagemagick
    (php.withExtensions ({ enabled, all }: enabled ++ [
      all.xdebug
      all.imagick
    ]))
  ];

  shellHook = ''
    if [ -z "$TMUX" ]; then
      SESSION_NAME=default
      FISH=$(command -v fish)
      # Get the absolute path to the repo root (where .config lives)
      # Try git first, then fall back to resolving from current directory
      REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || realpath . 2>/dev/null || pwd)"
      CONFIG_HOME="$REPO_ROOT/.config"

      if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        exec tmux attach-session -t "$SESSION_NAME"
      else
        exec tmux new-session -s "$SESSION_NAME" "XDG_CONFIG_HOME=\"$CONFIG_HOME\" exec $FISH"
      fi
    fi
'';
}
