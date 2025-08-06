{ pkgs ? import <nixpkgs> {} }:
  
pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs = with pkgs; [
    perl
    perlPackages.locallib
    perlPackages.Appcpanminus

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
    git
    ansible
    curl
    docker
    docker-compose
    packer
    go
    php
    wget
  ];

  shellHook = ''
    if [ -z "$TMUX" ]; then
      SESSION_NAME=default
      FISH=$(command -v fish)

      if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        exec tmux attach-session -t "$SESSION_NAME"
      else
        exec tmux new-session -s "$SESSION_NAME" "XDG_CONFIG_HOME=./.config exec $FISH"
      fi
    fi
'';
}
