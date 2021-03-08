" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
local package_path_str = "/Users/mikefunk/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/mikefunk/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/mikefunk/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/mikefunk/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/mikefunk/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

_G.packer_plugins = {
  ["BetterLua.vim"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/BetterLua.vim"
  },
  ["BufOnly.vim"] = {
    commands = { "BufOnly", "Bufonly" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/opt/BufOnly.vim"
  },
  ale = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/ale"
  },
  ["auto-git-diff"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/auto-git-diff"
  },
  ["auto-pairs"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/auto-pairs"
  },
  ["base16-vim"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/base16-vim"
  },
  ["blamer.nvim"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/blamer.nvim"
  },
  ["closetag.vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/opt/closetag.vim"
  },
  ["committia.vim"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/committia.vim"
  },
  ["context_filetype.vim"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/context_filetype.vim"
  },
  fzf = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/fzf.vim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  indentLine = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/indentLine"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["nette.vim"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/nette.vim"
  },
  ["nvim-bqf"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/nvim-bqf"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["splitjoin.vim"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/opt/splitjoin.vim"
  },
  ultisnips = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/ultisnips"
  },
  undotree = {
    commands = { "UndotreeToggle" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/opt/undotree"
  },
  vdebug = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/opt/vdebug"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-abolish"
  },
  ["vim-agriculture"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-agriculture"
  },
  ["vim-airline"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-airline"
  },
  ["vim-airline-themes"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-airline-themes"
  },
  ["vim-apathy"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-apathy"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-conjoin"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-conjoin"
  },
  ["vim-css-color"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/opt/vim-css-color"
  },
  ["vim-cursorword"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-cursorword"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-devicons"
  },
  ["vim-editorconfig"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-editorconfig"
  },
  ["vim-endwise"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-endwise"
  },
  ["vim-eunuch"] = {
    commands = { "Mkdir", "Remove" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/opt/vim-eunuch"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-gfm-syntax"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-gfm-syntax"
  },
  ["vim-ghost"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/opt/vim-ghost"
  },
  ["vim-git"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-git"
  },
  ["vim-gutentags"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-gutentags"
  },
  ["vim-highlighturl"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-highlighturl"
  },
  ["vim-indent-object"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-indent-object"
  },
  ["vim-ipmotion"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-ipmotion"
  },
  ["vim-jdaddy"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-jdaddy"
  },
  ["vim-lost"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-lost"
  },
  ["vim-matchup"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-matchup"
  },
  ["vim-orgymode"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-orgymode"
  },
  ["vim-pasta"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-pasta"
  },
  ["vim-php-namespace"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-php-namespace"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-polyglot"
  },
  ["vim-precious"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-precious"
  },
  ["vim-projectionist"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-projectionist"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-rest-console"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-rest-console"
  },
  ["vim-rhubarb"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-rhubarb"
  },
  ["vim-signify"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-signify"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-startify"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-swap"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-swap"
  },
  ["vim-togglelist"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-togglelist"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-unimpaired"
  },
  ["vim-vinegar"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vim-vinegar"
  },
  ["vista.vim"] = {
    loaded = true,
    path = "/Users/mikefunk/.local/share/nvim/site/pack/packer/start/vista.vim"
  }
}


-- Command lazy-loads
vim.cmd [[command! -nargs=* -range -bang -complete=file UndotreeToggle lua require("packer.load")({'undotree'}, { cmd = "UndotreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file BufOnly lua require("packer.load")({'BufOnly.vim'}, { cmd = "BufOnly", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Bufonly lua require("packer.load")({'BufOnly.vim'}, { cmd = "Bufonly", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Mkdir lua require("packer.load")({'vim-eunuch'}, { cmd = "Mkdir", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Remove lua require("packer.load")({'vim-eunuch'}, { cmd = "Remove", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
vim.cmd [[au FileType html.twig ++once lua require("packer.load")({'closetag.vim'}, { ft = "html.twig" }, _G.packer_plugins)]]
vim.cmd [[au FileType blade ++once lua require("packer.load")({'closetag.vim'}, { ft = "blade" }, _G.packer_plugins)]]
vim.cmd [[au FileType html ++once lua require("packer.load")({'closetag.vim', 'splitjoin.vim'}, { ft = "html" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascript.jsx ++once lua require("packer.load")({'closetag.vim'}, { ft = "javascript.jsx" }, _G.packer_plugins)]]
vim.cmd [[au FileType php ++once lua require("packer.load")({'closetag.vim', 'vdebug', 'splitjoin.vim'}, { ft = "php" }, _G.packer_plugins)]]
vim.cmd [[au FileType scss ++once lua require("packer.load")({'vim-css-color'}, { ft = "scss" }, _G.packer_plugins)]]
vim.cmd [[au FileType css ++once lua require("packer.load")({'vim-css-color'}, { ft = "css" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascript ++once lua require("packer.load")({'splitjoin.vim'}, { ft = "javascript" }, _G.packer_plugins)]]
vim.cmd [[au FileType phtml ++once lua require("packer.load")({'closetag.vim'}, { ft = "phtml" }, _G.packer_plugins)]]
vim.cmd [[au FileType xml ++once lua require("packer.load")({'closetag.vim'}, { ft = "xml" }, _G.packer_plugins)]]
vim.cmd("augroup END")
END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
