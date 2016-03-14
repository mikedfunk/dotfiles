# dotfiles

# TL;DR
```
git clone https://github.com/mikedfunk/dotfiles.git ~/.dotfiles --recursive && ~/.dotfiles/install.sh
```

My Bash, Vim, Git, and other dotfiles. *Now with 24-bit color support in [neovim](http://neovim.io/)!* I've commented all config files and install scripts indicating *why* I'm doing what I'm doing. Check the install directory to see what each install task does.

![Screenshot](https://raw.githubusercontent.com/mikedfunk/dotfiles/master/support/screenshot.png)

# Directions

1. If on mac, install [XCode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12) and ensure you run it at least once. You need the full XCode, not just the command line tools for [MacVim](https://github.com/b4winckler/macvim) and [Terminal Notifier](https://github.com/alloy/terminal-notifier).
2. Ensure git is installed with `which git`. On Mac just do `git status` somewhere and it will offer to install the XCode Command Line Tools.
3. *Install dotfiles*: `git clone https://github.com/mikedfunk/dotfiles.git ~/.dotfiles --recursive && ~/.dotfiles/install.sh`
 1. Or pick an install script in the `install` directory and run them one at a time.
4. If you are using iTerm
 1. install [powerline fonts](https://github.com/Lokaltog/powerline-fonts) from the [support directory](https://github.com/mikedfunk/dotfiles/tree/master/support).
 2. Go to iTerm preferences -> Profiles -> Default -> Text -> set *Regular Font* and *Non-ASCII Font* to `12 pt Meslo LG M DZ Regular for Powerline` [located here](https://github.com/powerline/fonts/tree/master/Meslo).
 3. Go to iTerm preferences -> Appearance -> Window -> check `Hide Scrollbar and Resize Control`.
 4. Install some [iterm2 color schemes](https://github.com/mbadolato/iTerm2-Color-Schemes) from the [support directory](https://github.com/mikedfunk/dotfiles/tree/master/support).
 5. Load one from Preferences -> Profiles -> Default -> Colors -> Load Presets...
5. To get Vim plugins installed, run `vim` from the command line, then type `:PlugInstall`.
6. To install tmux plugins: when inside tmux, hit `ctrl-A` then `shift-I`
7. Want to alias vim to neovim? It's in `to_link/bash/.bash_aliases`. Change `WHICH_VIM` to either *macvim*, *neovim*, or *vim*.


# Other stuff to install:

* [Dropbox](https://www.dropbox.com/downloading?src=index)
* [iTerm 2](https://iterm2.com/downloads.html) or [nightly version](http://iterm2.com/downloads/nightly/#/section/home)
* [Google Chrome](https://www.google.com/intl/en/chrome/browser/#brand=CHMB&utm_campaign=en&utm_source=en-ha-na-us-sk&utm_medium=ha)
* [GBookmarks](https://github.com/mikedfunk/gbookmarks-userscript) userscript
* [Firefox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/)
* [Google Drive](https://tools.google.com/dlpage/drive)
* [IE VMs](https://github.com/xdissent/ievms)
* [OSXFuse](https://osxfuse.github.io/) and then [MacFusion](http://downloads.patjack.co.uk/dl/Macfusion.zip) to mount ssh directories in the Finder (if necessary).
 * _NOTE: Be sure to check the *MacFuse compatibility layer* in the OSXFuse installer._
 * _NOTE: [this is a MacFuse fork](http://patjack.co.uk/macfusion-64-bit-ready-for-lion-mountain-lion/) for compatibility._
* [Latest Python for mac](https://www.python.org/downloads/mac-osx/) if your urllib3 complains about insecure platform for the [wakatime](https://wakatime.com/) service
* [Spectacle](http://spectacleapp.com/)
* [TinyGrab](http://tinygrab.com/download.php)
* [VirtualBox](http://virtualbox.org)
* [Vagrant](http://www.vagrantup.com/downloads)
* [Vagrant vbguest plugin](https://github.com/dotless-de/vagrant-vbguest)
* [Sequel Pro](http://www.sequelpro.com/) for Mac or [MySQL Workbench](http://dev.mysql.com/downloads/tools/workbench/) for Windows/Linux
* [NetExtender](https://sslvpn.demo.sonicwall.com/cgi-bin/portal) or [SonicWall Mobile Connect](https://itunes.apple.com/us/app/sonicwall-mobile-connect/id466931806/?mt=8) for vpn access
* [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12) or [XCode Command Line Tools](https://developer.apple.com/downloads/index.action) for Mac
* [Mac Bluetooth Headset Fix](https://github.com/jguice/mac-bt-headset-fix) fixes issue with bluetooth headphone pause/play button always opening iTunes on Mac OSX.
* [Function Flip](http://kevingessner.com/software/functionflip/) To selectively toggle function keys to not have to use the _fn_ key.
* Selenium server standalone from homebrew does not work too well with the default java version. I had to install [JDK 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) to get it to work.
