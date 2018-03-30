#!/bin/zsh
# vim: set foldmethod=marker ft=zsh:

# zplug {{{

# setup {{{
unset ZPLUG_SHALLOW # shut up zplug!!
export DISABLE_AUTO_TITLE="true" # prevent zsh from auto-updating tmux window title
# export ZSH="/Users/mikefunk/.zplug/repos/robbyrussell/oh-my-zsh/" # fix issue with wd plugin
# export ZSH="$ZPLUG_REPOS/robbyrussell/oh-my-zsh" # fix issue with wd plugin

# @link https://github.com/b4b4r07/zplug
if [ -d /usr/local/opt/zplug ]; then
    # homebrew version
    export ZPLUG_HOME=/usr/local/opt/zplug
    source $ZPLUG_HOME/init.zsh
else
    # curl version
    source ~/.zplug/init.zsh
fi
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

# https://github.com/mfaerevaag/wd
# If you're NOT using oh-my-zsh and you want to utilize the zsh-completion
# feature, you will also need to add the path to your wd installation (~/bin/wd
# if you used the automatic installer) to your fpath. E.g. in your ~/.zshrc:
# fpath=(~/path/to/wd $fpath)
fpath=(/usr/local/opt/zplug/repos/mfaerevaag/wd $fpath)

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
# zplug 'zplug/zplug', hook-build:'zplug --self-manage' # I handle this through homebrew
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
  $BREW_PREFIX/share/info
  /usr/local/share/info
  /usr/share/info
  $infopath
)

manpath=(
  $BREW_PREFIX/share/man
  /usr/local/share/man
  /usr/share/man
  $manpath
)

path=(
  # $HOME/.rvm/bin
  $HOME/.bin:${PATH}
  $HOME/.composer/vendor/bin
  $(brew --prefix)/{bin,sbin}
  ${PHPENV_ROOT}/bin
  ${PHPENV_ROOT}/shims
  $ZPLUG_ROOT/bin
  /usr/local/{bin,sbin}
  /usr/{bin,sbin}
  /{bin,sbin}
  # /usr/local/opt/icu4c/{bin,sbin}
  $path
)
# }}}

# source additional files {{{
[ -f ~/.private_vars.sh ] && source ~/.private_vars.sh # where I store my secret env vars
[ -f ~/.promptline.theme.bash ] && source ~/.promptline.theme.bash # vim plugin generates this tmux status line file
# [ -f /usr/local/etc/grc.bashrc ] && source "/usr/local/etc/grc.bashrc" # generic colorizer
[ -f /usr/local/etc/grc.zsh ] && source "/usr/local/etc/grc.zsh" # generic colorizer
# https://github.com/google/google-api-ruby-client/issues/235#issuecomment-169956795
[ -f /usr/local/etc/openssl/cert.pem ] && export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem
[ -d "$HOME/.zsh/completion" ] && find "$HOME/.zsh/completion" | while read f; do source "$f"; done
[[ "$(builtin type -p plenv)" ]] && eval "$(plenv init -)"
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ "$(builtin type -p rbenv)" ]] && eval "$(rbenv init -)"
# source $(brew --prefix php-version)/php-version.sh && php-version 7.0
# I only use phpenv because homebrew is making it difficult to install php 7.0
# and extensions right now.
export PHPENV_ROOT="/Users/mikefunk/.phpenv"
[[ "$(builtin type -p phpenv)" ]] && eval "$($PHPENV_ROOT/bin/phpenv init -)"

# }}}
#
# phpenv {{{
# I only use phpenv because homebrew is making it difficult to install php 7.0
# and extensions right now.
# TODO php-build is broken so it doesn't matter :/
#
# ```
# /var/tmp/php-build/source/7.0.28/ext/intl/intl_convertcpp.cpp:59:40: error: unknown type name 'UnicodeString'; did you mean 'icu_61::UnicodeString'?
# zend_string* intl_charFromString(const UnicodeString &from, UErrorCode *status)
#                                        ^~~~~~~~~~~~~
#                                        icu_61::UnicodeString
# /usr/local/Cellar/icu4c/HEAD-41179/include/unicode/unistr.h:286:20: note: 'icu_61::UnicodeString' declared here
# class U_COMMON_API UnicodeString : public Replaceable
# ```
#
# https://github.com/php-build/php-build/issues/498
export PHPENV_ROOT="/Users/mikefunk/.phpenv"
if [ -d "${PHPENV_ROOT}" ]; then
  export PATH="${PHPENV_ROOT}/bin:${PATH}"
  eval "$(phpenv init -)"
fi
# }}}

# gpg {{{
# uncomment this to enable gpg passwords in the terminal
# export GPG_TTY=`tty` # make gpg prompt for a password
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
# alias standup="builtin cd $HOME/Sites/saatchi && git standup"
standup () { builtin cd $HOME/Sites/saatchi && git standup $@ && builtin cd - > /dev/null; }
alias standup-monday="standup -d 3"
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
    xdebug-off > /dev/null
    php -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    [[ $? == 0 ]] && noti --message "PHPUnit tests passed 👍" ||
        noti --message "PHPUnit tests failed 👎"
    xdebug-on > /dev/null
}
function phpspecnotify() {
    xdebug-off > /dev/null
    php -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpspec run "${@}"
    # php -dxdebug.remote_autostart=1 -dxdebug.remote_connect_back=1 -dxdebug.idekey=${XDEBUG_IDE_KEY} -dxdebug.remote_port=9015 -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpspec run "${@}"
    [[ $? == 0 ]] && noti --message "Specs passed 👍" ||
        noti --message "Specs failed 👎"
    xdebug-on > /dev/null
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

# xdebug {{{

# usage: `xdb on` or `xdb off` or `xdb` for status {{{
xdb () { xdebug-toggle $1 --no-server-restart; }
# }}}
# }}}

# }}}

# source more files {{{
[ -e ~/.saatchirc.sh ] && source ~/.saatchirc.sh
# }}}
#
