#!/bin/bash

# golang
export TZ=Europe/London

# ansible
export LANGUAGE="C.UTF-8"
export LANG="C.UTF-8"
export LC_COLLATE="C.UTF-8"
export LC_CTYPE="C.UTF-8"
export LC_MONETARY="C.UTF-8"
export LC_NUMERIC="C.UTF-8"
export LC_TIME="C.UTF-8"
export LC_MESSAGES="C.UTF-8"
export LC_ALL="C.UTF-8"


XDG_CONFIG_HOME=./.config $(which fish)
