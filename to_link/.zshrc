#!/bin/zsh
#
# prevent zsh from auto-updating tmux window title
export DISABLE_AUTO_TITLE="true"

# @link https://github.com/b4b4r07/zplug
source ~/.zplug/zplug

# plugin definitions
zplug "bobthecow/git-flow-completion", if:"which git"
zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/", from:oh-my-zsh
zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/capistrano", from:oh-my-zsh
zplug "plugins/colored-man", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/composer", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh, if:"which git"
zplug "plugins/git-extras", from:oh-my-zsh, if:"which git"
zplug "plugins/git-flow-avh", from:oh-my-zsh, if:"which git"
zplug "plugins/gitfast", from:oh-my-zsh, if:"which git"
zplug "plugins/github", from:oh-my-zsh, if:"which git"
zplug "plugins/history", from:oh-my-zsh
zplug "plugins/jira", from:oh-my-zsh
zplug "plugins/jsontools", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/osx", from:oh-my-zsh
zplug "plugins/phing", from:oh-my-zsh
zplug "plugins/vagrant", from:oh-my-zsh
zplug "plugins/vi-mode", from:oh-my-zsh
zplug "plugins/wd", from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", nice:10 # source after completion scripts

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

# autossh -> ssh completion
compdef autossh=ssh
# function to use autossh with screen
compdef asc=ssh
# bring your dotfiles with you
compdef sshrc=ssh

# bash stuff
[ -f ~/.private_vars.sh ] && source ~/.private_vars.sh
[ -f ~/.bash_env ] && source ~/.bash_env
[ -f ~/.bash_paths ] && source ~/.bash_paths
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bash_functions ] && source ~/.bash_functions
# [ -f ~/.bash_completions ] && source ~/.bash_completions
[ -f ~/.promptline.theme.bash ] && source ~/.promptline.theme.bash
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
