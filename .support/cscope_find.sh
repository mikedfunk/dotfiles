#!/bin/bash
ag --skip-vcs-ignores --files-with-matches -g ".*.php$" `cat ~/.ctags | grep --regexp "^--exclude" | sed s/--exclude/--ignore/`
