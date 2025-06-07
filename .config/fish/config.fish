
function motd
    echo -n "
  _.........._
 | |@mikejw | |
 | |dotfiles| |
 | |        | |
 | |________| |
 |   ______   |
 |  |    | |  |
 |__|____|_|__|
"
end

function exit_nix
    kill -9 $NIX_PID
end

function start_tmux
    if type -q tmux
        if not test -n "$TMUX"
            tmux attach-session -t default; or tmux new-session -s default
            alias exit "exit_nix"

        else
            fish_config theme choose "Base16 Eighties"
            motd
            nvm install v22.16.0
            fish_add_path ./bin

            alias exit "exit"
        end
    end
end

if status is-interactive
    set SHELL (which fish)
    start_tmux
end
