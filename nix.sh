#/!/bin/bash

export NIXPKGS_ALLOW_UNFREE=1
export NIX_PID=$$

nix-shell ./nix
