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
link_this "$HOME/.dotfiles/to_link/.agignore" "$HOME/.agignore"
link_this "$HOME/.dotfiles/to_link/.config" "$HOME/.config"
link_this "$HOME/.dotfiles/to_link/.global_rsync_exclude" "$HOME/.rsync_exclude"
link_this "$HOME/.dotfiles/to_link/.eslintrc" "$HOME/.eslintrc"

link_this "$HOME/.dotfiles/to_link/.ctags" "$HOME/.ctags"
link_this "$HOME/.dotfiles/to_link/.irssi" "$HOME/.irssi"
link_this "$HOME/.dotfiles/to_link/.screenrc" "$HOME/.screenrc"
link_this "$HOME/.dotfiles/to_link/.tmux.conf" "$HOME/.tmux.conf"
link_this "$HOME/.dotfiles/to_link/.tmate.conf" "$HOME/.tmate.conf"

link_this "$HOME/.dotfiles/to_link/.grcat" "$HOME/.grcat"
link_this "$HOME/.dotfiles/to_link/.my.cnf" "$HOME/.my.cnf"
link_this "$HOME/.dotfiles/to_link/.my.ini" "$HOME/.my.ini"
link_this "$HOME/.dotfiles/to_link/.composer" "$HOME/.composer"
link_this "$HOME/.dotfiles/to_link/.config/git/ignore" "$HOME/.gitignore_global"

link_this "$HOME/.dotfiles/to_link/.inputrc" "$HOME/.inputrc"
link_this "$HOME/.dotfiles/to_link/.rainbarf.conf" "$HOME/.rainbarf.conf"
link_this "$HOME/.dotfiles/to_link/.psqlrc" "$HOME/.psqlrc"
link_this "$HOME/.dotfiles/to_link/.hgrc" "$HOME/.hgrc"
link_this "$HOME/.dotfiles/to_link/.hgignore" "$HOME/.hgignore"

link_this "$HOME/.dotfiles/to_link/.jscsrc" "$HOME/.jscsrc"
link_this "$HOME/.dotfiles/to_link/.curlrc" "$HOME/.curlrc"
link_this "$HOME/.dotfiles/to_link/.editorconfig" "$HOME/.editorconfig"
link_this "$HOME/.dotfiles/to_link/.editorconfig" "/Library/WebServer/Documents/.editorconfig"
link_this "$HOME/.dotfiles/to_link/.myclirc" "$HOME/.myclirc"

link_this "$HOME/.dotfiles/to_link/.zshrc" "$HOME/.zshrc"
link_this "$HOME/.dotfiles/to_link/.warprc" "$HOME/.warprc"
link_this "$HOME/.dotfiles/to_link/.sshrc" "$HOME/.sshrc"
link_this "$HOME/.dotfiles/to_link/.sshrc.d" "$HOME/.sshrc.d"
link_this "$HOME/.dotfiles/to_link/.inputrc" "$HOME/.sshrc.d/.inputrc"

link_this "$HOME/.dotfiles/to_link/.my.cnf" "$HOME/.sshrc.d/.my.cnf"
link_this "$HOME/.dotfiles/to_link/.rubocop.yml" "$HOME/.rubocop.yml"

link_this "/var/www/sites" "$HOME/Sites"
# default location for mac
link_this "/Library/WebServer/Documents" "$HOME/Sites"

# fix permissions if the above directories exist
if [ -d /Library/WebServer/Documents ]; then
    log_info "fixing permissions and ownership for mac web server folder"
    sudo chgrp staff /Library/WebServer/Documents
    sudo chmod g+w /Library/WebServer/Documents
fi
if [ -d /Library/WebServer/Documents ]; then
    log_info "fixing permissions and ownership for ~/Sites"
    sudo chgrp staff "$HOME/Sites"
    sudo chmod g+w "$HOME/Sites"
fi

link_this "$HOME/.dotfiles/to_link/.jshintrc" "$HOME/.jshintrc"
# link_this "$HOME/.dotfiles/to_link/.virtualhost.sh.conf" "$HOME/.virtualhost.sh.conf"
link_this "$HOME/.dotfiles/to_link/.tmux" "$HOME/.tmux"

link_this "$HOME/.dotfiles/to_link/.git_template" "$HOME/.git_template"
sudo chmod a+x ~/.dotfiles/to_link/.git_template/hooks/*

# try to link my php.ini in the right place... anywhere else it might be?
# liip php
link_this "$HOME/.dotfiles/to_link/999-my-php.ini" "/usr/local/php5/php.d/999-my-php.ini"
# default mac php
link_this "$HOME/.dotfiles/to_link/999-my-php.ini" "/etc/php5/apache2/conf.d/999-my-php.ini"
# homebrew php
link_this "$HOME/.dotfiles/to_link/999-my-php.ini" "/usr/local/etc/php/5.4/conf.d/999-my-php.ini"
link_this "$HOME/.dotfiles/to_link/999-my-php.ini" "/usr/local/etc/php/5.6/conf.d/999-my-php.ini"
link_this "$HOME/.dotfiles/to_link/999-my-php.ini" "/usr/local/etc/php/7.0/conf.d/999-my-php.ini"
link_this "$HOME/.dotfiles/to_link/999-my-php.ini" "$HOME/.phpbrew/php/php-5.4.45/etc/999-my-php.ini"
link_this "$HOME/.dotfiles/to_link/999-my-php.ini" "$HOME/.phpbrew/php/php-5.6.20/etc/999-my-php.ini"

link_this "$HOME/.dotfiles/to_link/.bro" "$HOME/.bro"
link_this "$HOME/.dotfiles/to_link/.phpspec" "$HOME/.phpspec"
link_this "$HOME/.dotfiles/to_link/.homestead" "$HOME/.homestead"
link_this "$HOME/.dotfiles/to_link/reattach-to-user-namespace-tmux" "/usr/local/bin/reattach-to-user-namespace-tmux"
sudo chmod +x /usr/local/bin/reattach-to-user-namespace-tmux

log_info "End symlinks install script"
