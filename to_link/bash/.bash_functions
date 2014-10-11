#!/usr/env/bin bash

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
# bash functions
# more info at http://mikefunk.com
# }}}

function ips ()
{
    # about 'display all ip addresses for this host'
    # group 'base'
    ifconfig | grep "inet " | awk '{ print $2 }'
}

function myip ()
{
    # about 'displays your ip address, as seen by the Internet'
    # group 'base'
    res=$(curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+')
    echo -e "Your public IP is: ${echo_bold_green} $res ${echo_normal}"
}

function mkcd ()
{
    # about 'make a directory and cd into it'
    # param 'path to create'
    # example '$ mkcd foo'
    # example '$ mkcd /tmp/img/photos/large'
    # group 'base'
    mkdir -p "$*"
    cd "$*"
}

# useful for administrators and configs
function buf ()
{
    # about 'back up file with timestamp'
    # param 'filename'
    # group 'base'
    local filename=$1
    local filetime=$(date +%Y%m%d_%H%M%S)
    cp ${filename} ${filename}_${filetime}
}

# try to extract with anything ya got!
extract () {
  if [ $# -ne 1 ]
  then
    echo "Error: No file specified."
    return 1
  fi
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xvjf $1   ;;
            *.tar.gz)  tar xvzf $1   ;;
            *.bz2)     bunzip2 $1    ;;
            *.rar)     unrar x $1    ;;
            *.gz)      gunzip $1     ;;
            *.tar)     tar xvf $1    ;;
            *.tbz2)    tar xvjf $1   ;;
            *.tgz)     tar xvzf $1   ;;
            *.zip)     unzip $1      ;;
            *.Z)       uncompress $1 ;;
            *.7z)      7z x $1       ;;
            *)         echo "'$1' cannot be extracted via extract" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function git_pub() {
  # about 'publishes current branch to remote origin'
  # group 'git'
  BRANCH=$(git rev-parse --abbrev-ref HEAD)

  echo "Publishing ${BRANCH} to remote origin"
  git push -u origin $BRANCH
}

function git_revert() {
  # about 'applies changes to HEAD that revert all changes after this commit'
  # group 'git'

  git reset $1
  git reset --soft HEAD@{1}
  git commit -m "Revert to ${1}"
  git reset --hard
}

function git_rollback() {
  # about 'resets the current HEAD to this commit'
  # group 'git'

  function is_clean() {
    if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]; then
      echo "Your branch is dirty, please commit your changes"
      kill -INT $$
    fi
  }

  function commit_exists() {
    git rev-list --quiet $1
    status=$?
    if [ $status -ne 0 ]; then
      echo "Commit ${1} does not exist"
      kill -INT $$
    fi
  }

  function keep_changes() {
    while true
    do
      read -p "Do you want to keep all changes from rolled back revisions in your working tree? [Y/N]" RESP
      case $RESP
      in
      [yY])
        echo "Rolling back to commit ${1} with unstaged changes"
        git reset $1
        break
        ;;
      [nN])
        echo "Rolling back to commit ${1} with a clean working tree"
        git reset --hard $1
        break
        ;;
      *)
        echo "Please enter Y or N"
      esac
    done
  }

  if [ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]; then
    is_clean
    commit_exists $1

    while true
    do
      read -p "WARNING: This will change your history and move the current HEAD back to commit ${1}, continue? [Y/N]" RESP
      case $RESP
        in
        [yY])
          keep_changes $1
          break
          ;;
        [nN])
          break
          ;;
        *)
          echo "Please enter Y or N"
      esac
    done
  else
    echo "you're currently not in a git repository"
  fi
}

# Adds files to git's exclude file (same as .gitignore)
function local-ignore() {
  # about 'adds file or path to git exclude file'
  # param '1: file or path fragment to ignore'
  # group 'git'
  echo "$1" >> .git/info/exclude
}

function git_stats {
    # about 'display stats per author'
    # group 'git'

# awesome work from https://github.com/esc/git-stats
# including some modifications

if [ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]; then
    echo "Number of commits per author:"
    git --no-pager shortlog -sn --all
    AUTHORS=$( git shortlog -sn --all | cut -f2 | cut -f1 -d' ')
    LOGOPTS=""
    if [ "$1" == '-w' ]; then
        LOGOPTS="$LOGOPTS -w"
        shift
    fi
    if [ "$1" == '-M' ]; then
        LOGOPTS="$LOGOPTS -M"
        shift
    fi
    if [ "$1" == '-C' ]; then
        LOGOPTS="$LOGOPTS -C --find-copies-harder"
        shift
    fi
    for a in $AUTHORS
    do
        echo '-------------------'
        echo "Statistics for: $a"
        echo -n "Number of files changed: "
        git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f3 | sort -iu | wc -l
        echo -n "Number of lines added: "
        git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f1 | awk '{s+=$1} END {print s}'
        echo -n "Number of lines deleted: "
        git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f2 | awk '{s+=$1} END {print s}'
        echo -n "Number of merges: "
        git log $LOGOPTS --all --merges --author=$a | grep -c '^commit'
    done
else
    echo "you're currently not in a git repository"
fi
}

function add_ssh() {
  # about 'add entry to ssh config'
  # param '1: host'
  # param '2: hostname'
  # param '3: user'
  # group 'ssh'

  echo -en "\n\nHost $1\n  HostName $2\n  User $3\n  ServerAliveInterval 30\n  ServerAliveCountMax 120" >> ~/.ssh/config
}

function sshlist() {
  # about 'list hosts defined in ssh config'
  # group 'ssh'

  awk '$1 ~ /Host$/ { print $2 }' ~/.ssh/config
}

# about-plugin 'set up vagrant autocompletion'
_vagrant()
{
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    commands="box destroy halt help init package provision reload resume ssh ssh_config status suspend up version"

    if [ $COMP_CWORD == 1 ]
    then
      COMPREPLY=($(compgen -W "${commands}" -- ${cur}))
      return 0
    fi

    if [ $COMP_CWORD == 2 ]
    then
        case "$prev" in
            "box")
              box_commands="add help list remove repackage"
              COMPREPLY=($(compgen -W "${box_commands}" -- ${cur}))
              return 0
            ;;
            "help")
              COMPREPLY=($(compgen -W "${commands}" -- ${cur}))
              return 0
            ;;
            *)
            ;;
        esac
    fi

    if [ $COMP_CWORD == 3 ]
    then
      action="${COMP_WORDS[COMP_CWORD-2]}"
      if [ $action == 'box' ]
      then
        case "$prev" in
            "remove"|"repackage")
              local box_list=$(find $HOME/.vagrant/boxes/* -maxdepth 0 -type d -printf '%f ')
              COMPREPLY=($(compgen -W "${box_list}" -- ${cur}))
              return 0
              ;;
            *)
            ;;
        esac
      fi
    fi

}
complete -F _vagrant vagrant

phpunitnotify () {
    # about 'runs phpunit and uses terminal-notifier to show the results'
    # group 'custom'

    phpunit "${@}"
    if [[ $? == 0 ]]; then
        terminal-notifier -message "PHPUnit tests passed" -title "Passed" -activate "com.apple.Terminal";
    else
        terminal-notifier -message "PHPUnit tests failed" -title "Failed" -activate "com.apple.Terminal";
    fi
}

dbreset() {
    # about 'drops and creates a specific database'
    # group 'custom'

    # drop database, create database
    echo "${GREEN}drop database${RESET}"
    mysql -uroot -e 'DROP DATABASE IF EXISTS einstein2;'

    echo "${GREEN}create database${RESET}"
    mysql -uroot -e 'CREATE DATABASE IF NOT EXISTS einstein2;'

    # migrate database, seed database
    php artisan migrate
    php artisan db:seed
}

cd() {
    # about 'ls after every cd'
    # group 'custom'

    builtin cd "$@" && ls;
}

togglexdebug() {
    # about 'toggle local xdebug on or off'
    # group 'custom'

    XDEBUGPATH="/usr/local/php5/php.d/50-extension-xdebug.ini"
    XDEBUGDIS="${XDEBUGPATH}.disabled"
    if [[ -f $XDEBUGPATH ]]; then
        echo "Disabling Xdebug"
        sudo mv $XDEBUGPATH $XDEBUGDIS
        sudo apachectl restart
    elif [[ -f $XDEBUGDIS ]]; then
        echo "Enabling Xdebug"
        sudo mv $XDEBUGDIS $XDEBUGPATH
        sudo apachectl restart
    else
        echo "Xdebug ini file not found!"
    fi
}

isxdebugon() {
    # about 'tell me whether xdebug is enabled'
    # group 'custom'

    if [[ "$(php -i | grep xdebug)" ]]; then
        echo 'xdebug is ON'
    else
        echo 'xdebug is OFF'
    fi
}

upgrades() {
    # about 'upgrade everything'
    # group 'custom'

    echo "Upgrading everything!"
    sudo pear upgrade
    sudo gem update
    sudo npm update -g
    brew update
    brew upgrade
    composer global update
    composer self-update
    php-cs-fixer self-update
    cd ~/.bash_it
    git pull
    cd ~/.spf13-vim-3
    git pull
    cd ~
    echo "Upgrading complete!"
}

whitespace() {
    # about 'strip all trailing whitespace in files in the current dir'
    # group 'custom'

    echo "Stripping ALL trailing whitespace in the current dir"
    read -p "Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        # exit 1
        echo "cancelled"
        return
    fi
    echo "proceeding..."
    export LANG=C; find . -not \( -name .svn -prune -o -name .git -prune \) -type f -print0 | xargs -0 sed -i '' -E "s/[[:space:]]\+$//"
}
