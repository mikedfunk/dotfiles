# dotfiles

## TL;DR

```
curl https://raw.githubusercontent.com/mikedfunk/dotfiles/master/install.sh | sh
```

My Bash, Vim, Git, and other dotfiles. Managed by [yadm](https://thelocehiliosan.github.io/yadm/docs).

![screenshot](https://user-images.githubusercontent.com/661038/71217556-0cd39e00-2273-11ea-9be5-009dd6c874ce.png)

## Key files

Tools I use, annotated:

* [Homebrew packages, casks, and mac store apps I use](.Brewfile)
* [Node packages (yarn)](.config/yarn/global/package.json)
* [Python packages (pip3)](requirements.txt)
* [Ruby packages (bundler)](Gemfile)
* [PHP packages (composer)](.composer/composer.json)

Script to install/upgrade everything:

* [Yadm bootstrap file](.config/yadm/bootstrap)

Key config files, annotated:

* [Vimrc](.vimrc)
* [Vim plugins](.vim/.vimrc.plugins.vim)
* [Vim plugin config](.vim/.vimrc.pluginconfig.vim)
* [Zshrc and zsh plugins](.zshrc)
* [P10k prompt config](.p10k.zsh)
* [Git config](.gitconfig)
* [Tig config](.tigrc)
* [Tmux config and tmux plugins](.tmux.conf)
* [Work tmuxp layout](.tmuxp/work.yml)
* [Home tmuxp layout](.tmuxp/home.yml)
