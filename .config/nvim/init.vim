set runtimepath^=~/.vim runtimepath+=~/.vim/after runtimepath+=.
let &packpath=&runtimepath
source ~/.vimrc
" source local vimrc if it exists
runtime .vimrc
