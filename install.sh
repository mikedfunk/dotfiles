#!/bin/bash
# vim: set foldmethod=marker ft=sh:

# helper functions {{{
function _log_info() { echo -e "$(tput setaf 2)$(tput rev)$(tput bold) \xE2\x9C\x93 $1 $(tput sgr0)"; "${@:2}"; }
function _log_error() { echo -e "$(tput setaf 1)$(tput rev)$(tput bold) \xE2\x9C\x97 $1 $(tput sgr0)"; "${@:2}"; }
function _log_notice() { echo -e "$(tput setaf 3)$(tput rev)$(tput bold) \xE2\x9A\xa0 $1 $(tput sgr0)"; "${@:2}"; }
function _has() { type "$1" &>/dev/null; }
function _executable_check() {
    EXECUTABLE=$1
    _has "$EXECUTABLE" && return
    _log_error "Executable $EXECUTABLE not found. Exiting."
    exit 1
}
function _directory_check() {
    DIRECTORY=$1
    [ -d "$DIRECTORY" ] && return
    _log_error "Directory $DIRECTORY not found. Exiting."
    exit 1
}
# }}}

function _install_yadm_if_missing () {
    _has yadm && return
    _log_info "Installing yadm"
    curl -fLo /usr/local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm && chmod a+x /usr/local/bin/yadm
    export PATH="/usr/local/bin:$PATH"
}

_directory_check "$HOME"/.ssh
_directory_check "$HOME"/.gpg
_executable_check git
_install_yadm_if_missing
yadm clone git@github.com:mikedfunk/dotfiles.git --bootstrap
