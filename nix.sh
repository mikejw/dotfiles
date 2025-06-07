#/!/bin/bash

exit_nix() {
  #kill -9 $NIX_PID
  echo "exiting..."
}

export NIX_PID=$$

export -f exit_nix

nix-shell ./nix
