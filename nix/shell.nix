{ pkgs ? import <nixpkgs> {
    overlays = [
      (import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
    ];
  }
}:

let
  rustToolchain = pkgs.rust-bin.stable."1.91.0".default;
in

pkgs.mkShell {
  # Nix glibc does not include host locales. New tmux panes are login shells,
  # and /etc/locale.conf sets LANG=en_GB.UTF-8.
  LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";

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

    libusb1
    rustToolchain

    awscli2

    (php.withExtensions ({ enabled, all }: enabled ++ [
      all.xdebug
      all.imagick
      all.mailparse
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

      # The first window used to be the only fish. New panes otherwise start
      # default-shell (bash) with XDG_CONFIG_HOME=$HOME/.config.
      configure_tmux() {
        tmux set-option -g default-shell "$FISH"
        tmux set-option -g default-command "exec \"$FISH\""
        tmux set-environment -g XDG_CONFIG_HOME "$CONFIG_HOME"
        tmux set-environment -g LOCALE_ARCHIVE "$LOCALE_ARCHIVE"
        tmux set-environment -g IN_NIX_SHELL "$IN_NIX_SHELL"
        if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
          tmux set-environment -t "$SESSION_NAME" XDG_CONFIG_HOME "$CONFIG_HOME"
          tmux set-environment -t "$SESSION_NAME" LOCALE_ARCHIVE "$LOCALE_ARCHIVE"
          tmux set-environment -t "$SESSION_NAME" IN_NIX_SHELL "$IN_NIX_SHELL"
        fi
      }

      if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        configure_tmux
        exec tmux attach-session -t "$SESSION_NAME"
      else
        tmux start-server
        configure_tmux
        exec tmux new-session -s "$SESSION_NAME"
      fi
    fi
  '';
}