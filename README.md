# dotfiles

## TL;DR
```
# Ensure git is installed with `which git`.
curl -fLo /usr/local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm && chmod a+x /usr/local/bin/yadm
/usr/local/bin/yadm clone git@github.com:mikedfunk/dotfiles.git --bootstrap
```

My Bash, Vim, Git, and other dotfiles. Managed by [yadm](https://thelocehiliosan.github.io/yadm/docs).

![screenshot](https://i.imgur.com/p0TTKI5.jpg)

## Key files

* [Homebrew packages I use](.Brewfile)
* [Yadm bootstrap file](.yadm/bootstrap) (script to install/upgrade everything)
* [Vimrc](.vimrc)
* [Zshrc](.zshrc)
* [Gitconfig](.gitconfig)
* [Tmux config](.tmux.conf)
