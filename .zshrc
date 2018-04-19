#!/bin/zsh
# vim: set foldmethod=marker ft=zsh:

# zplug {{{

# setup {{{
# unset ZPLUG_SHALLOW # shut up zplug!!
# export DISABLE_AUTO_TITLE="true" # prevent zsh from auto-updating tmux window title
source $HOME/.zplug/init.zsh
# }}}

# plugin definitions {{{
zplug "yous/vanilli.sh" # sensible zsh defaults
zplug "djui/alias-tips" # tell you when an alias would shorten the command you ran
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh # Plugin for highlighting file content
zplug 'mfaerevaag/wd', as:command, use:"wd.sh", hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"
zplug "marzocchi/zsh-notify" # notify when a command fails or lasts longer than 30 seconds and the terminal is in the background (requires terminal-notifier)
zplug "zsh-users/zsh-autosuggestions" # buggy if enabled along with zsh-syntax-highlighting. crashes the shell regularly.
zplug "zsh-users/zsh-completions" # do-everything argument completions
zplug "zsh-users/zsh-syntax-highlighting", defer:2 # colored input... see above
zplug 'zplug/zplug', hook-build:'zplug --self-manage' # manage itself
zplug "TheLocehiliosan/yadm", rename-to:_yadm, use:"completion/yadm.zsh_completion", as:command, defer:2

# DISABLED
# zplug "jamesob/desk", from:github, as:command, use:"desk" # shell workspace manager
# zplug "hchbaw/auto-fu.zsh", at:pu
# zplug "b4b4r07/enhancd", use:init.sh # enhanced cd
# zplug "felixr/docker-zsh-completion" # docker completion (deprecated)
# zplug "gko/ssh-connect", use:ssh-connect.sh # ssh-connect to get a ssh session manager
# zplug "hchbaw/auto-fu.zsh", use:"auto-fu.zsh" # autocompletion and suggestions
# zplug "peterhurford/up.zsh" # `up 2` to cd ../..
# zplug "plugins/docker", from:oh-my-zsh
# zplug "plugins/git", from:oh-my-zsh, if:"which git" # alias g to git and include completion. and other stuff.
# zplug "plugins/git-extras", from:oh-my-zsh, if:"which git" # I have this in brew already
# zplug "plugins/npm", from:oh-my-zsh, if:"which npm"
# zplug "plugins/phing", from:oh-my-zsh, if:"which phing"
# zplug "plugins/vagrant", from:oh-my-zsh, if:"which vagrant"
# zplug "plugins/vi-mode", from:oh-my-zsh
# zplug "plugins/wd", from:oh-my-zsh # "warp directory" bookmarking tool
# zplug "sharat87/zsh-vim-mode"
# zplug "supercrabtree/k" # pretty ls with git, filesize, and date features
# zplug "zplug/zplug" # zplugception!
# zplug "zsh-users/zaw" # completer with aliases, git branches, etc. <ctrl-x> to open
# }}}

# Install plugins if there are plugins that have not been installed {{{
if ! zplug check; then
    printf "Install zplug plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
# }}}
# }}}

# Paths {{{
cdpath=(
  $HOME/Code
  $cdpath
)

infopath=(
  $(brew --prefix)/share/info
  /usr/share/info
  $infopath
)

manpath=(
  $(brew --prefix)/share/man
  /usr/share/man
  $manpath
)

path=(
  # my own scripts
  $HOME/.bin
  # global ruby gems
  $HOME/bin
  $HOME/.{php,rb,pl,nod,py}env/bin
  $HOME/.phpenv/pear/bin
  $HOME/.composer/vendor/bin
  $(gem env home)
  $(brew --prefix)/{bin,sbin}
  # pip bin
  $HOME/.local/bin
  $ZPLUG_ROOT/bin
  /usr/{bin,sbin}
  /{bin,sbin}
  # /usr/local/opt/icu4c/{bin,sbin}
  $path
)

fpath=(
  "$ZPLUG_HOME/bin"
  $fpath
)
# }}}

# source additional files and env vars {{{
[ -f ~/.private_vars.sh ] && source ~/.private_vars.sh # where I store my secret env vars
[ -f ~/.support/promptline.theme.bash ] && source ~/.support/promptline.theme.bash # vim plugin generates this tmux status line file
# [ -f /usr/local/etc/grc.bashrc ] && source "/usr/local/etc/grc.bashrc" # generic colorizer
[ -f /usr/local/etc/grc.zsh ] && source "/usr/local/etc/grc.zsh" # generic colorizer
# https://github.com/google/google-api-ruby-client/issues/235#issuecomment-169956795
[ -f /usr/local/etc/openssl/cert.pem ] && export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem
[ -d "$HOME/.zsh/completion" ] && find "$HOME/.zsh/completion" | while read f; do source "$f"; done
[[ "$(builtin type -p plenv)" ]] && eval "$(plenv init -)"
[[ "$(builtin type -p rbenv)" ]] && eval "$(rbenv init -)"
[[ "$(builtin type -p nodenv)" ]] && eval "$(nodenv init -)"
[[ "$(builtin type -p pyenv)" ]] && eval "$(pyenv init -)"
[[ -f "$HOME/.phpenv/bin/phpenv" ]] && eval "$($HOME/.phpenv/bin/phpenv init -)"
# [ -n "$DESK_ENV" ] && source "$DESK_ENV" || true # Hook for desk activation

# disable autossh port monitoring and use ServerAliveInterval and
# ServerAliveCountMax instead.
# https://www.everythingcli.org/ssh-tunnelling-for-fun-and-profit-autossh/
export AUTOSSH_PORT=0
# }}}

# gpg {{{
# uncomment this to enable gpg passwords in the terminal
export GPG_TTY=`tty` # make gpg prompt for a password
export PINENTRY_USER_DATA="USE_CURSES=1"
# }}}

# functions and aliases {{{

# misc {{{
cd () { builtin cd "$@" && ls -FAG; } # auto ls on cd
alias ..="cd .."
alias ...="cd ..."
alias ll='ls -lhGFA'
alias phpx="php -dxdebug.remote_autostart=1 -dxdebug.remote_connect_back=1 -dxdebug.idekey=${XDEBUG_IDE_KEY} -dxdebug.remote_port=9000 -ddisplay_errors=on"
alias work="tmux attach -t Work || tmuxomatic ~/.tmuxomatic/Work"
alias home="tmux attach -t Home || tmuxomatic ~/.tmuxomatic/Home"
alias rmf='rm -rf'
compdef rmf="rm"
mkcd () { mkdir $1 && cd $1; }
alias src="source ~/.zshrc"
alias jobs="jobs -l"
# alias k="k --no-vcs"
alias pso="ps -o pid,command"
# alias add-keys="ssh-add -K ~/.ssh/keys/githubkey ~/.ssh/keys/bitbucketkey ~/.ssh/keys/saatchiartkey"
alias art="php artisan"
alias zpu="zplug update"
alias pc="phing -logger phing.listener.DefaultLogger"
compdef pc="phing"
alias pg="phing"
compdef pg="phing"

alias y="yadm"
compdef y="yadm"
alias yb="yadm bootstrap"
alias upgrades="yb"
alias save-dotfiles="yadm encrypt && yadm add -u && yadm ci -m working && yadm pu"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # fuzzy finder - installed and managed via vim-plug
export CLICOLOR=1 # ls colors by default
export NODE_PATH="/usr/local/lib/node_modules" # zombie.js doesn't work without this
[[ "$(builtin type -p direnv)" ]] && eval "$(direnv hook zsh)" # allow .envrc on each prompt start
ssh-add -A 2>/dev/null # add all keys stored in keychain if they haven't been added yet
compdef autossh="ssh"
# }}}

# suffix aliases {{{
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
alias coverage="pu --coverage-html=./coverage && open coverage/index.html"
alias puf="pu --filter="
alias puwatch="noglob ag -l -g '(application\/models|src|tests)/.*\\.php' | entr -r -c ./vendor/bin/phpunit --colors"
alias puw="puwatch"
# }}}

# composer {{{
alias cda="composer dump-autoload"
alias cu="composer update"
alias ci="composer install --prefer-dist"
alias cgu="composer global update"
alias cgi="composer global install"
# alias cgr="composer global require"
alias cgr="composer global bin main require"
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
alias t="tig"
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
alias psw="noglob ag -l -g '.*\\.php' | entr -r -c phpspec run"
# }}}

# pip {{{
# why is this so hard?
# alias pipu="pip list --outdated | cut -d' ' -f1 | xargs pip install --upgrade"
alias pipu="pip-review --local --auto"
# }}}

# vim {{{
alias v="vim"
compdef v="vim"
export EDITOR=vim # aww yeah
export LANG=en_US.UTF-8
KEYTIMEOUT=1 # no vim delay entering normal mode
# }}}

# xdebug-toggle {{{
alias xdebug-on="xdebug-toggle on --no-server-restart"
alias xdebug-off="xdebug-toggle off --no-server-restart"
alias xdebug-status="xdebug-toggle"
# usage: `xdb on` or `xdb off` or `xdb` for status
xdb () { xdebug-toggle $1 --no-server-restart; }
# }}}

# docker {{{
# docker-machine
alias dme="eval \$(docker-machine env default)"
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

function saatchi-mount-dir() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-mount-dir {/path/to/dir}"; return; fi;
    VboxManage sharedfolder add default --name $1 --hostpath $1 --automount
    sudo mount -t vboxsf -o uid=1000,gid=1000 $1 $1
}
# }}}

# phpunit {{{

# runs phpunit/phpspec and uses noti to show the results {{{
function phpunitnotify() {
    # xdebug-off > /dev/null
    php -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
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
    xdebug-off > /dev/null
    phpx -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    [[ $? == 0 ]] && noti --message "PHPUnit tests passed 👍" || noti --message "PHPUnit tests failed 👎"
    xdebug-on > /dev/null
}
# }}}
# }}}

# }}}

# source more files {{{
[ -e ~/.support/saatchirc.sh ] && source ~/.support/saatchirc.sh
# }}}

# zsh options {{{
# most basic options are now set up by vanilla zplug plugin
# zstyle ':completion:*' use-cache true
# }}}
