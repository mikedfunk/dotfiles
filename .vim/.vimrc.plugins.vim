" my vim plugins
" vim: set foldmethod=marker filetype=vim:
scriptencoding utf-8

" Vim-plug setup {{{
" Install Vim-plug and packages on new systems
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    augroup pluginstallgroup
        autocmd!
        autocmd VimEnter * PlugInstall | source $MYVIMRC
    augroup END
endif
call plug#begin('~/.vim/plugged')

Plug 'semanser/vim-outdated-plugins' " show a message on startup about outdated plugins
" }}}

" Unplug command {{{
" Provide a command to 'Unplug' or cancel requiring a plugin after it was
" required
" https://github.com/junegunn/vim-plug/issues/469
function! s:deregister(repo)
    let l:repo = substitute(a:repo, '[\/]\+$', '', '')
    let l:name = fnamemodify(l:repo, ':t:s?\.git$??')
    call remove(g:plugs, l:name)
    call remove(g:plugs_order, index(g:plugs_order, l:name))
endfunction
command! -nargs=1 -bar UnPlug call s:deregister(<args>)
" }}}

" Ctags and completion {{{
if executable('ctags')
    " evaluating https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html
    Plug 'ludovicchabant/vim-gutentags' " auto ctags runner. no lazy load.
    " Plug 'majutsushi/tagbar' "Shows methods/properties. no lazy load.
    Plug 'liuchengxu/vista.vim' " like tagbar for lsp symbols (broke with
    " latest neovim nightly)
    " Plug 'vim-php/tagbar-phpctags.vim', { 'do': 'make' } " Better php support for tagbar. Without this tagbar will show nothing if you use a trait. However, the php parser used is not updated for php 7, so it will fail on null coalesce! The first problem is now fixed in majutsushi/tagbar.
endif
" if has('nvim')
"     Plug 'ncm2/float-preview.nvim' " nifty neovim floating window alternative to vim's preview window during omni completion (I prefer my simpler approach - this adds separate searching functions)
" endif
" use these shortcuts for completion! https://github.com/mikedfunk/learning/blob/master/vim/completion.md
" Plug 'ajh17/VimCompletesMe' " simple tab omni completion with fallback to other types of completion (not sure I like this... I can just <c-x><c-o>, etc.)
" Plug 'maralla/completor.vim', { 'do': 'make js' } " vim 8 async autocomplete
" if has("python") || has("python3") | Plug 'Valloric/YouCompleteMe', { 'do': './install.py' } | endif " huge autocomplete plugin
" Plug 'maxboisvert/vim-simple-complete' " simple autocomplete in 50 lines
" Plug 'lifepillar/vim-mucomplete' " yet another completion plugin
" Plug 'Shougo/deoplete.nvim' | Plug 'roxma/nvim-yarp' | Plug 'roxma/vim-hug-neovim-rpc' " Autocomplete as you type, which is cool, but it's difficult to integrate with other completion tools. I also can't get echodoc to work with it.

Plug 'Shougo/echodoc.vim' " Displays function signatures from completions in the command line. Really helpful for omnicompletion!

" Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
" Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}

" completion not working currently with this...
" Async Language Server Protocol plugin for vim8 and neovim.
" TODO javascript gives me 'not executable: yarn flow'
" This makes the screen flash annoyingly
" Plug 'prabirshrestha/async.vim', { 'for': ['php'] }
" Plug 'prabirshrestha/vim-lsp', { 'for': ['php'] }
" Plug 'mattn/vim-lsp-settings', { 'for': ['php'] }
"

" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'yami-beta/asyncomplete-omni.vim'
" Plug 'prabirshrestha/asyncomplete-buffer.vim'
" Plug 'wellle/tmux-complete.vim' " add tmux as a completion source with user-defined completion <c-x><c-u>

" Plug 'natebosch/vim-lsc' " vim language server support https://bluz71.github.io/2019/10/16/lsp-in-vim-with-the-lsc-plugin.html (tried, I think the problem is with php-language-server. I get a shitload of errors. Tried again with intelephense. I don't know why but on completion the mode is changing to insert completion but I get no completion menu.)
" Plug 'prabirshrestha/async.vim' | Plug 'prabirshrestha/vim-lsp' " language server features
" Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'} " language server completion
" Plug 'neoclide/coc-sources' " more coc completion sources
" Plug 'Shougo/neco-vim' | Plug 'neoclide/coc-neco' " viml coc completion
" Plug 'roxma/nvim-completion-manager' | Plug 'roxma/vim-hug-neovim-rpc' " completion plugin recommended on reddit https://www.reddit.com/r/vim/comments/6zgi34/what_are_the_differences_between_vimcompletesme/?utm_content=title&utm_medium=front&utm_source=reddit&utm_name=vim
" Plug 'ncm2/ncm2' | Plug 'roxma/nvim-yarp' " formerly known as nvim-completion-manager (requires language server or phpactor connector)
"
if (has('nvim'))
    " actual official lsp config \o/
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/diagnostic-nvim' " better lsp diagnostics

    " Plug 'nvim-lua/completion-nvim' " use neovim completion to autocomplete and show auto popup (disabled: this causes all kinds of problems in my workflow even if it's working perfectly)
    " if I don't register intelephense:
    " error: Error executing vim.schedule lua callback: ....vim/plugged/completion-nvim/lua/completion/matching.lua:50: attempt to index field 'b' (a nil value)
    " this plugin also breaks nvim-lsp hover
    "
    " Plug 'RishabhRD/popfix' | Plug 'RishabhRD/nvim-lsputils' " better code action selector, better references window, etc. (disabled because it's buggy at the moment. Breaks references even if references are disabled. `t` no longer works to open a reference in a tab.)
endif

" nvim-lsp-smag {{{
" as of 2020-06-23:
"
" Vim(let):E5108: Error executing lua .../.vim/plugged/nvim-lsp-smag/lua/lsp_smag/utils/lists.lua:4: bad argument #1 to 'ipairs' (table expected, got nil)
"
" it's apparently because php doesn't support most of the default providers.
" If I pair this down to just 'definition' it just fails to find it but
" doesn't break.
"
" let g:lsp_smag_enabled_providers = ['definition']
"
" Plug 'weilbith/nvim-lsp-smag' " use lsp as tagfunc if available (Doesn't
" work - I found a
" function in an article that actually works, but it's just as innacurate as
" vim's built-in tagfunc)
" }}}

" }}}

" General {{{
" Plug 'tpope/vim-sensible' " sensible defaults (I copied these to my base vimrc)
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' } " redo another branch
" Plug 'simnalamburt/vim-mundo', { 'on': 'MundoToggle' } " nicer undotree... but MUCH slower
" Plug 'dahu/vim-lotr', { 'on': 'LOTRToggle' } " yankring-like
" Plug 'scrooloose/syntastic' " syntax checker (no lazy load)
" Plug 'mtscout6/syntastic-local-eslint.vim' " tell syntastic to prefer project node bin eslint executable over global one
Plug 'dense-analysis/ale' " as-you-type syntax checker
" Plug 'w0rp/ale', { 'commit': '2f9869d' } " as-you-type syntax checker
Plug 'tpope/vim-surround' | Plug 'tpope/vim-repeat' " surround text in quotes or something. repeatable.
Plug 'kreskij/Repeatable.vim', { 'on': 'Repeatable' } " Extra functionality to make mappings repeatable easily
" Plug 'machakann/vim-sandwich' " A better alternative to vim-surround... according to the internet
Plug 'vim-scripts/BufOnly.vim', { 'on': ['BufOnly', 'Bufonly'] } " close all buffers but the current one
Plug 'tpope/vim-commentary' " toggle comment with `gcc`. in my case I use `<leader>c<space>` which is the NERDCommenter default
" Plug 'scrooloose/nerdcommenter' " comment plugin... I switched to tpope's vim-commentary
" Plug 'jbgutierrez/vim-better-comments' " fancy comments
" Plug 'junegunn/vim-easy-align' " align on = with ga=
" Plug 'tommcdo/vim-lion' " align on = with visual mode and gl= (NOTE:
" mappings conflict with vim-lost)
Plug 'tpope/vim-unimpaired' " lots of cool keyboard shortcuts
if has('python3')
    Plug 'SirVer/ultisnips' " dynamic snippet completion
endif
" if has("python") | Plug 'robertbasic/snipbar' | endif " show available snips
" Plug 'jiangmiao/auto-pairs' " Auto insert closing brackets and parens
Plug 'jeromedalbert/auto-pairs', { 'branch': 'better-auto-pairs' } " fork, see https://www.reddit.com/r/vim/comments/adv2h0/do_you_use_a_custom_fork_of_autopairs_how_is_it/
" Plug 'tmsvg/pear-tree' " fancier auto-pairs alternative - only adds pair on esc
" Plug 'rstacruz/vim-closer' " like auto-pairs but only triggers on enter (only works well for JS)
" Plug 'kana/vim-smartinput' " like auto-pairs
Plug 'sickill/vim-pasta' " paste with context-sensitive indenting
" Plug 'wincent/terminus' " auto update file changes, better mouse, insert cursor shape, bracketed paste.
Plug 'tpope/vim-eunuch', { 'on': ['Mkdir!', 'Remove!'] } " :Mkdir!, :Remove!, and other shortcuts
" if executable('curl') | Plug 'mattn/webapi-vim', { 'on': 'Gist' } | Plug 'mattn/gist-vim', { 'on': 'Gist' } | endif " make gists with :Gist
" Plug 'vitalk/vim-shebang' " detect filetype from shebang
Plug 'skywind3000/asyncrun.vim' " vim 8 async to quickfix plugin
Plug 'milkypostman/vim-togglelist' " toggle quickfix and location lists. Barely a plugin.
" Plug 'tpope/vim-dispatch' " I only use this to dispatch alias commands in a tmux split, then close the split
" Plug 'aquach/vim-http-client' " postman for vim
" Plug 'diepm/vim-rest-console', { 'for': 'rest', 'tag': 'v2.6.0' } " like above but more capable
Plug 'diepm/vim-rest-console' " like above but more capable (latest version) NOTE see ~/.yadm/bootstrap for notes on wuzz as a replacement for this. NOTE: { 'for': 'rest' } prevents this from setting filetypes correctly
Plug 'AndrewRadev/splitjoin.vim', { 'for': ['php', 'javascript', 'html'] } " split and join php arrays to/from multiline/single line (gS, gJ) SO USEFUL
" Plug 'sunaku/vim-shortcut' " search for shortcuts with :Shortcuts with fzf completion
" Plug 'tweekmonster/startuptime.vim' " a plugin to find slow plugins. it's like rain on your wedding day.
" if executable('tmux')
    " Plug 'benmills/vimux' " run stuff in a tmux split
" endif
" Plug 'arecarn/vim-auto-autoread' " make autoread work as expected
Plug 'tmux-plugins/vim-tmux-focus-events' " makes FocusGained and FocusLost events work in terminal vim. Also handles functionality of vim-auto-autoread.
Plug 'tpope/vim-endwise' " auto add end/endif for vimscript/ruby. no lazy load or per-filetype load.
Plug 'tpope/vim-tbone', { 'on': ['Tmux', 'Tput', 'Tyank', 'Twrite', 'Tattach'] } " do stuff with tmux like send visual text to a split. Handy for repls.
" Plug 'mtth/scratch.vim' " :Scratch to open scratch buffer in split
Plug 'tpope/vim-rsi' " readline mappings for insert and command modes
" Plug 'google/vim-maktaba' | Plug 'google/vim-coverage' " coverage for python
" Plug 'revolvingcow/vim-umbrella' " vague coverage displayer
" Plug 'hyiltiz/vim-plugins-profile' " find slow plugins
" if has('nvim')
"     Plug 'glacambre/firenvim', { 'do': function('firenvim#install') } " use neovim in browser text inputs
" endif
if has('nvim') && has('python3')
    Plug 'raghur/vim-ghost', {'do': ':GhostInstall'} " manually connect a text field with neovim. I like this better because it doesn't vimify _all_ of my input areas.
endif
" }}}

" Html {{{
" Plug 'mattn/emmet-vim', { 'for': ['phtml', 'html', 'html.twig', 'twig', 'blade', 'xml', 'javascript.jsx'] } " html shorthand expander <c-y>, <c-y>n
Plug 'docunext/closetag.vim', { 'for': ['html', 'xml', 'html.twig', 'blade', 'php', 'phtml', 'javascript.jsx'] } " auto close tags by typing </ . different from auto-pairs.
" if has("python") || has("python3") | Plug 'Valloric/MatchTagAlways' | endif " highlight matching tag
" Plug 'Seb-C/better-indent-support-for-php-with-html' " fix god-awful phtml indentation
" runtime macros/matchit.vim " jump to matching html tag (moved to .vimrc)
Plug 'andymass/vim-matchup' " better matchit and match highlighter
" }}}

" Navigation and Search {{{
" Plug 'AndrewRadev/quickpeek.vim' " cool quickfix preview - mapped to <c-p> from quickfix (ONLY works on vim 8.1+ with popups, not neovim)
Plug 'mhinz/vim-startify' " better vim start screen. Strangely includes session management, which I don't use. I use vim-obsession for that.
" NOTE: this also installs ~/.fzf and stuff
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim' " fuzzy finder. lazy load will prevent other commands from being loaded unless you add them all.
" FZF TERMINAL TIPS!
"
" <ctrl-t> will open a fzf browser at the current pwd
" <TAB> in the fzf browser will mark a file/folder. Enter will add them all separated by spaces.
" cd ~/**<TAB> will complete for you
" ssh **<TAB>
" export **<TAB>
" unalias **<TAB>
Plug 'jesseleite/vim-agriculture' " Add :AgRaw to search with args
"
" if has('node')
    " Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' } " use vim fzf in a floating window with sensible defaults (I prefer fzf's suggested approach. This adds separate search commands and doesn't use ag.) 2020-07-31 it breaks my existing fzf commands
" endif
"
"
" Plug 'junegunn/vim-slash' " after finding and moving cursor, turn off search highlights
Plug 'tpope/vim-abolish' " search and replace for various naming types e.g. :S/someWord/someOtherWord/g
Plug 'michaeljsmith/vim-indent-object' " select in indentation level e.g. vii
" Plug 'kana/vim-kextobj-user' | Plug 'glts/vim-textobj-comment' " change a multiline comment with cic
" Plug 'kana/vim-textobj-entire' " select in entire document
" Plug 'coderifous/textobj-word-column.vim' " add a text object c and C for a column - visual block mode for current indentation level
" Plug 'wellle/visual-split.vim' " adds mappings and commands to split out the visual selection vertically
" Plug 'tpope/vim-vinegar' " netrw helper
" Plug 'preservim/nerdtree' " I have turned back to the dark side because they have icons and less bugs
" if has('python3')
"     Plug 'ms-jpq/chadtree', { 'branch': 'chad', 'do': ':UpdateRemotePlugins' } " that didn't last long
" endif
if executable('nnn')
    Plug 'mcchrish/nnn.vim'
endif
" Plug 'matthewd/vim-vinegar', { 'branch': 'netrw-plug' } " temporary fork that fixes a bug
Plug 'justinmk/vim-ipmotion' " makes blank line with spaces only the end of a paragraph
Plug 'machakann/vim-swap' " move args left/right with g< g> or gs for interactive mode
Plug 'EinfachToll/DidYouMean' " tries to help opening mistyped files
Plug 'unblevable/quick-scope' " highlights chars for f, F, t, T
" Plug 'severin-lemaignan/vim-minimap' " sublime-style minimap with <leader>mm (no lazy load)
Plug 'wfxr/minimap.vim' " another minimap but faster, written in rust
" Plug 'terryma/vim-multiple-cursors' " sublime-style with <c-n>
" if has('signs') | Plug 'MattesGroeger/vim-bookmarks' | endif " bookmark lines with annotations and navigate them globally. especially useful for taking inline notes on a file without adding a comment.
" Plug 'brooth/far.vim', { 'on': ['Far', 'Fardo', 'Farundo', 'Farp', 'Refar', 'F'] } " find and replace
" Plug 'yonchu/accelerated-smooth-scroll' " animated scroll on c-d, c-u, c-f, c-b
" Plug 'psliwka/vim-smoothie' " spiffier smooth scrolling
" Plug 'yuttie/comfortable-motion.vim' " smooth scroll using timer and shit
Plug 'wellle/targets.vim' " Adds selection targets like vi2) or vI} to avoid whitespace
Plug 'tpope/vim-obsession' " auto save sessions if you :Obsess
" Plug 'chrisbra/Recover.vim' " show diff when recovering a file
" Plug 'tyru/undoclosewin.vim' " reopen closed window with <leader>uc
Plug 'AndrewRadev/undoquit.vim' " another one to reopen closed buffers/windows/tabs: <c-w>u
" Plug 'google/vim-searchindex' " show search index in cmd area e.g. [4/7]
" Plug 'henrik/vim-indexed-search' " works better with vim-slash
" Plug 'matze/vim-move' " move lines up/down with <a-j> and <a-k>
Plug 'frioux/vim-lost', { 'branch': 'main' } " gL to see what function you're in. I use this in php sometimes to avoid expensive similar functionality in vim-airline.
" Plug 'ramele/agrep' " async grep that shows found context in a split. Cool!
" Plug 'wincent/ferret' " enhances search, quickfix window, etc. with :Ack command
" Plug 'dhruvasagar/vim-zoom' " zoom toggle. Can kind of do the same thing with <c-w>_ or <c-w><bar> or permanently with :only
Plug 'lifepillar/vim-cheat40' " Customizable cheatsheet. Mine is in ~/.vim/plugged/cheat40.txt. Open cheatsheet with <leader>? . I use this to avoid written cheatsheets on my desk for refactor tools and vdebug.
" Plug 'auwsmit/vim-active-numbers' " Only show line numbers on active window. Helps to show which is active. (but... doesn't let you see line numbers of unfocused windows, which I often want to do)
" if has('nvim')
    " Plug 'IMOKURI/line-number-interval.nvim' " highlight line numbers 10 lines away, etc. This is so cool! Buuut the actual display is different than the gif shows. line numbers not in the interval are hidden completely! (UPDATE I tried again 2020-08-06, same)
" endif
" Plug 'dyng/ctrlsf.vim' " Contextual search plugin ala sublime.
" Plug 'andymass/vim-tradewinds' " <c-w>gh to move the current split one to the left, etc. in other directions
" Plug 'Yilin-Yang/vim-markbar' " <leader>mm to show marks
" Plug 'simeji/winresizer' " ctrl-E to go to resize mode, hjkl, enter to finish, simple
" Plug 'haya14busa/vim-edgemotion' " c-j and c-k to go to 'edge'. Try it. It's hard to explain. (uninstalled because it conflicts with ultisnips mapping)
" if has('python2')
"     Plug 'vim-scripts/VOoM' " outliner like tagbar but for folds (python2?
"     not worth the trouble.)
" endif
" navigate markdown headers with ]] and [[
Plug 'https://gist.github.com/ac63e108c3d11084be62b3c04156c263.git', { 'as': 'markdown-nav', 'for': 'markdown' }
" Plug 'obcat/vim-hitspop' " when searching with / or ? show a tiny popup in the top right that shows the current match number and total number of matches (requires hlsearch and vim so I turned it off)
" }}}

" Php {{{
" xdebug (dbgp) client. To load with other filetypes do :PlugStatus and L over vdebug. temporarily disabled due to UnicodeError and vim.error on breaking :/ works as of 5-7-2018
if has('python3')
    Plug 'vim-vdebug/vdebug', { 'for': 'php' }
endif
" Plug 'arnaud-lb/vim-php-namespace', { 'for': 'php' } " insert use statements (abandoned)
Plug 'iusmac/vim-php-namespace', { 'for': 'php' } " maintained fork
" this is included with neovim in a pretty recent version
" /usr/local/Cellar/neovim/{version}/share/nvim/runtime/autoload/phpcomplete.vim
" Plug 'shawncplus/phpcomplete.vim' " better php omnicomplete. This is included with vim8 but the package keeps it up-to-date.

" this doesn't work very well - it only jumps/completes to psr-7 namespaced classes. I fucking hate working on this piece of dogshit codebase.
Plug 'phpactor/phpactor', {'for': 'php', 'branch': 'master', 'do': 'composer install --no-dev -o'} " recommended here to improve php completion https://www.reddit.com/r/vim/comments/95jxk7/big_list_of_tagsctags_matches_how_to_navigate_in/ PROBLEM: It _only_ works for classes in the composer autoloader, which makes it nearly useless on legacy until we merge simpler autoloading :/.
" Plug 'mkusher/padawan.vim', { 'for': 'php', 'do': 'command -v padawan >/dev/null 2>&1 && cgr update mkusher/padawan \|\| cgr mkusher/padawan' } " better php omnicomplete... but it doesn't complete at all for me
" Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer install'  } " based on phpcomplete but supposedly faster. Problem with legacy :/ SEE BELOW
" Plug 'mikedfunk/phpcd.vim', { 'for': 'php', 'do': 'composer install'  } " fork to make it actually work with php 7.0. I still have problems with php errors on this. This probably expects a newer api than the old versions of the dependencies I had to use.
" Plug 'alvan/vim-php-manual', { 'for': ['php', 'blade', 'phtml'] } " contextual php manual with shift-K (trying devdocs.io instead, see ~/.vimrc)
" Plug 'rayburgemeestre/phpfolding.vim' " php syntax folding with :EnableFastPhpFolds
" Plug 'Plug 'swekaj/php-foldexpr.vim' " better php folding recommended here https://stackoverflow.com/questions/792886/vim-syntax-based-folding-with-php#comment46149243_11859632
" Plug 'sbdchd/neoformat' " auto format code using prettier, phpcbf, etc. :Neoformat (I use ale fixing instead)
" Plug 'tobyS/vmustache', { 'for': 'php' } | Plug 'FlickerBean/pdv', { 'for': 'php' } " phpdoc generator (I just use ultisnips)
" Plug '2072/PHP-Indenting-for-VIm', { 'for': ['php', 'phtml'] } " apparently better php indenting for PHP 5.4+ (Is it though?)
" Plug 'janko-m/vim-test', { 'for': 'php' } | Plug 'benmills/vimux', { 'for': 'php' } " test runner :TestNearest :TestFile :TestLast in tmux split (I had a problem with the characters being sent to tmux VERY slowly)
if has("python3")
    " Only used for code coverage markers :Phpcc.
    " Use with my alias psc-clover or puc-clover.
    " TODO write a provider to replace this with vim-coverage https://github.com/google/vim-coverage
    " Plug 'joonty/vim-phpqa', { 'for': 'php' }
    " maintained fork
    Plug 'trendfischer/vim-phpqa', { 'for': 'php' }
endif
Plug 'adoy/vim-php-refactoring-toolbox', { 'for': 'php' }
" refactor php, get started with <leader>r
" DO NOT USE. (php parser is horribly outdated and composer dependency is broken.)
" this thing doesn't seem to work at all with php 7. Phar project is
" abandoned and forks don't work.
" Plug 'vim-php/vim-php-refactoring', { 'do': '/usr/local/bin/wget -O /usr/local/bin/refactor.phar https://github.com/QafooLabs/php-refactoring-browser/releases/download/v0.1/refactor.phar' }
Plug 'noahfrederick/vim-laravel', { 'for': 'php' } " mostly junk commands like :Artisan but useful for gf improvement for config, blade template names, and translation keys
" }}}

" Projects and Tasks {{{
" Plug 'xolox/vim-notes' | Plug 'xolox/vim-misc' " notes in vim
" Plug 'DarwinSenior/vim-notes' | Plug 'xolox/vim-misc' " maintained fork
" Plug 'vimwiki/vimwiki' " now that xolox notes seems to be the one killing my syntax highlighting, it's time to try something else
" Plug 'timgreen/vimwiki' " bugfix for markdown tags, should switch back when merged
" if has('python') | Plug 'vim-voom/VOoM' | endif " `:Voom markdown` to get a left navbar for markdown structure hierarchy.
Plug 'tpope/vim-projectionist' " link tests and classes together
" Plug 'editorconfig/editorconfig-vim' " use per-project editor settings
Plug 'sgur/vim-editorconfig' " faster version of editorconfig
Plug 'scrooloose/vim-orgymode' " kind of like emacs org-mode. <c-c> will toggle markdown checkbox. Also some syntax highlighting and ultisnips snippets. I use it in my notes.

" Plug 'dkarter/bullets.vim' " does cool stuff with numbered and bullet lists in markdown, etc. <c-t> to indent, <c-d> to outdent.
" Plug 'blindFS/vim-taskwarrior' " vim taskwarrior integration. :TW to interact with tasks
" }}}

" Git {{{
" temporarily disabled due to bug with vim-php-namespace
" if executable('git') | Plug 'airblade/vim-gitgutter' | endif " show git changes in sidebar
if executable('git')
    Plug 'mhinz/vim-signify' " show git changes in sidebar
" if executable('git') | Plug 'tpope/vim-fugitive' | Plug 'shumphrey/fugitive-gitlab.vim' | Plug 'tpope/vim-dispatch' | endif " git integration
    " fugitive - vim git integration
    " fubitive - add bitbucket support to fugitive
    " rhubarb - github support for fugitive
    Plug 'tpope/vim-fugitive' | Plug 'shumphrey/fugitive-gitlab.vim' | Plug 'tommcdo/vim-fubitive' | Plug 'tpope/vim-rhubarb' " git integration
    Plug 'esneider/YUNOcommit.vim' " u save lot but no commit. Y u no commit??
    Plug 'rhysd/committia.vim' " prettier commit editor. Really cool!
    " Plug 'junegunn/gv.vim', { 'on': 'GV' } " :GV for git/tig-style log
    " Plug 'mmozuras/vim-github-comment', { 'on': 'GHComment' } | Plug 'mattn/webapi-vim' " :GHComment my comment goes to latest commit on github (so cool but I haven't got into the habit of using it)
    Plug 'hotwatermorning/auto-git-diff' " cool git rebase diffs per commit
    " Plug 'tpope/vim-fugitive' | Plug 'christoomey/vim-conflicted' " better mergetool that makes use of fugitive (this is worse - I still get problems with using local or remote changes not properly removing conflict symbols and the other code)

    " NOTE: gutentags by default does not tag files in wildignore!
    "
    " if has('python') | Plug 'euclio/gitignore.vim' | endif " automatically populate wildignore from gitignore. Why would I not want to do this? Because it's buggy with no gitignore :/
    " Plug 'vim-scripts/gitignore' " simpler version with no python
    " Plug 'octref/rootignore' " yet another gitignore -> wildignore
    Plug 'tpope/vim-git' " Git file mappings and functions (e.g. rebase helpers) and syntax highlighting, etc. I add mappings in my plugin config.
endif
Plug 'wting/gitsessions.vim' " sessions based on git branches!
" Plug 'rhysd/git-messenger.vim', { 'on': 'GitMessenger' } " show last commit for line, or even the one before that!
if has('nvim')
    " Plug 'f-person/git-blame.nvim' " show commit message in virtual text to the right of code in muted colors. That's it.
    Plug 'APZelos/blamer.nvim' " yet another git blame virtual text plugin
endif
Plug 'mattn/webapi-vim' | Plug 'mattn/vim-gist' " :Gist to create a github gist
" }}}

" Javascript {{{
" Plug 'othree/jspc.vim', { 'for': 'javascript' } " javascript parameter completion
" Plug 'moll/vim-node', { 'for': ['javascript', 'typescript', 'jsx'] } " node tools - go to module def, etc.
" if executable('tsc') | Plug 'Shougo/vimproc.vim', { 'do': 'make', 'for': 'typescript' } | Plug 'Quramy/tsuquyomi', { 'for': 'typescript' } | endif " typescript omnicompletion, custom jump to def, custom syntax erroring
Plug 'tpope/vim-jdaddy' "`gqaj` to pretty-print json, `gwaj` to merge the json object in the clipboard with the one under the cursor
" Plug 'chemzqm/vim-jsx-improve' " better jsx formatting
Plug 'MaxMEllon/vim-jsx-pretty' " jsx formatting (NOT in vim-polyglot)
" if has('python3')
"     Plug 'ternjs/tern_for_vim', { 'do': '/usr/local/bin/npm install' }
" endif " javascript omnifunc and jump to def. requires a .tern-project or ~/.tern-config file. http://ternjs.net/doc/manual.html#configuration
" Plug 'othree/javascript-libraries-syntax.vim' " syntax completion for common libraries (react, lodash, jquery, etc.)
" Plug 'kristijanhusak/vim-js-file-import' " Go to definition: <leader>ig Import file: <Leader>if
Plug 'tpope/vim-apathy' " tweak built-in vim features to allow jumping to javascript (and others) module location with gf
Plug 'tomarrell/vim-npr' " make gf work with index.js and search js files more intelligently
" vim-apathy is useful to replace something like this https://stackoverflow.com/questions/33093491/vim-gf-with-file-extension-based-on-current-filetype#33096831
Plug 'styled-components/vim-styled-components', { 'branch': 'main' } " styled-components support
Plug 'kristijanhusak/vim-js-file-import' " ctags-based importing
" }}}

" Syntax highlighting {{{
" Plug 'rtfb/vim-dox-spell' " fix buggy doxygen support in php and others
Plug 'gerw/vim-HiLinkTrace' " adds an <leader>hlt command to get all highlight groups under cursor
" Plug 'elzr/vim-json' " json syntax (in vim-polyglot)
" annoyingly this must be loaded before polyglot is loaded :/
let g:polyglot_disabled = [
            \ 'php',
            \ 'rst'
            \ ]
Plug 'sheerun/vim-polyglot' " just about every filetype under the sun in one package
Plug 'neoclide/jsonc.vim' " jsonc syntax
" Plug 'zimbatm/haproxy.vim' " haproxy syntax (in vim-polyglot)
" Plug 'amadeus/vim-mjml' " mjml email syntax
" Plug 'stephpy/vim-yaml' " faster yaml syntax highlighting (vim-polyglot has a different one)
Plug 'fpob/nette.vim' " .neon format
" Plug 'pangloss/vim-javascript' " Vastly improved Javascript indentation and syntax support in Vim. (in vim-polyglot)
" Plug 'flowtype/vim-flow' " flowtype omnicompletion. If not using flow in a project, add this to project .vimrc: let g:flow#enable = 0
" Plug 'jez/vim-flow' " fork that adds --quiet. without --quiet doesn't work still as of may 2018 (in vim-polyglot)
" Plug 'othree/yajs.vim', { 'for': ['javascript', 'jsx', 'vue'] } " additonal javascript syntax highlighting. jsx is included in polyglot above.
" Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' } " typescript syntax, etc. based on yajs
" Plug 'mxw/vim-jsx' (in vim-polyglot)
" Plug 'MaxMEllon/vim-jsx-pretty'
" Plug 'elixir-editors/vim-elixir'
" Plug 'othree/es.next.syntax.vim', { 'for': ['javascript', 'jsx', 'vue'] }
" Plug 'StanAngeloff/php.vim' " php 5.6+ (including 7.x) syntax highlighting improvements like docblocks (in vim-polyglot)
" Plug 'kkoomen/vim-doge' " docblock comments for a variety of languages <leader>dd (doesn't work for shit in php)
" Plug 'posva/vim-vue' " vue.js syntax (in vim-polyglot)
" Plug 'digitaltoad/vim-pug', { 'for': ['pug', 'jade'] } " pug (formerly jade) highlighting
" Plug 'heavenshell/vim-syntax-flowtype' " js flowtype (included in pangloss/vim-javascript)
Plug 'rhysd/vim-gfm-syntax' " github-flavored markdown. yum!
" Plug 'tpope/vim-markdown' " This is supposed to be included with vim but I don't think it is included with neovim
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'plantuml', 'vim-plug']}
" Plug 'nelstrom/vim-markdown-folding' " just markdown folding (markdown folding functionality is actually provided by default, you just have to enable it with let g:markdown_folding=1)
" Plug 'osyo-manga/vim-precious' | Plug 'Shougo/context_filetype.vim' " code block syntax highlighting for markdown, etc. _really_ helpful! Also really helps to see the surrounding code block text! MUST USE for markdown.
Plug 'qnighy/vim-ssh-annex' " ssh files syntax coloring e.g. ssh config
" Plug 'evanmiller/nginx-vim-syntax' " nginx conf syntax
" Plug 'darfink/vim-plist' " plist syntax
" Plug 'rodjek/vim-puppet' " (in vim-polyglot)
" Plug 'aklt/plantuml-syntax' " (in vim-polyglot)
" Plug 'framallo/taskwarrior.vim' " taskwarrior config and task edit syntax
" Plug 'jwalton512/vim-blade' " laravel blade syntax (in vim-polyglot)
Plug 'itchyny/vim-highlighturl' " just highlight urls like in a browser
if has('nvim')
    " Plug 'nvim-treesitter/nvim-treesitter' " fancy language-aware highlighting and other functions (it changes colors and is a little buggy with color rendering. I also just don't find it that useful at the moment. I can already do most of this stuff without it.)
endif
" }}}

" Visuals {{{
Plug 'vim-airline/vim-airline' " better status bar
Plug 'vim-airline/vim-airline-themes' " pretty colors for airline

" Indent Guides {{{
" Plug 'nathanaelkane/vim-indent-guides' " show vertical indent guides for levels of indentations
" Plug 'mikedfunk/vim-indent-guides' " my fork to enable color guessing with termguicolors
" Plug 'thaerkh/vim-indentguides' " faster indent guides (lately it's only been showing every other one. Also they disappear when reloading vimrc.)
Plug 'Yggdroot/indentLine' " show vertical lines for levels of indentions
Plug 'lukas-reineke/indent-blankline.nvim' " works with above plugin to include indent symbols on blank lines. finally!
" }}}

if executable('tmux')
    Plug 'edkolev/tmuxline.vim' " tmux statusline file generator
endif
" Plug 'edkolev/promptline.vim', { 'on': ['Promptline', 'PromptlineSnapshot'] } " custom bash prompt creation in sync with airline
" Plug 'ntpeters/vim-better-whitespace' " highlight tabs and trailing whitespace. Slows down typing considerably though!
" Plug 'thirtythreeforty/lessspace.vim' " remove trailing whitespace only on lines you edit. Messes up paste indent!
" Plug 'dodie/vim-disapprove-deep-indentation', { 'for': ['php', 'ruby'] } " too much indentation = ಠ_ಠ . messes up the quantum theme I use for saatchi
" Plug 'xolox/vim-colorscheme-switcher' " F8 for next, Shift-F8 for previous color scheme
Plug 'chxuan/change-colorscheme' " :NextColorScheme :PreviousColorScheme
" Plug 'osyo-manga/vim-brightest' " highlight matching words. 1.5 seconds to load!
" Plug 'dominikduda/vim_current_word' " highlight matching words. More intelligent.
Plug 'itchyny/vim-cursorword' " highlight matching words. What I like about this one is it keeps the same color and bold/italic.
" Plug 'elqatib/remaining-todos.vim' " when remaining todos in a file, flash a message before closing a buffer
Plug 'ap/vim-css-color', { 'for': ['scss', 'css'] } " colorize css colors e.g. #333 with the actual color in the background
" Plug 'chrisbra/NrrwRgn' " work in a separate window with a sub-region of a document. :NR
" Plug 'scrooloose/vim-slumlord' " plantuml live preview for sequence diagrams
Plug 'ryanoasis/vim-devicons' " file type icons in netrw, etc.
" Plug 'TaDaa/vimade' " fade inactive buffers, preserving color scheme (I don't really need this)
Plug 'junegunn/goyo.vim' | Plug 'junegunn/limelight.vim' " focus mode

" if has('popupwin')
    " Plug 'mnishz/colorscheme-preview.vim' " :ColorschemePreview only for vim
" endif

" color schemes: 256-friendly {{{
" Plug 'MarioRicalde/vim-lucius'
" Plug 'adelarsq/vim-grimmjow'
" Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim/' }
" Plug 'fmoralesc/molokayo'
" Plug 'freeo/vim-kalisi'
" Plug 'jnurmine/Zenburn'
" Plug 'joshdick/onedark.vim' "base16 version available
" Plug 'jsit/disco.vim' " makes 16-color schemes 256-color friendly
" Plug 'junegunn/seoul256.vim'
" Plug 'nanotech/jellybeans.vim'
" Plug 'romainl/Apprentice'
" Plug 'sjl/badwolf'
" Plug 'tomasr/molokai'
" Plug 'w0ng/vim-hybrid'
" Plug 'whatyouhide/vim-gotham'
" Plug 'sonph/onehalf', { 'rtp': 'vim' }
" Plug 'archSeer/colibri.vim'
" Plug 'fenetikm/falcon'
" Plug 'arzg/vim-colors-xcode'
" Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
" Plug 'connorholyday/vim-snazzy'
" }}}

" color schemes: 24-bit only {{{
" Plug 'AlessandroYorba/Alduin'
" Plug 'AlessandroYorba/Despacio'
" Plug 'AlessandroYorba/Monrovia'
" Plug 'AlessandroYorba/Sidonia'
" Plug 'KeitaNakamura/neodark.vim'
" Plug 'NLKNguyen/papercolor-theme'
" Plug 'arcticicestudio/nord-vim'
" Plug 'atelierbram/Base2Tone-vim'
" Plug 'blueshirts/darcula'
" Plug 'danilo-augusto/vim-afterglow'
" Plug 'dracula/vim', {'as':'dracula'} " base16 version available
" Plug 'fcpg/vim-fahrenheit'
" Plug 'jacoborus/tender.vim'
" Plug 'kamwitsta/nordisk'
" Plug 'lifepillar/vim-solarized8'
" Plug 'mbbill/vim-seattle'
" Plug 'mhartington/oceanic-next' " base16 version available
" Plug 'gruvbox-community/gruvbox'
" Plug 'rakr/vim-one'
" Plug 'raphamorim/lucario'
" Plug 'roosta/vim-srcery'
" Plug 'tpope/vim-vividchalk'
" Plug 'alessandroyorba/sierra'
" Plug 'ayu-theme/ayu-vim'
Plug 'chriskempson/base16-vim' " themes made of 16 colors
" Plug 'kristijanhusak/vim-hybrid-material'
" Plug 'tyrannicaltoucan/vim-quantum'
" Plug 'cocopon/iceberg.vim'
" Plug 'evturn/cosmic-barf' " psychadelic solarized (comments are really hard to see)
" Plug 'toothpaste-theme/toothpaste'
" Plug 'wmvanvliet/vim-blackboard'
" Plug 'jaredgorski/SpaceCamp'
" Plug 'mr-ubik/vim-hackerman-syntax'
" Plug 'flrnprz/taffy.vim'
" Plug 'patstockwell/vim-monokai-tasty'
" Plug 'bcicen/vim-vice'
Plug 'flazz/vim-colorschemes' " a bunch of colorschemes from vim.org
" Plug 'kaicataldo/material.vim', { 'branch': 'main' }
" Plug 'ghifarit53/tokyonight-vim'
" }}}

" }}}

" Vim-plug close {{{
call plug#end()
" }}}
