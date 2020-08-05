# Homebrew, brew cask, and mac app store package manifest
# vim: set foldmethod=marker:

# brew {{{
brew "akamai" # interact with akamai caching
# brew "angband" # middle-earth themed dungeon crawler (requires java)
brew "ansible" # used in some of my company-specific stuff to run ssh commands on multiple servers.
# brew "ant" # apache build tool
brew "getantibody/tap/antibody" # like antigen but faster! (zsh plugin system)
# brew "antigen" # zsh package manager. I switched to antibody for speed
# brew "autoconf" # needed to build some php70 libs from source https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
brew "autossh" # ssh that reconnects (I use this a lot for tunnels, etc)
brew "awscli" # aws command - used to upload to s3, etc. `aws configure` to set up credentials. (set up access keys here https://console.aws.amazon.com/iam/home?region=us-west-1#/users/mike.funk?section=security_credentials)
brew "bandwhich" # top-like tool to see which processes are using the most bandwidth (sudo bandwhich)
brew "bat" # much cooler looking cat
brew "bison" # needed for phpenv build. The default mac one is too old. https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
# brew "broot" # use `br` to do something between tree and ls. File browser with lots of vim patterns.
brew "browser" # pipe html to a temp file and open in browser e.g. `ls | browser`
brew "bzip2" # needed for phpenv https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
# brew "bzt" # taurus http and performance test runner
# brew "chromedriver" # like selenium for chrome. (These drivers feel pretty outdated to me)
brew "circleci" # circleci cli e.g. `circleci open`
brew "codespell" # neat little utility to show and fix code misspellings
# brew "colortail" # tail with support for colors (I use multitail)
# brew "composer" # php dependency management (now installed via phpenv)
brew "coreutils" # used by k zsh plugin and msgpack gem which is a dependency of rouge and neovim gems.
# brew "cmake" # used by youcompleteme (which I no longer use)
# brew "ctags" # allows jumping to function/class definitions, etc. in vim (I use universal-ctags)
brew "ctop" # like top for docker containers (really great!)
brew "curl" # http cli tool. Included with mac of course, but this gives me the updated version. Also needed for phpenv https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
brew "git-delta" # git pager with syntax highlighting, language aware
# brew "denisidoro/tools/navi" # cool interactive command helper (eh, I like aliases and functions. this is basically just a persistent <ctrl-r> with fzf.)
# brew "desk" # shell workspace manager. (I use direnv instead)
# brew "diff-so-fancy" # better git diff viewer (note: diff-highlight is in pip) (I now use delta instead)
brew "direnv" # allow .envrc in directories to be loaded at every prompt to add relative bins to PATH, etc. easy. (I use this a lot to adjust path, kubernetes context, etc.)
# brew "dnsmasq" # easily set up dynamic dev domains such as myproject.dev `sudo brew services start dnsmasq` (WARNING: this _could_ cause problems with docker-machine certs)
# brew "docker" # virtualization software (I use docker-for-mac, which comes with executables but doesn't link them to /usr/local/bin any more, so I'm doing that manually in my yadm bootstrap)
brew "docker-compose" # manage multiple docker images and how they interact
brew "docker-machine" # virtualbox VM for your docker images
brew "docker-machine-nfs" # enables nfs mounts for docker-machine via `docker-machine-nfs default --mount-opts="async,noatime,actimeo=1,nolock,vers=3,udp" --force` (speeds up docker-machine a LOT)
# brew "dos2unix" # converts dos line endings to unix in a file
# tap "moncho/dry"
# brew "dry" # docker monitoring (does not work with docker-machine. works with docker for mac because needs access to docker.sock.)
# brew "dtrx" # do the right extraction - so you don't have to remember tar args (I found a helpful pneumonic to remember tar args: eXtract Ze Vucking Files, Compress Ze Vucking Files)
# brew "knes1/tap/elktail" # tail kibana logs (doesn't work with latest elk version)
brew "entr" # file watcher (I use this a lot in my shell functions)
# brew "fasd" # Command-line productivity booster, offers quick access to files and directories, inspired by autojump, z and v. (I use wd)
# brew "fd" # prettier alternative to find that respects gitignore (haven't used it yet)
# brew "fpp" # facebook path picker. Used with tmux-fpp to easily open files in an editor. (I don't use it)
brew "fx" # json funagler used by some of my shell functions
brew "fzf" # fuzzy file finder `git branch | fzf | xargs git checkout`
brew "github/gh/gh" # new github cli
brew "git"
# brew "git-extras" # adds some cool additional git commands (conflicts with npm git-standup)
# brew "git-flow" # adds first class git commands for the git-flow workflow (I use avh version below)
brew "git-flow-avh" # adds first class git commands for the git-flow workflow. This version will delete remote feature, release, and hotfix branches on finishing.
brew "git-standup" # show commits in the last day. works in parent dir too.
brew "gitlab-gem" # gitlab cli
# brew "global" # gnu global tags aka gtags. More powerful than ctags but has a different interface with a learning curve. Also depends on ctags which conflicts with universal-ctags.
brew "gnu-sed" # linux version of sed - saves as gsed (required for diff-so-fancy)
# brew "gnu-tar" # linux version of tar so stuff actually works
# brew "graphviz" # useful for xdebug profiler class maps
brew "grc" # generic colorizer - used to colorize ps, ls, netstat, etc.
# brew "go" # golang programming language. used for installing/managing mailhog and rtop and wuzz.
brew "gpg" # used by s3cmd and yadm to encrypt stuff
# brew "heroku-toolbelt" # heroku deploy tools (I don't use heroku atm)
# brew "hg" # mercurial (who still uses mercurial? no rebase)
# brew "highlight" # colorizes html and other output on the command line. used by ranger. (I don't use ranger these days)
brew "hostess" # manage hosts file `hostess help` TODO try https://github.com/feross/hostile - you can apply/unapply separate hosts file in normal hosts file format rather than json.
brew "htop" # prettier, more powerful version of top. gets the top running processes. (see my notes)
brew "httpie" # a cool alternative to curl (http --help) (NOTE: `man http` is something different :/ )
brew "hub" # , args: ["devel"] # github tool is a superset of git with extra commands.
# brew "icu4c" # needed for php70-intl extension (it seems this is included with node https://stackoverflow.com/questions/27896229/library-not-loaded-error-after-brew-install-php56) https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
# brew "ievms" # internet explorer VirtualBox VMs to test a site in various IE versions
brew "imagemagick" # image transformation tool - needed by php imagemagick extension (latest version needed to install host machine pecl imagick php extension)
# brew "imagemagick@6" # image transformation tool - v6 needed for catalog
# brew "interactive-rebase-tool" # awesome ncurses tool to spiff up interactive rebases (I use vim with a plugin instead)
# brew "intellij-idea-ce" # there's a community edition?? Just bookmarking this for later
# brew "irssi" # irc client (I use web app)
# brew "jenkins-zh/jcli/jcli" # jenkins cli - alternative to .jar version
# brew "jsawk" # parse json in bash
brew "joplin" # powerful note-taking app with cli version, multi-pane, search, etc.
brew "jsonlint" # used by vim ale to lint json
brew "jq" # simple json pretty-printer `echo '{"my" => "json"}' | jq .` (Used in some of my shell functions)
# brew "jrnl" # simple journaling wrapper (I use joplin)
# brew "keychain" # manage ssh agent and adding keys to it automatically. (I don't use this now that I have an ssh config directive to store passphrases for ssh agent in my osx keychain, which is different from this project's "keychain". Confusing, I know.)
# brew "kubernetes-cli" # already installed via brew cask install docker
brew "kubectx" # quick way to switch contexts with a fzf picker
brew "derailed/k9s/k9s" # handy kubernetes dashboard `k9s -n develop`
# brew "lastpass-cli" # TODO move all of my cli private_stuff over to lastpass
brew "less" # huh, there's a newer version of less available
# brew "lftp" # fancy scp, torrent, http, ftp download and upload client with queues, backgrounding, and more
brew "libcouchbase@2" # nosql fast data storage. I install this for the cli tool `cbc` and to build the php couchbase extension (note: requires brew link libcouchbase@2 --force)
brew "libedit" # needed for phpenv https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
brew "libiconv" # needed for phpenv https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
brew "libmemcached" # needed by php70 memcached pecl extension
brew "libmcrypt" # needed by php-build, which is used by phpenv DO NOT DELETE php will break
# brew "libpng" # needed for phpenv https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
# brew "libxml2" # needed by phpenv php70 https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
# brew "libzip" # needed for phpenv https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
brew "dbcli/tap/litecli" # like mycli for sqlite
# brew "lockrun" # simple way to lock cron jobs with a lock file and clear them when done
# brew "lsd" # pretty ls augmentation
# brew "lynx" # console web browser. used by ranger to preview html.
# brew "macvim" # mac gui vim client
brew "mas" # mac app store cli. e.g. `mas install Xcode`
# brew "andersjanmyr/homebrew-tap/mc" # memcached cli. Use the full path to avoid conflicting with midnight commander, or just uninstall midnight commander (Trouble using on saatchi due to networking limitations, also this tap is in a private github repo!! I have an installer in my yadm config instead)
# brew "mc" # old-school file manager, editor, viewer, script runner, remote filesystem access, etc.
brew "memcached" # needed by php70 memcached pecl extension
# brew "mkcert" # create a certificate, create a local CA, add the cert as trusted in the CA (Only needed to _create_ certs)
# brew "mono" # .NET compiler for mac. Useful for OmniSharp. (not needed)
brew "multitail" # tail multiple files or tail streams in splits with pretty colors. I use this a lot.
brew "mycli" # Mysql cli augmentation with completion, highlighting, etc.
brew "mysql" # I haven't been using the server lately but I use the cli tool to connect and I use mysql_config_editor. Unfortunately I can't just install the config editor separately :(
# brew "mysql-client" # If I ever need mysql client without mysql on local... downside: it doesn't link automatically - you have to brew link --force even if mysql isn't installed :/
# brew "m-cli" # mac cli tools e.g. restart, screensaver, bluetooth, etc.
# brew "nano" # text editor. This gets the latest version: 2.2.6 rather than 2.2.0 that comes with osx.
# brew "ncdu" # interactive du
brew "newsboat" # terminal rss reader. I'm debating on whether this is worth it. It's kind of handy to read the headlines in hackernews, reddit programming, etc.
# brew "neovim" # vim re-imagined (temporarily disabled so I can build from source to address the extremely annoying quickfix bug)
brew "nextdns/tap/nextdns" # dns privacy service
brew "node" # nodejs and npm (non-nodenv version required by joplin, yarn)
# brew "nodenv" # node version manager (same api as rbenv) (I use asdf now)
brew "noti" # simple terminal notifier
brew "nss" # required by mkcert to make certs trusted in firefox
brew "openssl" # needed for rbenv https://github.com/rbenv/ruby-build/issues/377#issuecomment-391427324 and phpenv https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
# brew "pandoc" # transform between document formats e.g. markdown <-> pdf (used for inline vim php documentation, which I no longer use)
# brew "pass" # unix password manager using gpg
# brew "peco" # interactively filter results and print the filtered version. can be used to print filtered one or e.g. `vim $(dosomething | peco)` (FZF does this)
# brew "perl" # for swat cpan package
# brew "perl-build" # needed for perlenv (which I don't use currently)
# brew "percona-toolkit" # mysql schema migrator among other things. requires java and perl.
brew "pgcli" # like mycli for postgres (used for toaf judging app)
# php has been moved to homebrew-php. In the process, php70 was removed >:( I've switched to phpenv and pecl instead. I don't even know how extensions work in the new homebrew php.
# brew "php@7.1", args: ["--with-pear"], link: true
brew "php-cs-fixer" # fix php code according to configuration
brew "pinentry" # gpg terminal pin entry (used by yadm encrypt/decrypt)
# brew "pinentry-mac" # native gpg pin entry for yadm and others. Opens a native window.
brew "pinfo" # man-like command to get manuals on tools written for info
brew "codekitchen/pipeline/pipeline" # cool subshell to let you interactively view unix pipeline results as you write
brew "pkg-config" # needed for phpenv to build https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
brew "plantuml" # uml generation from text. requires java (I use regularly for diagramming processes and sometimes uml class diagrams)
# brew "plenv" # perl version manager. better than perlbrew and consistent with my other env managers (rbenv, phpenv, nodenv, pyenv). used to get percona-toolkit working.
# brew "postgresql" # database similar to mysql (install if needed)
brew "pre-commit" # yelp git pre-commit framework (local hooks ftw! Easily create hooks that run various CI stuff before committing with pretty output, able to skip during rebases, yaml config.)
# brew "prettyping" # ping with a cool sparkline graph of status
brew "pspg" # , args: ["HEAD"] # "postgres pager" also useful for mysql, etc.
# brew "pv" # pipe something to pv to see progress of data through a pipeline. pv works like cat so `pv /path/to/myfile.sql > mysql ...`
# brew "pyenv" # python version manager (same api as rbenv)
# brew "python" # updated version of python with updated pip. Useful for installing pip packages without root. NOTE: homebrew "pip" breaks neovim. Needed for ntfy, see ~/.config/yadm/bootstrap
brew "qcachegrind" # like kcachegrind which is useful for profiling php apps with xdebug
# brew "ranger" # vim-like file system browser (cool but I don't use it)
# brew "rbenv" # ruby environment switcher (I use asdf now)
# brew "reattach-to-user-namespace" # used to fix mac issues with copy/paste in tmux (not needed after tmux 2.6! https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/issues/66)
brew "re2c" # needed by phpenv https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
# brew "readline" # needed for phpenv
# brew "redis" # key/value store (If I need this I'll use docker)
# brew "rlwrap" # wrap a command in readline to enable up for history, etc. Useful for python repl: `rlwrap python`
# brew "ruby" # (rbenv covers it for me)
# brew "ruby-build" # an rbenv plugin that provides an rbenv install command to compile and install different versions of ruby
# brew "rvm" # ruby version manager (I use rbenv instead)
# brew "s3cmd" # amazon s3 uploader (I use awscli instead)
# brew "scummvm" # never have I seen a more wretched hive of scum(m) and villainy
# brew "selenium-server-standalone" # controls a browser for automated testing
brew "shellcheck" # Checks shell syntax (used by vim ALE)
brew "shfmt" # formats shell scripts (used by vim ALE)
brew "shml" # $(fgcolor red)wow$(fgcolor end)
# brew "skaffold" # awesome local kubernetes cluster by google (TODO learn this! It looks freakin awesome)
brew "ssh-copy-id" # copies ssh keys to remote servers
brew "sshrc" # use ~/.sshrc and ~/.sshrc.d on remote servers. bring your dotfiles with you!
# brew "sshfs" # mounts ssh servers as file systems in the local fs. requires osxfuse.
# brew "https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb" # use an ssh password. trying this for leaf group LDAP access. (didn't work, don't need it for anything else at the moment)
# brew "solr" # search data server (I hate solr. If I were to install it for an app it would be through docker.)
# brew "source-highlight" # used to automatically colorize `less` text (I Just use `bat` instead. Got weird results with this.)
# brew "spark" # used for rainbarf to show spiffy cli graphs (I don't use rainbarf currently)
brew "sqlite3" # used as the default db for rails
# brew "sqlparse" # sql formatter (managed by pip in ~/requirements.txt)
# brew "stern" # kubernetes multitailer (waiting for this to be solved https://github.com/wercker/stern/issues/112)
# brew "stormssh" # interact with ssh config. I have yet to find a net positive use for this. It makes my ssh config less readable because it doesn't put them in comment fold groups like I do. just so I can `storm add ...`. `storm list` and `storm search` are kind of useless as I can do that with `ssh <tab>`. It lets you edit multiple ssh entries at once, but I can do that in vim. It provides a web interface, but I don't want that.
# brew "stone-soup" # roguelike called dungeon-crawl-stone-soup `crawl`
# brew "stow" # http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html (I use yadm instead)
# brew "stripe/stripe-cli/stripe" # test webooks with stripe, tail api events, etc.
# brew "swagger-codegen" # openapi codegen - depends on adoptopenjdk8.
# brew "task" # taskwarrior https://taskwarrior.org (I don't need this unless I don't have jira. Doesn't let you assign points! Has an opaque priority selection algorithm.)
# brew "teleconsole" # share your console with others easily (Extremely rare that I need something like this)
brew "telnet" # I don't have telnet? How am I going to watch star wars?
brew "terminal-notifier" # used by tmux plugin marzocchi/zsh-notify and my circleci pre-push hook (this is really just a gem so watch for it being installed by dependencies of other gems :/ ) This overlaps with noti but it provides full access to the desktop notification api unlike noti.
brew "the_silver_searcher" # awesome fast grep replacement: `ag --help`
# brew "tidy-html5" # needed by phpenv https://github.com/phpenv/phpenv/issues/90#issuecomment-550538864
brew "tig" # git? tig! (note: this requires asciidoc)
# brew "timewarrior" # taskwarrior-like interface for tracking time (I don't use this)
brew "tldr" # more consise community man pages
brew "tmux" # terminal multiplexer similar to screen.
# brew "tofrodos" # line ending conversion (install if needed)
# brew "trash" # a trash can for the terminal
brew "trash-cli" # a trash can for the terminal
brew "tree" # display file/folder hierarchies in a visual tree format
brew "universal-ctags/universal-ctags/universal-ctags", args: ["HEAD", " --with-jansson"] # tag creator for use by vim to navigate by symbols. head only.
brew "urlview" # used by <prefix>u tmux urlview plugin
# brew "virtualhost".sh # (crappy) virtualhost management script
brew "watch" # Executes a program periodically, showing output fullscreen (an npm package which is a child dependency of another sometimes replaces this binary: https://www.npmjs.com/package/watch . If so, just `brew link --overwrite watch` )
brew "watchman" # needed for `jest --watch` https://github.com/cm-pliser-tdd-by-example/tdd-by-example-js/issues/10
# brew "w3m" # full color image previewer for ranger (but doesnt work in tmux)
brew "wget" # latest version
# brew "wifi-password" # get your current wifi password quickly without mucking about with keychain access (install if needed)
# brew "xdebug-osx" # xdebug toggler for homebrew php (which I don't currently use)
# brew "xmlto" # convert xml to other formats because fuck xml
# brew "vim" # macvim requires xcode. This also allows you to get vim 8 without using a separate tap. (switched back to neovim)
# brew "vit" # ncurses taskwarrior interface - like tig for taskwarrior (This is cool but I don't really use taskwarrior anymore. Freeform daily task list with notes are more helpful to me.)
brew "yamllint" # used by vim-ale
brew "yarn" # wrapper for npm with real lock files and caching (installing via npm is deprecated)
brew "yadm" # yet another dotfiles manager
brew "yq" # jq is to json what yq is to yaml. yaml parser and searcher. I use it to read configs my circleci stuff, etc.
brew "zork" # seriously? yes. tip: `save` and `restore` And yes, there's only one save slot, what do you think this is, 1990?
# brew "zplug" # zsh plugin manager like composer. bash installer crashes for some reason. works fine via homebrew. (switched to antibody)
brew "zsh" # awesome bash shell replacement
# brew "zsh-completions" # tab completions (I install this via my zsh plugin manager instead)
# brew "zsh-lovers" # https://grml.org/zsh/zsh-lovers.html
# }}}

# cask {{{
cask "ableton-live-lite" # music production
# cask "adoptopenjdk" # needed to install akamai cli
# cask "adoptopenjdk8" # needed for swagger-codegen
cask "aerial" # cool apple tv style screensavers
# cask "bettertouchtool" # with a config file this lets me vimify any cocoa app https://raw.githubusercontent.com/Vincent-Carrier/CocoaVim/master/CocoaVim.bttpreset
# cask "bitbar" # use any cli command to show stuff in the menubar with colors and icons and provide menu options
# cask "beardedspice" # keyboard media controls for media sites. Always seems to be broken :/
cask "browserstacklocal" # local ie11, etc? If I have to. Otherwise, easy alternative is xdissent's ievms.
# cask "bubo" # menubar app that lets you use media and bluetooth keys with spotify web in chrome (but not in firefox, boo!)
# cask "burp-suite" # web vulnerability scanner (eclipse-based)
# cask "caffeine" # keep mac awake (replaced with amphetamine)
# cask "cheatsheet" # hold <cmd> for a bit to get a modal of available keyboard shortcuts (kind of annoying - rarely comes up when I actually want it to, too much info)
cask "cold-turkey-blocker" # blocks distracting website access so I can work
# cask "discord" # chat
cask "docker" # docker for mac desktop app
cask "dozer" # little menubar app that allows hiding menubar icon clutter
# cask "dropbox" # I especially use this for synching my notes so I can view them in the joplin mobile app (not using this feature right now)
# cask "emacs" # this actually makes sense as a cask. It becomes tmux, vim, and kitty all in one.
# cask "epic-games" # game store
# cask "ferdi" # all messaging in one electron app (slack, discord, google voice, android messages, etc.) another approach to this is matrix (riot.im) with "bridges" to other services
cask "firefox" # I use firefox for my home profile
cask "firefox-developer-edition" # I use dev edition for my work profile
# cask "font-fira-code"
# cask "font-iosevka"
cask "font-iosevka-nerd-font-mono" # note: homebrew doesn't need a tap for these any more
# cask "font-meslo-for-powerline" # whoa there are a ton of fonts on brew "cask"!
cask "microsoft/git/git-credential-manager-core" # new github credentials manager https://github.blog/2020-07-02-git-credential-manager-core-building-a-universal-authentication-experience/
cask "glance" # all-in-one quicklook app that works with dark mode
cask "grandperspective" # visualize storage hogs in the hard drive
# cask "gog-galaxy" # good old games
# cask "google-chrome"
# cask "google-drive" (menubar app for google drive access)
cask "haptickey" # give haptic feedback on touchpad when pressing the touchbar
# cask "helium" # android backup without root (doesn't seem to work, but the chrome app does)
# cask "http-toolkit" # kind of like charles or wireshark, but with support for docker. (docker support seems to be coming soon)
# cask "insomnia" # http api client like postman but nicer looking (I use this for sharing with my team but I mostly use vim-rest-console)
cask "insomnia-designer" # like insomnia but includes openapi features
cask "iterm2" # I was using kitty but they use opengl and macos deprecated opengl support, so it crashes regularly. iTerm now has gpu rendering, so I'm back to iTerm! It has a bunch of other cool new stuff now anyway. (There's also iterm2-nightly and iterm2-beta, which I've found to be unstable.)
cask "java" # required for plantuml, etc.
# cask "joplin" # desktop joplin (I use the terminal interface)
cask "jumpcut" # clipboard manager recommended by Michael Zick (slightly annoying interface but I haven't found any better on brew) ctrl-cmd-p (forward) or ctrl-cmd-shift-p (backward)
cask "keeper-password-manager" # password manager used at my work
# cask "kitematic" # mac native docker container browser (I just use docker cli tools)
# cask "kitty" # fast terminal emulator (see iterm2 above for why I switched back to iTerm)
# cask "launchcontrol" # launchctl gui. (I use lunchy gem instead)
# cask "licecap" # shitty, simple gif screen capture. OSX used to have this but I think they got rid of the gif exporting :/
# cask "lunchy" # launchctl cli wrapper. Port of lunchy gem. (Tried this, was missing options, back to gem)
# cask "macfusion" # other half of tool to mount ssh directories in the finder
# cask "macgdbp" # xdebug gui client (I use vdebug)
cask "malwarebytes" # ya neva know
# cask "menubar-stats" # used to show bluetooth headphones battery level in menubar (Doesn't work with my headphones for some reason... and it's $5)
# cask "microsoft-edge"
cask "minikube" # for learning `minikube start`
cask "mpv" # video player like vlc
# cask "mudlet" # muds are rad
cask "multifirefox" # profile picker until firefox fixes this glaring omission
# cask "multipass" # "ubuntu LTS on tap" launch instances of ubuntu and itialize them with cloud-init metadata in a matter of seconds. Uses hypervisor or virtualbox behind the scenes.
cask "muzzle" # stop notifications while screensharing
# cask "noti" # mac native pushbullet notifications (I use the chrome/firefox extension)
# cask "ngrok" # securely expose your local site to the internet and inspect and repeat traffic
# cask "nvidia-geforce-now"
# cask "onecast" # cast xbox one to mac.
# cask "osxfuse" # half of tool to mount ssh directories in the finder (useful if working on a shared dev environment)
# cask "openemu" # multi game system emulator
# cask "origin" # ea games store
# cask "pdftotext" # used by ranger to preview pdfs (I don't use ranger these days)
# cask "playonmac" # run windows apps on mac for free via wine
cask "https://raw.githubusercontent.com/popcorn-official/popcorn-desktop/development/casks/popcorn-time.rb" # popcorn time!
# cask "postico" # postgresql gui. Useful for some time saver capabilities like copy/paste rows, etc. (paid app, ugh)
# cask "postman" # http api client (I use insomnia to share, but vim-rest-console in the terminal)
# https://github.com/sindresorhus/quick-look-plugins
# cask "qlcolorcode" # quicklook plugin to provide syntax highlighting to code files (fails to install)
cask "qlstephen" # quicklook plugin (preview plain text files without or with unknown file extension e.g. README, CHANGELOG)
cask "qlmarkdown" # quicklook plugin (preview markdown)
cask "quicklook-json" # quicklook plugin (preview json)
# cask "qlprettypatch" # quicklook plugin (preview patch files)
cask "quicklook-csv" # quicklook plugin (preview csvs)
cask "qlimagesize" # quicklook plugin (display image size and resolution in the title in preview)
# cask "scummvm" # old school
# cask "sequel-pro" # mysql gui client. I mostly use mycli.
cask "sequel-pro-nightly" # nightly has bug fixes and dark mode! B)
# cask "shadow" # cloud gaming system https://shadow.tech
cask "skype" # Dad uses skype. Skype web requires chrome. I don't like chrome.
cask "slack" # needed for screen sharing features. I mostly use the web app.
cask "spectacle" # keyboard window splitter/resizer/mover. Kind of like a lightweight i3 window manager. I use it a lot.
# cask "spotify" # mac native spotify player (I use the web app, but sometimes it gets stuck in an offline state or randomly stops playing)
# cask "stoplight-studio" # openapi ide. This is cool but you can also just use the web version at https://stoplight.io/p/studio but the desktop app works with local files _and_ automatically mocks local apis with prism - their built-in api mocker (this is really only useful as a fancy local openapi spec editor since even their ci docs generator just hits their api)
# cask "synthesia" # piano learning software
# cask "ssh-tunnel-manager" # mac native gui to manage running ssh tunnels (I just put tunnels in launchctl with autossh and forget about them)
# cask "steam" # yep
# cask "suspicious-package" # quicklook plugin for mac dmg package inspection (I don't care about inspecting these)
# cask "transmission" # unleash a torrent of files ;)
cask "unshaky" # fix double keypress on macbook butterfly keyboard
cask "vagrant" # development VM maker/manager (I use docker now, but this is helpful for a linux training course I'm taking)
cask "pvinis/pvinis/vimac" # control mac with vimium-style vi controls
#
# TODO these can't just be upgraded while virtualbox is running :/
cask "virtualbox" # virtual machine software (needed by docker-machine at least)
# cask "virtualbox-extension-pack" # add-on to do stuff you'll always want... except for docker-machine
#
# cask "vivaldi" # chrome alternative with some cool features (I switched back to chrome for now - profiles are kind of buggy atm)
# cask "vlc" # watch the videos I download (switchtd to mpv)
# cask "webpquicklook" # quicklook plugin (preview webp images)
# cask wine-stable # run windows apps on mac
# cask wine-staging # run windows apps on mac (with bugfixes not in the stable package yet)
# cask "wineskin-winery" # run windows apps in macos via wine (doesn't work in macOS catalina)
# cask "wireshark" # analyze network data (but not on virtualbox networks)
# cask "wormhole" # interact with your phone screen from your computer
# cask "xquartz" # needed to install xclip, which is needed to copy text from multitail (I installed all of that, copy still didn't work :/ ) also needed for wine-stable
# cask "xscreensaver" # shitload of old screensavers... downside is there are so many it slows down selecting Desktop & Screen Saver the first time in System Preferences :/ Upside: it has GLMatrix :)
# cask "zappy" # screenshot and video recorder (buggy solid black screenshots and pins, also privacy concerns)
# cask "zdoom" # doom, hexen, heretic, etc.
# cask "zoomus" # zoom video conferencing (installed and managed via my company)
# }}}

# mac app store {{{
# Do I really need these?
mas "Downlink", id: 1454269192 # cool live (20 min refresh) earth view on my desktop (tries to reinstall every time :/ )
mas "Xcode", id: 497799835 # needed for some tools (TODO which tools?)
mas "Amphetamine", id: 937984704 # replacement for discontinued "caffeine" menubar app
# mas "Keeper", id: 414781829 # used by leaf group, like lastpass (There's a brew cask version)
mas "GIPHY CAPTURE", id: 668208984 # capture screen to gif (alternative to licecap, etc.)
mas "Jira", id: 1475897096 # official jira cloud desktop app
# }}}
