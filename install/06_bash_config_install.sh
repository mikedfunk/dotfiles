#!/usr/bin/env bash

# Modeline and Notes {{{
# vim: set sw=4 ts=4 sts=4 et tw=78 foldmethod=marker:
#
#  ___  ____ _         ______           _
#  |  \/  (_) |        |  ___|         | |
#  | .  . |_| | _____  | |_ _   _ _ __ | | __
#  | |\/| | | |/ / _ \ |  _| | | | '_ \| |/ /
#  | |  | | |   <  __/ | | | |_| | | | |   <
#  \_|  |_/_|_|\_\___| \_|  \__,_|_| |_|_|\_\
#
# link my dotfiles to their expected locations
# more info at http://mikefunk.com
# }}}

# source installer support files {{{
for f in ~/.dotfiles/install/support/*; do source $f; done
# }}}

log_info "Beginning bash install script"

link_this "$HOME/.dotfiles/to_link/bash/.bashrc" "$HOME/.bashrc"
link_this "$HOME/.dotfiles/to_link/bash/.bash_profile" "$HOME/.bash_profile"
link_this "$HOME/.dotfiles/to_link/bash/.bash_aliases" "$HOME/.bash_aliases"
link_this "$HOME/.dotfiles/to_link/bash/.bash_functions" "$HOME/.bash_functions"
link_this "$HOME/.dotfiles/to_link/bash/.bash_completions" "$HOME/.bash_completions"
link_this "$HOME/.dotfiles/to_link/zsh_friendly/.zsh_friendly_completions" "$HOME/.zsh_friendly_completions"

link_this "$HOME/.dotfiles/to_link/bash/.bash_paths" "$HOME/.bash_paths"
link_this "$HOME/.dotfiles/to_link/bash/.bash_env" "$HOME/.bash_env"
link_this "$HOME/.dotfiles/to_link/promptline.theme.bash" "$HOME/.promptline.theme.bash"

# try to add some more bash completions somewhere
# link_this "$HOME/.dotfiles/to_link/bash_completion/misc.bash" "/usr/local/etc/bash_completion.d/misc.bash"
# link_this "$HOME/.dotfiles/to_link/bash_completion.d/misc.bash" "/etc/bash_completion.d/misc.bash"

log_info "End bash install script"
