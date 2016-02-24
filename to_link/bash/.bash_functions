#!/usr/env/bin bash

# Modeline and Notes {{{
# vim: set sw=4 ts=4 sts=4 et tw=78 foldmethod=marker filetype=sh:
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
if [[  $0 == "bash" ]]; then
  complete -F _vagrant vagrant
fi

profile () {
  # about 'source either bashrc or zshrc'
  # group 'custom'
  if [ $SHELL = "/usr/local/bin/zsh" ]; then
    source ~/.zshrc && echo 'zsh profile reloaded'
  elif [ $SHELL = "/usr/local/bin/bash" ]; then
    source ~/.bash_profile && echo 'bash profile reloaded'
  else
    echo "Shell config not found for $SHELL"
  fi
}

command_exists () {
  # about 'check if a command exists in any shell'
    type "$1" &> /dev/null;
}

phpunitnotify () {
    # about 'runs phpunit and uses terminal-notifier to show the results'
    # group 'custom'

    if [ -f ./vendor/bin/phpunit ]; then
      PHPUNIT="./vendor/bin/phpunit"
    else
      PHPUNIT="$HOME/.composer.vendor/bin/phpunit"
    fi
    php -d memory_limit=2048M $PHPUNIT --colors "${@}"
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

    # XDEBUGPATH="/usr/local/php5/php.d/50-extension-xdebug.ini"
    XDEBUGPATH="/usr/local/etc/php/5.6/conf.d/ext-xdebug.ini"
    # XDEBUGPATH="/usr/local/etc/php/7.0/conf.d/ext-xdebug.ini"
    XDEBUGDIS="${XDEBUGPATH}.disabled"
    if [[ -f $XDEBUGPATH ]]; then
        echo "Disabling Xdebug"
        sudo mv $XDEBUGPATH $XDEBUGDIS
        sudo apachectl restart
        # launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.php70.plist
        # launchctl load ~/Library/LaunchAgents/homebrew.mxcl.php70.plist
        launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.php56.plist
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.php56.plist
    elif [[ -f $XDEBUGDIS ]]; then
        echo "Enabling Xdebug"
        sudo mv $XDEBUGDIS $XDEBUGPATH
        sudo apachectl restart
        # launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.php70.plist
        # launchctl load ~/Library/LaunchAgents/homebrew.mxcl.php70.plist
        launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.php56.plist
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.php56.plist
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
    # sudo pear upgrade
    sudo gem update
    sudo npm update -g
    sudo pip3 install --upgrade pip setuptools
    brew update
    brew upgrade
    brew reinstall --HEAD neovim
    composer global update
    composer self-update
    php-cs-fixer self-update
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

# create a gitlab merge request from the current branch into develop via
# the curl api
mergerequest() {

    # gitlab api: https://github.com/gitlabhq/gitlabhq/tree/master/doc/api
    # this works to test the api
    # URL="projects/1155"
    # curl --header "PRIVATE-TOKEN: $GITLAB_API_PRIVATE_TOKEN" $GITLAB_API_ENDPOINT$URL
    # return

    # first push the branch to remote so we have something to request merging
    git push

    # set the project based on the current dir
    if pwd | grep -q 'trails-website'; then
        PROJECT="trails-website"
        PROJECT_ID="192"
    elif pwd | grep -q 'airliners-website'; then
        PROJECT="airliners-website"
        PROJECT_ID="201"
    elif pwd | grep -q 'airliners-new'; then
        PROJECT="airliners"
        PROJECT_ID="1155"
    elif pwd | grep -q 'www.airliners.net'; then
        PROJECT="airliners"
        PROJECT_ID="1155"
    elif pwd | grep -q 'airliners_app'; then
        PROJECT="airliners"
        PROJECT_ID="1155"
    elif pwd | grep -q 'airliners-new'; then
        PROJECT="airliners"
        PROJECT_ID="1155"
    elif pwd | grep -q 'answerbag-website'; then
        PROJECT="answerbag-website"
        PROJECT_ID="193"
    elif pwd | grep -q 'synonym-website'; then
        PROJECT="synonym-website"
        PROJECT_ID="185"
    elif pwd | grep -q 'arcadetown-website'; then
        PROJECT="arcadetown-website"
        PROJECT_ID="204"
    elif pwd | grep -q 'gardenguides-website'; then
        PROJECT="gardenguides-website"
        PROJECT_ID="188"
    elif pwd | grep -q 'dailypuppy-website'; then
        PROJECT="dailypuppy-website"
        PROJECT_ID="206"
    else
        echo "Error: project id not found! Maybe it's not in gitlab?"
        return
    fi

    # set the assignee id based on the name
    USERNAME=$2
    if [[ $USERNAME == 'larry' ]]; then
        USER_ID=52
    elif [[ $USERNAME == 'matt' ]]; then
        USER_ID=168
    elif [[ $USERNAME == 'michael' ]]; then
        USER_ID=103
    else
        # matt is default
        USER_ID="168"
        USERNAME="matt"
    fi

    # set the message and the current branch
    MESSAGE=$1
    CURRENT_BRANCH="$(git symbolic-ref --short HEAD)"

    # call the command
    # there is no error checking here so if things fail it won't figure it out.
    # for instance if you already have an open merge request for this branch
    # it will 404.
    URL="projects/$PROJECT_ID/merge_requests"
    CURL_RESPONSE=$(curl --silent --header "PRIVATE-TOKEN: $GITLAB_API_PRIVATE_TOKEN" $GITLAB_API_ENDPOINT$URL --data "id=$PROJECT_ID&source_branch=$CURRENT_BRANCH&target_branch=develop&title=$MESSAGE&assignee_id=$USER_ID")
    # parse the json, get the "iid" key which is the merge request id
    MERGE_REQUEST_ID=$(echo $CURL_RESPONSE | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["iid"]')
    echo "merge request created here:"
    echo "$GITLAB_MERGE_REQUEST_URL/$PROJECT/merge_requests/$MERGE_REQUEST_ID"
}

# this will help set up the mergerequest function above
gitlabtest() {

    # get members of dvn group to get their user ids
    # URL="groups/31/members?per_page=100"

    # search for projects by name to get the id
    URL="projects/search/dailypuppy-website?per_page=100"

    # this works to test the api
    curl --header "PRIVATE-TOKEN: $GITLAB_API_PRIVATE_TOKEN" $GITLAB_API_ENDPOINT$URL
}

##
# Get a document from couchbase in raw json without worrying about the 2.5k size
# limitation in the web ui
##
function couchtest() {
    read -e -p "Enter environment [local|dev|qa|production]: " -i "production" REMOVE_ENV
    read -e -p "Enter bucket name [art|catalog|user]: " -i "art" BUCKET
    read -p "Enter document id:" DOCID
    APPLICATION_ENV=$REMOTE_ENV php ~/sites/saatchi/saatchiart/scripts/mike/couchtest.php $REMOTE_ENV -v -b=$BUCKET -d=$DOCID
    # same thing but pretty-print json, which it turns out looks exactly the same :/
    # php /data/code_base/current/scripts/mike/couchtest.php production -v -b=$BUCKET -d=$DOCID | sed '1d; $d; s/^ *//' | sed '1d; $d; s/^ *//' | python -m json.tool
}

##
 # resilient ssh with ssh and screen
 ##
function asc() {
    # Set the title to something more obvious, e.g. the expanded
    # alias, eh, function
    print -Pn "\e]0;%n@%m: autossh -t $* 'screen -RdU'\a";
    autossh -x -a -t "$@" 'screen -RdU'
}
