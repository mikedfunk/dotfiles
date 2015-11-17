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
# install tools where the installation method is common among all platforms
# more info at http://mikefunk.com
# }}}

# source installer support files {{{
for f in ~/.dotfiles/install/support/*; do source $f; done
# }}}

log_info "Beginning common install script"

# install npm packages
if [[ ! "$(type -P npm)" ]]; then
    log_error "npm not installed"
    return ${E_FAILURE}
fi

log_info "Updating npm"
sudo npm install -g npm

log_info "Installing npm Packages"
packages=(
babel-core # used by eslint to lint ecmascript
# babel-eslint # es6 javascript linter - used by syntastic in vim
bower # package management for css/js
bower-installer # allows you to only install the files you need into a specific dir
browser-sync # like livereload but easier
coffeelint # verify coffeescript files
coffee-script # javascript abstraction / augmentation
csslint # verify css files
eslint # javascript linter - used by syntastic in vim
eslint-plugin-react # react jsx javascript linter - used by syntastic in vim
esprima-fb@15001.1.0-dev-harmony-fb # used by jscs to also check jsx coding standards
express-generator # generates express.js apps
# fixmyjs # like php-cs-fixer for javascript
# git-guilt # see the top few users for whom this commit has overwritten code. Commented out because this is now included with git-extras.
gulp # task runner / watcher
grunt # older, more complex task runner / watcher
grunt-cli # wtf? grunt is lame.
#instant-markdown-d # used by vim to instantly preview markdown files as you type
jasmine # javascript behavior testing framework
jscs # javascript coding style checker
jshint # like jslint but less punishing
# json # json formatter used for vim
json-server # an easy way to set up a quick fake json API
jsonlint # verify json
# jspm # javascript package manager with autoloader
# jsxhint # like jshint with extra stuff for reactjs jsx syntax ("jsxhint is being sunsetted and doesn't handle react errors correctly")
karma # js test runner
karma-cli # karma testing framework command line runner
komodo-debug # debugger for nodejs. Lets you attach node sessions to vdebug.
less # add dynamic capabilities to less
letswork # distraction remover (no reddit, facebook, twitter)
live-server # just runs a web server in a dir and refreshes on file change.
# localtunnel # allow others to view a site you have running locally
# log.io # web-based live log browser
# newman # companion to postman REST tester for chrome
nixar # friendly equivalents for existing linux commands such as clipboard and count
npm-check-updates # check for updates to stuff defined in package.json
# phantomjs # headless browser used for BDD
# phpunit-watchr # dinky tool to watch files for changes and run phpunit
# psi # PageSpeed Insights with reporting
react-tools # used for vim syntastic syntax checking for jsx react modules
# redis-cli # command line tool to monitor redis, check connection, etc.
# redis-commander # web interface for redis similar to beanstalkd
syntastic-react # used for vim syntastic syntax checking for jsx react modules
# tldr # community-driven man pages
ttystudio # easy terminal to gif maker
typescript # superset of javascript that adds type hinting and other goodies. Must be compiled down to javascript of course. Used by tsuquyomi vim plugin
yo # yeoman - boilerplate maker
# zombie@3.1.1 # browser emulator for testing like phantomjs. v3 is node, v4 is io.js
)
for package in "${packages[@]}"
do
    hash $package 2>/dev/null || {
        log_info "installing $package"
        sudo npm install -g $package --user "$(whoami)"
    }
done

# jsctags
if [[ ! "$(type -P jsctags)" ]]; then
    log_info "Installing jsctags"
    sudo npm install -g git://github.com/ramitos/jsctags.git
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

# composer global install
link_this "$HOME/.dotfiles/to_link/.composer" "$HOME/.composer"
composer global install

# had some problems with php-cs-fixer via composer so here's the wget version
if [[ ! "$(type -P php-cs-fixer)" ]]; then
    log_info "Installing php-cs-fixer"
    sudo wget http://get.sensiolabs.org/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer
    sudo chmod +x /usr/local/bin/php-cs-fixer
fi

# build phpctags
if [[ ! "$(type -P phpctags)" ]]; then
    log_info "building phpctags"
    cd $HOME/.composer/vendor/mr-russ/phpctags
    make
    cp build/phpctags.phar $HOME/.composer/vendor/bin/phpctags
    sudo chmod +x $HOME/.composer/vendor/bin/phpctags
    cd -
fi

# set default phpcs standard
if [[ "$(type -P phpcs)" ]]; then
    log_info "setting phpcs defaults"
    sudo phpcs --config-set default_standard PSR2
    sudo phpcs --config-set show_progress 1
    sudo phpcs --config-set encoding utf-8
    sudo phpcs --config-set tab_width 4
fi

# install gems
if [[ ! "$(type -P gem)" ]]; then
    log_error "gem utility not installed"
    return ${E_FAILURE}
fi

log_info "Installing Gems"
packages=(
# bluecloth # ruby implementation of markdown. Another option jekyll can use.
# bropages # a highly readable supplement to man pages
bundler # lets gems be package-specific. Used by jekyll.
CoffeeTags # ctags with coffeescript
compass # ruby tool to compile sass. Used by foundation cli tool.
# execjs
# git-gitlab # command line tool to create merge requests and stuff
foundation # zurb foundation css framework installer
github_changelog_generator # generate changelogs from tags, issues, and merged pull requests
# haste
jekyll # blogging platform used by github
# json_pure
# kramdown # another markdown parser option that can be used by Jekyll.
# mailcatcher # catches outgoing mail and displays it from a local server to a web-based view
# mysql2xxxx # export mysql to json, etc.
# observr # watches the file system and does stuff when things change
pre-commit # install pre-commit hooks to check for all kinds of things
# pre-commit-php
# puppet # virtual machine provisioning language
pygmentize # used by jekyll and vim-instant-markdown
pygments.rb # syntax highlighting - used by jekyll
redcarpet # used by jekyll to convert markdown to html. also used by vim-instant-markdown
# rdiscount # another markdown option for jekyll.
# ruby-fsevent # probably a dependency of another package I dont use anymore
# teamocil # save tmux layouts and regenerate them with ease
)
for package in "${packages[@]}"
do
    hash $package 2>/dev/null || {
        log_info "installing $package"
        sudo gem install $package
    }
done

# install pip
sudo easy_install pip

# install python packages
if [[ ! "$(type -P pip)" ]]; then
    log_error "pip not installed"
    return ${E_FAILURE}
fi
log_info "Installing Python 2 packages"

packages=(
# gmusicapi # google music api
# argcomplete # tab completion of arguments for python scripts
fabric # deployment tool
glances # like htop on steroids
mycli # mysql cli tool with autocomplete
neovim # neovim python library
# pgcli # a postgresql repl with autocompletion
Pillow # used by image.vim to preview images in vim via ascii conversion
pre-commit # yelp git pre-commit framework
#requests # used for vim-jira-complete
requests[security] # used to prevent urllib3 warning with wakatime vim plugin
# robotframework # front-end testing framework
# robotframework-selenium2screenshots
saws # aws console on steroids
# stellar # fast database stapshot and restore tool for development
# supervisor # a client/server system that allows its users to control a number of processes
)
for package in "${packages[@]}"
do
    hash $package 2>/dev/null || {
        log_info "installing $package"
        # this will work fine as long as python is installed via brew and
        # /usr/local/bin is before /usr/bin
        pip install --upgrade $package
    }
done

log_info "Installing Python 3 packages"
packages=(
tmuxomatic # tmux layout/session manager
)
for package in "${packages[@]}"
do
    hash $package 2>/dev/null || {
        log_info "installing $package"
        pip3 install --upgrade $package
    }
done

# disabled - it uses a -D switch on mac which doesn't exist
# log_info "activating argcomplete"
# depends on location of bash completion folder
# [ -d /usr/local/etc/bash_completion.d ] && activate-global-python-argcomplete --dest /usr/local/etc/bash_completion.d
# [ -d /etc/bash_completion.d ] && activate-global-python-argcomplete --dest /etc/bash_completion.d

# install tmux plugin manager
if [[ ! -f "$HOME/.tmux/plugins/tpm" ]]; then
    log_info "installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# I'm sure I could combine these somehow...
if [[ "$(type -P vagrant)" ]]; then
    if vagrant box list | grep homestead -ne 0; then
        log_info "adding laravel homestead vagrant box"
        # option 1 is virtualbox. 2 is vmware.
        echo 1 | vagrant box add laravel/homestead
        # homestead cli tool is in global composer.json
    fi
fi

# commented all go stuff out until I am programming in go

# setup gocode directory. this is like a vendor directory so no need to store
# it in this repo.
# if [[ ! -d "/usr/local/go" ]]; then
    # log_info "creating gocode directory"
    # mkdir "/usr/local/go"
    # export GOPATH="/usr/local/go"
    # export PATH="$GOPATH/bin:$PATH"
# fi

# setup gopm
# if [[ "$(type -P gopm)" ]]; then
    # log_info "installing gopm package manager"
    # go get -u github.com/gpmgo/gopm
# fi

# install gopm packages
# if [[ ! "$(type -P gopm)" ]]; then
    # log_error "gopm not installed"
    # return ${E_FAILURE}
# fi
# log_info "Installing gopm packages"

# packages=(
# )
# for package in "${packages[@]}"
# do
    # hash $package 2>/dev/null || {
        # log_info "installing $package"
        # gopm install $package
    # }
# done

log_info "End common install script"
