#!/usr/bin/env bash

export NIXPKGS_ALLOW_UNFREE=1
export NIX_PID=$$

# Interactive nix-shell sources ~/.bashrc before shellHook. This machine's
# bashrc starts /bin/fish and blocks there, so tmux (and the motd) never run
# until that fish is exited. --run is non-interactive and skips bashrc.
# shellHook execs tmux; the command is only reached when already inside tmux.
nix-shell ./nix --run 'if [ -n "$TMUX" ]; then exec "${SHELL:-bash}"; fi'




