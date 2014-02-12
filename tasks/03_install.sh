#!/usr/bin/env bash

. ~/.dotfiles/support/install_functions.sh

function install_init() {
    task_setup "install" "Install Tasks" "Install cli tools"
}

function install_run() {
    # install npm packages
    if [[ ! "$(type -P npm)" ]]; then
        log_error "npm not installed"
        return ${E_FAILURE}
    fi
    log_info "Installing npm Packages"
    # yo includes grunt and bower
    packages=(
    csslint
    instant-markdown-d
    jshint
    jsonlint
    less
    log.io
    tldr
    yo
    )
    for package in "${packages[@]}"
    do
        hash $package 2>/dev/null || {
            log_info "installing $package"
            sudo npm install -g $package --user "$(whoami)"
        }
    done

    # install pear packages
    if [[ ! "$(type -P pear)" ]]; then
        log_error "pear not installed"
        return ${E_FAILURE}
    fi
    log_info "Installing Pear Packages"
    sudo pear config-set auto_discover 1
    packages=(
    pear.phpqatools.org/phpqatools
    doc.php.net/pman
    )
    for package in "${packages[@]}"
    do
        # if [[ ! "$(type -P $package)" ]]; then
            # log_info "installing $package"
            sudo pear install $package
        # fi
    done

    # set default phpcs standard
    log_info "setting phpcs default to psr2"
    sudo phpcs --config-set default_standard PSR2

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
        sudo curl http://laravel.com/laravel.phar -o /usr/local/bin/laravel
        sudo chmod +x /usr/local/bin/laravel
    fi

    # install laravel envoy
    if [[ ! "$(type -P envoy)" ]]; then
        log_info "Installing Laravel Envoy"
        sudo curl https://github.com/laravel/envoy/raw/master/envoy.phar -o /usr/local/bin/envoy
        sudo chmod +x /usr/local/bin/envoy
    fi

    # install php-cs-fixer
    if [[ ! "$(type -P php-cs-fixer)" ]]; then
        log_info "Installing php-cs-fixer"
        sudo curl http://cs.sensiolabs.org/get/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer
        sudo chmod a+x /usr/local/bin/php-cs-fixer
    fi

    # install gems
    if [[ ! "$(type -P gem)" ]]; then
        log_error "gem utility not installed"
        return ${E_FAILURE}
    fi
    log_info "Installing Gems"
    packages=(
    bluecloth
    bundler
    execjs
    jekyll
    kramdown
    mailcatcher
    pre-commit
    puppet
    pygmentize
    pygments.rb
    redcarpet
    rdiscount
    teamocil
    watch
    tmuxinator
    )
    for package in "${packages[@]}"
    do
        hash $package 2>/dev/null || {
            log_info "installing $package"
            sudo gem install $package
        }
    done

    # install python packages
    if [[ ! "$(type -P pip)" ]]; then
        log_error "pip not installed"
        return ${E_FAILURE}
    fi
    log_info "Installing Python packages"

    packages=(
    )
    for package in "${packages[@]}"
    do
        hash $package 2>/dev/null || {
            log_info "installing $package"
            sudo pip install $package
        }
    done

    return ${E_SUCCESS}
}
