-- vim: set fdm=marker:
-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- setup {{{
-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

local g, fn = vim.g, vim.fn
local has, executable = fn.has, fn.executable

return require('packer').startup(function()
  use {'wbthomason/packer.nvim'}
-- }}}

  -- ctags and completion {{{
  use {'ludovicchabant/vim-gutentags'} -- auto ctags runner. no lazy load.
  use {'liuchengxu/vista.vim', opt = true} -- like tagbar for lsp symbols
  use {'Shougo/echodoc.vim'} -- Displays function signatures from completions in the command line. Really helpful for omnicompletion!
  use {'neovim/nvim-lspconfig'} -- official language server protocol config
  -- use {'RishabhRD/popfix'}
  -- use {'RishabhRD/nvim-lsputils'} -- better code action selector, better references window, etc. (Breaks references even if references are disabled. `t` no longer works to open a reference in a tab.)
  -- }}}

  -- General {{{
  use {'antoinemadec/FixCursorHold.nvim'} -- improve performance of CursorHold event
  use {'mbbill/undotree', opt = true, cmd = {'UndotreeToggle'}} -- show a sidebar with branching undo history so you can redo on a different branch
  use {'dense-analysis/ale'} -- linter, fixer, and even lsp client
  use {'tpope/vim-surround'} -- surround text in quotes or something
  use {'tpope/vim-repeat'} -- repeat some things you wouldn't otherwise be able to
  use {'kreskij/Repeatable.vim'} -- make mappings repeatable easily
  use {'vim-scripts/BufOnly.vim', opt = true, cmd = {'BufOnly', 'Bufonly'}} -- close all buffers but the current one
  use {'tpope/vim-commentary'} -- toggle comment with `gcc`. in my case I use `<leader>c<space>` which is the NERDCommenter default
  use {'tpope/vim-unimpaired'} -- lots of useful, basic keyboard shortcuts

  if has('python3') then
    use {'SirVer/ultisnips'} -- snippet system
  end

  use {'jeromedalbert/auto-pairs', branch = 'better-auto-pairs'} -- Auto insert closing brackets and parens. Fork, see https://www.reddit.com/r/vim/comments/adv2h0/do_you_use_a_custom_fork_of_autopairs_how_is_it/
  use {'sickill/vim-pasta'} -- paste with context-sensitive indenting
  use {'tpope/vim-eunuch', opt = true, cmd = {'Mkdir', 'Remove'}} -- directory shortcuts
  use {'skywind3000/asyncrun.vim'} -- run commands, etc asynchronously
  use {'milkypostman/vim-togglelist'} -- toggle quickfix and location lists. barely a plugin.
  use {'diepm/vim-rest-console'} -- like above but more capable (latest version) NOTE see ~/.yadm/bootstrap for notes on wuzz as a replacement for this. NOTE: { 'for': 'rest' } prevents this from setting filetypes correctly
  use {'AndrewRadev/splitjoin.vim'} -- split and join php arrays to/from multiline/single line (gS, gJ) SO USEFUL! Doesn't like being loaded by filetype :/
  use {'tpope/vim-endwise'} -- auto add end/endif for vimscript/ruby. no lazy load or per-filetype load.
  use {'tpope/vim-tbone', opt = true, cmd = {'Tmux', 'Tput', 'Tyank', 'Twrite', 'Tattach'}} -- do stuff with tmux like send visual text to a split. Handy for repls.
  use {'tpope/vim-rsi'} -- readline mappings for insert and command modes

  if has('python3') then
    use {'raghur/vim-ghost', opt = true, run = ':GhostInstall'} -- manually connect a text field with neovim. I like this better because it doesn't vimify _all_ of my input areas.
  end

  use {'Jorengarenar/vim-SQL-UPPER'} -- uppercase sql keywords in sql files
  -- }}}

  -- html {{{
  use {'docunext/closetag.vim', ft = {'html', 'xml', 'html.twig', 'blade', 'php', 'phtml', 'javascript.jsx'}} -- auto close tags by typing </ . different from auto-pairs.
  use {'andymass/vim-matchup'} -- " better matchit and match highlighter
  -- }}}

  -- navigation and search {{{
  use {'mhinz/vim-startify'} -- better vim start screen
  use {'junegunn/fzf'} -- fuzzy finder
  use {'junegunn/fzf.vim'} -- fuzzy finder
  use {'jesseleite/vim-agriculture'} -- Add :AgRaw to search with args
  use {'tpope/vim-abolish'} -- search and replace for various naming types e.g. :S/someWord/someOtherWord/g
  use {'michaeljsmith/vim-indent-object'} -- select in indentation level e.g. vii

  if executable('nnn') then
    use {'mcchrish/nnn.vim'}
  end

  use {'justinmk/vim-ipmotion'} -- makes blank line with spaces only the end of a paragraph
  use {'machakann/vim-swap'} -- move args left/right with g< g> or gs for interactive mode
  use {'EinfachToll/DidYouMean'} -- tries to help opening mistyped files
  use {'unblevable/quick-scope'} -- highlights chars for f, F, t, T
  use {'wfxr/minimap.vim'} -- another minimap but faster, written in rust
  use {'wellle/targets.vim'} -- Adds selection targets like vi2) or vI} to avoid whitespace
  use {'tpope/vim-obsession'} -- auto save sessions if you :Obsess
  use {'AndrewRadev/undoquit.vim'} -- another one to reopen closed buffers/windows/tabs: <c-w>u
  use {'frioux/vim-lost', branch = 'main'} -- gL to see what function you're in. I use this in php sometimes to avoid expensive similar functionality in vim-airline.
  use {'lifepillar/vim-cheat40'} -- Customizable cheatsheet. Mine is in ~/.vim/plugged/cheat40.txt. Open cheatsheet with <leader>? . I use this to avoid written cheatsheets on my desk for refactor tools and vdebug.
  -- }}}

  -- php {{{
  if has('python3') then
      use {'vim-vdebug/vdebug', opt = true, ft = 'php'} -- debug php
  end

  use {'iusmac/vim-php-namespace'} -- insert use statements (maintained fork) (doesn't like to be loaded by ft)
  use {'phpactor/phpactor', opt = true, ft = 'php', branch = 'master', run = 'composer install --no-dev --optimize'}

  if has('python3') then
    use {'trendfischer/vim-phpqa', opt = true, ft = 'php'} -- maintained fork
    use {'adoy/vim-php-refactoring-toolbox', opt = true, ft = 'php'}
  end

  use {'noahfrederick/vim-laravel', opt = true, ft = 'php'} -- mostly junk commands like :Artisan but useful for gf improvement for config, blade template names, and translation keys
  -- }}}

  -- projects and tasks {{{
  use {'tpope/vim-projectionist'} -- link tests and classes together
  use {'sgur/vim-editorconfig'} -- faster version of editorconfig
  use {'scrooloose/vim-orgymode'} -- kind of like emacs org-mode. <c-c> will toggle markdown checkbox. Also some syntax highlighting and ultisnips snippets. I use it in my notes.
  -- }}}

  -- git {{{
  if executable('git') then
    use {'mhinz/vim-signify'} -- show git changes in sidebar
    use {'tpope/vim-fugitive'} -- git integration
    use {'shumphrey/fugitive-gitlab.vim'} -- fugitive + gitlab
    use {'tommcdo/vim-fubitive'} -- fugitive + bitbucket
    use {'tpope/vim-rhubarb'} -- fugitive + github
    use {'rhysd/committia.vim'} -- prettier commit editor. Really cool!
    use {'hotwatermorning/auto-git-diff'} -- cool git rebase diffs per commit
    use {'tpope/vim-git'} -- Git file mappings and functions (e.g. rebase helpers) and syntax highlighting, etc. I add mappings in my plugin config.
    use {'wting/gitsessions.vim'} -- sessions based on git branches!
    use {'APZelos/blamer.nvim'} -- yet another git blame virtual text plugin
    use {'mattn/webapi-vim'}
    use {'mattn/vim-gist'} -- :Gist to create a github gist
  end
  -- }}}

  -- javascript {{{
  use {'tpope/vim-jdaddy'} --`gqaj` to pretty-print json, `gwaj` to merge the json object in the clipboard with the one under the cursor
  use {'MaxMEllon/vim-jsx-pretty'} -- jsx formatting (NOT in vim-polyglot)
  use {'tpope/vim-apathy'} -- tweak built-in vim features to allow jumping to javascript (and others) module location with gf
  use {'styled-components/vim-styled-components', branch = 'main'} -- styled-components support
  use {'kristijanhusak/vim-js-file-import'} -- ctags-based importing
  -- }}}

  -- syntax highlighting {{{
  use {'gerw/vim-HiLinkTrace'} -- adds an <leader>hlt command to get all highlight groups under cursor
  -- annoyingly this must be loaded before polyglot is loaded :/
  -- this commit broke my php rendering until I disabled graphql https://github.com/sheerun/vim-polyglot/commit/c228e993ad6a8b79db5a5a77aecfdbd8e92ea31f
  g['polyglot_disabled'] = {'graphql', 'rst'}
  use {'sheerun/vim-polyglot'} -- just about every filetype under the sun in one package
  use {'neoclide/jsonc.vim'} -- jsonc syntax
  use {'fpob/nette.vim'} -- .neon format
  use {'rhysd/vim-gfm-syntax'} -- github-flavored markdown
  use {'qnighy/vim-ssh-annex'} -- ssh files syntax coloring e.g. ssh config
  use {'itchyny/vim-highlighturl'} -- just highlight urls like in a browser
  -- }}}

  -- visuals {{{
  use {'vim-airline/vim-airline'} -- better status bar
  use {'vim-airline/vim-airline-themes'} -- pretty colors for airline
  use {'Yggdroot/indentLine'} -- show vertical lines for levels of indentions
  use {'lukas-reineke/indent-blankline.nvim'} -- works with above plugin to include indent symbols on blank lines. finally!

  if executable('tmux') then
      use {'edkolev/tmuxline.vim'} -- tmux statusline file generator
  end

  use {'chxuan/change-colorscheme'} -- :NextColorScheme :PreviousColorScheme
  use {'itchyny/vim-cursorword'} -- highlight matching words. What I like about this one is it keeps the same color and bold/italic.
  use {'ap/vim-css-color', ft = {'scss', 'css'}} -- colorize css colors e.g. #333 with the actual color in the background
  use {'ryanoasis/vim-devicons'} -- file type icons in netrw, etc.
  use {'junegunn/goyo.vim'}
  use {'junegunn/limelight.vim'} -- focus mode

  use {'chriskempson/base16-vim'} -- themes made of 16 colors
  use {'flazz/vim-colorschemes'} -- a bunch of colorschemes from vim.org
  -- }}}

-- wrapup {{{
end)
-- }}}
