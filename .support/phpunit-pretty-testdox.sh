#!/bin/bash
# From the phpunit testdox output, print passing lines in green, failing in red
#vim:set foldmethod=marker:

# unofficial bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/ {{{
set -euo pipefail
# IFS=$'\n\t' # messes up colors
# }}}

# colors {{{
BLACK="$(tput setaf 0)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
PINK="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
NORMAL="$(tput sgr0)"
# }}}

while read -r LINE; do
    echo -E $LINE | \
        sed -E -e "s/^\[x\].*/ ${GREEN}&${NORMAL}/" | \
        sed -E -e "s/^\[ \].*/ ${RED}&${NORMAL}/"
done
