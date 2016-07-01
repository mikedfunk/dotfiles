#!/bin/zsh

# shut up zplug!!
unset ZPLUG_SHALLOW

# prevent zsh from auto-updating tmux window title
export DISABLE_AUTO_TITLE="true"

# @link https://github.com/b4b4r07/zplug
source ~/.zplug/zplug

# plugin definitions
zplug "bobthecow/git-flow-completion", if:"which git"
zplug "djui/alias-tips"
zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/", from:oh-my-zsh
zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/capistrano", from:oh-my-zsh
zplug "plugins/colored-man", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
# currently dies with an undefined function "is-at-least"
# zplug "plugins/common-aliases", from:oh-my-zsh
# zplug "plugins/composer", from:oh-my-zsh, nice:15
zplug "plugins/git", from:oh-my-zsh, if:"which git", nice:15
zplug "plugins/git-extras", from:oh-my-zsh, if:"which git"
zplug "plugins/gitfast", from:oh-my-zsh, if:"which git", nice:15
zplug "plugins/github", from:oh-my-zsh, if:"which git"
zplug "plugins/history", from:oh-my-zsh
zplug "plugins/jira", from:oh-my-zsh
zplug "plugins/jsontools", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/phing", from:oh-my-zsh, nice:15
zplug "plugins/vagrant", from:oh-my-zsh
zplug "plugins/vi-mode", from:oh-my-zsh
zplug "plugins/wd", from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions" # buggy if enabled along with zsh-syntax-highlighting. crashes the shell regularly.
zplug "zsh-users/zsh-history-substring-search"
# zplug "plugins/osx", from:oh-my-zsh #compdef issue
# zplug "horosgrisa/mysql-colorize" # I already have practically the same thing in ~/.my.cnf
# zplug "plugins/git-flow-avh", from:oh-my-zsh, if:"which git"
# zplug "zsh-users/zsh-syntax-highlighting", nice:10 # source after completion scripts


# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install zplug plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# zplug commands

# install	Install described items (plugins/commands) in parallel	--verbose,--select
# load	Source installed plugins and add installed commands to $PATH	--verbose
# list	List installed items (Strictly speaking, view the associative array $zplugs)	--select
# update	Update installed items in parallel	--self,--select
# check	Return false if there are not installed items	--verbose
# status	Check if the remote repositories are up to date	--select
# clean	Remove repositories which are no longer managed	--force,--select
# clear	Remove the cache file	--force

# Then, source plugins and add commands to $PATH
# zplug load --verbose
zplug load

source ~/.bash_profile

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
