-- vim: set fdm=marker:
local g, cmd, has, executable = vim.g, vim.cmd, vim.fn.has, vim.fn.executable
local stdpath, mkdir, system, input = vim.fn.stdpath, vim.fn.mkdir, vim.fn.system, vim.fn.input

-- offer to install packer if it's not installed {{{
-- https://github.com/lucax88x/configs/blob/e585f0f6bf057675d3765f5a7d5deec85cdc03af/dotfiles/.config/nvim/nvim/lua/lt/plugins.lua
-- Only required if you have packer in your `opt` pack
local is_packer_installed = pcall(cmd, [[packadd packer.nvim]])

if not is_packer_installed then
  if input("Download Packer? (y for yes)") ~= "y" then
    return
  end

  local directory = string.format(
    '%s/site/pack/packer/opt/',
    stdpath('data')
  )

  mkdir(directory, 'p')

  local out = system(string.format(
    'git clone %s %s',
    'https://github.com/wbthomason/packer.nvim',
    directory .. '/packer.nvim'
  ))

  print(out)
  print("Downloading packer.nvim...")

  return
end
-- }}}

local function_definitions = function()
  use {'wbthomason/packer.nvim'}

  -- package definitions {{{

  -- use {'Shougo/echodoc.vim'} -- Displays function signatures from completions in the command line. Really helpful for omnicompletion! (hopefully no longer needed with lsp and signature help)
  -- use {'mcchrish/nnn.vim'} -- shim to browse with nnn terminal file browser
  -- use {'nvim-lua/completion-nvim'} -- completion helper for nvim lsp (I've reinstalled and uninstalled this about 5x. I prefer to choose my type of completion: omni, buffer, spell, line, etc.)
  -- use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim', {'nvim-lua/plenary.nvim'}}}} -- fuzzy searcher (doesn't provide any more capabilities than fzf for me)
  -- use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'} -- unlocks a world of possibilities (Bug in latest version: attempt to call add_directive, a nil value. Related? https://github.com/nvim-treesitter/nvim-treesitter/issues/759)
  -- use {'tjdevries/nlua.nvim'} -- hopefully better lua lsp than the high cpu sumneko. (I couldn't even get it to work at all)
  g['polyglot_disabled'] = {'graphql', 'rst'} -- annoyingly this config must be loaded before polyglot is loaded :/ this commit broke my php rendering until I disabled graphql https://github.com/sheerun/vim-polyglot/commit/c228e993ad6a8b79db5a5a77aecfdbd8e92ea31f
  use {'APZelos/blamer.nvim'} -- yet another git blame virtual text plugin
  use {'AndrewRadev/splitjoin.vim'} -- split and join php arrays to/from multiline/single line (gS, gJ) SO USEFUL! Doesn't like being loaded by filetype :/
  use {'AndrewRadev/undoquit.vim'} -- another one to reopen closed buffers/windows/tabs: <c-w>u
  use {'MaxMEllon/vim-jsx-pretty'} -- jsx formatting (NOT in vim-polyglot)
  use {'Yggdroot/indentLine'} -- show vertical lines for levels of indentions
  use {'andymass/vim-matchup'} -- " better matchit and match highlighter
  use {'antoinemadec/FixCursorHold.nvim'} -- improve performance of CursorHold event
  use {'ap/vim-css-color', ft = {'scss', 'css'}} -- colorize css colors e.g. #333 with the actual color in the background
  use {'chriskempson/base16-vim'} -- themes made of 16 colors
  use {'dense-analysis/ale'} -- linter, fixer, even lsp implementation. TODO I only have this here temporarily until I can get built-in lsp diagnostics with diagnosticls working.
  use {'diepm/vim-rest-console'} -- like above but more capable (latest version) NOTE see ~/.yadm/bootstrap for notes on wuzz as a replacement for this. NOTE: { 'for': 'rest' } prevents this from setting filetypes correctly
  use {'docunext/closetag.vim', ft = {'html', 'xml', 'html.twig', 'blade', 'php', 'phtml', 'javascript.jsx'}} -- auto close tags by typing </ . different from auto-pairs.
  use {'euclidianAce/BetterLua.vim'} -- recommended better lua syntax highlighting https://github.com/tjdevries/nlua.nvim
  use {'fpob/nette.vim'} -- .neon format
  use {'frioux/vim-lost', branch = 'main'} -- gL to see what function you're in. I use this in php sometimes to avoid expensive similar functionality in vim-airline or lsp. TODO use lsp + airline
  use {'hotwatermorning/auto-git-diff'} -- cool git rebase diffs per commit
  use {'itchyny/vim-cursorword'} -- highlight matching words. What I like about this one is it keeps the same color and bold/italic.
  use {'itchyny/vim-highlighturl'} -- just highlight urls like in a browser
  use {'iusmac/vim-php-namespace'} -- insert use statements (maintained fork) (doesn't like to be loaded by ft)
  use {'jeromedalbert/auto-pairs', branch = 'better-auto-pairs'} -- Auto insert closing brackets and parens. Fork, see https://www.reddit.com/r/vim/comments/adv2h0/do_you_use_a_custom_fork_of_autopairs_how_is_it/
  use {'jesseleite/vim-agriculture'} -- Add :AgRaw to search with args
  use {'junegunn/fzf', run = './install --all'} -- fuzzy finder
  use {'junegunn/fzf.vim'} -- fuzzy finder
  use {'junegunn/vim-peekaboo'} -- preview registers
  use {'justinmk/vim-ipmotion'} -- makes blank line with spaces only the end of a paragraph
  use {'kreskij/Repeatable.vim'} -- make mappings repeatable easily (I use this to open/close vdebug trees)
  use {'kristijanhusak/vim-js-file-import'} -- ctags-based importing
  use {'lambdalisue/fern.vim', requires = {{'lambdalisue/fern-hijack.vim'}, {'lambdalisue/fern-renderer-nerdfont.vim'}, {'lambdalisue/nerdfont.vim'}}} -- file browser
  use {'lifepillar/vim-cheat40'} -- Customizable cheatsheet. Mine is in ~/.vim/plugged/cheat40.txt. Open cheatsheet with <leader>? . I use this to avoid written cheatsheets on my desk for refactor tools and vdebug.
  use {'liuchengxu/vim-which-key'} -- show keybindings on <leader> in a popup
  use {'liuchengxu/vista.vim'} -- like tagbar for lsp symbols
  use {'ludovicchabant/vim-gutentags'} -- auto ctags runner. no lazy load.
  use {'lukas-reineke/indent-blankline.nvim'} -- works with above plugin to include indent symbols on blank lines. finally!
  use {'machakann/vim-swap'} -- move args left/right with g< g> or gs for interactive mode
  use {'mbbill/undotree', cmd = 'UndotreeToggle'} -- show a sidebar with branching undo history so you can redo on a different branch
  use {'mhinz/vim-signify'} -- show git changes in sidebar
  use {'mhinz/vim-startify'} -- better vim start screen
  use {'michaeljsmith/vim-indent-object'} -- select in indentation level e.g. vii
  use {'milkypostman/vim-togglelist'} -- toggle quickfix and location lists. barely a plugin.
  use {'neovim/nvim-lspconfig'} -- official language server protocol config
  use {'ojroques/nvim-lspfuzzy', branch = 'main'} -- fuzzy find lsp stuff. This is especially helpful for searching all symbols or finding references.
  use {'rhysd/committia.vim'} -- prettier commit editor. Really cool!
  use {'rhysd/vim-gfm-syntax'} -- github-flavored markdown
  use {'ryanoasis/vim-devicons'} -- file type icons in netrw, etc.
  use {'scrooloose/vim-orgymode'} -- kind of like emacs org-mode. <c-c> will toggle markdown checkbox. Also some syntax highlighting and ultisnips snippets. I use it a lot in my notes.
  use {'sgur/vim-editorconfig'} -- faster version of editorconfig
  use {'sheerun/vim-polyglot'} -- just about every filetype under the sun in one package
  use {'sickill/vim-pasta'} -- paste with context-sensitive indenting
  use {'skywind3000/asyncrun.vim'} -- run commands, etc asynchronously
  use {'styled-components/vim-styled-components', branch = 'main'} -- styled-components support
  use {'tpope/vim-abolish'} -- search and replace for various naming types e.g. :S/someWord/someOtherWord/g
  use {'tpope/vim-apathy'} -- tweak built-in vim features to allow jumping to javascript (and others) module location with gf
  use {'tpope/vim-commentary'} -- toggle comment with `gcc`. in my case I use `<leader>c<space>` which is the NERDCommenter default
  use {'tpope/vim-endwise'} -- auto add end/endif for vimscript/ruby. no lazy load or per-filetype load.
  use {'tpope/vim-eunuch', cmd = {'Mkdir', 'Remove'}} -- directory shortcuts
  use {'tpope/vim-fugitive'} -- git integration
  use {'tpope/vim-git'} -- Git file mappings and functions (e.g. rebase helpers) and syntax highlighting, etc. I add mappings in my plugin config.
  use {'tpope/vim-jdaddy'} --`gqaj` to pretty-print json, `gwaj` to merge the json object in the clipboard with the one under the cursor
  use {'tpope/vim-projectionist'} -- link tests and classes together
  use {'tpope/vim-rhubarb'} -- fugitive github integration
  use {'tpope/vim-surround'} -- surround text in quotes or something
  use {'tpope/vim-unimpaired'} -- lots of useful, basic keyboard shortcuts
  use {'unblevable/quick-scope'} -- highlights chars for f, F, t, T
  use {'vim-airline/vim-airline'} -- better status bar
  use {'vim-airline/vim-airline-themes'} -- pretty colors for airline
  use {'vim-scripts/BufOnly.vim', cmd = {'BufOnly', 'Bufonly'}} -- close all buffers but the current one
  use {'wellle/targets.vim'} -- Adds selection targets like vi2) or vI} to avoid whitespace

  if has('python3') then
    use {'SirVer/ultisnips'} -- snippet system
    use {'vim-vdebug/vdebug', ft = 'php'} -- debug php
    use {'raghur/vim-ghost', opt = true, run = ':GhostInstall'} -- manually connect a text field with neovim. I like this better because it doesn't vimify _all_ of my input areas.
  end
  -- }}}
end

return require'packer'.startup(function_definitions)
