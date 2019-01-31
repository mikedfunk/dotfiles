#!/bin/zsh
# vim: set foldmethod=marker ft=zsh:
# https://code.joejag.com/2014/why-zsh.html
# https://til.hashrocket.com/posts/alk38eeu8r-use-fc-to-fix-commands-in-the-shell

# ctrl-z won't work? remove ~/.zsh/log/jog.lock

# Paths {{{
cdpath=(
  $HOME/Code
  $cdpath
)

infopath=(
  # $(brew --prefix)/share/info
  /usr/local/share/info
  /usr/share/info
  $infopath
)

manpath=(
  # $(brew --prefix)/share/man
  /usr/local/share/man
  /usr/share/man
  $manpath
)

path=(
  # my own scripts
  $HOME/.bin
  # global ruby gems
  $HOME/bin
  # this needs to be first so rbenv from homebrew can take precedence
  # $(brew --prefix)/{bin,sbin}
  /usr/local/{bin,sbin}
  # golang packages
  $HOME/go/bin
  # rust cargo packages
  # $HOME/.cargo/bin
  # golang executables
  /usr/local/opt/go/libexec/bin
  $HOME/.{php,pl,nod,py}env/bin
  $HOME/.pyenv/shims
  $HOME/.phpenv/pear/bin
  $HOME/.composer/vendor/bin
  $(gem env home)
  # pip bin
  $HOME/.local/bin
  /usr/{bin,sbin}
  /{bin,sbin}
  # /usr/local/opt/icu4c/{bin,sbin}
  $path
)

# weird that I have to specify zsh functions. That should work out of the box,
# but it doesn't. If I don't source that I get compdef undefined.
fpath=(
  # homebrew zsh completions
  "/usr/local/share/zsh/functions"
  "/usr/local/share/zsh/site-functions"
  $fpath
)
# }}}

# antibody {{{
# If I re-source antibody init a second time it takes MINUTES to reinit. Even
# if I re-run antibody bundle commands it takes progressively longer each time
# I reload. Better to just run once on load. Only takes 3 seconds the first
# time.
if [[ ! $ANTIBODY_LOADED ]]; then
    source <(antibody init)

    antibody bundle yous/vanilli.sh # sensible zsh defaults
    antibody bundle djui/alias-tips # tell you when an alias would shorten the command you ran
    antibody bundle robbyrussell/oh-my-zsh path:plugins/colored-man-pages
    antibody bundle robbyrussell/oh-my-zsh path:plugins/colorize # Plugin for highlighting file content
    # antibody bundle mfaerevaag/wd # antibody doesn't like this. It dies.
    antibody bundle robbyrussell/oh-my-zsh path:plugins/wd
    antibody bundle robbyrussell/oh-my-zsh path:plugins/vi-mode
    # # zplug 'mfaerevaag/wd', as:command, use:"wd.sh", hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"
    antibody bundle robbyrussell/oh-my-zsh path:plugins/gitfast # fix git completion issues https://unix.stackexchange.com/a/204308 downside: this also adds a TON of gxx aliases https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/gitfast it also adds MORE git aliases and functions from the main git plugin https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/git/git.plugin.zsh
    antibody bundle marzocchi/zsh-notify # notify when a command fails or lasts longer than 30 seconds and the terminal is in the background (requires terminal-notifier)
    antibody bundle zsh-users/zsh-autosuggestions # OLD COMMENT: buggy if enabled along with zsh-syntax-highlighting. crashes the shell regularly.
    antibody bundle zsh-users/zsh-completions # do-everything argument completions
    antibody bundle zsh-users/zsh-syntax-highlighting # colored input... see above
    # antibody bundle zsh-users/zsh-history-substring-search # up arrow after typing part of command

    ANTIBODY_LOADED=1
fi
# }}}

# source additional files and env vars {{{
[ -f ~/.private_vars.sh ] && source ~/.private_vars.sh # where I store my secret env vars
[ -f ~/.support/promptline.theme.bash ] && source ~/.support/promptline.theme.bash # vim plugin generates this tmux status line file
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)" # allow .envrc on each prompt start
# [ -f /usr/local/etc/grc.bashrc ] && source "/usr/local/etc/grc.bashrc" # generic colorizer
[ -f /usr/local/etc/grc.zsh ] && source "/usr/local/etc/grc.zsh" # generic colorizer
# https://github.com/google/google-api-ruby-client/issues/235#issuecomment-169956795
[ -f /usr/local/etc/openssl/cert.pem ] && export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem
# [ -d "$HOME/.zsh/completion" ] && find "$HOME/.zsh/completion" | while read f; do source "$f"; done
# command -v plenv >/dev/null 2>&1 && eval "$(plenv init -)"
command -v nodenv >/dev/null 2>&1 && eval "$(nodenv init -)"
# https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#pyenv-global
# strangely this is already set BEFORE this file is sourced!
unset PYENV_VERSION
# PYENV_VERSION="$(cat $HOME/.pyenv/version)"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"
# command -v pyenv-virtualenv-init >/dev/null 2>&1 && eval "$(pyenv virtualenv-init -)"
[[ -f "$HOME/.phpenv/bin/phpenv" ]] && eval "$($HOME/.phpenv/bin/phpenv init -)"
command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"
command -v akamai >/dev/null 2>&1 && eval "$(akamai --zsh)" # compinit: function definition file not found
# [ -f "/usr/local/opt/asdf/asdf.sh" ] && source "/usr/local/opt/asdf/asdf.sh"
# [ -n "$DESK_ENV" ] && source "$DESK_ENV" || true # Hook for desk activation
# tabtab source for yo package
# uninstall by removing these lines or running `tabtab uninstall yo`
# [[ -f /Users/mikefunk/.config/yarn/global/node_modules/tabtab/.completions/yo.zsh ]] && . /Users/mikefunk/.config/yarn/global/node_modules/tabtab/.completions/yo.zsh
export LC_CTYPE=en_US.UTF-8 # https://unix.stackexchange.com/a/302418/287898
export LC_ALL=en_US.UTF-8 # https://unix.stackexchange.com/a/302418/287898
# https://github.com/variadico/noti/blob/master/docs/noti.md#environment
export NOTI_NSUSER_SOUNDNAME="Hero"
command -v vivid >/dev/null 2>&1 && export LS_COLORS="$(vivid generate molokai)" # https://github.com/sharkdp/vivid
# }}}

# ssh {{{
# disable autossh port monitoring and use ServerAliveInterval and
# ServerAliveCountMax instead.
# https://www.everythingcli.org/ssh-tunnelling-for-fun-and-profit-autossh/
export AUTOSSH_PORT=0

# pass the current ssh alias. Used by my promptline theme and .screenrc to show the alias in the PS1.
function ssh () { LC_SSH_ALIAS=$1 /usr/bin/ssh $@; }
function autossh () { LC_SSH_ALIAS=$1 /usr/local/bin/autossh $@; }
function sshrc () { LC_SSH_ALIAS=$1 /usr/local/bin/sshrc $@; }

compdef autossh="ssh"
compdef sshrc="ssh"

ssh-add -A 2>/dev/null # add all keys stored in keychain if they haven't been added yet
# }}}

# gpg {{{
# uncomment this to enable gpg passwords in the terminal
export GPG_TTY=`tty` # make gpg prompt for a password
export PINENTRY_USER_DATA="USE_CURSES=1"
# }}}

# functions and aliases {{{

# misc {{{
alias info="info --vi-keys"
alias starwars="telnet towel.blinkenlights.nl" # :)
cd () { builtin cd "$@" && ls -FAG; } # auto ls on cd
alias ..="cd .."
alias ...="cd ../.."
alias ll='ls -lhGFA'
alias phpx="php -dxdebug.remote_autostart=1 -dxdebug.remote_connect_back=1 -dxdebug.idekey=${XDEBUG_IDE_KEY} -dxdebug.remote_port=9000 -ddisplay_errors=on"
alias work="tmux attach -t Work || tmuxomatic ~/.tmuxomatic/Work"
alias home="tmux attach -t Home || tmuxomatic ~/.tmuxomatic/Home"
alias rmf='rm -rf'
compdef rmf="rm"
mkcd () { mkdir $1 && cd $1; }
compdef mkcd="mkdir"
alias src="source ~/.zshrc"
alias jobs="jobs -l"
# alias k="k --no-vcs"
alias pso="ps -o pid,command"
# alias add-keys="ssh-add -K ~/.ssh/keys/githubkey ~/.ssh/keys/bitbucketkey ~/.ssh/keys/saatchiartkey"
alias art="php artisan"
alias pc="phing -logger phing.listener.DefaultLogger"
# compdef pc="phing"
alias pg="phing"
# compdef pg="phing"

alias y="yadm"
compdef y="yadm"
alias yb="yadm bootstrap"
alias upgrades="yb"
alias save-dotfiles="yadm encrypt && yadm add -u && yadm ci -m working && yadm pu"
alias joplin="/usr/local/bin/node `which joplin`" # joplin and nodenv do not mix. this uses homebrew node.
# alias jsc="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc" # javascript repl for testing javascript wonkiness
alias ncdu="ncdu --color dark -rr -x --exclude .git --exclude vendor" # enhanced interactive disk usage command

export CLICOLOR=1 # ls colors by default
# export NODE_PATH="/usr/local/lib/node_modules" # zombie.js doesn't work without this

# pretty-print PATH with line breaks
function pretty-path () { tr : '\n' <<<"$PATH"; }
alias vit="vim +TW" # until vit gets its act together
# alias tree="alder" # colorized tree from npm (I colorize tree with "vivid" now so this is not needed)
# }}}

# suffix aliases {{{
# https://unix.stackexchange.com/questions/354960/zsh-suffix-alias-alternative-in-bash
alias -s css=vim
alias -s html=vim
alias -s js=vim
alias -s json=vim
alias -s jsx=vim
alias -s markdown=vim
alias -s md=vim
alias -s phar=php
alias -s php=vim
alias -s phtml=vim
alias -s rb=vim
alias -s scss=vim
alias -s txt=vim
alias -s xml=vim
alias -s xql=vim
alias -s yaml=vim
alias -s yml=vim
# }}}

# brew {{{
alias bru="brew update && brew upgrade"
alias bri="brew install"
# }}}

# phpunit {{{
alias pu="phpunitnotify"
function phpunit-coverage () { pu --coverage-html=./coverage $@ && open coverage/index.html; }
function phpspec-coverage () { phpdbg -qrr ./vendor/bin/phpspec run --config ./phpspec-coverage.yml $@ && open coverage/index.html; }
alias puf="pu --filter="
# alias puwatch="noglob ag -l -g '\
#     (application\/controllers|application\/modules\/*\/controllers|application\/models|library|src|tests)/.*\\.php\
#     ' | entr -r -c ./vendor/bin/phpunit --colors"
# alias puw="puwatch"
alias puw="php -dmemory_limit=2048M -ddisplay_errors=on -derror_reporting='E_ALL & ~E_NOTICE' $(which phpunit-watcher) watch"
# }}}

# composer {{{
alias cda="composer dump-autoload"
alias cu="composer update"
alias ci="composer install --prefer-dist"
alias cgu="composer global update"
alias cgi="composer global install"
# alias cgr="composer global require"
# alias cgr="composer global bin main require"
alias cr="composer require"
alias crd="composer require --dev"
# }}}

# git {{{
alias g="git"
compdef g="git"
function grt () { cd `g root`; }
alias cdg="grt"
alias git-standup="$HOME/.config/yarn/global/node_modules/.bin/git-standup" # use this instead of the one in brew git-extras
# alias standup="tig --since='2 days ago' --author='Mike Funk' --no-merges"
# Experimenting with using taskwarrior for this instead
# alias t="tig"
alias ts="tig status"
alias td="tig develop.."
alias tm="tig master.."
# }}}

# yarn {{{
alias ya="yarn add"
alias yad="yarn add --dev"
alias yga="yarn global add"
alias ygu="yarn global upgrade"
# }}}

# phpspec {{{
alias psr="phpspecnotify"
alias psd="phpspec describe"
# alias psw="phpspec-watcher watch"
alias psw="noglob ag -l -g '.*\\.php' | entr -r -c noti --message \"PHPSpec passed 👍\" phpspec run -vvv"
# function phpspecnotify () {
#     php -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpspec "${@}"
#     [[ $? == 0 ]] && noti --message "PHPSpec specs passed 👍" ||
#         noti --message "PHPSpec specs failed 👎"
# }
# }}}

# pip {{{
# why is this so hard?
# alias pipu="pip list --outdated | cut -d' ' -f1 | xargs pip install --upgrade"
alias pipu="pip-review --local --auto"
# }}}

# taskwarrior {{{
# note: this conflicts with tig
# alias t="task"
# alias tl="task list"
# alias ta="task add"
# }}}

# vim {{{

# vim 8 {{{
# alias v="vim"
# compdef v="vim"
# export EDITOR=vim # aww yeah
# }}}

# neovim {{{
alias v="nvim"
compdef v="nvim"
alias vim="nvim"
compdef vim="nvim"
export EDITOR=nvim # aww yeah
export LANG=en_US.UTF-8
KEYTIMEOUT=1 # no vim delay entering normal mode
# }}}

# }}}

# xdebug-toggle {{{
# alias xdebug-on="xdebug-toggle on --no-server-restart"
# alias xdebug-off="xdebug-toggle off --no-server-restart"
# alias xdebug-status="xdebug-toggle"
# usage: `xdb on` or `xdb off` or `xdb` for status
# xdb () { xdebug-toggle $1 --no-server-restart; }

function xdebug-off () {
    PHP_VERSION="$( phpenv version | cut -d' ' -f1 )"
    builtin cd "$(phpenv root)/versions/${PHP_VERSION}/etc/conf.d"
    if ! [ -f xdebug.ini ]; then
        echo "xdebug.ini does not exist"
        return 1
    fi
    mv xdebug.ini xdebug.ini.DISABLED
    builtin cd -
    echo "xdebug disabled"
}

function xdebug-on () {
    builtin cd "$(phpenv root)/versions/${PHP_VERSION}/etc/conf.d"
    if ! [ -f xdebug.ini.DISABLED ]; then
        echo "xdebug.ini.DISABLED does not exist"
        return 1
    fi
    mv xdebug.ini.DISABLED xdebug.ini
    builtin cd -
    echo "xdebug disabled"
}

function xdebug-status () {
    builtin cd "$(phpenv root)/versions/${PHP_VERSION}/etc/conf.d"
    [ -f ./xdebug.ini  ] && echo 'xdebug enabled' || echo 'xdebug disabled'
    builtin cd -
}
# }}}

# docker {{{
# docker-machine
alias dme="eval \$(docker-machine env default)"
# alias dme=":" # no-op because I don't use docker-machine any more
alias dmc="docker-machine create --driver=virtualbox --virtualbox-memory=4096 --virtualbox-disk-size=40000 default" # 40gb hard drive, 4gb memory
alias dmd="VBoxManage discardstate default" # the virtualbox vm doesn't like to come back up when suspended.
alias dmi="dme && docker-machine ip"
alias dms="docker-machine start && dme"
# alias dmr="docker-machine regenerate-certs default"
alias dmr="dme && docker-machine restart && dme"
alias dps="dme && docker ps"
alias dmt="dme && docker-machine status"
alias dmu="dme && docker-machine upgrade"

# docker-compose
alias dcr="dme && docker-compose restart"
alias dcu="dme && docker-compose up"
alias dcb="dme && docker-compose build"
alias dcd="dme && docker-compose stop"
alias dcp="dme && docker-compose ps"

# https://github.com/moby/moby/issues/9098#issuecomment-189743947
# kill docker exec processes on ctrl-c
# it's not perfect but it does stop the process
function _docker_cleanup {
    docker exec $IMAGE bash -c "if [ -f $PIDFILE ]; then kill -TERM -\$(cat $PIDFILE); rm $PIDFILE; fi"
}

function _docker_exec {
    IMAGE=$1
    PIDFILE=/tmp/docker-exec-$$
    shift
    trap 'kill $PID; _docker_cleanup $IMAGE $PIDFILE' TERM INT
    docker exec $IMAGE bash -c "echo \"\$\$\" > $PIDFILE; exec $*" &
    PID=$!
    wait $PID
    trap - TERM INT
    wait $PID
}

alias docker-restart="osascript -e 'quit app \"Docker\"' && open -a Docker"
function docker-stats {
    dme
    docker stats --format "table $(tput setaf 2){{.Name}}\t$(tput setaf 3){{.CPUPerc}}\t$(tput setaf 4){{.MemPerc}}" | sed -E -e "s/(NAME.*)/$(tput smul)\1$(tput sgr0)/"
}
# }}}

# phpunit {{{

# runs phpunit/phpspec and uses noti to show the results {{{
function phpunitnotify() {
    # xdebug-off > /dev/null
    php -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    # phpdbg -qrr -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    [[ $? == 0 ]] && noti --message "PHPUnit tests passed 👍" ||
        noti --message "PHPUnit tests failed 👎"
    # xdebug-on > /dev/null
}
function phpspecnotify() {
    # xdebug-off > /dev/null
    php -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpspec run "${@}"
    # php -dxdebug.remote_autostart=1 -dxdebug.remote_connect_back=1 -dxdebug.idekey=${XDEBUG_IDE_KEY} -dxdebug.remote_port=9015 -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpspec run "${@}"
    [[ $? == 0 ]] && noti --message "Specs passed 👍" ||
        noti --message "Specs failed 👎"
    # xdebug-on > /dev/null
}
# }}}

# phpunit with xdebug turned on {{{
function pux() {
    # xdebug-off > /dev/null
    phpx -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    [[ $? == 0 ]] && noti --message "PHPUnit tests passed 👍" || noti --message "PHPUnit tests failed 👎"
    xdebug-on > /dev/null
}
# }}}
# }}}

# wd {{{
# load from ruby bin
wd() {
  . /Users/mikefunk/bin/wd/wd.sh
}
# }}}

# sourcegraph {{{
# only works with docker-for-mac, not docker-machine :/
# https://about.sourcegraph.com/docs/
# alias sourcegraph="dme && docker run -d --publish 7080:7080 --rm --volume ~/.sourcegraph/config:/etc/sourcegraph --volume ~/.sourcegraph/data:/var/opt/sourcegraph --volume /var/run/docker.sock:/var/run/docker.sock sourcegraph/server:2.13.5"
# }}}

# swagger {{{
# bring up a swagger web editor that can interact with your local api
# https://github.com/huan/swagger-edit
function swagger-edit() {
    dme && docker run -ti --rm --volume="$(pwd)":/swagger -p 8080:8080 zixia/swagger-edit "$@"
}
# }}}

# }}}

# source more files {{{
[ -e ~/.saatchirc.sh ] && source ~/.saatchirc.sh
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # fuzzy finder - installed and managed via vim-plug https://github.com/junegunn/fzf
# }}}

# zsh options {{{
# most basic options are now set up by vanilla zsh plugin
# zstyle ':completion:*' use-cache true

# fuzzy completion: cd ~/Cde -> ~/Code
# https://superuser.com/a/815317
# 0 -- vanilla completion (abc => abc)
# 1 -- smart case completion (abc => Abc)
# 2 -- word flex completion (abc => A-big-Car)
# 3 -- full flex completion (abc => ABraCadabra)
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'
autoload -U edit-command-line

# https://wrotenwrites.com/a_modern_terminal_workflow_3/#Spellcheck-Typo-Correction
# setopt correctall
# alias git-status='nocorrect git status'

# zsh keybinds {{{
# up/down allows searching history by prefix e.g. `cd {up}`
# https://unix.stackexchange.com/questions/16101/zsh-search-history-on-up-and-down-keys#100860
# bindkey "[A" history-beginning-search-backward
# bindkey "[B" history-beginning-search-forward
# }}}

# }}}
