" vim: set foldmethod=marker filetype=vim:
" my vim plugins
"
" Vim-plug setup {{{
" Install Vim-plug and packages on new systems
if empty(glob("~/.vim/autoload/plug.vim"))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
" }}}

" Unplug {{{
" https://github.com/junegunn/vim-plug/issues/469
function! s:deregister(repo)
    let repo = substitute(a:repo, '[\/]\+$', '', '')
    let name = fnamemodify(repo, ':t:s?\.git$??')
    call remove(g:plugs, name)
    call remove(g:plugs_order, index(g:plugs_order, name))
endfunction
command! -nargs=1 -bar UnPlug call s:deregister(<args>)
" }}}

" Ctags and completion {{{
if executable('ctags')
    " evaluating https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html
    " Plug 'ludovicchabant/vim-gutentags' " auto ctags runner. no lazy load.
    Plug 'majutsushi/tagbar' "Shows methods/properties. no lazy load.
    " Plug 'vim-php/tagbar-phpctags.vim', { 'do': 'make' } " Better php support for tagbar. Without this tagbar will show nothing if you use a trait. However, the php parser used is not updated for php 7, so it will fail on null coalesce! The first problem is now fixed in majutsushi/tagbar.
endif
" use these shortcuts for completion! https://github.com/mikedfunk/learning/blob/master/vim/completion.md
" Plug 'ajh17/VimCompletesMe' " simple tab omni completion
" Plug 'maralla/completor.vim', { 'do': 'make js' } " vim 8 async autocomplete
" if has("python") || has("python3") | Plug 'Valloric/YouCompleteMe', { 'do': './install.py' } | endif " huge autocomplete plugin
" Plug 'maxboisvert/vim-simple-complete' " simple autocomplete in 50 lines
" Plug 'lifepillar/vim-mucomplete' " yet another completion plugin
" Plug 'roxma/nvim-completion-manager' | Plug 'roxma/vim-hug-neovim-rpc' " completion plugin recommended on reddit https://www.reddit.com/r/vim/comments/6zgi34/what_are_the_differences_between_vimcompletesme/?utm_content=title&utm_medium=front&utm_source=reddit&utm_name=vim
" Plug 'Shougo/deoplete.nvim' | Plug 'roxma/nvim-yarp' | Plug 'roxma/vim-hug-neovim-rpc' " Autocomplete as you type, which is cool, but it's difficult to integrate with other completion tools. I also can't get echodoc to work with it.

Plug 'Shougo/echodoc.vim' " Displays function signatures from completions in the command line. Really helpful for omnicompletion!
Plug 'wellle/tmux-complete.vim' " add tmux as a completion source with user-defined completion <c-x><c-u>

" Got this error for languageclient:
" Error detected while processing function <SNR>158_VimOutputCallback[6]..<SNR>159_HandleCommandMessage[3]..ale#lsp#HandleMessage:
" line    1:
" E734: Wrong variable type for .=
" [vim-hug-neovim-rpc] rpc method [nvim_buf_set_option] not implemented in pythonx/neovim_rpc_methods.py. Please send PR or contact the mantainer.
" Plug 'autozimu/LanguageClient-neovim' | Plug 'roxma/vim-hug-neovim-rpc' | Plug 'roxma/nvim-yarp' " works with felixfbecker/php-language-server composer global package to do more intelligent completion

" completion not working currently with this...
" Plug 'prabirshrestha/asyncomplete.vim' | Plug 'prabirshrestha/asyncomplete-lsp.vim' | Plug 'prabirshrestha/async.vim' | Plug 'prabirshrestha/vim-lsp' " Async Language Server Protocol plugin for vim8 and neovim.
" }}}

" General {{{
" Plug 'tpope/vim-sensible' " sensible defaults (I copied these to my base vimrc)
" Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' } " redo another branch
Plug 'simnalamburt/vim-mundo', { 'on': 'MundoToggle' } " nicer undotree
" Plug 'dahu/vim-lotr', { 'on': 'LOTRToggle' } " yankring-like
" Plug 'scrooloose/syntastic' " syntax checker (no lazy load)
" Plug 'mtscout6/syntastic-local-eslint.vim' " tell syntastic to prefer project node bin eslint executable over global one
Plug 'w0rp/ale' " as-you-type syntax checker
" Plug 'w0rp/ale', { 'commit': '2f9869d' } " as-you-type syntax checker
Plug 'tpope/vim-surround' | Plug 'tpope/vim-repeat' " surround text in quotes or something. repeatable.
" Plug 'machakann/vim-sandwich' " A better alternative to vim-surround... according to the internet
Plug 'vim-scripts/BufOnly.vim', { 'on': ['BufOnly', 'Bufonly'] } " close all buffers but the current one
Plug 'tpope/vim-commentary' " toggle comment with gcc. in my case I use <leader>c<space>
" Plug 'junegunn/vim-easy-align' " align on = with ga=
Plug 'tpope/vim-unimpaired' " lots of cool keyboard shortcuts
" if has("python") || has("python3") | Plug 'SirVer/ultisnips' | endif " dynamic snippet completion
if has("python") || has("python3") | Plug 'SirVer/ultisnips' | endif " dynamic snippet completion
" if has("python") | Plug 'robertbasic/snipbar' | endif " show available snips
Plug 'jiangmiao/auto-pairs' " Auto insert closing brackets and parens
Plug 'sickill/vim-pasta' " paste with context-sensitive indenting
" Plug 'wincent/terminus' " auto update file changes, better mouse, insert cursor shape, bracketed paste.
Plug 'tpope/vim-eunuch', { 'on': ['Mkdir!', 'Remove!'] } " :Mkdir!, :Remove!, and other shortcuts
" if executable('curl') | Plug 'mattn/webapi-vim', { 'on': 'Gist' } | Plug 'mattn/gist-vim', { 'on': 'Gist' } | endif " make gists with :Gist
" Plug 'vitalk/vim-shebang' " detect filetype from shebang
Plug 'skywind3000/asyncrun.vim' " vim 8 async to quickfix plugin
" Plug 'aquach/vim-http-client' " postman for vim
" Plug 'diepm/vim-rest-console', { 'for': 'rest', 'tag': 'v2.6.0' } " like above but more capable
Plug 'diepm/vim-rest-console', { 'for': 'rest' } " like above but more capable (latest version)
Plug 'AndrewRadev/splitjoin.vim', { 'for': ['php', 'javascript', 'html'] } " split and join php arrays to/from multiline/single line (gS, gJ) SO USEFUL
" Plug 'sunaku/vim-shortcut' " search for shortcuts with :Shortcuts with fzf completion
" Plug 'tweekmonster/startuptime.vim' " a plugin to find slow plugins. it's like rain on your wedding day.
" Plug 'benmills/vimux' " run stuff in a tmux split
" Plug 'arecarn/vim-auto-autoread' " make autoread work as expected
Plug 'tmux-plugins/vim-tmux-focus-events' " makes FocusGained and FocusLost events work in terminal vim. Also handles functionality of vim-auto-autoread.
Plug 'tpope/vim-endwise' " auto add end/endif for vimscript/ruby. no lazy load or per-filetype load.
" Plug 'tpope/vim-tbone', { 'on': ['Twrite', 'Tmux', 'Tattach'] } " do stuff with tmux like send visual text to a split
" Plug 'mtth/scratch.vim' " :Scratch to open scratch buffer in split
" }}}

" Html {{{
" Plug 'mattn/emmet-vim', { 'for': ['phtml', 'html', 'html.twig', 'twig', 'blade', 'xml'] } " html shorthand expander <c-y>, <c-y>n
Plug 'docunext/closetag.vim', { 'for': ['html', 'xml', 'html.twig', 'blade', 'php', 'phtml'] } " auto close tags by typing </ . different from auto-pairs.
" if has("python") || has("python3") | Plug 'Valloric/MatchTagAlways' | endif " highlight matching tag
if has("python") || has("python3") | Plug 'Valloric/MatchTagAlways' | endif " highlight matching tag
" Plug 'Seb-C/better-indent-support-for-php-with-html' " fix god-awful phtml indentation
" runtime macros/matchit.vim " jump to matching html tag
" }}}

" Navigation and Search {{{
" Plug 'mhinz/vim-startify' " better vim start screen. Strangely includes session management, which I don't use. I use vim-obsession for that.
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
"
" Plug 'junegunn/vim-slash' " after finding and moving cursor, turn off search highlights
Plug 'tpope/vim-abolish' " search and replace for various naming types
Plug 'michaeljsmith/vim-indent-object' " select in indentation level e.g. vii
" Plug 'kana/vim-textobj-user' | Plug 'glts/vim-textobj-comment' " change a multiline comment with cic
" Plug 'kana/vim-textobj-entire' " select in entire document
" Plug 'coderifous/textobj-word-column.vim' " add a text object c and C for a column - visual block mode for current indentation level
" Plug 'wellle/visual-split.vim' " adds mappings and commands to split out the visual selection vertically
" Plug 'tpope/vim-vinegar' " netrw helper
" Plug 'matthewd/vim-vinegar', { 'branch': 'netrw-plug' } " temporary fork that fixes a bug
Plug 'justinmk/vim-ipmotion' " makes blank line with spaces only the end of a paragraph
Plug 'machakann/vim-swap' " move args left/right with g< g> or gs for interactive mode
" Plug 'EinfachToll/DidYouMean' " tries to help opening mistyped files
" Plug 'unblevable/quick-scope' " highlights chars for f, F, t, T
" Plug 'severin-lemaignan/vim-minimap' " sublime-style minimap with <leader>mm (no lazy load)
" Plug 'terryma/vim-multiple-cursors' " sublime-style with <c-n>
" if has('signs') | Plug 'MattesGroeger/vim-bookmarks' | endif " bookmark lines with annotations and navigate them globally
" Plug 'brooth/far.vim', { 'on': ['Far', 'Fardo', 'Farundo', 'Farp', 'Refar', 'F'] } " find and replace
" Plug 'yonchu/accelerated-smooth-scroll' " animated scroll on c-d, c-u, c-f, c-b
" Plug 'yuttie/comfortable-motion.vim' " smooth scroll using timer and shit
" Plug 'wellle/targets.vim' " Adds selection targets like vi2) or vI} to avoid whitespace
Plug 'tpope/vim-obsession' " auto save sessions if you :Obsess
" Plug 'chrisbra/Recover.vim' " show diff when recovering a file
Plug 'tyru/undoclosewin.vim' " reopen closed window with <leader>uc
" Plug 'google/vim-searchindex' " show search index in cmd area e.g. [4/7]
" Plug 'henrik/vim-indexed-search' " works better with vim-slash
" Plug 'matze/vim-move' " move lines up/down with <a-j> and <a-k>
Plug 'frioux/vim-lost' " gL to see what function you're in. I use this in php sometimes to avoid expensive similar functionality in vim-airline.
" Plug 'ramele/agrep' " async grep that shows found context in a split. Cool!
" Plug 'wincent/ferret' " enhances search, quickfix window, etc. with :Ack command
" Plug 'dhruvasagar/vim-zoom' " zoom toggle. Can kind of do the same thing with <c-w>_ or <c-w><bar>
Plug 'lifepillar/vim-cheat40' " Customizable cheatsheet. Mine is in ~/.vim/plugged/cheat40.txt. Open cheatsheet with <leader>? . I use this to avoid written cheatsheets on my desk for refactor tools and vdebug.
" Plug 'auwsmit/vim-active-numbers' " Only show line numbers on active window. Helps to show which is active.
" }}}

" Php {{{
" if has("python3") | Plug 'vim-vdebug/vdebug' | endif " xdebug (dbgp) client. To load with other filetypes do :PlugStatus and L over vdebug. temporarily disabled due to UnicodeError and vim.error on breaking :/ last tested 04-21-2018
if has("python") | Plug 'vim-vdebug/vdebug', { 'for': 'php', 'tag': 'v1.5.2' } | endif " python2 compatible version
Plug 'arnaud-lb/vim-php-namespace', { 'for': 'php' } " insert use statements
" Plug 'shawncplus/phpcomplete.vim', { 'for': 'php' } " better php omnicomplete. This is included with vim8 but the package keeps it up-to-date.
" Plug 'mkusher/padawan.vim', { 'for': 'php', 'do': 'command -v padawan >/dev/null 2>&1 && cgr update mkusher/padawan \|\| cgr mkusher/padawan' } " better php omnicomplete... but it doesn't complete at all for me
Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer install'  } " based on phpcomplete but supposedly faster. IT WORKS! GOOD! EVEN ON LEGACY!
Plug 'alvan/vim-php-manual', { 'for': ['php', 'blade', 'phtml'] } " contextual php manual with shift-K
" Plug 'rayburgemeestre/phpfolding.vim' " php syntax folding with :EnableFastPhpFolds
" Plug 'Plug 'swekaj/php-foldexpr.vim' " better php folding recommended here https://stackoverflow.com/questions/792886/vim-syntax-based-folding-with-php#comment46149243_11859632
" Plug 'stephpy/vim-php-cs-fixer', { 'for': 'php' } " fix coding standards for current file/dir. Disabled: I use vim-phpfmt instead so it uses phpcbf.
" Plug 'beanworks/vim-phpfmt', { 'for': 'php', 'on': 'PhpFmt' } " automatically fixes coding standards which phpcbf on save or via :PhpFmt
" Plug 'sbdchd/neoformat' " auto format code using prettier, phpcbf, etc. :Neoformat
" Plug 'tobyS/vmustache', { 'for': 'php' } | Plug 'FlickerBean/pdv', { 'for': 'php' } " phpdoc generator
" Plug '2072/PHP-Indenting-for-VIm', { 'for': ['php', 'phtml'] } " apparently better php indenting for PHP 5.4+
" Plug 'janko-m/vim-test', { 'for': 'php' } | Plug 'benmills/vimux', { 'for': 'php' } " test runner :TestNearest :TestFile :TestLast in tmux split
" if has("python") | Plug 'joonty/vim-phpqa', { 'for': 'php' } | endif " Only used for code coverage markers :Phpcc
" Plug 'adoy/vim-php-refactoring-toolbox'
" Plug 'vim-php/vim-php-refactoring' " requires refactor.phar <leader>r to show available refactors DO NOT USE. (php parser is horribly outdated and composer dependency is broken.)
" }}}

" Projects and Tasks {{{
" Plug 'xolox/vim-notes' | Plug 'xolox/vim-misc' " notes in vim
" Plug 'DarwinSenior/vim-notes' | Plug 'xolox/vim-misc' " maintained fork
" Plug 'vimwiki/vimwiki' " now that xolox notes seems to be the one killing my syntax highlighting, it's time to try something else
" Plug 'timgreen/vimwiki' " bugfix for markdown tags, should switch back when merged
Plug 'tpope/vim-projectionist' " link tests and classes together
" Plug 'editorconfig/editorconfig-vim' " use per-project editor settings
Plug 'sgur/vim-editorconfig' " faster version of editorconfig
" Plug 'scrooloose/vim-orgymode' " kind of like emacs org-mode. <c-c> will toggle markdown checkbox. Also some syntax highlighting and ultisnips snippets.
" Plug 'dkarter/bullets.vim' " does cool stuff with numbered and bullet lists in markdown, etc. <c-t> to indent, <c-d> to outdent.
" }}}

" Git {{{
" temporarily disabled due to bug with vim-php-namespace
" if executable('git') | Plug 'airblade/vim-gitgutter' | endif " show git changes in sidebar
if executable('git') | Plug 'mhinz/vim-signify' | endif " show git changes in sidebar
" if executable('git') | Plug 'tpope/vim-fugitive' | Plug 'shumphrey/fugitive-gitlab.vim' | Plug 'tpope/vim-dispatch' | endif " git integration
if executable('git') | Plug 'tpope/vim-fugitive' | Plug 'shumphrey/fugitive-gitlab.vim' | Plug 'tommcdo/vim-fubitive' | Plug 'tpope/vim-rhubarb' | endif " git integration
if executable('git') | Plug 'esneider/YUNOcommit.vim' | endif " u save lot but no commit. Y u no commit??
if executable('git') | Plug 'rhysd/committia.vim' | endif " prettier commit editor. Really cool!
if executable('git') | Plug 'junegunn/gv.vim', { 'on': 'GV' } | endif " :GV for git/tig-style log
if executable('git') | Plug 'mmozuras/vim-github-comment', { 'on': 'GHComment' } | Plug 'mattn/webapi-vim' | endif " :GHComment my comment goes to latest commit on github
if executable('git') | Plug 'hotwatermorning/auto-git-diff' | endif " cool git rebase diffs per commit
if has('python') | Plug 'euclio/gitignore.vim' | endif " automatically populate wildignore from gitignore. Why would I not want to do this?
" }}}

" Javascript {{{
" Plug 'othree/jspc.vim', { 'for': 'javascript' } " javascript parameter completion
" Plug 'moll/vim-node', { 'for': ['javascript', 'typescript', 'jsx'] } " node tools - go to module def, etc.
" Plug 'ruanyl/vim-fixmyjs', { 'for': ['javascript', 'jsx', 'vue'] } " runs eslint fix via :Fixmyjs
" if executable('tsc') | Plug 'Shougo/vimproc.vim', { 'do': 'make', 'for': 'typescript' } | Plug 'Quramy/tsuquyomi', { 'for': 'typescript' } | endif " typescript omnicompletion, custom jump to def, custom syntax erroring
" Plug 'sekel/vim-vue-syntastic' " let syntastic play nice with vue files
Plug 'tpope/vim-jdaddy' "`gqaj` to pretty-print json, `gwaj` to merge the json object in the clipboard with the one under the cursor
" Plug 'chemzqm/vim-jsx-improve' " better jsx formatting
Plug 'flowtype/vim-flow' " flowtype omnicompletion. If not using flow in a project, add this to project .vimrc: let g:flow#enable = 0
Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' } " javascript omnifunc and jump to def. requires a .tern-project file. http://ternjs.net/doc/manual.html#configuration
Plug 'othree/javascript-libraries-syntax.vim' " syntax completion for common libraries (react, lodash, jquery, etc.)
Plug 'kristijanhusak/vim-js-file-import' " Go to definition: <leader>ig Import file: <Leader>if
" }}}

" Syntax highlighting {{{
" Plug 'sheerun/vim-polyglot' " just about every filetype under the sun in one package
Plug 'zimbatm/haproxy.vim' " haproxy syntax
Plug 'stephpy/vim-yaml' " faster yaml syntax highlighting
Plug 'fpob/nette.vim' " .neon format
Plug 'pangloss/vim-javascript' " Vastly improved Javascript indentation and syntax support in Vim.
" Plug 'othree/yajs.vim', { 'for': ['javascript', 'jsx', 'vue'] } " additonal javascript syntax highlighting. jsx is included in polyglot above.
" Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' } " typescript syntax, etc. based on yajs
" Plug 'mxw/vim-jsx'
Plug 'MaxMEllon/vim-jsx-pretty'
" Plug 'elixir-editors/vim-elixir'
" Plug 'othree/es.next.syntax.vim', { 'for': ['javascript', 'jsx', 'vue'] }
Plug 'StanAngeloff/php.vim' " php 5.6+ (including 7.x) syntax highlighting improvements like docblocks
Plug 'tpope/vim-git' " vim git syntax, indent, and filetypes
Plug 'posva/vim-vue' " vue.js syntax
" Plug 'digitaltoad/vim-pug', { 'for': ['pug', 'jade'] } " pug (formerly jade) highlighting
" Plug 'heavenshell/vim-syntax-flowtype' " js flowtype (included in pangloss/vim-javascript)
Plug 'rhysd/vim-gfm-syntax' " github-flavored markdown. yum!
Plug 'osyo-manga/vim-precious' | Plug 'Shougo/context_filetype.vim' " code block syntax highlighting for markdown
Plug 'qnighy/vim-ssh-annex' " ssh files syntax coloring e.g. ssh config
" Plug 'evanmiller/nginx-vim-syntax' " nginx conf syntax
" Plug 'darfink/vim-plist' " plist syntax
Plug 'rodjek/vim-puppet'
" }}}

" Visuals {{{
Plug 'vim-airline/vim-airline' " better status bar
Plug 'vim-airline/vim-airline-themes' " pretty colors for airline
" Plug 'nathanaelkane/vim-indent-guides' " show vertical indent guides for levels of indentations
" Plug 'mikedfunk/vim-indent-guides' " my fork to enable color guessing with termguicolors
Plug 'Yggdroot/indentLine' " show vertical lines for levels of indentions
" Plug 'thaerkh/vim-indentguides' " faster indent guides (lately it's only been showing every other one. Also they disappear when reloading vimrc.)
" Plug 'edkolev/tmuxline.vim', { 'on': ['Tmuxline', 'TmuxlineSnapshot'] } " tmux statusline file generator
" Plug 'edkolev/promptline.vim', { 'on': ['Promptline', 'PromptlineSnapshot'] } " custom bash prompt in sync with airline
" Plug 'ntpeters/vim-better-whitespace' " highlight tabs and trailing whitespace. Slows down typing considerably though!
" Plug 'thirtythreeforty/lessspace.vim' " remove trailing whitespace only on lines you edit. Messes up paste indent!
" Plug 'dodie/vim-disapprove-deep-indentation', { 'for': ['php', 'ruby'] } " too much indentation = ಠ_ಠ . messes up the quantum theme I use for saatchi
" Plug 'xolox/vim-colorscheme-switcher' " F8 for next, Shift-F8 for previous color scheme
" Plug 'chxuan/change-colorscheme' " :NextColorScheme :PreviousColorScheme
" Plug 'osyo-manga/vim-brightest' " highlight matching words. 1.5 seconds to load!
" Plug 'dominikduda/vim_current_word' " highlight matching words. More intelligent.
Plug 'itchyny/vim-cursorword' " highlight matching words. What I like about this one is it keeps the same color and bold/italic.
" Plug 'elqatib/remaining-todos.vim' " when remaining todos in a file, flash a message before closing a buffer
Plug 'ap/vim-css-color', { 'for': ['scss', 'css'] } " colorize css colors e.g. #333 with the actual color in the background
" Plug 'chrisbra/NrrwRgn' " work in a separate window with a sub-region of a document. :NR

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
Plug 'sonph/onehalf', { 'rtp': 'vim' }
" Plug 'archSeer/colibri.vim'
" Plug 'fenetikm/falcon'
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
" Plug 'dracula/vim' " base16 version available
" Plug 'fcpg/vim-fahrenheit'
" Plug 'jacoborus/tender.vim'
" Plug 'kamwitsta/nordisk'
" Plug 'lifepillar/vim-solarized8'
" Plug 'mbbill/vim-seattle'
" Plug 'mhartington/oceanic-next' " base16 version available
" Plug 'morhetz/gruvbox'
" Plug 'rakr/vim-one'
" Plug 'raphamorim/lucario'
" Plug 'roosta/vim-srcery'
" Plug 'tpope/vim-vividchalk'
" Plug 'alessandroyorba/sierra'
" Plug 'ayu-theme/ayu-vim'
Plug 'chriskempson/base16-vim' " themes made of 16 colors
Plug 'kristijanhusak/vim-hybrid-material'
" Plug 'tyrannicaltoucan/vim-quantum'
" Plug 'cocopon/iceberg.vim'
" }}}
" }}}

" Vim-plug close {{{
call plug#end()
" }}}
