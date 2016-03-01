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
# symlink vim config files and install vim plugins
# more info at http://mikefunk.com
# }}}

# source installer support files {{{
for f in ~/.dotfiles/install/support/*; do source $f; done
# }}}

log_info "Beginning vim install script"

log_info "linking vim config files"
link_this "$HOME/.dotfiles/to_link/vim/.vimrc" "$HOME/.vimrc"
link_this "$HOME/.dotfiles/to_link/vim/.vimrc" "$HOME/.sshrc.d/.vimrc"
link_this "$HOME/.dotfiles/to_link/vim/.gvimrc" "$HOME/.gvimrc"
link_this "$HOME/.dotfiles/to_link/vim/.vimrc.plugins" "$HOME/.vimrc.plugins"
link_this "$HOME/.dotfiles/to_link/vim/.vimrc.plugins" "$HOME/.sshrc.d/.vimrc.plugins"

# create ~/.vim and ~/.vim/autoload if it doesn't exist
log_info "creating required vim directories"
if [[ ! -d "$HOME/.vim" ]]; then
    log_info "creating the ~/.vim/autoload directory"
    mkdir -p $HOME/.vim/autoload
    chmod +w ~/.vim/autoload
fi
if [[ ! -d "$HOME/.vim/files/info" ]]; then
    log_info "creating the ~/.vim/files/info directory"
    mkdir -p ~/.vim/files/info
    chmod a+w ~/.vim/files/info
fi

# install vim-plug
log_info "installing vim-plug"
[[ ! -f $HOME/.vim/autoload/plug.vim ]] && curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# this needs to be after the .vim folder is created
log_info "linking UltiSnips custom snippets dir"
link_this "$HOME/.dotfiles/to_link/UltiSnips" "$HOME/.vim/UltiSnips"

# neovim config symlinks
log_info "linking configs for neovim"
# old style
# link_this "$HOME/.vim" "$HOME/.nvim"
# link_this "$HOME/.vimrc" "$HOME/.nvimrc"

# new style - the whole ~/.config dir is linked though so this is not
# necessary
# link_this "$HOME/.vim" "$HOME/.config/nvim"
# link_this "$HOME/.dotfiles/to_link/vim/.vimrc" "$HOME/.config/nvim/init.vim"

# I just can't seem to get this working
# log_info "linking nerdtree plugins"
# link_this "$HOME/.dotfiles/to_link/vim/nerdtree_open_multiple.vim" "$HOME/.vim/plugged/nerdtree/nerdtree_open_multiple.vim"

# install vim-plug plugins
log_info "installing vim plugins"
vim +PlugInstall +qall

log_info "End vim install script"
