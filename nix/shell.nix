{ pkgs ? import <nixpkgs> {} }:
  
pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs = with pkgs.buildPackages; [
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
  ];

  shellHook = ''
    ./nix/start.sh
  '';
}
