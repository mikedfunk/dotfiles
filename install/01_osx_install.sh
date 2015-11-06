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

log_info "Beginning mac install script"

# OSX-only stuff. Abort if not OSX.
if [[ "$OSTYPE" =~ ^darwin ]]; then

    # install xcode command line tools
    if [[ ! "$(type -P xcode-select)" ]]; then
        log_error "xcode is not currently installed! Please download it here: https://developer.apple.com/xcode/downloads/"
    elif [ "$(xcode-select --print-path)" != "/Applications/Xcode.app/Contents/Developer" ]; then
        log_info "starting xcode command line tools installer"
        xcode-select --install
    fi

    # set mac preferences
    if [[ $(defaults read com.apple.finder NewWindowTargetPath) != "file://Users/mfunk" ]]; then
        log_info "setting finder default location"
        defaults write com.apple.finder NewWindowTargetPath file://Users/mfunk/
    fi

    if [[ $(defaults read com.apple.finder AppleShowAllFiles) != "TRUE" ]]; then
        log_info "setting finder to show hidden files"
        defaults write com.apple.finder AppleShowAllFiles TRUE
        killall Finder
    fi

    # Install Homebrew.
    if [[ ! "$(type -P brew)" ]]; then
        log_info "Installing Homebrew"
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # homebrew cask
    # @link https://github.com/caskroom/homebrew-cask
    brew install caskroom/cask/brew-cask

    # this is required before installing sshfs
    brew cask install osxfuse

    if [[ "$(type -P brew)" ]]; then
        # update homebrew
        log_info "Updating Homebrew"
        brew doctor
        brew update
        # brew tap phinze/homebrew-cask

        # install homebrew recipes
        log_info "Installing Homebrew Recipes"
        packages=(
        atool # manipulate archives in ranger
        autossh # keeps ssh connections open for instant access
        bash # homebrew has the newest version of bash
        # ack # a search tool better than grep but worse than ag
        # cloc #count lines of code
        colortail # tail with support for colors
        cmake # used by youcompleteme
        # ctags # allows jumping to function/class definitions, etc. in vim
        dnsmasq # easily set up dynamic dev domains such as myproject.dev
        # dos2unix # converts dos line endings to unix in a file
        # fasd # Command-line productivity booster, offers quick access to files and directories, inspired by autojump, z and v.
        git
        git-extras # adds some cool additional git commands
        # git-flow # adds first class git commands for the git-flow workflow
        git-flow-avh # adds first class git commands for the git-flow workflow. This version will delete remote feature, release, and hotfix branches on finishing.
        # googlecl # google command line tool
        # graphviz # useful for xdebug profiler class maps
        grc # generic colorizer
        gnu-sed # linux version of sed - saves as gsed
        gnu-tar # linux version of tar so stuff actually works
        # go # go programming language. used for mailhog.
        gpg # used by s3cmd
        # hg # mercurial
        highlight # colorizes html and other output on the command line. used by ranger.
        htop # prettier, more powerful version of top. gets the top running processes
        httpie # a cool alternative to curl
        # hub # github tool is a superset of git. 2.0 needs to be installed via --HEAD
        imagemagick # image transformation tool
        irssi # irc client
        # jsawk # parse json in bash
        libcaca # image previewing in ASCII. used by ranger
        libcouchbase # nosql fast data storage similar to mongo. Used at Saatchi
        lynx # console web browser. used by ranger to preview html.
        # macvim # mac gui vim client
        # mono # .NET compiler for mac. Useful for OmniSharp.
        # multitail # tail multiple files in splits with pretty colors
        mysql
        nano # text editor. This gets the latest version: 2.2.6 rather than 2.2.0 that comes with osx.
        nodejs
        pandoc # used for inline vim php documentation
        # postgresql
        python # updated version of python with updated pip
        python3 # required for tmuxomatic
        ranger # vim-like file system browser
        rbenv # ruby environment switcher
        reattach-to-user-namespace # used to fix mac issues with copy/paste in tmux
        redis # key/value store used by a project I am working on
        ruby-build # an rbenv plugin that provides an rbenv install command to compile and install different versions of ruby
        s3cmd # amazon s3 uploader
        ssh-copy-id # copies ssh keys to remote servers
        # sshfs # mounts ssh servers as file systems in the local fs. requires osxfuse.
        # sshuttle # poor mans vpn. doesnt work on yosemite at the moment
        # solr # search data server
        # spark # used for rainbarf to show spiffy cli graphs
        terminal-notifier # send macos notifications from terminal
        tig # git? tig!
        # tmux # terminal multiplexer similar to screen. commented out to use special tapped version instead for 24-bit color support.
        tofrodos # line endings
        # trash # a trash can for the terminal
        tree # display file/folder hierarchies in a visual tree format
        # virtualhost.sh # crappy virtualhost management script
        watch # contains some tools: free, kill, ps, uptime, etc.
        # w3m # full color image previewer for ranger but doesnt work in tmux
        wget # latest version
        )
        for package in "${packages[@]}"
        do
            hash $package 2>/dev/null || {
                log_info "installing $package"
                brew install $package
            }
        done

        if [[ "$(which bash)" == "/usr/local/bin/bash" ]]; then
            log_info "changing shell to homebrew bash"
            chsh -s /usr/local/bin/bash
        fi

        if [[ ! "$(type -P mvim)" ]]; then
            log_info "installing macvim"
            brew install macvim --with-lua --override-system-vim
        fi

        if [[ ! "$(type -P vagrant)" ]]; then
            log_info "installing vagrant"
            brew install Caskroom/cask/vagrant

            log_info "installing vagrant completion"
            brew install homebrew/completions/vagrant-completion
        fi

        if [[ ! "$(type -P tmux)" ]]; then
            log_info "installing tmux with 24-bit color support"
            brew tap choppsv1/term24
            brew install choppsv1/term24/tmux
        fi

        # jabber/xmpp client to do chat in the terminal
        if [[ ! "$(type -P profanity)" ]]; then
            log_info "installing profanity console IM client"
            brew install profanity --with-terminal-notifier
        fi

        # install all quicklook plugins via brew cask
        # @link https://github.com/sindresorhus/quick-look-plugins

        # install homebrew recipes
        log_info "Installing Homebrew cask Recipes"
        packages=(
        pdftotext # used by ranger to preview pdfs
        qlcolorcode # quicklook plugin
        qlstephen # quicklook plugin
        qlmarkdown # quicklook plugin
        quicklook-json # quicklook plugin
        qlprettypatch # quicklook plugin
        quicklook-csv # quicklook plugin
        betterzipql # quicklook plugin
        qlimagesize # quicklook plugin
        suspicious-package # quicklook plugin
        webpquicklook # quicklook plugin
        )
        for package in "${packages[@]}"
        do
            hash $package 2>/dev/null || {
                log_info "installing $package"
                brew cask install $package
            }
        done

        # https://github.com/neovim/neovim/wiki/Installing
        # bookmarking this for later. right now some things are still breaking
        # in my vim setup with neovim.
        if [[ ! "$(type -P nvim)" ]]; then
            brew tap neovim/homebrew-neovim
            brew install --HEAD neovim
            # sudo pip install neovim
            ln -sf ~/.vim ~/.nvim
            ln -sf ~/.vimrc ~/.nvimrc
        else
            brew reinstall --HEAD neovim
            sudo pip install neovim --upgrade
        fi

        log_info "setting up homebrew mysql to launch now and on startup"
        ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

        # ensuring homebrew bash is in /etc/shells
        if [[ $(grep "/usr/local/bin/bash" /etc/shells -c) == 0 ]]; then
            log_info "installing homebrew bash to /etc/paths"
            sudo bash -c "echo /usr/local/bin/bash >> /etc/shells"
        fi

        # htop-osx requires root privileges to correctly display all running processes.
        if [[ -f /usr/local/Cellar/htop-osx/0.8.2.3/bin/htop ]]; then
            log_info "setting permissions/ownership for htop"
            # You can either run the program via `sudo` or set the setuid bit:
            sudo chown root:wheel /usr/local/Cellar/htop-osx/0.8.2.3/bin/htop
            sudo chmod u+s /usr/local/Cellar/htop-osx/0.8.2.3/bin/htop
        fi

        if [[ ! "$(type -P libxml2)" ]]; then
            log_info "installing libxml2 with python (for phpqa vim package)"
            brew install libxml2 --with-python
            mkdir -p ~/Library/Python/2.7/lib/python/site-packages
            echo '/usr/local/opt/libxml2/lib/python2.7/site-packages' > ~/Library/Python/2.7/lib/python/site-packages/homebrew.pth
        fi

        if [[ ! "$(type -P battery)" ]]; then
            log_info "installing battery script for tmux statusline"
            brew tap Goles/battery
            brew install battery
        fi

        # hub 2.x requires --HEAD
        if [[ ! "$(type -P hub)" ]]; then
            log_info "installing github hub"
            brew install --HEAD hub
        fi

        # set up dnsmasq
        log_info "setting up dnsmasq"
        link_this "$HOME/.dotfiles/to_link/dnsmasq.conf" "/usr/local/etc/dnsmasq.conf"
        # launch dnsmasq on startup
        sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
        # load dnsmasq now
        sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
        # set up dns resolver dir if not already there
        [[ -d "/etc/resolver" ]] || sudo mkdir -p /etc/resolver
        # link the dns resolver file
        link_this "$HOME/.dotfiles/to_link/dev_dns_resolver" "/etc/resolver/dev"
        # restart dnsmasq
        sudo launchctl stop homebrew.mxcl.dnsmasq
        sudo launchctl start homebrew.mxcl.dnsmasq

        # install homebrew packages without the same cli name
        packages=(
        bash-completion # installs all homebrew bash completion
        selenium-server-standalone
        the_silver_searcher
        ruby-build
        )
        for package in "${packages[@]}"
        do
            log_info "attempting to install $package"
            brew install $package
        done

        # make selenium server start on launch
        ln -sfv /usr/local/opt/selenium-server-standalone/*.plist ~/Library/LaunchAgents
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.selenium-server-standalone.plist
    fi

    # install ctags patched
    # @link https://github.com/shawncplus/phpcomplete.vim/wiki/Patched-ctags
    # Works but fishman includes built-in support for css and coffeescript
    # log_info "Installing Ctags Patched"
    # cd /usr/local/Library/Formula/
    # curl https://raw.githubusercontent.com/shawncplus/phpcomplete.vim/master/misc/ctags-better-php.rb > /usr/local/Library/Formula/ctags-better-php.rb
    # brew install ctags-better-php
    # brew link --overwrite ctags-better-php

    # this used to be fishman ctags but it is merging thankfully with other
    # ctags contributors
    log_info "Installing Universal Ctags"
    brew tap universal-ctags/universal-ctags
    brew install --HEAD universal-ctags

    # link brew apps
    brew linkapps

    # install php 5.6 via homebrew
    log_info "Installing homebrew php"
    brew tap homebrew/dupes
    brew tap homebrew/versions
    brew tap homebrew/homebrew-php
    brew install php56 --with-homebrew-curl --with-debug
    brew install php56-xdebug --HEAD # fails if HEAD version not used
    brew install php56-mcrypt
    # brew install php56-redis # used by airliners
    brew install php56-couchbase # used at Saatchi
    brew install php56-intl # needed by symfony installer
    # have launchd start php-fpm at login
    ln -sfv /usr/local/opt/php56/*.plist ~/Library/LaunchAgents
    # load php-fpm now
    # launchctl load ~/Library/LaunchAgents/homebrew.mxcl.php56.plist
    # if extension not in httpd.conf, add it
    LoadPhp="LoadModule php5_module /usr/local/opt/php56/libexec/apache2/libphp5.so";
    if ! cat /etc/apache2/httpd.conf | grep -q "LoadModule php5_module /usr/local/opt/php56/libexec/apache2/libphp5.so"; then
        log_info "enabling homebrew php in apache"
        sudo sed -i '.bak' 's/#LoadModule php5_module\ libexec\/apache2\/libphp5\.so/LoadModule php5_module\ \/usr\/local\/opt\/php56\/libexec\/apache2\/libphp5\.so/' /etc/apache2/httpd.conf
    fi

    # if the vhosts lines are commented out in httpd.conf, uncomment them
    if ! cat /etc/apache2/httpd.conf | grep -q "#Include /private/etc/apache2/extra/httpd-vhosts.conf" || ! cat /etc/apache2/httpd.conf | grep -q "#LoadModule vhost_alias_module libexec/apache2/mod_vhost_alias.so"; then
        log_info "enabling vhosts in apache"
        sudo sed -i '.bak' 's/#Include\ \/private\/etc\/apache2\/extra\/httpd\vhosts\.conf/Include\ \/private\/etc\/apache2\/extra\/httpd\vhosts\.conf/' /etc/apache2/httpd.conf
        sudo sed -i '.bak' 's/#LoadModule\ vhost_alias_module\ libexec\/apache2\/mod_vhost_alias\.so/LoadModule\ vhost_alias_module\ libexec\/apache2\/mod_vhost_alias\.so/' /etc/apache2/httpd.conf
    fi

    # Remove outdated versions from the cellar.
    brew cleanup

    # fix an issue with variable loading
    # @link http://stackoverflow.com/questions/4749330/how-to-test-if-string-exists-in-file-with-bash-shell
    if grep -Fxq 'variables_order = "GPCS"' /usr/local/etc/php/5.6/php.ini
    then
        log_info "fixing php.ini variable order"
        sed -i '.bak' 's/variables_order\ =\ "GPCS"/variables_order\ =\ "EGPCS"/' /usr/local/etc/php/5.6/php.ini
    fi

    # install phing bash completion
    if [[ ! -f /usr/local/etc/bash_completion.d/phing ]]; then
        log_info "Installing phing bash completion"
        cd
        wget https://gist.githubusercontent.com/krymen/4124392/raw/37c8436ac44cdd21620e3a355fc96cf6b7bf61a3/phing
        sudo mv phing /usr/local/etc/bash_completion.d/
    fi

    # download and move mailcatcher
    if [[ ! "$(type -P mailhog)" ]]; then
        log_info "installing mailhog"
        wget https://github.com/mailhog/MailHog/releases/download/v0.1.3/MailHog_darwin_amd64
        mv MailHog_darwin_amd64 /usr/local/bin/mailhog
        chmod +x /usr/local/bin/mailhog
    fi

    # mac defaults from mathias bynens {{{
        # @link https://github.com/mathiasbynens/dotfiles/blob/master/.osx
        log_info "updating mac settings"

        #####################
        # General UI
        #####################

        # Increase window resize speed for Cocoa applications
        defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

        # Expand save panel by default
        defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
        defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

        # Expand print panel by default
        defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
        defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

        # Automatically quit printer app once the print jobs complete
        defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

        # Disable the “Are you sure you want to open this application?” dialog
        defaults write com.apple.LaunchServices LSQuarantine -bool false

        # Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
        /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

        # Check for software updates daily, not just once per week
        defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

        # Disable smart quotes as they’re annoying when typing code
        defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

        # Disable smart dashes as they’re annoying when typing code
        defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

        #####################
        # SSD
        #####################

        # Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
        # all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
        #rm -rf ~/Library/Application Support/Dock/desktoppicture.db
        #sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
        #sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

        # Disable the sudden motion sensor as it’s not useful for SSDs
        sudo pmset -a sms 0

        #####################
        # Keyboard and mouse
        #####################

        # Trackpad: enable tap to click for this user and for the login screen
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
        defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
        defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

        # Disable “natural” (Lion-style) scrolling
        defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

        # Increase sound quality for Bluetooth headphones/headsets
        defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

        # Enable full keyboard access for all controls
        # (e.g. enable Tab in modal dialogs)
        defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

        # Use scroll gesture with the Ctrl (^) modifier key to zoom
        defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
        defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
        # Follow the keyboard focus while zoomed in
        defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

        # Disable press-and-hold for keys in favor of key repeat
        defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

        # Set a blazingly fast keyboard repeat rate
        defaults write NSGlobalDomain KeyRepeat -int 0

        #####################
        # Screen
        #####################

        # Enable subpixel font rendering on non-Apple LCDs
        defaults write NSGlobalDomain AppleFontSmoothing -int 2

        # Enable HiDPI display modes (requires restart)
        sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

        #####################
        # Finder
        #####################

        # Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
        defaults write com.apple.finder QuitMenuItem -bool true

        # Finder: show all filename extensions
        defaults write NSGlobalDomain AppleShowAllExtensions -bool true

        # Finder: show status bar
        defaults write com.apple.finder ShowStatusBar -bool true

        # Finder: show path bar
        defaults write com.apple.finder ShowPathbar -bool true

        # Finder: allow text selection in Quick Look
        defaults write com.apple.finder QLEnableTextSelection -bool true

        # When performing a search, search the current folder by default
        defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

        # Enable spring loading for directories
        defaults write NSGlobalDomain com.apple.springing.enabled -bool true

        # Avoid creating .DS_Store files on network volumes
        defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

        # Use list view in all Finder windows by default
        # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
        defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

        # Enable AirDrop over Ethernet and on unsupported Macs running Lion
        defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

        # Expand the following File Info panes:
        # “General”, “Open with”, and “Sharing & Permissions”
        defaults write com.apple.finder FXInfoPanesExpanded -dict \
            General -bool true \
            OpenWith -bool true \
            Privileges -bool true

        #####################
        # Dock
        #####################

        # dock on the left
        defaults write com.apple.dock orientation left

        # Wipe all (default) app icons from the Dock
        # This is only really useful when setting up a new Mac, or if you don’t use
        # the Dock to launch apps.
        # defaults write com.apple.dock persistent-apps -array

        # Make Dock icons of hidden applications translucent
        defaults write com.apple.dock showhidden -bool true
        killall Dock

        # Only use UTF-8 in Terminal.app
        defaults write com.apple.terminal StringEncodings -array 4

        # Use plain text mode for new TextEdit documents
        defaults write com.apple.TextEdit RichText -int 0
        # Open and save files as UTF-8 in TextEdit
        defaults write com.apple.TextEdit PlainTextEncoding -int 4
        defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

        #####################
        # Chrome
        #####################

        # Allow installing user scripts via GitHub Gist or Userscripts.org
        defaults write com.google.Chrome ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"
        defaults write com.google.Chrome.canary ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"

        # Disable the all too sensitive backswipe
        defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
        defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

        # Use the system-native print preview dialog
        defaults write com.google.Chrome DisablePrintPreview -bool true
        defaults write com.google.Chrome.canary DisablePrintPreview -bool true

    # }}}

else
    log_notice "This is not OSX so not running osx tasks"
fi

log_info "End mac install script"
