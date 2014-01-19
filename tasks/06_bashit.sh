#!/usr/bin/env bash

function bashit_init() {
    task_setup "bashit" "bash-it install" "Run bashit framework setup" "setup"
}

function bashit_run() {

    if [[ ! -d "$HOME/.bash_it" ]]; then
        log_info "cloning into ~/.bash_it"
        git clone https://github.com/revans/bash-it.git ~/.bash_it
    fi

    if [[ ! -f "$HOME/.bash_it/aliases/custom.aliases.bash" ]]; then
        log_info "linking bash-it aliases"
        ln -s ~/.dotfiles/to_link/custom.aliases.bash ~/.bash_it/aliases/
    fi

    if [[ ! -f "$HOME/.bash_it/plugins/custom.plugins.bash" ]]; then
        log_info "linking bash-it plugins"
        ln -s ~/.dotfiles/to_link/custom.plugins.bash ~/.bash_it/custom/
    fi

    if [[ ! -f "$HOME/.bash_it/lib/custom.bash" ]]; then
        log_info "linking bash-it libs"
        ln -s ~/.dotfiles/to_link/custom.bash ~/.bash_it/lib/
    fi

    if [[ ! -f "$HOME/.bash_it/custom/custom.theme.bash" ]]; then
        log_info "linking bash-it theme"
        ln -s ~/.dotfiles/to_link/custom.theme.bash ~/.bash_it/custom/
    fi

    bashit_dir="$HOME/.bash_it/install.sh"
    if [[ ! -f $bashit_dir ]]; then
        log_error "bash-it installer not found"
        return ${E_FAILURE}
    fi
    log_info "Running bash-it installer"
    if [[ -f "$HOME/.dotfiles/.bashit.status" ]]; then
        source ~/.dotfiles/.bashit.status
        if [[ $bashit_dependencies == "setup" ]]; then
            log_info "bashit already installed"
            return ${E_SUCCESS}
        fi
    fi
    source $bashit_dir
    return ${E_SUCCESS}
}
