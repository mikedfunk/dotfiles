#!/bin/bash
# ag --skip-vcs-ignores --files-with-matches -g ".*.php$" `cat ~/.ctags.d/config.ctags | grep --regexp "^--exclude" | sed s/--exclude/--ignore/`
# This is so I can ignore _ide_helper.php in searches but include it in ctags and cscope db.
ag --unrestricted --files-with-matches -g ".*.php$" `cat ~/.ctags.d/config.ctags | grep --regexp "^--exclude" | sed s/--exclude/--ignore/`
