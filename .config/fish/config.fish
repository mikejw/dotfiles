
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

function go-env --description 'Set environment variables for Go'
    set -gx TZ Europe/London
end

function ansible-env --description 'Set environment variables for Ansible/locale'
    set -gx LANGUAGE C.UTF-8
    set -gx LANG C.UTF-8
    set -gx LC_COLLATE C.UTF-8
    set -gx LC_CTYPE C.UTF-8
    set -gx LC_MONETARY C.UTF-8
    set -gx LC_NUMERIC C.UTF-8
    set -gx LC_TIME C.UTF-8
    set -gx LC_MESSAGES C.UTF-8
    set -gx LC_ALL C.UTF-8
end

function perl-env --description 'Set up local::lib for Perl'
    set -gx PERL_LOCAL_LIB_ROOT (pwd)/.perl5
    set -gx PERL_MB_OPT "--install_base $PERL_LOCAL_LIB_ROOT"
    set -gx PERL_MM_OPT "INSTALL_BASE=$PERL_LOCAL_LIB_ROOT"
    set -gx PERL5LIB "$PERL_LOCAL_LIB_ROOT/lib/perl5:$PERL5LIB"
    set -gx PATH "$PERL_LOCAL_LIB_ROOT/bin:$PATH"

    if test -d "$PERL_LOCAL_LIB_ROOT/lib/perl5"
        eval (perl -I"$PERL_LOCAL_LIB_ROOT/lib/perl5" -Mlocal::lib="$PERL_LOCAL_LIB_ROOT")
    end
end

# cpanm shebang fix
function cpanm
    if set -q shell
        set -e shell
    end
    perl (which cpanm) $argv
end

function start
    fish_config theme choose "Base16 Eighties"
    motd
    nvm use 22.16.0 > /dev/null 2>&1
    fish_add_path ./bin
    go-env
    ansible-env
    perl-env
end

if status is-interactive
    set -gx SHELL (which fish)
    if test -n "$IN_NIX_SHELL"
        start
    end
end
