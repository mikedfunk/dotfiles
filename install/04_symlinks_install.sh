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

log_info "Beginning symlinks install script"

link_this "$HOME/.dotfiles/to_link/.gitconfig" "$HOME/.gitconfig"
link_this "$HOME/.dotfiles/to_link/.gitignore" "$HOME/.gitignore"
link_this "$HOME/.dotfiles/to_link/.agignore" "$HOME/.agignore"
link_this "$HOME/.dotfiles/to_link/.config" "$HOME/.config"
link_this "$HOME/.dotfiles/to_link/.ssh" "$HOME/.ssh"

link_this "$HOME/.dotfiles/to_link/.ctags" "$HOME/.ctags"
link_this "$HOME/.dotfiles/to_link/.irssi" "$HOME/.irssi"
link_this "$HOME/.dotfiles/to_link/.screenrc" "$HOME/.screenrc"
link_this "$HOME/.dotfiles/to_link/.tmux.conf" "$HOME/.tmux.conf"
link_this "$HOME/.dotfiles/to_link/.tmate.conf" "$HOME/.tmate.conf"

link_this "$HOME/.dotfiles/to_link/.grcat" "$HOME/.grcat"
link_this "$HOME/.dotfiles/to_link/.my.cnf" "$HOME/.my.cnf"
link_this "$HOME/.dotfiles/to_link/.my.ini" "$HOME/.my.ini"
link_this "$HOME/.dotfiles/to_link/.composer" "$HOME/.composer"

link_this "$HOME/.dotfiles/to_link/.inputrc" "$HOME/.inputrc"
link_this "$HOME/.dotfiles/to_link/.rainbarf.conf" "$HOME/.rainbarf.conf"

link_this "$HOME/.dotfiles/to_link/.teamocil" "$HOME/.teamocil"
link_this "/var/www/sites" "$HOME/Sites"
# default location for mac
link_this "/Library/WebServer/Documents" "$HOME/Sites"

link_this "$HOME/.dotfiles/to_link/.jshintrc" "$HOME/.jshintrc"
# link_this "$HOME/.dotfiles/to_link/.virtualhost.sh.conf" "$HOME/.virtualhost.sh.conf"
link_this "$HOME/.dotfiles/to_link/.tmux" "$HOME/.tmux"

link_this "$HOME/.dotfiles/to_link/.git_template" "$HOME/.git_template"
sudo chmod a+x ~/.dotfiles/to_link/.git_template/hooks/*

# try to link my php.ini in the right place... anywhere else it might be?
link_this "$HOME/.dotfiles/to_link/999-my-php.ini" "/usr/local/php5/php.d/999-my-php.ini"
link_this "$HOME/.dotfiles/to_link/999-my-php.ini" "/etc/php5/apache2/conf.d/999-my-php.ini"

log_info "End symlinks install script"