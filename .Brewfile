tap "caskroom/cask"

brew "autoconf" # needed to build some php70 libs from source
brew "autossh" # ssh that reconnects
brew "chromedriver" # like selenium for chrome.
# brew "colortail" # tail with support for colors
# brew "coreutils" # used by k zsh plugin
brew "cmake" # used by youcompleteme
# brew "ctags" # allows jumping to function/class definitions, etc. in vim
brew "ctop" # like top for docker containers
brew "curl" # http cli tool
# brew "desk" # shell workspace manager
brew "direnv" # allow .envrc in directories to be loaded at every prompt. easy.
# brew "dnsmasq" # easily set up dynamic dev domains such as myproject.dev
brew "docker" # virtualization software
brew "docker-compose" # manage multiple docker images and how they interact
brew "docker-machine" # virtualbox VM for your docker images
brew "docker-machine-nfs" # enables nfs mounts for docker-machine via `docker-machine-nfs default`
# brew "dos"2unix # converts dos line endings to unix in a file
brew "entr" # file watcher
# brew "fasd" # Command-line productivity booster, offers quick access to files and directories, inspired by autojump, z and v.
brew "fd" # alternative to find
# brew "fpp" # facebook path picker. Used with tmux-fpp to easily open files in an editor.
# brew "fzf" # fuzzy file finder
brew "git"
brew "git-extras" # adds some cool additional git commands
# brew "git-flow" # adds first class git commands for the git-flow workflow
brew "git-flow-avh" # adds first class git commands for the git-flow workflow. This version will delete remote feature, release, and hotfix branches on finishing.
brew "gnu-sed" # linux version of sed - saves as gsed (required for diff-so-fancy)
brew "gnu-tar" # linux version of tar so stuff actually works
# brew "googlecl" # google command line tool
# brew "graphviz" # useful for xdebug profiler class maps
brew "grc" # generic colorizer
# brew "go" # go programming language. used for mailhog.
brew "gpg" # used by s3cmd and to encrypt stuff
# brew "heroku-toolbelt" # heroku deploy tools
# brew "hg" # mercurial
# brew "highlight" # colorizes html and other output on the command line. used by ranger.
brew "hostess" # manage hosts file
brew "htop" # prettier, more powerful version of top. gets the top running processes
brew "httpie" # a cool alternative to curl (http --help)
brew "hub", args: ["--devel"] # github tool is a superset of git. 2.0 needs to be installed via --HEAD
# brew "icu4c" # needed for php70-intl extension
brew "ievms" # internet explorer VMs to test a site in various IE versions
brew "imagemagick" # image transformation tool - needed by php imagemagick extension
brew "intltool" # needed for php intl extension
# brew "irssi" # irc client
# brew "jsawk" # parse json in bash
brew "joplin" # powerful note-taking app
brew "jq" # simple json pretty-printer `echo '{"my" => "json"}' | jq .`
# brew "libcaca" # image previewing in ASCII. used by ranger
brew "libcouchbase" # nosql fast data storage similar to mongo. Used at Saatchi. Includes cli tool cbc
brew "libmemcached" # needed by php70
brew "libmcrypt" # needed by php-build
brew "libxml2" # needed by php70
# brew "lynx" # console web browser. used by ranger to preview html.
# brew "macvim" # mac gui vim client
brew "mas" # mac app store cli. e.g. `mas install Xcode`
brew "memcached" # needed by php70
# brew "mono" # .NET compiler for mac. Useful for OmniSharp.
brew "multitail" # tail multiple files in splits with pretty colors
# brew "mycli"
brew "mysql"
# brew "nano" # text editor. This gets the latest version: 2.2.6 rather than 2.2.0 that comes with osx.
brew "neovim" # vim re-imagining
brew "node" # nodejs and npm
brew "nodenv" # node version manager
brew "noti" # simple terminal notifier
# brew "openssl@1.1" # not sure if this is still needed...
brew "pandoc" # used for inline vim php documentation
# brew "pass" # unix password manager using gpg
brew "percona-toolkit" # mysql schema migrator among other things
# TODO php has been moved to homebrew-php. In the process, php70 was removed
# >:( phpenv is another option, but it's failing to build right now. For now
# I'm just installing php 7.2 and not dealing with extensions. If I need to I
# can use pecl. ARGH.
brew "php", args: ["--with-pear"], link: true
# brew "php@7.0", args: ["--with-pear"], link: true
# brew "php70-couchbase"
# brew "php70-intl", args: ["--build-from-source"] # needed for phpstan
# brew "php70-igbinary"
# brew "php70-memcache" # needed for zed
# brew "php70-memcached", args: ["--HEAD"] # head only!
# brew "php70-mongodb"
# brew "php70-pcntl"
# brew "php70-xdebug"
# brew "php-version" # php version switcher
brew "pinentry-mac" # gpg pin entry for yadm and others
brew "plenv" # perl version manager. better than perlbrew. used to get percona-toolkit working.
# brew "postgresql"
# brew "pre-commit" # yelp git pre-commit framework (I manage this via pip)
brew "pyenv" # python version manager
brew "python" # updated version of python with updated pip. Useful for installing pip packages without root. NOTE: homebrew "pip" breaks neovim.
brew "python3" # required for tmuxomatic
# brew "ranger" # vim-like file system browser
# brew "rbenv" # ruby environment switcher
brew "reattach-to-user-namespace" # used to fix mac issues with copy/paste in tmux
# brew "redis" # key/value store used by a project I am working on
# brew "ruby-build" # an rbenv plugin that provides an rbenv install command to compile and install different versions of ruby
# brew "rvm" # ruby version manager
# brew "s3cmd" # amazon s3 uploader
brew "selenium-server-standalone" # controls a browser for automated testing
# brew "shellcheck" # hooks in with syntastic to style-check and lint bash. DISABLED because vim dies in shell files with this installed
brew "ssh-copy-id" # copies ssh keys to remote servers
# brew "sshrc" # use ~/.sshrc and ~/.sshrc.d on remote servers
# brew "sshfs" # mounts ssh servers as file systems in the local fs. requires osxfuse.
# brew "sshuttle" # poor mans vpn. doesnt work on yosemite at the moment
# brew "solr" # search data server
# brew "spark" # used for rainbarf to show spiffy cli graphs
# brew "stormssh" # interact with ssh config
# brew "stow" # http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html
# brew "teleconsole" # share your console with others easily
brew "terminal-notifier" # used by tmux plugin marzocchi/zsh-notify
brew "the_silver_searcher" # awesome fast grep replacement: ag
brew "tig" # git? tig!
brew "tmux" # terminal multiplexer similar to screen.
# brew "tofrodos" # line endings
# brew "trash" # a trash can for the terminal
brew "tree" # display file/folder hierarchies in a visual tree format
tap "universal-ctags/universal-ctags"
brew "universal-ctags", args: ["--HEAD"] # tag creator for use by vim to navigate by symbols
brew "unixodbc" # needed by php70
# brew "virtualhost".sh # crappy virtualhost management script
brew "watch" # contains some tools: free, kill, ps, uptime, etc.
# brew "w3m" # full color image previewer for ranger but doesnt work in tmux
brew "wget" # latest version
# brew "xdebug-osx" # xdebug toggler
brew "vim" # macvim requires xcode. This also allows you to get vim 8 without using a separate tap.
brew "yarn" # wrapper for npm with real lock files and caching
brew "yadm" # yet another dotfiles manager
# brew "zplug" # zsh plugin manager like composer. bash installer crashes for some reason. works fine via homebrew. (switched to installer - see bootstrap)
brew "zsh" # awesome bash shell replacement
brew "zsh-completions" # tab completions



# cask "dashlane" # password manager like lastpass
cask "bitbar" # use any cli command to show stuff in the menubar with colors and icons and provide menu options
# cask "beardedspice" # keyboard media controls for media sites (I now use streamkeys chrome extension) - goes together with bubo.app
# cask "docker" # docker for mac desktop app (I use docker-machine)
# cask "dropbox"
cask "firefox"
tap "caskroom/fonts"
cask "font-meslo-for-powerline" # whoa there are a ton of fonts on brew "cask"!
# cask "gifox" # menubar app to record 10-second gifs with cmd-shift-6
# cask "gifrocket" # video to gif converter
cask "google-chrome"
# cask "google-drive"
cask "iterm2"
cask "kap" # screen capture to gif
# cask "keycastr" for screencasts - show keys pressed on the screen
cask "lastpass" # password manager
# cask "licecap" # another gif screen cap tool
# cask "macfusion" # other half of tool to mount ssh directories in the finder
cask "macgdbp" # xdebug gui client
# cask "noti" # mac native pushbullet notifications
# cask "osxfuse" # half of tool to mount ssh directories in the finder (useful if working on a shared dev environment)
# cask "pdftotext" # used by ranger to preview pdfs
# cask "see" https://github.com/sindresorhus/quick-look-plugins
# cask "qlcolorcode" # quicklook plugin
# cask "qlstephen" # quicklook plugin
cask "qlmarkdown" # quicklook plugin
cask "quicklook-json" # quicklook plugin
cask "qlprettypatch" # quicklook plugin
cask "quicklook-csv" # quicklook plugin
cask "betterzipql" # quicklook plugin
cask "qlimagesize" # quicklook plugin
cask "sequel-pro" # mysql gui client
cask "spectacle" # keyboard window splitter/resizer/mover
cask "suspicious-package" # quicklook plugin
# cask "tinygrab" # simple screenshot uploader
# cask "vagrant" # development VM maker/manager
# TODO these can't just be upgraded while virtualbox is running :/
# cask "virtualbox" # virtual machine software
# cask "virtualbox-extension-pack" # add-on to do stuff you'll always want
cask "webpquicklook" # quicklook plugin
cask "wireshark" # analyze network data
# cask "xquartz" # needed to install xclip, which is needed to copy text from multitail
