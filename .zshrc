#!/bin/zsh
# vim: set foldmethod=marker ft=zsh:

# zplug {{{

# setup {{{
unset ZPLUG_SHALLOW # shut up zplug!!
export DISABLE_AUTO_TITLE="true" # prevent zsh from auto-updating tmux window title
source $HOME/.zplug/init.zsh
# }}}

# plugin definitions {{{
zplug "djui/alias-tips" # tell you when an alias would shorten the command you ran
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh # Plugin for highlighting file content
zplug 'mfaerevaag/wd', as:command, use:"wd.sh", hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"
zplug "marzocchi/zsh-notify" # notify when a command fails or lasts longer than 30 seconds and the terminal is in the background (requires terminal-notifier)
zplug "zsh-users/zsh-autosuggestions" # buggy if enabled along with zsh-syntax-highlighting. crashes the shell regularly.
zplug "zsh-users/zsh-completions" # do-everything argument completions
zplug "zsh-users/zsh-syntax-highlighting", defer:2 # colored input... see above
zplug 'zplug/zplug', hook-build:'zplug --self-manage' # manage itself

# DISABLED
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
  $HOME/.bin
  # $HOME/.{php,rb,pl,nod,py}env/{bin,shims}
  $HOME/.phpenv/pear/bin
  $HOME/.composer/vendor/bin
  $(gem env home)
  $(brew --prefix)/{bin,sbin}
  $HOME/.local/bin
  $ZPLUG_ROOT/bin
  /usr/{bin,sbin}
  /{bin,sbin}
  # /usr/local/opt/icu4c/{bin,sbin}
  $path
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
mkcd () { mkdir $1 && cd $1; }
alias src="source ~/.zshrc"
alias jobs="jobs -l"
alias k="k --no-vcs"
alias pso="ps -o pid,command"
alias add-keys="ssh-add -K ~/.ssh/keys/githubkey ~/.ssh/keys/bitbucketkey ~/.ssh/keys/saatchiartkey"
alias art="php artisan"
alias zpu="zplug update"
alias pc="phing -logger phing.listener.DefaultLogger"
alias pg="phing"

alias y="yadm"
alias yb="yadm bootstrap"
alias upgrades="yb"
alias save-dotfiles="yadm add -u && yadm ci -m working && yadm pu"
# TODO: figure out how to properly use pinentry to save password to keychain
# https://github.com/TheLocehiliosan/yadm/issues/110
alias save-privates="yadm encrypt && yadm add -u && yadm ci -m working && yadm pu"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # fuzzy finder - installed and managed via vim-plug
export CLICOLOR=1 # ls colors by default
export NODE_PATH="/usr/local/lib/node_modules" # zombie.js doesn't work without this
[[ "$(builtin type -p direnv)" ]] && eval "$(direnv hook zsh)" # allow .envrc on each prompt start
ssh-add -A 2>/dev/null # add all keys stored in keychain if they haven't been added yet
compdef autossh="ssh"
# }}}

# suffix aliases {{{
alias -s php=vim
alias -s js=vim
alias -s css=vim
alias -s scss=vim
alias -s jsx=vim
alias -s yml=vim
alias -s yaml=vim
alias -s json=vim
alias -s txt=vim
alias -s md=vim
alias -s markdown=vim
alias -s phtml=vim
alias -s html=vim
alias -s rb=vim
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
alias grt="cd `g root`" # I can't do this as a git alias
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
setopt auto_cd # if a command is a directory cd to it
setopt auto_pushd # Make cd push the old directory onto the directory stack.
# setopt extended_history # Save time stamp
# setopt hist_expand # Expand history
# setopt long_list_jobs # Better jobs
# setopt magic_equal_subst # Enable completion in "--option=arg"
# setopt rm_star_wait # wait 10 seconds before running rm *
zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select
zstyle ':completion:*' list-colors 'di=;34;1' # highlight selected item
# Share zsh histories {{{
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=50000
setopt inc_append_history
setopt share_history
# }}}
# }}}
