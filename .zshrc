#!/bin/zsh
# vim: set foldmethod=marker ft=zsh:
# https://code.joejag.com/2014/why-zsh.html
# https://til.hashrocket.com/posts/alk38eeu8r-use-fc-to-fix-commands-in-the-shell

# ctrl-z won't work? remove ~/.zsh/log/jog.lock
# if using zplug, just `rm $_zplug_lock`
# https://github.com/zplug/zplug/issues/322#issuecomment-274557883

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
  $HOME/.{php,pl,nod,py}env/bin
  $HOME/.phpenv/pear/bin
  $HOME/.composer/vendor/bin
  $(gem env home)
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
  # homebrew zsh completions
  "/usr/local/share/zsh/site-functions"
  $fpath
)
# }}}

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
zplug "plugins/gitfast", from:oh-my-zsh, if:"which git" # fix git completion issues https://unix.stackexchange.com/a/204308
zplug "marzocchi/zsh-notify" # notify when a command fails or lasts longer than 30 seconds and the terminal is in the background (requires terminal-notifier)
zplug "zsh-users/zsh-autosuggestions" # OLD COMMENT: buggy if enabled along with zsh-syntax-highlighting. crashes the shell regularly.
zplug "zsh-users/zsh-completions" # do-everything argument completions
zplug "zsh-users/zsh-syntax-highlighting", defer:2 # colored input... see above
zplug 'zplug/zplug', hook-build:'zplug --self-manage' # manage itself

# DISABLED
# zplug "TheLocehiliosan/yadm", rename-to:_yadm, use:"completion/yadm.zsh_completion", as:command, defer:2 # yadm completion (not needed - comes with brew installation)
# zplug "jamesob/desk", from:github, as:command, use:"desk" # shell workspace manager
# zplug "hchbaw/auto-fu.zsh", at:pu
# zplug "b4b4r07/enhancd", use:init.sh # enhanced cd
# zplug "felixr/docker-zsh-completion" # docker completion (deprecated)
# zplug "gko/ssh-connect", use:ssh-connect.sh # ssh-connect to get a ssh session manager (broken - prefixes with an integer for some reason)
# zplug "hchbaw/auto-fu.zsh", use:"auto-fu.zsh" # autocompletion and suggestions
# zplug "peterhurford/up.zsh" # `up 2` to cd ../..
# zplug "plugins/docker", from:oh-my-zsh
# zplug "plugins/git", from:oh-my-zsh, if:"which git" # alias g to git and include completion. and other stuff.
# zplug "plugins/git-extras", from:oh-my-zsh, if:"which git" # I have this in brew already
# zplug "plugins/npm", from:oh-my-zsh, if:"which npm"
# zplug "plugins/phing", from:oh-my-zsh, if:"which phing"
# zplug "plugins/rake-fast", from:oh-my-zsh # rake task completion
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

# source additional files and env vars {{{
[ -f ~/.private_vars.sh ] && source ~/.private_vars.sh # where I store my secret env vars
[ -f ~/.support/promptline.theme.bash ] && source ~/.support/promptline.theme.bash # vim plugin generates this tmux status line file
[[ "$(builtin type -p direnv)" ]] && eval "$(direnv hook zsh)" # allow .envrc on each prompt start
# [ -f /usr/local/etc/grc.bashrc ] && source "/usr/local/etc/grc.bashrc" # generic colorizer
[ -f /usr/local/etc/grc.zsh ] && source "/usr/local/etc/grc.zsh" # generic colorizer
# https://github.com/google/google-api-ruby-client/issues/235#issuecomment-169956795
[ -f /usr/local/etc/openssl/cert.pem ] && export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem
[ -d "$HOME/.zsh/completion" ] && find "$HOME/.zsh/completion" | while read f; do source "$f"; done
# [[ "$(builtin type -p plenv)" ]] && eval "$(plenv init -)"
[[ "$(builtin type -p nodenv)" ]] && eval "$(nodenv init -)"
[[ "$(builtin type -p pyenv)" ]] && eval "$(pyenv init -)"
[[ -f "$HOME/.phpenv/bin/phpenv" ]] && eval "$($HOME/.phpenv/bin/phpenv init -)"
[[ "$(builtin type -p rbenv)" ]] && eval "$(rbenv init -)"
[[ "$(builtin type -p akamai)" ]] && eval "$(akamai --zsh)"
# [ -n "$DESK_ENV" ] && source "$DESK_ENV" || true # Hook for desk activation
# tabtab source for yo package
# uninstall by removing these lines or running `tabtab uninstall yo`
[[ -f /Users/mikefunk/.config/yarn/global/node_modules/tabtab/.completions/yo.zsh ]] && . /Users/mikefunk/.config/yarn/global/node_modules/tabtab/.completions/yo.zsh
export LC_CTYPE=en_US.UTF-8 # https://unix.stackexchange.com/a/302418/287898
export LC_ALL=en_US.UTF-8 # https://unix.stackexchange.com/a/302418/287898
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
alias joplin="/usr/local/bin/node `which joplin`" # joplin and nodenv do not mix. this uses homebrew node.
# alias jsc="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc" # javascript repl for testing javascript wonkiness
alias ncdu="ncdu --color dark -rr -x --exclude .git --exclude vendor" # enhanced interactive disk usage command

export CLICOLOR=1 # ls colors by default
# export NODE_PATH="/usr/local/lib/node_modules" # zombie.js doesn't work without this

# pretty-print PATH with line breaks
function pretty-path () { tr : '\n' <<<"$PATH"; }
alias vit="vim +TW" # until vit gets its act together
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
alias coverage="pu --coverage-html=./coverage && open coverage/index.html"
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
alias t="task"
alias tl="task list"
alias ta="task add"
# }}}

# vim {{{
alias v="vim"
# compdef v="vim"
export EDITOR=vim # aww yeah
export LANG=en_US.UTF-8
KEYTIMEOUT=1 # no vim delay entering normal mode
# }}}

# xdebug-toggle {{{
# alias xdebug-on="xdebug-toggle on --no-server-restart"
# alias xdebug-off="xdebug-toggle off --no-server-restart"
# alias xdebug-status="xdebug-toggle"
# usage: `xdb on` or `xdb off` or `xdb` for status
# xdb () { xdebug-toggle $1 --no-server-restart; }

function xdebug-off () {
    builtin cd "$(phpenv root)/versions/$( phpenv version | cut -d' ' -f1 )/etc/conf.d"
    if ! [ -f xdebug.ini ]; then
        echo "xdebug.ini does not exist"
        return 1
    fi
    mv xdebug.ini xdebug.ini.DISABLED
    builtin cd -
    echo "xdebug disabled"
}

function xdebug-on () {
    builtin cd "$(phpenv root)/versions/$( phpenv version | cut -d' ' -f1 )/etc/conf.d"
    if ! [ -f xdebug.ini.DISABLED ]; then
        echo "xdebug.ini.DISABLED does not exist"
        return 1
    fi
    mv xdebug.ini.DISABLED xdebug.ini
    builtin cd -
    echo "xdebug disabled"
}

function xdebug-status () {
    builtin cd "$(phpenv root)/versions/$( phpenv version | cut -d' ' -f1 )/etc/conf.d"
    [ -f ./xdebug.ini  ] && echo 'xdebug enabled' || echo 'xdebug disabled'
    builtin cd -
}
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
    # xdebug-off > /dev/null
    phpx -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    [[ $? == 0 ]] && noti --message "PHPUnit tests passed 👍" || noti --message "PHPUnit tests failed 👎"
    xdebug-on > /dev/null
}
# }}}
# }}}

# }}}

# source more files {{{
[ -e ~/.saatchirc.sh ] && source ~/.saatchirc.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # fuzzy finder - installed and managed via vim-plug https://github.com/junegunn/fzf
# }}}

# zsh options {{{
# most basic options are now set up by vanilla zplug plugin
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

# }}}
