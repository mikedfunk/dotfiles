#!/usr/bin/env bash

function install_init() {
	task_setup "install" "Install Tasks" "Install these on any system" "setup"
}

function install_run() {
	# install npm packages
	if [[ ! "$(type -P npm)" ]]; then
		log_error "npm not installed"
		return ${E_FAILURE}
	fi
	log_info "Installing npm Packages"
	# yo includes grunt and bower
	sudo npm install -g yo

	# install pear packages
	if [[ ! "$(type -P pear)" ]]; then
		log_error "pear not installed"
		return ${E_FAILURE}
	fi
	log_info "Installing Pear Packages"
	sudo pear config-set auto_discover 1
	sudo pear install pear.phpqatools.org/phpqatools

	# fix tmux namespace issue on macos only
	if [[ ! "$(type -P reattach-to-user-namespace-tmux)" ]]; then
	    log_info "Installing reattach-to-user-namespace-tmux"
	    sudo mv ~/.dotfiles/reattach-to-user-namespace-tmux /usr/local/bin/
	    sudo chmod +x /usr/local/bin/reattach-to-user-namespace-tmux
	fi

	# install composer
	if [[ ! "$(type -P composer)" ]]; then
	    log_info "Installing Composer"
	    cd
	    curl -sS https://getcomposer.org/installer | php
	    sudo mv composer.phar /usr/local/bin/composer
	    sudo chmod +x composer
	    cd -
	fi

	# install laravel installer
	if [[ ! "$(type -P laravel)" ]]; then
	    log_info "Installing Laravel Installer"
	    cd
	    wget http://laravel.com/laravel.phar
	    sudo mv laravel.phar /usr/local/bin/laravel
	    sudo chmod +x laravel
	    cd -
	fi

	if [[ ! "$(type -P gem)" ]]; then
		log_error "gem not installed"
		return ${E_FAILURE}
	fi
	log_info "Installing Gems"
	sudo gem install "pygmentize"
	sudo gem install "watch"
	sudo gem install "tmuxinator"

	# install phpctags
	# if [[ ! -d ~/.dotfiles/phpctags/build ]]; then
	    # e_header "installing phpctags"
	    # cd ~/.dotfiles/phpctags
	    # make
	    # ln -s ~/.dotfiles/phpctags/phpctags /usr/local/bin/phpctags
	    # cd -
	# fi

	# install phpenv
	if [[ ! -d ~/.phpenv ]]; then
		log_info "installing phpenv"
		git clone git://github.com/phpenv/phpenv.git ~/.phpenv
	fi

	return ${E_SUCCESS}
}
