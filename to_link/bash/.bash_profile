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
# bash aliases
# more info at http://mikefunk.com
# }}}

[ -f ~/.private_vars.sh ] && source ~/.private_vars.sh
[ -f ~/.bash_env ] && source ~/.bash_env
[ -f ~/.bash_paths ] && source ~/.bash_paths
[ -f ~/.bash_init ] && source ~/.bash_init
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bash_functions ] && source ~/.bash_functions
# it seems most bash completions do not play nice with zsh
[ -f ~/.bash_completions ] && [[ $SHELL == 'bash' ]] && source ~/.bash_completions
[ -f ~/.zsh_friendly_completions ] && source ~/.zsh_friendly_completions
