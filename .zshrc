#!/bin/zsh
# zsh config
# vim: set foldmethod=marker ft=zsh:

# notes {{{
# https://code.joejag.com/2014/why-zsh.html
# https://til.hashrocket.com/posts/alk38eeu8r-use-fc-to-fix-commands-in-the-shell
# ctrl-z won't work? remove ~/.zsh/log/jog.lock
# This is documented with tomdoc.sh style https://github.com/tests-always-included/tomdoc.sh
# }}}

# p10k instant prompt {{{
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}}

# helper functions {{{

# Internal: Whether a command is available
_has() {
    type "$1" &>/dev/null
}

# colors {{{
BLACK="$(tput setaf 0)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
PINK="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
NORMAL="$(tput sgr0)"
MAC_REMOVE_ANSI='gsed "s/\x1b\[[0-9;]*m//g"'
LINUX_REMOVE_ANSI='sed \"s/\x1b\[[0-9;]*m//g\"'
UNDERLINE="$(tput smul)"
# }}}

# }}}

# env parallel {{{
# _has env_parallel.zsh && source $(which env_parallel.zsh)
# _has env_parallel && env_parallel --record-env
# }}}

# set up homebrew paths {{{
# _has brew && eval $(brew shellenv) # this MUST be done before setting the rest of paths
# }}}

# Paths {{{
cdpath=(
  $HOME/Code
  $cdpath
)

# https://github.com/denisidoro/navi
navipath=(
  $HOME/.navi
  $navipath
)

infopath=(
  /usr/local/share/info
  /usr/share/info
  $infopath
)

manpath=(
  /usr/local/share/man
  /usr/share/man
  $manpath
)

path=(
  # my own scripts
  $HOME/.bin
  # global ruby gems
  $HOME/bin
  # global python pip packages
  $HOME/.local/bin
  /Applications/Docker.app/Contents/Resources/bin
  # (homebrew is already covered by the eval above)
  # wtf homebrew? this is too far down the list!
  /usr/local/{bin,sbin}
  # homebrew doesn't like to link curl
  /usr/local/opt/curl/bin
  /usr/local/opt/perl/bin
  # rust cargo packages
  # $HOME/.cargo/bin
  # golang packages
  # $HOME/go/bin
  # golang executables
  # /usr/local/opt/go/libexec/bin
  # $HOME/.{pl,nod,py}env/bin # these will be set up by shell integration
  # $HOME/.config/yarn/global/node_modules/.bin
  $(_has yarn && yarn global bin)
  $HOME/.composer/vendor/bin
  $(_has gem && gem env home)
  /usr/{bin,sbin}
  /{bin,sbin}
  # /usr/local/opt/icu4c/{bin,sbin}
  # add gnu coreutils before path... this seems a bit heavy-handed :/
  # /usr/local/opt/coreutils/libexec/gnubin
  $path
)
# }}}

# zsh {{{
# If I don't do this I get "compdef undefined"
autoload -Uz compinit
compinit

# https://github.com/machinshin/dotfiles/blob/master/.zshrc#L159-L160
# Complete the hosts and - last but not least - the remote directories.
#  $ scp file username@<TAB><TAB>:/<TAB>
zstyle ':completion:*:(ssh|scp|sftp|sshrc|autossh|sshfs):*' hosts $hosts
zstyle ':completion:*:(ssh|scp|sftp|sshrc|autossh|sshfs):*' users $users

# https://www.justingarrison.com/blog/2020-05-28-shell-shortcuts/
bindkey '^q' push-line-or-edit
# }}}

# antibody (#slow) {{{
# make oh-my-zsh plugins work with antibody... this is kind of crazy
ZSH="$HOME/Library/Caches/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"
# If I re-source antibody init a second time it takes MINUTES to reinit. Even
# if I re-run antibody bundle commands it takes progressively longer each time
# I reload. Better to just run once on load. Only takes 3 seconds the first
# time.
if [[ ! $ANTIBODY_LOADED ]]; then
    source <(antibody init)

    # disabled plugins {{{
    # antibody bundle djui/alias-tips # tell you when an alias would shorten the command you ran
    # antibody bundle sei40kr/fast-alias-tips-bin branch:v0.1.1 (doesn't work - he doesn't put the executable on a branch, it's in a release, which antibody doesn't know how to get)
    # antibody bundle sei40kr/zsh-fast-alias-tips (this does not play nice with antibody)
    # antibody bundle mfaerevaag/wd # warp directory
    # antibody bundle marzocchi/zsh-notify # notify when a command fails or lasts longer than 30 seconds and the terminal is in the background (requires terminal-notifier and reattach-to-user-namespace from within tmux) (same functionality as ntfy)
    # antibody bundle zsh-users/zsh-syntax-highlighting # colored input... see above
    # antibody bundle marlonrichert/zsh-autocomplete # automatically show flags/options completion (this plugin is really janky)
    # antibody bundle zsh-users/zsh-history-substring-search # up arrow after typing part of command
    # antibody bundle oldratlee/hacker-quotes # just add some cool hacker quotes in shell init like MOTD
    # antibody bundle zdharma/zsh-startify # like vim-startify for zsh (neat, but doesn't really help)
    # antibody bundle paulmelnikow/zsh-startup-timer # uncomment to show startup time. This plugin itself is slow, but helpful to measure once in a while.
    # }}}

    # enabled plugins
    antibody bundle yous/vanilli.sh # sensible zsh defaults
    antibody bundle robbyrussell/oh-my-zsh path:lib/functions.zsh # some dependencies for oh-my-zsh plugins
    antibody bundle robbyrussell/oh-my-zsh path:plugins/alias-finder # supposed to be 10x faster than alias-tips O_O https://github.com/djui/alias-tips/issues/49#issuecomment-569726313
    antibody bundle robbyrussell/oh-my-zsh path:plugins/colored-man-pages
    antibody bundle robbyrussell/oh-my-zsh path:plugins/colorize # Plugin for highlighting file content
    antibody bundle robbyrussell/oh-my-zsh path:plugins/command-not-found # suggest packages to install if command not found
    antibody bundle robbyrussell/oh-my-zsh path:plugins/gitfast # fix git completion issues https://unix.stackexchange.com/a/204308 downside: this also adds a TON of gxx aliases https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/gitfast it also adds MORE git aliases and functions from the main git plugin https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/git/git.plugin.zsh
    antibody bundle robbyrussell/oh-my-zsh path:plugins/jira # simple command-line tool that just opens jira on different pages. No fancy shit.
    antibody bundle robbyrussell/oh-my-zsh path:plugins/vi-mode
    antibody bundle robbyrussell/oh-my-zsh path:plugins/wd/wd.plugin.zsh # warp directory
    antibody bundle zsh-users/zsh-autosuggestions # OLD COMMENT: buggy if enabled along with zsh-syntax-highlighting. crashes the shell regularly.
    antibody bundle zsh-users/zsh-completions # do-everything argument completions
    antibody bundle zdharma/fast-syntax-highlighting # colored input but faster
    antibody bundle romkatv/powerlevel10k # zsh prompt theme (see ~/.p10k.zsh)
    antibody bundle qoomon/zsh-lazyload # lazyload various commands
    antibody bundle mroth/evalcache # speeds up subsequent runs of eval init functions. if you make a change just call `_evalcache_clear`.
    antibody bundle hlissner/zsh-autopair # auto close parens, etc.

    ANTIBODY_LOADED=1
fi
# }}}

# lazyload {{{
_has lazyload && lazyload akamai -- '_has akamai && eval "$(akamai --zsh)"'
# }}}

# source additional files and env vars {{{
export ZSH_ALIAS_FINDER_AUTOMATIC=true # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/alias-finder#usage
export ZSH_AUTOSUGGEST_USE_ASYNC=true # https://github.com/zsh-users/zsh-autosuggestions#enable-asynchronous-mode
# ZSH_AUTOSUGGEST_STRATEGY=(history completion) # https://github.com/zsh-users/zsh-autosuggestions#suggestion-strategy (this prevents me from typing more e.g. `php artisan ...`!)
[ -f ~/.private_vars.sh ] && source ~/.private_vars.sh # where I store my secret env vars
# [ -f ~/.support/promptline.theme.bash ] && source ~/.support/promptline.theme.bash # vim plugin generates this tmux status line file
# if you get this error:
# 25:28: execution error: Not authorized to send Apple events to iTerm. (-1743)
# Goto Settings -> Security & Privacy -> Privacy -> Automation -> Privacy tab and check the System Events checkbox. https://stackoverflow.com/a/53380557
# then do this `tccutil reset AppleEvents; tccutil reset SystemPolicyAllFiles` https://stackoverflow.com/a/56992109/557215
# [ -f /usr/local/etc/grc.bashrc ] && source "/usr/local/etc/grc.bashrc" # generic colorizer
[ -f /usr/local/etc/grc.zsh ] && source "/usr/local/etc/grc.zsh" # generic colorizer
# https://github.com/google/google-api-ruby-client/issues/235#issuecomment-169956795
[ -f /usr/local/etc/openssl/cert.pem ] && export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem
# [ -d "$HOME/.zsh/completion" ] && find "$HOME/.zsh/completion" | while read f; do source "$f"; done
# _has plenv && eval "$(plenv init -)"
# [ -f "/usr/local/opt/asdf/asdf.sh" ] && source "/usr/local/opt/asdf/asdf.sh"
# [ -n "$DESK_ENV" ] && source "$DESK_ENV" || true # Hook for desk activation
# tabtab source for yo package
# uninstall by removing these lines or running `tabtab uninstall yo`
# [[ -f /Users/mikefunk/.config/yarn/global/node_modules/tabtab/.completions/yo.zsh ]] && . /Users/mikefunk/.config/yarn/global/node_modules/tabtab/.completions/yo.zsh

# evaluated startup commands {{{
_has tmuxp && _evalcache "$HOME"/.support/enable-tmuxp-completion.sh # workaround to make evalcache happy
_has direnv && _evalcache direnv hook zsh # (evalcache version)
# _has ntfy && _evalcache ntfy shell-integration # notify when long-running command finishes. pip package, breaks in pyenv - see yadm bootstrap for unique setup. this is broken: `AttributeError: 'NoneType' object has no attribute 'scheduleNotification_'`
_has npx && _evalcache npx --shell-auto-fallback zsh
# #slow
_has hub && _evalcache hub alias -s # alias git to hub with completion intact

[ -f /usr/local/opt/asdf/asdf.sh ] && source /usr/local/opt/asdf/asdf.sh

# https://github.com/black7375/zsh-lazyenv
# _has lazyenv-enabled && lazyenv-enabled

# https://github.com/trapd00r/LS_COLORS
DIRCOLORS_CMD="/usr/local/opt/coreutils/libexec/gnubin/dircolors"
DIRCOLORS_FILE="$HOME/.dircolors"
[[ -e "$DIRCOLORS_CMD" && -f "$DIRCOLORS_FILE" ]] && _evalcache "$DIRCOLORS_CMD" -b "$DIRCOLORS_FILE"
# }}}

export LC_CTYPE=en_US.UTF-8 # https://unix.stackexchange.com/a/302418/287898
export LC_ALL=en_US.UTF-8 # https://unix.stackexchange.com/a/302418/287898
# https://github.com/variadico/noti/blob/master/docs/noti.md#environment
export NOTI_NSUSER_SOUNDNAME="Hero"
# don't notify when these die after being "long-running processes"
export AUTO_NTFY_DONE_IGNORE=(
    ctop
    htop
    less
    man
    screen
    tig
    tmux
    ts
    v
    vim
    y
    yadm
)
# colorize less... I get weird indentations all over the place with this
# https://www.reddit.com/r/linux/comments/b5n1l5/whats_your_favorite_cli_tool_nobody_knows_about/ejex2pm/
# export LESSOPEN="| /usr/local/opt/source-highlight/bin/src-hilite-lesspipe.sh %s"
# alias less="less -R"
lessc () {
    rougify highlight $@ | \less -R -M
}
export GITWEB_PROJECTROOT="$HOME/Code"
export PRE_COMMIT_COLOR=always # https://pre-commit.com/#cli
export PSQL_PAGER="pspg"

# https://github.com/jarun/nnn
export NNN_PLUG='u:getplugs;p:preview-tui'
export NNN_OPTS="adg"
export NNN_COLORS='#0a1b2c3d;1234'
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'

set PLANTUML_LIMIT_SIZE=8192

# [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh" # this seems to conflict with direnv. Direnv seems to wipe the PATH changes this applies.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
builtin setopt aliases # weird, this should have already been done :/

_has kubectl && source <(kubectl completion zsh) # brew doesn't install this, I checked
# _has stern && source <(stern --completion=zsh) # unfortunately I still get no completion. cod works better for this.
_has cod && source <(cod init $$ zsh)

# https://github.com/denisidoro/navi/blob/master/docs/installation.md#installing-the-shell-widget
_has navi && source <(echo "$(navi widget zsh)")
# NOTE any completions in the brew completions dir are already added!
# [[ -e /usr/local/opt/coreutils/libexec/gnubin/dircolors && -f "$HOME"/.dircolors ]] && eval $( /usr/local/opt/coreutils/libexec/gnubin/dircolors -b "$HOME"/.dircolors )
# _has zsh-startify && zsh-startify (neat, but doesn't really help)
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
[[ -f "$HOME"/.iterm2_shell_integration.zsh ]] && source "$HOME"/.iterm2_shell_integration.zsh

# broot file browser https://dystroy.org/broot/documentation/installation/##installation-completion-the-br-shell-function
[ -f "$HOME"/Library/Preferences/org.dystroy.broot/launcher/bash/br ] && source "$HOME"/Library/Preferences/org.dystroy.broot/launcher/bash/br

HOMEBREW_NO_ANALYTICS=1

# used by newsboat and others
# this opens in both my work AND home profiles :/
# export BROWSER="/Applications/Firefox.app/Contents/MacOS/firefox -P Home --new-tab"
# this breaks git-open :/
# export BROWSER="echo '%u' | pbcopy"

# https://odb.github.io/shml/getting-started/
# "$(fgcolor red)wow$(fgcolor end)$(br)$(hr '-')"
# colors: black red green yellow blue magenta cyan gray white darkgray lightgreen lightyellow lightblue lightmagenta lightcyan
# attributes: bold dim underline invert hidden
# icons: checkmark xmark heart sun star darkstar umbrella flag snowflake music scissors trademark copyright apple smile
# emojis: smiley innocent joy =p worried cry rage wave ok_hand thumbsup thumbsdown smiley_cat cat dog bee pig monkey cow panda sushi home eyeglases smoke fire hankey beer cookie lock unlock star joker check x toilet bell search dart cash thinking luck
# confirm QUESTION [SUCCESS_FUNCTION] [FAILURE_FUNCTION]
# #slow
# _has shml && source $(which shml) # disabled because it's slow! Using tput instead.

# disable weird highlighting of pasted text
# https://old.reddit.com/r/zsh/comments/c160o2/command_line_pasted_text/erbg6hy/
zle_highlight=('paste:none')
# }}}

# ssh {{{
# disable autossh port monitoring and use ServerAliveInterval and
# ServerAliveCountMax instead.
# https://www.everythingcli.org/ssh-tunnelling-for-fun-and-profit-autossh/
export AUTOSSH_PORT=0

# Public: pass the current ssh alias. Used by my promptline theme and .screenrc to show the alias in the PS1.
# saatchi servers don't like anything *-256color so I need to use screen via ssh
ssh() { env TERM=screen LC_SSH_ALIAS=$1 /usr/bin/ssh $@; }
autossh() { LC_SSH_ALIAS=$1 /usr/local/bin/autossh $@; }
sshrc() { env TERM=screen LC_SSH_ALIAS=$1 /usr/local/bin/sshrc $@; }

compdef autossh="ssh"
compdef sshrc="ssh"

# https://infosec.mozilla.org/guidelines/openssh#openssh-client
ssh-add -K -A 2>/dev/null # add all keys stored in keychain if they haven't been added yet
# ssh-add -c -K -A 2>/dev/null # add all keys stored in keychain if they haven't been added yet
# [c] confirm password on use
# [K] store/use password with macos keychain
# [A] add all identities stored in keychain. Therefore, before this is useful, you'll need to add each key to the ssh agent at least once.
# }}}

# gpg {{{
# enable gpg passwords in the terminal
export GPG_TTY=`tty` # make gpg prompt for a password
export PINENTRY_USER_DATA="USE_CURSES=1"
# }}}

# fzf {{{
export FZF_DEFAULT_OPTS="--multi"
# }}}

# functions and aliases {{{

# misc {{{
# alias nb="BROWSER=\"echo '%u' | pbcopy\" newsboat" # when opening links, just copy to clipboard
alias nb="BROWSER=\"open '%u'\" newsboat"
alias info="info --vi-keys" # info -> pinfo is like top -> htop

# tip: curl ping.gg to set up a pingdom-style alert
shorten-url () { curl -s http://tinyurl.com/api-create.php?url=$1; }

cd () { builtin cd "$@" && ls -FAG; } # auto ls on cd
alias ..="cd .."
alias ...="cd ../.."
# _has lsd && alias ls="lsd" # fancy ls augmentation (disabled because it's missing flags that ls _has >:(  )
alias du="grc --colour=auto /usr/bin/du"
# https://github.com/sharkdp/vivid/issues/25#issuecomment-450423306
# _has gls && alias ls="gls --color"
alias ll='ls -lhGFA'
alias phpx="php -dxdebug.remote_autostart=1 -dxdebug.remote_connect_back=1 -dxdebug.idekey=${XDEBUG_IDE_KEY} -dxdebug.remote_port=9000 -ddisplay_errors=on"
# alias work="tmux attach -t Work || tmuxomatic ~/.tmuxomatic/Work"
# suppress warning thing: https://github.com/tmuxinator/tmuxinator/issues/695#issuecomment-487315070
# alias work="tmux attach -t Work || tmuxinator Work"
alias work="tmux attach -t Work || tmuxp load work"
# alias home="tmux attach -t Home || tmuxomatic ~/.tmuxomatic/Home"
# alias home="tmux attach -t Home || tmuxinator Home"
alias home="tmux attach -t Home || tmuxp load home"
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
save-dotfiles () { yadm encrypt && yadm add -u && yadm ci -m ${1:-working} && yadm ps; }
save-dotfiles-without-encryption () { yadm add -u && yadm ci -m ${1:-working} && yadm ps; }
alias joplin="/usr/local/bin/node `which joplin`" # joplin and nodenv do not mix. this uses homebrew node.
alias notes="joplin"
# alias jsc="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc" # javascript repl for testing javascript wonkiness
alias ncdu="ncdu --color dark -rr -x --exclude .git --exclude vendor" # enhanced interactive disk usage command
alias tmux-layout="tmux display-message -p \"#{window_layout}\""
# fuzzy wd
wf () {
    # this doesn't work because xargs runs in a subshell
    # wd list | gsed '1d' | fzf | gsed -E 's/^ +(\w+).*$/\1/' | xargs wd
    wd $(wd list | gsed '1d' | fzf | gsed -E 's/^ +(\w+).*$/\1/')
}

export CLICOLOR=1 # ls colors by default
# export NODE_PATH="/usr/local/lib/node_modules" # zombie.js doesn't work without this

# pretty-print PATH with line breaks
pretty-path() { tr : '\n' <<<"$PATH"; }
# alias vit="vim +TW" # until vit gets its act together
# alias tree="alder" # colorized tree from npm (I colorize tree with "lsd" now so this is not needed)
# https://unix.stackexchange.com/a/293608/287898
alias mc="mc --nosubshell --xterm"
# }}}

# games {{{
alias play-starwars="telnet towel.blinkenlights.nl" # :)
# alias play-gameboy="telnet gameboy.live 1989" # not working any more
alias play-nethack="ssh nethack@alt.org" # :)
alias play-chess="telnet freechess.org" # :)
alias play-aardwolf="telnet aardmud.org" # :)
alias play-tron="ssh sshtron.zachlatta.com" # :)
alias play-zork="zork"
# }}}

# suffix aliases {{{
# https://unix.stackexchange.com/questions/354960/zsh-suffix-alias-alternative-in-bash
# NOTE: This breaks php-language-server.php
# alias -s css=vim
# alias -s html=vim
# alias -s js=vim
# alias -s json=vim
# alias -s jsx=vim
# alias -s markdown=vim
# alias -s md=vim
# alias -s phar=php
# alias -s php=vim
# alias -s phtml=vim
# alias -s rb=vim
# alias -s scss=vim
# alias -s txt=vim
# alias -s xml=vim
# alias -s xql=vim
# alias -s yaml=vim
# alias -s yml=vim
# }}}

# brew {{{
alias bru="brew update && brew upgrade"
alias bri="brew install"
# }}}

# phpunit {{{
alias pu="phpunitnotify"

# Public: phpunit coverage
puc() { pu --coverage-html=./coverage $@ && open coverage/index.html; }
puc-clover() { pu --coverage-clover=./coverage/clover.xml $@; }

# Public: phpspec coverage
psc() { php -dmemory_limit=2048M ./vendor/bin/phpspec run --config ./phpspec-coverage-html.yml $@ && open coverage/index.html; }
psc-clover() { php -dmemory_limit=2048M ./vendor/bin/phpspec run --config ./phpspec-coverage-clover.yml $@; }
alias puf="pu --filter="

# Public: phpunit watch
puw() {
    noglob ag -l -g \
        '(application\/controllers|application\/modules\/*\/controllers|application\/models|library|src|app|tests)/.*\.php' \
        | entr -c \
        phpdbg -qrr \
        -dmemory_limit=2048M \
        -ddisplay_errors=on \
        ./vendor/bin/phpunit \
        --colors=always \
        $@
}

# Public: phpunit watch with a "pretty" formatter (close to phpspec's pretty formatter)
puw-pretty() {
    noglob ag -l -g \
        '(application\/controllers|application\/modules\/*\/controllers|application\/models|library|src|tests)/.*\.php' \
        | entr -c \
        "$HOME/.bin/pu-pretty" \
        $@
}

# Public: phpspec watch with a "pretty" formatter
psw-pretty() {
    psw --format=pretty $@
}
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
alias crs="composer run-script"
# }}}

# git {{{
alias g="git"
compdef g="git"
grt() { cd `g root`; }
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
alias psw="noglob ag -l -g '.*\\.php' | entr -c noti --message \"PHPSpec passed 👍\" php -dmemory_limit=1024M -ddisplay_errors=on ./vendor/bin/phpspec run --no-interaction -vvv"
# phpspecnotify() {
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
# useful for mc
export VIEWER="bat --paging=always"
export LANG=en_US.UTF-8
KEYTIMEOUT=1 # no vim delay entering normal mode
# }}}

# }}}

# docker {{{
# Public: switch to docker-machine
alias dme="eval \$(docker-machine env default)"
# unset all docker-machine env vars
alias dmu="eval \$(docker-machine env -u)"
# alias dme=":" # no-op because I don't use docker-machine any more
alias dmc="docker-machine create --driver=virtualbox --virtualbox-memory=4096 --virtualbox-disk-size=40000 default" # 40gb hard drive, 4gb memory
alias dmd="VBoxManage discardstate default" # the virtualbox vm doesn't like to come back up when suspended.
alias dmi="dme && docker-machine ip"
# alias dms="docker-machine start && dme"
alias dms="docker-machine stop"
# alias dms="brew services stop docker-machine"

# Public: docker-machine can get hung up by virtualbox sometimes during startup. Try
# again after 15 seconds up to 5 times.
# https://unix.stackexchange.com/a/82610/287898
docker-machine-start() {
    for i in {1..5}; do
        docker-machine start && \
            dme && \
            break || \
            sleep 15
    done
}
# alias dmr="docker-machine regenerate-certs default"
alias dmr="dme && docker-machine restart && dme"
alias dps="dme && docker ps"
alias dmt="dme && docker-machine status"
# alias dmu="dme && docker-machine upgrade"

# docker-compose
alias dcr="dme && docker-compose restart"
alias dcu="dme && docker-compose up"
alias dcb="dme && docker-compose build"
alias dcd="dme && docker-compose stop"
alias dcp="dme && docker-compose ps"

# Internal: kill docker exec processes on ctrl-c
#
# https://github.com/moby/moby/issues/9098#issuecomment-189743947
# it's not perfect but it does stop the process
_docker_cleanup() {
    docker exec $IMAGE bash -c "if [ -f $PIDFILE ]; then kill -TERM -\$(cat $PIDFILE); rm $PIDFILE; fi"
}

_docker_exec() {
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

# Public: wrap docker status with color and underline in header
docker-stats() {
    dme
    docker stats --format "table ${GREEN}{{.Name}}\t${YELLOW}{{.CPUPerc}}\t${BLUE}{{.MemPerc}}" | sed -E -e "s/(NAME.*)/${UNDERLINE}\1${NORMAL}/"
}
# }}}

# phpunit {{{

# Public: runs phpunit and uses noti to show the results
phpunitnotify() {
    # xdebug-off > /dev/null
    # php -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    # autoloader is failing :(
    phpdbg -qrr -dmemory_limit=4096M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    [[ $? == 0 ]] && noti --message "PHPUnit tests passed 👍" ||
        noti --message "PHPUnit tests failed 👎"
    # xdebug-on > /dev/null
}

# but why
alias magento-phpunit="pu -c dev/tests/unit/phpunit.xml.dist"

# Public: runs phpspec run and uses noti to show the results
phpspecnotify() {
    # xdebug-off > /dev/null
    phpdbg -qrr -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpspec run "${@}"
    # php -dxdebug.remote_autostart=1 -dxdebug.remote_connect_back=1 -dxdebug.idekey=${XDEBUG_IDE_KEY} -dxdebug.remote_port=9015 -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpspec run "${@}"
    [[ $? == 0 ]] && noti --message "Specs passed 👍" ||
        noti --message "Specs failed 👎"
    # xdebug-on > /dev/null
}

# Public: phpunit with xdebug turned on
pux() {
    # xdebug-off 2> /dev/null
    phpx -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    [[ $? == 0 ]] && noti --message "PHPUnit tests passed 👍" || noti --message "PHPUnit tests failed 👎"
    # xdebug-on > /dev/null
}
# }}}

# xdebug {{{
xdebug-off () {
    ( mv "$(asdf where php)"/conf.d/04_xdebug.ini{,_OLD} 2> /dev/null ) || true
}

xdebug-on () {
    ( mv "$(asdf where php)"/conf.d/04_xdebug.ini{_OLD,} 2>/dev/null ) || true
}
# }}}

# sourcegraph {{{

# Public: Run sourcegraph via docker
sourcegraph() {
    if ( docker ps | grep sourcegraph ); then
        docker logs --follow $( docker ps | grep "sourcegraph\/server" | awk '{print $1}' )
    else
        for i in {1..20}; do
            # running in foreground mode makes it easier to kill it when it's having problems, just ctrl-c
            docker run \
                --publish 7080:7080 \
                --publish 3370:3370 \
                --rm \
                --volume ~/.sourcegraph/config:/etc/sourcegraph \
                --volume ~/.sourcegraph/data:/var/opt/sourcegraph sourcegraph/server:3.15.0 \
                || sleep 15
            # open http://127.0.0.1:7080
        done
    fi
}
# }}}

# swagger {{{

# Public: bring up a swagger web editor that can interact with your local api
# https://github.com/huan/swagger-edit
swagger-edit() {
    if [ "$1" = "--help" ]; then echo "Usage: $0 {my-api-spec.yaml}"; return; fi
    docker run \
        --publish 8095:8080 \
        --env SWAGGER_JSON=/tmp/$1 \
        --volume $(pwd)/$1:/tmp/$1 \
        swaggerapi/swagger-editor
}

swagger-ui() {
    if [ "$1" = "--help" ]; then echo "Usage: $0 {my-open-api-3.0-spec.yaml}"; return; fi
    docker run \
        --publish 8090:8080 \
        --env SWAGGER_JSON=/tmp/"$1" \
        --env SPEC="{ \"openapi\": \"3.0.2\" }" \
        --volume "$(pwd)"/"$1":/tmp/"$1" \
        swaggerapi/swagger-ui
}

# Public: convert doctrine php docblocks to openapi spec yaml
# https://github.com/zircote/swagger-php
swagger-php-gen() {
    docker run \
        --volume $(pwd):/app \
        -it \
        tico/swagger-php
}
# }}}

# pahout {{{
# https://github.com/wata727/pahout
pahout() { docker run --rm -t -v $(pwd):/workdir wata727/pahout; }
# }}}

# couchbase {{{
couchbase-php-sdk-version() { php --re couchbase | head -1 | awk '{print $6, $7, $8}'; }
couchbase-php-extension-version() { php -i | grep couchbase | grep "libcouchbase runtime"; }
# }}}

# php-language-server {{{
php-language-server-script() {
    if [ "$1" = "--help" ]; then echo "Usage: $0 with no args lists scripts, $0 {script-name} to run"; return; fi
    [ -z $@ ] && ARG='-l' || ARG="$@"
    composer global run-script --working-dir=$HOME/.composer/global/felixfbecker/language-server/vendor/felixfbecker/language-server $ARG
}
# }}}

# glow {{{
alias glow-watch="ag -l -g '\.js$' | entr -c /usr/local/bin/glow"
# }}}

# letsfun / letsbreak (formerly letswork / letsfun) {{{
# this is more flexible and much simpler than an npm package for this.
# but you still have to clear dns cache and/or restart the browser for it to work :/ https://w3guy.com/flush-delete-dns-cache-firefox-chrome/
DISTRACTING_SITES=(
    reddit.com
    old.reddit.com
    facebook.com
    instagram.com
    twitter.com
    cnn.com
)
letsfun () {
    if [ "$1" = "--help" ]; then echo "Turns off all distracting sites in /etc/hosts."; return; fi
    MESSAGE=${1:-"Let's do some fun work!"}
    hostess fix
    for SITE in $DISTRACTING_SITES; do
        hostess add $SITE 0.0.0.0
    done
    cd >/dev/null
    hostess apply ~/.support/hosts.json
    cd - >/dev/null
    echo "${GREEN}${MESSAGE}${NORMAL}"
}
alias letswork="letsfun"
letsbreak () {
    if [ "$1" = "--help" ]; then echo "Turns off all distracting sites in /etc/hosts."; return; fi
    BREAK_TIME_IN_MINUTES=${1:-15}
    ((BREAK_TIME_IN_SECONDS=BREAK_TIME_IN_MINUTES*60))
    hostess fix
    for SITE in $DISTRACTING_SITES; do
        hostess rm $SITE
    done
    cd >/dev/null
    hostess apply ~/.support/hosts.json
    cd - >/dev/null
    echo "${YELLOW}Let's take a break for $BREAK_TIME_IN_MINUTES minutes!${NORMAL}"
    sleep $BREAK_TIME_IN_SECONDS
    MESSAGE="Break's over, let's do some fun work!"
    letsfun "$MESSAGE"
    noti --message "$MESSAGE"
    return 0
}
# }}}

# npx wrappers {{{
alias babel-init="npx babel-init"
alias babel="npx @babel/cli"
alias commitizen="npx commitizen"
alias cypress="npx cypress"
alias ec="npx editorconfig-cli"
alias gatsby="npx gatsby-cli"
alias gen="npx gen"
alias git-open="npx git-open"
# alias glow="npx glow"
alias grunt="npx grunt-cli"
alias jest="npx jest"
alias parcel="npx parcel-bundler"
alias poi="npx poi"
# alias redoc-cli="npx redoc-cli"
alias speccy="npx speccy"
alias swagger-cli="npx swagger-cli"
alias vue="npx vue-cli"
# alias wait-on="npx wait-on"
alias webpack-cli="npx webpack-cli"
alias webpack-dev-server="npx webpack-dev-server"
alias webpack="npx webpack"
alias yo="npx yo"
# }}}

# zsh-autocomplete {{{
# so chatty
zstyle ':autocomplete:*:no-matches-yet' message ''
# zstyle ':autocomplete:*:too-many-matches' message '[⌥-↓] to complete'
zstyle ':autocomplete:*:too-many-matches' message ''
zstyle ':autocomplete:*:no-matches-at-all' message ''
# turn off fzf bindings
zstyle ':autocomplete:*' fuzzy-search off
# }}}

# }}}

# source more files {{{
[ -e "$HOME/.saatchirc" ] && source "$HOME/.saatchirc"
# [ -e "$HOME/.toafrc" ] && source "$HOME/.toafrc"
# [ -e "$HOME/.mjmrc" ] && source "$HOME/.mjmrc"
# ensure the tmux term exists, otherwise some stuff like ncurses apps (e.g. tig) might break. This is very fast.
[ -f "$HOME/.support/tmux-256color.terminfo.txt" ] && tic -x "$HOME/.support/tmux-256color.terminfo.txt" &>/dev/null
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # fuzzy finder - installed and managed via vim-plug https://github.com/junegunn/fzf
# https://github.com/romkatv/powerlevel10k#does-powerlevel10k-always-render-exactly-the-same-prompt-as-powerlevel9k-given-the-same-config
ZLE_RPROMPT_INDENT=0
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

# https://unix.stackexchange.com/questions/167582/why-zsh-ends-a-line-with-a-highlighted-percent-symbol
PROMPT_EOL_MARK=''

# https://wrotenwrites.com/a_modern_terminal_workflow_3/#Spellcheck-Typo-Correction
# setopt correctall
# alias git-status='nocorrect git status'

# zsh keybinds {{{
# up/down allows searching history by prefix e.g. `cd {up}`
# https://unix.stackexchange.com/questions/16101/zsh-search-history-on-up-and-down-keys#100860
# bindkey "[A" history-beginning-search-backward
# bindkey "[B" history-beginning-search-forward
# }}}

# fix problem with zsh autosuggest color getting overwritten somewhere
typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# }}}
