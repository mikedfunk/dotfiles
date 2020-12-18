# dotfiles

## TL;DR

```
curl https://raw.githubusercontent.com/mikedfunk/dotfiles/master/install.sh | sh
```

My Bash, Neovim, Git, and other dotfiles. Managed by [yadm](https://thelocehiliosan.github.io/yadm/docs).

<img width="1792" alt="Screen Shot 2020-12-17 at 12 32 28 PM" src="https://user-images.githubusercontent.com/661038/102560587-68538a00-4087-11eb-88c5-fc13fbb36bd7.png">

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

* [Neovim init.lua](.config/nvim/init.lua)
* [Zshrc and zsh plugins](.zshrc)
* [P10k prompt config](.p10k.zsh)
* [Git config](.gitconfig)
* [Tig config](.tigrc)
* [Tmux config and tmux plugins](.tmux.conf)
* [Work tmuxp layout](.tmuxp/work.yml)
* [Home tmuxp layout](.tmuxp/home.yml)
