# Homebrew, brew cask, and mac app store package manifest
# vim: set foldmethod=marker:

# brew {{{
brew "akamai" # interact with akamai caching
# brew "angband" # requires java
brew "ant" # apache build tool (used to build plantuml)
tap "getantibody/tap"
brew "antibody" # like antigen but faster! (zsh plugin system)
# brew "antigen" # zsh package manager. I switched to antibody for speed
brew "autoconf" # needed to build some php70 libs from source
brew "autossh" # ssh that reconnects
brew "awscli" # aws command - used to upload to s3, etc. `aws configure` to set up credentials. (set up access keys here https://console.aws.amazon.com/iam/home?region=us-west-1#/users/mike.funk?section=security_credentials)
brew "bat" # much cooler looking cat
# brew "chromedriver" # like selenium for chrome.
brew "codespell" # neat little utility to show and fix code misspellings
# brew "colortail" # tail with support for colors
# brew "composer" # php dependency management (now installed via phpenv)
brew "coreutils" # used by k zsh plugin and msgpack gem which is a dependency of rouge and neovim gems
# brew "cmake" # used by youcompleteme
# brew "ctags" # allows jumping to function/class definitions, etc. in vim (I use universal-ctags)
brew "ctop" # like top for docker containers
brew "curl" # http cli tool. Included with mac of course, but this gives me the updated version.
# tap "dandavison/delta" "https://github.com/dandavison/delta"
# brew "dandavison/delta/git-delta" # git pager with syntax highlighting, language aware (kind of buggy right now, will stick with diff-so-fancy but check this out later)
# brew "denisidoro/tools/navi" # cool interactive command helper (eh, I like aliases and functions. this is basically just a persistent <ctrl-r> with fzf.)
# brew "desk" # shell workspace manager. I use direnv instead.
brew "diff-so-fancy" # better git diff viewer (note: diff-highlight is in pip)
brew "direnv" # allow .envrc in directories to be loaded at every prompt to add relative bins to PATH, etc. easy.
# brew "dnsmasq" # easily set up dynamic dev domains such as myproject.dev
# brew "docker" # virtualization software (I use docker for mac now - see docker cask)
# brew "docker-compose" # manage multiple docker images and how they interact (I get this via docker-for-mac)
# brew "docker-machine" # virtualbox VM for your docker images (I get this via docker-for-mac)
brew "docker-machine-nfs" # enables nfs mounts for docker-machine via `docker-machine-nfs default --mount-opts="async,noatime,actimeo=1,nolock,vers=3,udp" --force`
# brew "dos2unix" # converts dos line endings to unix in a file
# tap "moncho/dry"
# brew "dry" # docker monitoring (does not work with docker-machine. works with docker for mac because needs access to docker.sock.)
# brew "dtrx" # do the right extraction - so you don't have to remember tar args (I found a helpful pneumonic to remember tar args: eXtract Ze Vucking Files, Compress Ze Vucking Files)
brew "entr" # file watcher
# brew "fasd" # Command-line productivity booster, offers quick access to files and directories, inspired by autojump, z and v. (I use wd)
brew "fd" # prettier alternative to find that respects gitignore
# brew "fpp" # facebook path picker. Used with tmux-fpp to easily open files in an editor. (I don't use it)
brew "fx" # json funagler used by some of my shell functions
brew "fzf" # fuzzy file finder `git branch | fzf | xargs git checkout`
brew "git"
# brew "git-extras" # adds some cool additional git commands (conflicts with npm git-standup)
# brew "git-flow" # adds first class git commands for the git-flow workflow (I use avh version below)
brew "git-flow-avh" # adds first class git commands for the git-flow workflow. This version will delete remote feature, release, and hotfix branches on finishing.
# brew "global" # gnu global tags aka gtags. More powerful than ctags but has a different interface with a learning curve. Also depends on ctags which conflicts with universal-ctags.
brew "gnu-sed" # linux version of sed - saves as gsed (required for diff-so-fancy)
# brew "gnu-tar" # linux version of tar so stuff actually works
# brew "graphviz" # useful for xdebug profiler class maps
brew "grc" # generic colorizer - used to colorize ps, ls, netstat, etc.
# brew "go" # go programming language. used for mailhog and rtop and wuzz.
brew "gpg" # used by s3cmd and yadm to encrypt stuff
# brew "heroku-toolbelt" # heroku deploy tools
# brew "hg" # mercurial
# brew "highlight" # colorizes html and other output on the command line. used by ranger.
brew "hostess" # manage hosts file `hostess help` TODO try https://github.com/feross/hostile - you can apply/unapply separate hosts file in normal hosts file format rather than json.
brew "htop" # prettier, more powerful version of top. gets the top running processes. (see my notes)
brew "httpie" # a cool alternative to curl (http --help) (NOTE: `man http` is something different :/ )
brew "hub" # , args: ["devel"] # github tool is a superset of git with extra commands. 2.0 needs to be installed via --HEAD
# brew "icu4c" # needed for php70-intl extension (it seems this is included with node https://stackoverflow.com/questions/27896229/library-not-loaded-error-after-brew-install-php56)
# brew "ievms" # internet explorer VirtualBox VMs to test a site in various IE versions
brew "imagemagick" # image transformation tool - needed by php imagemagick extension (latest version needed to install host machine pecl imagick php extension)
brew "imagemagick@6" # image transformation tool - v6 needed for catalog
# brew "interactive-rebase-tool" # awesome ncurses tool to spiff up interactive rebases (I use vim with a plugin instead)
brew "intltool" # needed for php intl extension
# brew "irssi" # irc client
# brew "jsawk" # parse json in bash
brew "joplin" # powerful note-taking app with cli version, multi-pane, search, etc.
brew "jsonlint" # used by vim ale to lint json
brew "jq" # simple json pretty-printer `echo '{"my" => "json"}' | jq .`
# brew "jrnl" # simple journaling wrapper
# brew "keychain" # manage ssh agent and adding keys to it automatically. (I don't use this now that I have an ssh config directive to store passphrases for ssh agent in my osx keychain, which is different from this project's "keychain". Confusing, I know.)
# brew "kubernetes-cli" # already installed via brew cask install docker
# brew "lftp" # fancy scp, torrent, http, ftp download and upload client with queues, backgrounding, and more
brew "libcouchbase" # nosql fast data storage. I install this for the cli tool `cbc`
brew "libmemcached" # needed by php70 memcached pecl extension
brew "libmcrypt" # needed by php-build, which is used by phpenv DO NOT DELETE php will break
brew "libxml2" # needed by php70
# brew "lockrun" # simple way to lock cron jobs with a lock file and clear them when done
# brew "lsd" # pretty ls augmentation
# brew "lynx" # console web browser. used by ranger to preview html.
# brew "macvim" # mac gui vim client
brew "mas" # mac app store cli. e.g. `mas install Xcode`
# brew "andersjanmyr/homebrew-tap/mc" # memcached cli. Use the full path to avoid conflicting with midnight commander (Trouble using on saatchi due to networking limitations)
brew "memcached" # needed by php70 memcached pecl extension
brew "mkcert" # create a certificate, create a local CA, add the cert as trusted in the CA
# brew "mono" # .NET compiler for mac. Useful for OmniSharp.
brew "multitail" # tail multiple files in splits with pretty colors
brew "mycli" # Mysql cli augmentation with completion, highlighting, etc.
brew "mysql" # I haven't been using the server lately but I use the cli tool to connect and I use mysql_config_editor. Unfortunately I can't just install this separately :(
# brew "mysql-client" # If I ever need mysql client without mysql on local... downside: it doesn't link automatically - you have to brew link --force even if mysql isn't installed :/
# brew "m-cli" # mac cli tools e.g. restart, screensaver, bluetooth, etc.
# brew "nano" # text editor. This gets the latest version: 2.2.6 rather than 2.2.0 that comes with osx.
# brew "ncdu" # interactive du
brew "neovim" # vim re-imagined
brew "node" # nodejs and npm (non-nodenv version required by joplin, yarn)
brew "nodenv" # node version manager (same api as rbenv)
brew "noti" # simple terminal notifier
brew "nss" # required by mkcert to make certs trusted in firefox
# brew "pandoc" # transform between document formats e.g. markdown <-> pdf (used for inline vim php documentation)
# brew "pass" # unix password manager using gpg
# brew "peco" # interactively filter results and print the filtered version. can be used to print filtered one or e.g. `vim $(dosomething | peco)` (FZF does this)
# brew "perl-build" # needed for perlenv
# brew "percona-toolkit" # mysql schema migrator among other things. requires java and perl.
brew "pgcli" # like mycli for postgres (used for toaf judging app)
# php has been moved to homebrew-php. In the process, php70 was removed >:( I've switched to phpenv and pecl instead. I don't even know how extensions work in the new homebrew php.
# brew "php@7.1", args: ["--with-pear"], link: true
brew "pinentry" # gpg terminal pin entry (used by yadm encrypt/decrypt)
# brew "pinentry-mac" # native gpg pin entry for yadm and others. Opens a native window.
brew "plantuml" # uml generation from text. requires java (I use regularly for diagramming processes and sometimes uml class diagrams)
# brew "plenv" # perl version manager. better than perlbrew and consistent with my other env managers (rbenv, phpenv, nodenv, pyenv). used to get percona-toolkit working.
# brew "postgresql" # database similar to mysql (install if needed)
# brew "pre-commit" # yelp git pre-commit framework (I manage this via pip)
# brew "prettyping" # ping with a cool sparkline graph of status
brew "pspg" # , args: ["HEAD"] # "postgres pager" also useful for mysql, etc.
# brew "pv" # pipe something to pv to see progress of data through a pipeline. pv works like cat so `pv /path/to/myfile.sql > mysql ...`
brew "pyenv" # python version manager (same api as rbenv)
# brew "python" # updated version of python with updated pip. Useful for installing pip packages without root. NOTE: homebrew "pip" breaks neovim.
# brew "python3" # required for tmuxomatic (but I use pyenv)
# brew "ranger" # vim-like file system browser (cool but I don't use it)
brew "rbenv" # ruby environment switcher
# brew "reattach-to-user-namespace" # used to fix mac issues with copy/paste in tmux (not needed after tmux 2.6! https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/issues/66)
# brew "redis" # key/value store
# brew "rlwrap" # wrap a command in readline to enable up for history, etc. Useful for python repl: `rlwrap python`
# brew "ruby"
# brew "ruby-build" # an rbenv plugin that provides an rbenv install command to compile and install different versions of ruby
# brew "rust" # used for "vivid" LS_COLORS package (I now download the executable until it's on homebrew)
# brew "rvm" # ruby version manager (I use rbenv instead)
# brew "s3cmd" # amazon s3 uploader (I use awscli instead)
# brew "scummvm" # never have I seen a more wretched hive of scum(m) and villainy
# brew "selenium-server-standalone" # controls a browser for automated testing
brew "shellcheck" # Checks shell syntax (used by vim ALE)
brew "shfmt" # formats shell scripts (used by vim ALE)
brew "ssh-copy-id" # copies ssh keys to remote servers
brew "sshrc" # use ~/.sshrc and ~/.sshrc.d on remote servers. bring your dotfiles with you!
# brew "sshfs" # mounts ssh servers as file systems in the local fs. requires osxfuse.
# brew "https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb" # use an ssh password. trying this for leaf group LDAP access. (didn't work, don't need it for anything else at the moment)
# brew "solr" # search data server
# brew "source-highlight" # used to automatically colorize `less` text (I Just use `bat` instead. Got weird results with this.)
# brew "spark" # used for rainbarf to show spiffy cli graphs
# brew "sqlparse" # sql formatter (managed by pip in ~/requirements.txt)
# brew "stern" # kubernetes multitailer (waiting for this to be solved https://github.com/wercker/stern/issues/112)
# brew "stormssh" # interact with ssh config. I have yet to find a net positive use for this. It makes my ssh config less readable because it doesn't put them in comment fold groups like I do. just so I can `storm add ...`. `storm list` and `storm search` are kind of useless as I can do that with `ssh <tab>`. It lets you edit multiple ssh entries at once, but I can do that in vim. It provides a web interface, but I don't want that.
# brew "stow" # http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html (I use yadm instead)
# brew "task" # taskwarrior https://taskwarrior.org (I don't need this unless I don't have jira)
# brew "teleconsole" # share your console with others easily
brew "terminal-notifier" # used by tmux plugin marzocchi/zsh-notify (this is really just a gem so watch for it being installed by dependencies of other gems :/ )
brew "the_silver_searcher" # awesome fast grep replacement: `ag --help`
brew "tig" # git? tig! (note: this requires asciidoc)
# brew "timewarrior" # taskwarrior-like interface for tracking time (I don't use this)
brew "tldr" # more consise community man pages
# brew "tmux" # terminal multiplexer similar to screen. (Latest tmux 2.9a has some crash-inducing bugs. I am manually installing 2.8 from a tarball temporarily. See ~/.yadm/bootstrap for details.)
# brew "tofrodos" # line ending conversion (install if needed)
# brew "trash" # a trash can for the terminal
brew "tree" # display file/folder hierarchies in a visual tree format
tap "universal-ctags/universal-ctags"
brew "universal-ctags", args: ["HEAD"] # tag creator for use by vim to navigate by symbols. head only.
brew "unixodbc" # needed by php70
# brew "virtualhost".sh # (crappy) virtualhost management script
brew "watch" # Executes a program periodically, showing output fullscreen (an npm package which is a child dependency of another sometimes replaces this binary: https://www.npmjs.com/package/watch . If so, just `brew link --overwrite watch` )
brew "watchman" # needed for `jest --watch` https://github.com/cm-pliser-tdd-by-example/tdd-by-example-js/issues/10
# brew "w3m" # full color image previewer for ranger (but doesnt work in tmux)
brew "wget" # latest version
# brew "wifi-password" # get your current wifi password quickly without mucking about with keychain access (install if needed)
# brew "xdebug-osx" # xdebug toggler for homebrew php (which I don't currently use)
# brew "vim" # macvim requires xcode. This also allows you to get vim 8 without using a separate tap. (trying neovim again)
# brew "vit" # ncurses taskwarrior interface - like tig for taskwarrior TODO: upgrade to 1.3 when it passes beta! I can't install it from source because it requires current perl version be from /usr/bin/perl, among other problems. https://www.mankier.com/5/vitrc (also I don't use taskwarrior anymore)
brew "yamllint" # used by vim-ale
brew "yarn" # wrapper for npm with real lock files and caching (installing via npm is deprecated)
brew "yadm" # yet another dotfiles manager
# brew "zlib" # needed for pyenv (but can be used from /usr/include after installing developer package)
brew "zork" # seriously? yes. tip: `save` and `restore` And yes, there's only one save slot, what do you think this is, 1990?
# brew "zplug" # zsh plugin manager like composer. bash installer crashes for some reason. works fine via homebrew. (switched to antibody)
brew "zsh" # awesome bash shell replacement
# brew "zsh-completions" # tab completions (I install this via my zsh plugin manager instead)
# }}}

# cask {{{
tap "caskroom/cask"
cask "adoptopenjdk" # needed to install akamai cli
# cask "dashlane" # password manager like lastpass (I use lastpass)
# cask "bettertouchtool" # with a config file this lets me vimify any cocoa app https://raw.githubusercontent.com/Vincent-Carrier/CocoaVim/master/CocoaVim.bttpreset
# cask "bitbar" # use any cli command to show stuff in the menubar with colors and icons and provide menu options
# cask "beardedspice" # keyboard media controls for media sites. Always seems to be broken :/
# cask "caffeine" # keep mac awake (replaced with amphetamine)
# cask "cheatsheet" # hold <cmd> for a bit to get a modal of available keyboard shortcuts (kind of annoying - rarely comes up when I actually want it to, too much info)
# cask "discord" # chat
cask "docker" # docker for mac desktop app
cask "dozer" # little menubar app that allows hiding rarely used menubar icons
# cask "dropbox" # I especially use this for synching my notes so I can view them in the joplin mobile app (not using this feature right now)
# cask "emacs" # this actually makes sense as a cask. It becomes tmux, vim, and kitty all in one.
# cask "epic-games" # game store
cask "firefox"
tap "homebrew/cask-fonts"
# tap "caskroom/fonts"
# cask "font-fira-code"
# cask "font-iosevka"
cask "font-iosevka-nerd-font-mono"
# cask "font-meslo-for-powerline" # whoa there are a ton of fonts on brew "cask"!
# cask "gog-galaxy" # good old games
cask "google-chrome"
# cask "google-drive"
cask "insomnia" # http api client like postman but nicer looking
cask "iterm2" # I was using kitty but they use opengl and macos deprecated opengl support, so it crashes regularly. iTerm now has gpu rendering, so I'm back to iTerm! It has a bunch of other cool new stuff now anyway.
cask "java" # required for plantuml, etc.
# cask "joplin" # desktop joplin (I use the terminal interface)
cask "jumpcut" # clipboard manager recommended by Michael Zick (slightly annoying interface but I haven't found any better on brew) ctrl-opt-v (forward) or ctrl-opt-shift-v (backward)
# cask "kitematic" # mac native docker container browser (I just use docker cli tools)
# cask "kitty" # fast terminal emulator (see iterm2 above for why I switched back to iTerm)
# cask "launchcontrol" # launchctl gui. (I use lunchy gem instead)
cask "lunchy" # launchctl cli wrapper. Port of lunchy gem. (Tried this, was missing options, back to gem)
# cask "macfusion" # other half of tool to mount ssh directories in the finder
# cask "macgdbp" # xdebug gui client (I use vdebug)
cask "malwarebytes" # ya neva know
cask "microsoft-edge-beta" # not out of beta yet as of 2019-09-27
cask "minikube" # for learning
cask "mpv" # video player like vlc
cask "multifirefox" # profile picker until firefox fixes this glaring omission
# cask "noti" # mac native pushbullet notifications (I use the chrome extension)
# cask "ngrok" # securely expose your local site to the internet and inspect and repeat traffic
# cask "osxfuse" # half of tool to mount ssh directories in the finder (useful if working on a shared dev environment)
# cask "openemu" # multi game system emulator
# cask "origin" # ea games store
# cask "pdftotext" # used by ranger to preview pdfs
# cask "postman" # http api client
# cask "see" https://github.com/sindresorhus/quick-look-plugins
# cask "qlcolorcode" # quicklook plugin to provide syntax highlighting to code files (fails to install)
# cask "qlstephen" # quicklook plugin
cask "qlmarkdown" # quicklook plugin
cask "quicklook-json" # quicklook plugin
# cask "qlprettypatch" # quicklook plugin
cask "quicklook-csv" # quicklook plugin
# cask "qlimagesize" # quicklook plugin
cask "sequel-pro" # mysql gui client
cask "slack" # needed for screen sharing features
cask "spectacle" # keyboard window splitter/resizer/mover. Kind of like a i3 window manager.
cask "spotify" # mac native spotify player (I use the web app, but sometimes it gets stuck in an offline state)
# cask "ssh-tunnel-manager" # mac native gui to manage running ssh tunnels
# cask "steam" # yep
# cask "suspicious-package" # quicklook plugin
# cask "vagrant" # development VM maker/manager (I use docker now)
# cask "transmission" # unleash a torrent of files ;)
#
# TODO these can't just be upgraded while virtualbox is running :/
cask "virtualbox" # virtual machine software (needed by docker-machine at least)
# cask "virtualbox-extension-pack" # add-on to do stuff you'll always want... except for docker-machine
#
# cask "vivaldi" # chrome alternative with some cool features (I switched back to chrome for now - profiles are kind of buggy atm)
# cask "vlc" # watch the videos I download
# cask "webpquicklook" # quicklook plugin
# cask "wireshark" # analyze network data
# cask "xquartz" # needed to install xclip, which is needed to copy text from multitail (I installed all of that, copy still didn't work :/ )
cask "xscreensaver" # shitload of old screensavers... downside is there are so many it slows down selecting Desktop & Screen Saver the first time in System Preferences :/
# }}}

# mac app store {{{
# Do I really need these?
mas "Downlink", id: 1454269192 # cool live (20 min refresh) earth view on my desktop (tries to reinstall every time :/ )
mas "Xcode", id: 497799835 # needed for some tools (TODO which tools?)
mas "Amphetamine", id: 937984704 # replacement for discontinued "caffeine" menubar app
# mas "GIPHY CAPTURE", id: 668208984
# }}}
