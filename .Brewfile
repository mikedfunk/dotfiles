# vim: set foldmethod=marker:

# brew {{{
brew "akamai" # interact with akamai caching
brew "angband"
brew "autoconf" # needed to build some php70 libs from source
brew "autossh" # ssh that reconnects
brew "awscli" # aws command - used to upload to s3, etc. `aws configure` to set up credentials. (set up access keys here https://console.aws.amazon.com/iam/home?region=us-west-1#/users/mike.funk?section=security_credentials)
brew "bat" # much cooler looking cat
# brew "chromedriver" # like selenium for chrome.
# brew "colortail" # tail with support for colors
brew "composer" # php dependency management
# brew "coreutils" # used by k zsh plugin
# brew "cmake" # used by youcompleteme
# brew "ctags" # allows jumping to function/class definitions, etc. in vim
brew "ctop" # like top for docker containers
brew "curl" # http cli tool
# brew "desk" # shell workspace manager. I use direnv instead.
brew "direnv" # allow .envrc in directories to be loaded at every prompt to add relative bins to PATH, etc. easy.
# brew "dnsmasq" # easily set up dynamic dev domains such as myproject.dev
brew "docker" # virtualization software
brew "docker-compose" # manage multiple docker images and how they interact
brew "docker-machine" # virtualbox VM for your docker images
brew "docker-machine-nfs" # enables nfs mounts for docker-machine via `docker-machine-nfs default --mount-opts="async,noatime,actimeo=1,nolock,vers=3,udp" --force`
# brew "dos"2unix # converts dos line endings to unix in a file
# brew "dtrx" # do the right extraction - so you don't have to remember tar args
brew "entr" # file watcher
# brew "fasd" # Command-line productivity booster, offers quick access to files and directories, inspired by autojump, z and v.
# brew "fd" # prettier alternative to find that respects gitignore
# brew "fpp" # facebook path picker. Used with tmux-fpp to easily open files in an editor.
# brew "fzf" # fuzzy file finder
brew "git"
brew "git-extras" # adds some cool additional git commands
# brew "git-flow" # adds first class git commands for the git-flow workflow
brew "git-flow-avh" # adds first class git commands for the git-flow workflow. This version will delete remote feature, release, and hotfix branches on finishing.
brew "gnu-sed" # linux version of sed - saves as gsed (required for diff-so-fancy)
# brew "gnu-tar" # linux version of tar so stuff actually works
# brew "graphviz" # useful for xdebug profiler class maps
brew "grc" # generic colorizer
# brew "go" # go programming language. used for mailhog and rtop.
brew "gpg" # used by s3cmd and yadm to encrypt stuff
# brew "heroku-toolbelt" # heroku deploy tools
# brew "hg" # mercurial
# brew "highlight" # colorizes html and other output on the command line. used by ranger.
brew "hostess" # manage hosts file
brew "htop" # prettier, more powerful version of top. gets the top running processes. (see my notes)
brew "httpie" # a cool alternative to curl (http --help)
brew "hub", args: ["--devel"] # github tool is a superset of git. 2.0 needs to be installed via --HEAD
# brew "icu4c" # needed for php70-intl extension (it seems this is included with node https://stackoverflow.com/questions/27896229/library-not-loaded-error-after-brew-install-php56)
brew "ievms" # internet explorer VirtualBox VMs to test a site in various IE versions
brew "imagemagick@6" # image transformation tool - needed by php imagemagick extension (v6 needed for catalog)
brew "intltool" # needed for php intl extension
# brew "irssi" # irc client
# brew "jsawk" # parse json in bash
brew "joplin" # powerful note-taking app
brew "jsonlint" # used by vim ale to lint json
brew "jq" # simple json pretty-printer `echo '{"my" => "json"}' | jq .`
# brew "keychain" # manage ssh agent and adding keys to it automatically. (I don't use this now that I have an ssh config directive to store passphrases for ssh agent in my osx keychain, which is different from this project's "keychain". Confusing, I know.)
# brew "lftp" # fancy scp, torrent, http, ftp download and upload client with queues, backgrounding, and more
brew "libcouchbase" # nosql fast data storage similar to mongo. Used at Saatchi. Includes cli tool cbc
brew "libmemcached" # needed by php70
brew "libmcrypt" # needed by php-build DO NOT DELETE php will break
brew "libxml2" # needed by php70
# brew "lynx" # console web browser. used by ranger to preview html.
# brew "macvim" # mac gui vim client
brew "mas" # mac app store cli. e.g. `mas install Xcode`
brew "memcached" # needed by php70
# brew "mono" # .NET compiler for mac. Useful for OmniSharp.
brew "multitail" # tail multiple files in splits with pretty colors
# brew "mycli"
brew "mysql" # I haven't been using the server lately but I use it to connect and I use mysql_config_editor
# brew "mysql-client" # If I ever need mysql client without mysql on local...
# brew "nano" # text editor. This gets the latest version: 2.2.6 rather than 2.2.0 that comes with osx.
# brew "neovim" # vim re-imagining
brew "node" # nodejs and npm (required by joplin, yarn)
brew "nodenv" # node version manager
brew "noti" # simple terminal notifier
# brew "openssl@1.1" # not sure if this is still needed...
brew "pandoc" # used for inline vim php documentation
# brew "pass" # unix password manager using gpg
brew "percona-toolkit" # mysql schema migrator among other things
# brew "pgcli" # like mycli for postgres
# php has been moved to homebrew-php. In the process, php70 was removed >:( I've switched to phpenv and pecl instead. I don't even know how extensions work in the new homebrew php.
# brew "php@7.1", args: ["--with-pear"], link: true
# brew "pinentry-mac" # native gpg pin entry for yadm and others
brew "plantuml" # uml generation from text
brew "plenv" # perl version manager. better than perlbrew. used to get percona-toolkit working.
# brew "postgresql"
# brew "pre-commit" # yelp git pre-commit framework (I manage this via pip)
# brew "pv" # pipe something to pv to see progress of data through a pipeline
brew "pyenv" # python version manager
# brew "python" # updated version of python with updated pip. Useful for installing pip packages without root. NOTE: homebrew "pip" breaks neovim.
# brew "python3" # required for tmuxomatic
# brew "ranger" # vim-like file system browser
brew "rbenv" # ruby environment switcher
brew "reattach-to-user-namespace" # used to fix mac issues with copy/paste in tmux
# brew "redis" # key/value store used by a project I am working on
# brew "ruby"
# brew "ruby-build" # an rbenv plugin that provides an rbenv install command to compile and install different versions of ruby
# brew "rvm" # ruby version manager. I use rbenv instead.
# brew "s3cmd" # amazon s3 uploader. I use awscli instead.
# brew "selenium-server-standalone" # controls a browser for automated testing
brew "shellcheck" # Checks shell syntax (used by vim ALE)
brew "shfmt" # formats shell scripts (used by vim ALE)
brew "ssh-copy-id" # copies ssh keys to remote servers
brew "sshrc" # use ~/.sshrc and ~/.sshrc.d on remote servers. bring your dotfiles with you!
# brew "sshfs" # mounts ssh servers as file systems in the local fs. requires osxfuse.
# brew "sshuttle" # poor mans vpn. doesnt work on yosemite at the moment
# brew "solr" # search data server
# brew "spark" # used for rainbarf to show spiffy cli graphs
# brew "stormssh" # interact with ssh config. I have yet to find a net positive use for this. It makes my ssh config less readable because it doesn't put them in comment fold groups like I do. just so I can `storm add ...`. `storm list` and `storm search` are kind of useless as I can do that with `ssh <tab>`. It lets you edit multiple ssh entries at once, but I can do that in vim. It provides a web interface, but I don't want that.
# brew "stow" # http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html <- I use yadm instead
brew "task" # taskwarrior https://taskwarrior.org
# brew "teleconsole" # share your console with others easily
brew "terminal-notifier" # used by tmux plugin marzocchi/zsh-notify
brew "the_silver_searcher" # awesome fast grep replacement: ag
brew "tig" # git? tig! (note: this requires asciidoc)
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
# brew "vim", args: ["--with-python@2"] # macvim requires xcode. This also allows you to get vim 8 without using a separate tap. I install with python 2 because vdebug 2.x is broken for me and 1.5.x does not work with python 3.
brew "vim" # macvim requires xcode. This also allows you to get vim 8 without using a separate tap. (vdebug 2.x now working with python 3!)
brew "yarn" # wrapper for npm with real lock files and caching
brew "yadm" # yet another dotfiles manager
# brew "zplug" # zsh plugin manager like composer. bash installer crashes for some reason. works fine via homebrew. (switched to installer - see bootstrap)
brew "zsh" # awesome bash shell replacement
# brew "zsh-completions" # tab completions. I install this via zplug instead.
# }}}

# cask {{{
tap "caskroom/cask"
# cask "dashlane" # password manager like lastpass
cask "bitbar" # use any cli command to show stuff in the menubar with colors and icons and provide menu options
# cask "beardedspice" # keyboard media controls for media sites (I now use streamkeys chrome extension) - goes together with bubo.app
cask "cheatsheet" # hold <cmd> for a bit to get a modal of available keyboard shortcuts (kind of annoying - rarely comes up when I actually want it to, too much info)
# cask "docker" # docker for mac desktop app (I use docker-machine)
cask "dropbox" # I especially use this for synching my notes so I can view them in the joplin mobile app
# cask "firefox"
tap "caskroom/fonts"
# cask "font-fira-code"
cask "font-iosevka"
# cask "font-meslo-for-powerline" # whoa there are a ton of fonts on brew "cask"!
# cask "gog-galaxy" # good old games
cask "google-chrome"
# cask "google-drive"
cask "iterm2"
# cask "kap" # screen capture to gif (Trying out licecap instead)
# cask "keycastr" for screencasts - show keys pressed on the screen
# cask "kitematic" # docker container browser
# cask "kitty" # fast terminal emulator
cask "lastpass" # password manager
cask "licecap" # another gif screen cap tool. It's ancient but very fast at exporting gifs!
# cask "macfusion" # other half of tool to mount ssh directories in the finder
# cask "macgdbp" # xdebug gui client (I use vdebug)
# cask "multifirefox" # profile picker until firefox fixes this glaring omission
# cask "noti" # mac native pushbullet notifications
# cask "osxfuse" # half of tool to mount ssh directories in the finder (useful if working on a shared dev environment)
# cask "pdftotext" # used by ranger to preview pdfs
# cask "see" https://github.com/sindresorhus/quick-look-plugins
# cask "qlcolorcode" # quicklook plugin
# cask "qlstephen" # quicklook plugin
cask "qlmarkdown" # quicklook plugin
cask "quicklook-json" # quicklook plugin
# cask "qlprettypatch" # quicklook plugin
cask "quicklook-csv" # quicklook plugin
cask "betterzipql" # quicklook plugin
# cask "qlimagesize" # quicklook plugin
cask "sequel-pro" # mysql gui client
cask "spectacle" # keyboard window splitter/resizer/mover
# cask "spotify" # their web app has been broken for a bit https://community.spotify.com/t5/Other-Partners-Web-Player-etc/Web-Player-Not-Working/td-p/1070938
cask "steam" # yep
# cask "suspicious-package" # quicklook plugin
# cask "tinygrab" # simple screenshot uploader
# cask "vagrant" # development VM maker/manager (I use docker now)
# TODO these can't just be upgraded while virtualbox is running :/
# cask "virtualbox" # virtual machine software
# cask "virtualbox-extension-pack" # add-on to do stuff you'll always want
# cask "webpquicklook" # quicklook plugin
# cask "wireshark" # analyze network data
# cask "xquartz" # needed to install xclip, which is needed to copy text from multitail (I installed all of that, copy still didn't work :/ )
# }}}

# mac app store {{{
# Do I really need these?
# mas "Xcode", id: 497799835
# mas "GIPHY CAPTURE", id: 668208984
# }}}
