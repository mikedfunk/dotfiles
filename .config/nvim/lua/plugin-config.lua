-- vim: set fdm=marker:

-- setup {{{
local fn, g, cmd, lsp = vim.fn, vim.g, vim.cmd, vim.lsp
local has_key, has, executable, exists, getenv, expand, getcwd = fn.has_key, fn.has, fn.executable, fn.exists, fn.getenv, fn.expand, fn.getcwd
local nvim_set_keymap, nvim_buf_set_keymap = vim.api.nvim_set_keymap, vim.api.nvim_buf_set_keymap
local call = vim.call

local helpers = require'helpers'
-- }}}

-- ale {{{
local function configure_ale()
  g['ale_cache_executable_check_failures'] = 1
  g['ale_lint_on_save'] = 1
  g['ale_lint_on_enter'] = 0
  g['ale_lint_on_filetype_changed'] = 0
  g['ale_lint_on_text_changed'] = 'never'
  g['ale_completion_autoimport'] = 1
  g['ale_php_cs_fixer_options'] = '--config=.php_cs'
  g['ale_sign_column_always'] = 1
  g['ale_sign_warning'] = '⚠️'
  g['ale_sign_error'] = '🚨'
  g['ale_sign_info'] = 'ℹ️'
  g['zenburn_high_Contrast'] = 1
  g['ale_virtualtext_cursor'] = 1
  g['ale_virtualtext_prefix'] = ' '
  g['ale_sign_highlight_linenrs'] = 1

  if helpers.is_plugin_installed('ale') then
    nvim_set_keymap('n', '[w', ':ALEPreviousWrap<cr>', {noremap = true, silent = true})
    nvim_set_keymap('n', ']w', ':ALENextWrap<cr>', {noremap = true, silent = true})

    nvim_set_keymap('n', '[e', ':ALEPrevious -error<cr>', {noremap = true, silent = true})
    nvim_set_keymap('n', ']e', ':ALENext -error<cr>', {noremap = true, silent = true})

    nvim_set_keymap('n', '<leader>al', ':ALELint<cr>', {noremap = true})
    nvim_set_keymap('n', '<leader>af', ':ALEFix<cr>', {noremap = true})
  end

  g['ale_hover_to_preview'] = 1

  g['ale_completion_symbols'] = {
    text = '',
    method = '',
    -- function = '',
    constructor = '',
    field = '',
    variable = '',
    class = '',
    interface = '',
    module = '',
    property = '',
    unit = 'unit',
    value = 'val',
    enum = '',
    keyword = 'keyword',
    snippet = '',
    color = 'color',
    file = '',
    reference = 'ref',
    folder = '',
    enum_member = '',
    constant = '',
    struct = '',
    event = 'event',
    operator = '',
    type_parameter = 'type param',
    -- <default> = 'v',
  }
  g['ale_completion_symbols']['function'] = ''
  g['ale_completion_symbols']['<default>'] = 'v'
  -- do not set the error sign background color to red. If I don't do this it looks weird with an emoji icon.
  cmd('highlight! link ALEErrorSign ALEWarningSign')

  -- strange that these are white by default - hard to differentiate between
  cmd('highlight! link ALEVirtualTextError Comment')
  cmd('highlight! link ALEVirtualTextWarning Comment')
  cmd('highlight! link ALEVirtualTextInfo Comment')
  cmd('highlight! link ALEVirtualTextStyleError Comment')
  cmd('highlight! link ALEVirtualTextStyleWarning Comment')

  -- rename bindings
  if helpers.is_plugin_installed('ale') then
    nvim_set_keymap('n', '<leader>rrv', 'ALERename<cr>', {noremap = true}) -- rename local variable
    nvim_set_keymap('n', '<leader>rrp', 'ALERename<cr>', {noremap = true}) -- rename class variable
    nvim_set_keymap('n', '<leader>rrm', 'ALERename<cr>', {noremap = true}) -- rename class method
  end
end
configure_ale()
-- }}}

-- base16-vim {{{
local function configure_base16_vim()
  if helpers.is_plugin_installed('base16-vim') then
    cmd('silent! colorscheme base16-atlas') -- very solarized-y but more colorful
  end
end
configure_base16_vim()
-- }}}

-- blamer.nvim {{{
local function configure_blamer()
  g['blamer_enabled'] = 1
  g['blamer_show_in_visual_modes'] = 0
  g['blamer_show_in_insert_modes'] = 0
  g['blamer_prefix'] = '    '
  g['blamer_relative_time'] = 1
end
configure_blamer()
-- }}}

-- echodoc.vim {{{
local function configure_echodoc()
  g['echodoc#enable_at_startup'] = 1
end
configure_echodoc()
-- }}}

-- editorconfig-vim {{{
local function configure_editorconfig()
  g['EditorConfig_exclude_patterns'] = {'fugitive://.*', 'scp://.*'} -- " work with fugitive. this should be default.
end
configure_editorconfig()
-- }}}

-- emmet-vim {{{
local function configure_emmet()
  g['user_emmet_settings'] = {
    javascript = {extends = 'jsx'},
    typescript = {extends = 'jsx'},
  }
end
configure_emmet()
-- }}}

-- float-preview {{{
local function configure_float_preview()
  g['float_preview#docked'] = 0
end
configure_float_preview()
-- }}}

-- fzf.vim {{{
local function configure_fzf()
  -- g['$FZF_DEFAULT_COMMAND'] = 'ag --files-with-matches --skip-vcs-ignores -g ""'
  local fzf_action = {}
  fzf_action['ctrl-t'] = 'tab split'
  fzf_action['ctrl-x'] = 'split'
  fzf_action['ctrl-v'] = 'vsplit'
  g['fzf_action'] = fzf_action
  g['fzf_buffers_jump'] = 1

  nvim_set_keymap('n', '<leader>ag', ':Ag<cr>', {noremap = true})
  nvim_set_keymap('n', '<leader>ff', ':Files<cr>', {noremap = true})
  nvim_set_keymap('n', '<leader>tt', ':Tags<cr>', {noremap = true})
  nvim_set_keymap('n', '<leader>hh', ':Helptags<cr>', {noremap = true})
end
configure_fzf()
-- }}}

-- gitsessions.vim {{{
local function configure_gitsessions()
  g['gitsessions_disable_auto_load'] = 1

  if helpers.is_plugin_installed('gitsessions.vim') then
      nvim_set_keymap('n', '<leader>ss', ':GitSessionSave<cr>', {noremap = true})
      nvim_set_keymap('n', '<leader>sl', ':GitSessionLoad<cr>', {noremap = true})
      nvim_set_keymap('n', '<leader>sd', ':GitSessionDelete<cr>', {noremap = true})
  end
end
configure_gitsessions()
-- }}}

-- goyo.vim + limelight.vim {{{
local function configure_goyo_and_limelight()
  g['limelight_paragraph_span'] = 1

  -- intentionally global
  function goyo_enter()
    if exists('$TMUX') == 1 then
      call('silent! !tmux set status off')
    end
    call('silent! Limelight')
  end

  -- intentionally global
  function goyo_leave()
    if exists('$TMUX') == 1 then
      call('silent! !tmux set status on')
    end
    call('silent! Limelight!')
  end

  -- TODO echoes some stuff for some reason :/
  -- cmd('augroup')
  -- cmd('autocmd! User GoyoEnter')
  -- cmd('autocmd! User GoyoLeave')
  -- cmd('autocmd User GoyoEnter silent! :lua goyo_enter()<cr>')
  -- cmd('autocmd User GoyoLeave silent! :lua goyo_leave()<cr>')
  -- cmd('augroup END')

  if helpers.is_plugin_installed('goyo.vim') then
    nvim_set_keymap('n', '<leader>fo', ':Goyo<cr>', {noremap = true}) -- pneumonic: (fo)cus mode
  end
end
configure_goyo_and_limelight()
-- }}}

-- minimap.vim {{{
local function configure_minimap()
  if helpers.is_plugin_installed('minimap.vim') then
      nvim_set_keymap('n', '<leader>mm', ':MinimapToggle<cr>', {noremap = true})
  end
end
configure_minimap()
-- }}}

-- nnn.vim {{{
local function configure_nnn()
  g['nnn#replace_netrw'] = 1
  g['nnn#set_default_mappings'] = 0

  local nnn_action = {}
  nnn_action['<c-t>'] = 'tab split'
  nnn_action['<c-x>'] = 'split'
  nnn_action['<c-v>'] = 'vsplit'
  g['nnn#action'] = nnn_action

  -- Floating window (neovim latest and vim with patch 8.2.191)
  g['nnn#layout'] = {
    window = {
      width = 0.9,
      height = 0.6,
      highlight = 'Debug',
    }
  }

  if helpers.is_plugin_installed('nnn.vim') then
    nvim_set_keymap('n', '-', ':NnnPicker %<cr>', {noremap = true})
    nvim_set_keymap('n', '<leader>ee', ':NnnPicker<cr>', {noremap = true})
    cmd('command! -bang -nargs=* -complete=file Ex NnnPicker <args>')
    cmd('command! -bang -nargs=* -complete=file Explore NnnPicker <args>')
  end
end
configure_nnn()
-- }}}

-- nvim-lspconfig {{{
local function configure_nvim_lspconfig()
  if helpers.is_plugin_installed('nvim-lspconfig') then

    local function preview_location_callback(_, method, result)
      if result == nil or vim.tbl_isempty(result) then
        vim.lsp.log.info(method, 'No location found')
        return nil
      end
      if vim.tbl_islist(result) then
        vim.lsp.util.preview_location(result[1])
      else
        vim.lsp.util.preview_location(result)
      end
    end

    -- intentionally global! preview the definition under the cursor
    local function peek_definition()
      local params = vim.lsp.util.make_position_params()
      return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
    end

    -- intentionally global! shared on_attach lua handler for nvim lsp
    function on_attach(client, bufnr)
      if helpers.is_plugin_installed('completion-nvim') then
        require'completion'.on_attach(client, bufnr)
      end
    end

    local lspconfig = require'lspconfig'

    if executable('intelephense') == 1 then
      lspconfig.intelephense.setup{
        settings = {
          intelephense = {
            environment = {phpVersion = "7.0.0"},
            completion = {
              insertUseDeclaration = true,
              fullyQualifyGlobalConstantsAndFunctions = true,
              triggerParameterHints = true
            },
            diagnostics = {run = {"onSave"}},
            format = {enable = true},
            files = {
              exclude = {
                "**/.git/**",
                "**/.svn/**",
                "**/.hg/**",
                "**/CVS/**",
                "**/.DS_Store/**",
                "**/node_modules/**",
                "**/bower_components/**",
                "**/vendor/**/{Tests,tests}/**",
                "**/.history/**",
                "**/vendor/**/vendor/**",
                -- below was added to the list
                "**/spec/**",
                "**/coverage/**"
              },
            },
            telemetry = {enabled = false},
            stubs = {
              -- available stubs: https://github.com/JetBrains/phpstorm-stubs
              -- added: couchbase, redis, memcached
              "apache",
              "bcmath",
              "bz2",
              "calendar",
              "com_dotnet",
              "Core",
              "ctype",
              "couchbase", -- added
              "curl",
              "date",
              "dba",
              "dom",
              "enchant",
              "exif",
              "fileinfo",
              "filter",
              "fpm",
              "ftp",
              "gd",
              "hash",
              "iconv",
              "imap",
              "interbase",
              "intl",
              "json",
              "ldap",
              "libxml",
              "mbstring",
              "mcrypt",
              "memcached", -- added
              "meta",
              "mssql",
              "mysqli",
              "oci8",
              "odbc",
              "openssl",
              "pcntl",
              "pcre",
              "PDO",
              "pdo_ibm",
              "pdo_mysql",
              "pdo_pgsql",
              "pdo_sqlite",
              "pgsql",
              "Phar",
              "posix",
              "pspell",
              "readline",
              "recode",
              "redis", -- added
              "Reflection",
              "regex",
              "session",
              "shmop",
              "SimpleXML",
              "snmp",
              "soap",
              "sockets",
              "sodium",
              "SPL",
              "sqlite3",
              "standard",
              "superglobals",
              "sybase",
              "sysvmsg",
              "sysvsem",
              "sysvshm",
              "tidy",
              "tokenizer",
              "wddx",
              "xml",
              "xmlreader",
              "xmlrpc",
              "xmlwriter",
              "Zend OPcache",
              "zip",
              "zlib"
            },
          },
          -- on_attach = on_attach,
        },
      }
    end

    if executable('solargraph') == 1 then
      lspconfig.solargraph.setup{}
    end

    if executable('docker-langserver') == 1 then
      lspconfig.dockerls.setup{}
    end

    if executable(getenv('HOME') .. '/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/bin/macOS/lua-language-server') == 1 then
      lspconfig.sumneko_lua.setup{
        cmd = {
            getenv('HOME') .. "/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/bin/macOS/lua-language-server",
            "-E",
            getenv('HOME') .. "/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/main.lua"
        }
      }
    end
  end
end
configure_nvim_lspconfig()
-- }}}

-- nvim-lsputils {{{
local function configure_nvim_lsputils()
  if helpers.is_plugin_installed('nvim-lsputils') then
    lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
    -- lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
    lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
    lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
    lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
    lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
    lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
    lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
  end
end
configure_nvim_lsputils()
-- }}}

-- nvim-treesitter {{{
local function configure_nvim_treesitter()
  if helpers.is_plugin_installed('nvim-treesitter') then
    require'nvim-treesitter.configs'.setup{}

    -- full example:
    --
    -- require'nvim-treesitter.configs'.setup {
    --   ensure_installed = { "javascript", "php" },
    --   highlight = { enable = true },
    --   incremental_selection = {
    --     enable = true,
    --     keymaps = {
    --       init_selection = "gnn",
    --       node_incremental = "grn",
    --       scope_incremental = "grc",
    --       node_decremental = "grm"
    --     },
    --   },
    --   refactor = {
    --     highlight_definitions = { enable = true },
    --     highlight_current_scope = { enable = true },
    --     smart_rename = {
    --       enable = true,
    --       keymaps = { smart_rename = "grr" }
    --     },
    --     navigation = {
    --       enable = true,
    --       keymaps = {
    --         goto_definition = "gnd",
    --         list_definitions = "gnD",
    --         goto_next_usage = "<a-*>",
    --         goto_previous_usage = "<a-#>"
    --       },
    --     },
    --   },
    --   textobjects = {
    --     select = {
    --       enable = true,
    --       keymaps = {
    --         ["af"] = "@function.outer",
    --         ["if"] = "@function.inner",
    --         ["ac"] = "@class.outer",
    --         ["ic"] = "@class.inner"
    --       },
    --     },
    --     move = {
    --       enable = true,
    --       goto_next_start = {
    --         ["]m"] = "@function.outer",
    --         ["]]"] = "@class.outer"
    --       },
    --       goto_next_end = {
    --         ["]M"] = "@function.outer",
    --         ["]["] = "@class.outer"
    --       },
    --       goto_previous_start = {
    --         ["[m"] = "@function.outer",
    --         ["[["] = "@class.outer"
    --       },
    --       goto_previous_end = {
    --         ["[M"] = "@function.outer",
    --         ["[]"] = "@class.outer"
    --       }
    --     }
    --   }
    -- }
  end
end
configure_nvim_treesitter()
-- }}}

-- packer.nvim {{{
local function configure_packer()
  nvim_set_keymap('n', '<leader>bi', ':PackerInstall<CR>', {noremap = true})
  nvim_set_keymap('n', '<leader>bc', ':PackerClean<CR>', {noremap = true})
  nvim_set_keymap('n', '<leader>bu', ':PackerSync<CR>', {noremap = true})
end
configure_packer()
-- }}}

-- php.vim {{{
local function configure_php()
  g['php_ignore_phpdoc'] = 0
end
configure_php()
-- }}}

-- phpactor {{{
local function configure_phpactor()
  g['phpactorPhpBin'] = getenv('HOME') .. "/.asdf/installs/php/7.4.7/bin/php"

  -- intentionally global
  function php_modify(transformer)
    cmd('update')
    cmd('silent !' .. g['phpactorPhpBin'] .. ' ' .. getenv('HOME') .. '/.vim/plugged/phpactor/bin/phpactor class:transform ' .. expand('%') .. ' --transform=' .. transformer)
  end

  -- intentionally global
  function php_fix_everything()
    cmd('call PHPConstructorArgumentMagic()')
    php_modify('implement_contracts')
    php_modify('fix_namespace_class_name')
    php_modify('add_missing_properties')
    cmd(':PhpactorImportMissingClasses')
  end

  -- intentionally global
  function phpactor_mappings()
    nvim_buf_set_keymap(0, 'n', '<leader>rsm', ':PhpactorContextMenu<CR>', {noremap = true})
    nvim_buf_set_keymap(0, 'n', '<leader>rcv', ':PhpactorChangeVisibility<CR>', {noremap = true})
    nvim_buf_set_keymap(0, 'n', ']v', ':PhpactorChangeVisibility<CR>', {noremap = true})
    nvim_buf_set_keymap(0, 'n', '<leader>rcf', ':lua php_fix_everything<CR>', {noremap = true})
    nvim_buf_set_keymap(0, 'n', '<leader>raa', ':lua php_modify("add_missing_properties")<CR>', {noremap = true})
    nvim_buf_set_keymap(0, 'n', '<leader>ric', ':lua php_modify("implement_contracts")<CR>', {noremap = true})
    nvim_buf_set_keymap(0, 'n', '<leader>rrc', ':PhpactorMoveFile<CR>', {noremap = true})
    nvim_buf_set_keymap(0, 'n', '<leader>rrd', ':lua php_modify()<CR>', {noremap = true})
    nvim_buf_set_keymap(0, 'n', '<leader>rcc', ':PhpactorCopyFile<CR>', {noremap = true})
    -- this could be better but just hover over the method name and press
    -- (r) for replace references. Otherwise I have to write a lot more
    -- code to skip one keypress.
    nvim_buf_set_keymap(0, 'n', '<leader>rrm', ':PhpactorContextMenu<CR>', {noremap = true})
    nvim_buf_set_keymap(0, 'n', '<leader>rem', ':PhpactorExtractMethod<CR>', {noremap = true})
    nvim_buf_set_keymap(0, 'v', '<leader>rem', ":'< , '>PhpactorExtractMethod<CR>", {noremap = true})
    nvim_buf_set_keymap(0, 'v', '<leader>rev', ":'< , '>PhpactorExtractExpression<CR>", {noremap = true})
    nvim_buf_set_keymap(0, 'n', '<leader>rev', ':PhpactorExtractExpression<CR>', {noremap = true})
    nvim_buf_set_keymap(0, 'n', '<leader>rei', ':PhpactorClassInflect<CR>', {noremap = true})
  end

  helpers.create_augroup('phpactor_mappings', {
    {'FileType', 'php', 'lua phpactor_mappings()'},
  })
end
configure_phpactor()
-- }}}

-- phpcomplete.vim {{{
local function configure_phpcomplete()
  if helpers.is_plugin_installed('phpcomplete.vim') then
    helpers.create_augroup('ignorecase_augroup', {
      {"FileType", "php", "setlocal omnifunc=phpcomplete#CompletePHP"},
    })
  end

  g['phpcomplete_enhance_jump_to_definition'] = 0 -- turned this off because it makes jumping to definition slow :/
  g['phpcomplete_remove_function_extensions'] = {'xslt_php_4'}
  g['phpcomplete_remove_constant_extensions'] = {'xslt_php_4'}
end
configure_phpcomplete()
-- }}}

-- quick-scope {{{
local function configure_quick_scope()
  g['qs_highlight_on_keys'] = {'f', 'F', 't', 'T'}
  g['qs_highlight_on_keys'] = {'f', 'F'}
end
configure_quick_scope()
-- }}}

-- tagbar {{{
local function configure_tagbar()
  g['tagbar_autofocus'] = 1
  g['tagbar_autoclose'] = 1
  g['tagbar_previewwin_pos'] = 'botright'

  if helpers.is_plugin_installed('tagbar') then
    nvim_set_keymap('n', '<leader>bb', ':TagbarToggle<CR>', {noremap = true, silent = true})
  end

  -- Configure Tagbar to user ripper-tags with ruby
  g['tagbar_type_ruby'] = {
    kinds = {
      'm:modules',
      'c:classes',
      'f:methods',
      'F:singleton methods',
      'C:constants',
      'a:aliases',
    },
    ctagsbin = 'ripper-tags',
    ctagsargs = {'-f', '-'},
  }
end
configure_tagbar()
-- }}}

-- tmuxline {{{
local function configure_tmuxline()
  g['tmuxline_preset'] = {
       a = {'🏠 #S'}, -- session name
       c = {
         '#{cpu_fg_color}#{cpu_icon}#[fg=default] #{ram_fg_color}#{ram_icon}#[fg=default] #{battery_color_charge_fg}#{battery_icon_charge}#[fg=default]', -- cpu, ram, battery
         '#(~/.support/docker-status.sh)',
       },
       win = {'#I', '#W'}, -- unselected tab
       cwin = {'#I', '#W#F'}, -- current tab
       x = {"#(TZ=Etc/UTC date '+%%R UTC')"}, -- UTC time
       y = {'%l:%M %p'}, -- local time
       z = {'%a', '%b %d'}, -- local date
  }

  if helpers.is_plugin_installed('tmuxline.vim') then
      -- apply tmuxline settings and snapshot to file
      cmd('command! MyTmuxline :Tmuxline | TmuxlineSnapshot! ~/.tmux/tmuxline.conf')
  end
end
configure_tmuxline()
-- }}}

-- ultisnips {{{
local function configure_ultisnips()
  g['snips_author'] = 'Michael Funk <mike.funk@leafgroup.com>'
  g['UltiSnipsEditSplit'] = 'vertical'
  g['UltiSnipsExpandTrigger'] = '<c-l>' -- default: <Tab>

  -- NOTE: do not mess with this config value, you are going to have a bad time.
  g['UltiSnipsSnippetDirectories'] = {
    'UltiSnips',
    getenv('HOME') .. '/.config/nvim/UltiSnips',
  }
  if helpers.is_plugin_installed('ultisnips') then
    nvim_set_keymap('i', '<c-j>', '<c-r>=UltiSnips#JumpForwards()<CR>', {noremap = true}) -- UltiSnips somehow forgets this mapping when I open a new file :/
  end
end
configure_ultisnips()
-- }}}

-- undotree {{{
local function configure_undotree()
  g['undotree_SetFocusWhenToggle'] = 1

  if helpers.is_plugin_installed('undotree') then
      nvim_set_keymap('n', '<leader>uu', ':UndotreeToggle<CR>', {noremap = true}) -- toggle undotree window
  end
end
configure_undotree()
-- }}}

-- vdebug {{{
local function configure_vdebug()
  g['vdebug_options'] = {
    timeout = 30,
    watch_window_style = 'compact',
    continuous_mode = 1,
    -- debug_file = '/tmp/xdebug.log',
    simplified_status = 1,
  }

  g['vdebug_keymap'] = {eval_visual = '<leader>ev'}

  -- intentionally global
  function fix_vdebug_highlights()
    cmd('highlight DbgBreakptLine term=reverse ctermfg=Black ctermbg=Green guifg=#000000 guibg=#00ff00')
    cmd('highlight DbgBreakptSign term=reverse ctermfg=Black ctermbg=Green guifg=#000000 guibg=#00ff00')
    cmd('highlight DbgCurrentLine term=reverse ctermfg=White ctermbg=Red guifg=#ffffff guibg=#ff0000')
    cmd('highlight DbgCurrentSign term=reverse ctermfg=White ctermbg=Red guifg=#ffffff guibg=#ff0000')
  end

  helpers.create_augroup('fix_vdebug_highlights', {
      {'FileType', 'php', 'lua fix_vdebug_highlights()'},
      {'ColorScheme', '*', 'lua fix_vdebug_highlights()'},
  })

  helpers.create_augroup('vdebug_watch_panel_larger', {
      {'Bufenter', 'DebuggerWatch', 'resize 999'},
      {'Bufenter', 'DebuggerStack', 'resize 999'},
  })

  if helpers.is_plugin_installed('vdebug') and helpers.is_plugin_installed('Repeatable.vim') then
    local function open_vdebug_trees()
      cmd("silent! " .. g['vdebug_options']["marker_closed_tree"] .. "/normal <cr><cr>")
    end

    local function close_vdebug_trees()
      cmd("silent! " .. g['vdebug_options']["marker_open_tree"] .. "/normal <cr><cr>")
    end

    -- TODO not a command?
    -- cmd('Repeatable nnoremap <leader>v+ :silent! lua open_vdebug_trees()<cr>')
    -- cmd('Repeatable nnoremap <leader>v- :silent! lua close_vdebug_trees()<cr>')
    cmd('nnoremap <leader>v+ :silent! lua open_vdebug_trees()<cr>')
    cmd('nnoremap <leader>v- :silent! lua close_vdebug_trees()<cr>')
  end
end
configure_vdebug()
-- }}}

-- vim-agriculture {{{
local function configure_vim_agriculture()
  if helpers.is_plugin_installed('vim-agriculture') then
    nvim_set_keymap('n', '<leader>gg', ':AgRaw<space>', {noremap = true})
    nvim_set_keymap('v', '<leader>gv', ':<Plug>AgRawVisualSelection<cr>', {noremap = true})
    nvim_set_keymap('n', '<leader>g*', ':<Plug>AgRawWordUnderCursor<cr>', {noremap = true})
  end
end
configure_vim_agriculture()
-- }}}

-- vim-airline {{{
local function configure_vim_airline()
  g['airline#extensions#vista#enabled'] = 1
  g['airline#extensions#tmuxline#enabled'] = 0
  g['airline#extensions#gutentags#enabled'] = 1
  g['airline_theme'] = 'base16'
  g['airline#extensions#ale#show_line_numbers'] = 0
  g['airline#extensions#ale#error_symbol'] = 'Errors:' -- default: E
  g['airline#extensions#ale#warning_symbol'] = 'Warnings:' -- default: W
  g['airline#extensions#fzf#enabled'] = 1
  g['airline#extensions#tagbar#enabled'] = 0 -- cool but slows down php
  g['airline#extensions#tmuxline#snapshot_file'] = getenv('HOME') .. '/.tmuxline.conf'

  g['airline#extensions#branch#format'] = 1 -- feature/foo -> foo
  g['airline_powerline_fonts'] = 1 -- airline use cool powerline symbols (this also makes vista.vim use powerline symbols)
  g['airline#extensions#whitespace#enabled'] = 1 -- show whitespace warnings
  g['airline_highlighting_cache'] = 1 -- cache syntax highlighting for better performance
  g['airline#extensions#tabline#enabled'] = 1 -- advanced tabline
  g['airline#extensions#tabline#close_symbol'] = '✕' -- configure symbol used to represent close button
  g['airline#extensions#tabline#tab_nr_type'] = 1 -- tab number
  g['airline#extensions#tabline#show_tab_count'] = 0 -- hide tab count on right
  g['airline#extensions#tabline#show_buffers'] = 0 -- shows buffers when no tabs
  g['airline#extensions#tabline#show_splits'] = 1 -- shows how many splits are in each tab and which split you're on
  g['airline#extensions#tabline#show_tab_type'] = 0 -- right side says either 'buffers' or 'tabs'
  g['airline#extensions#nvimlsp#enabled'] = 0 -- overlaps with ale
  g['airline#extensions#obsession#enabled'] = 1
  g['airline#extensions#searchcount#enabled'] = 1
  g['airline#extensions#wordcount#enabled'] = 0
  g['airline#extensions#fugitiveline#enabled'] = 1

  if helpers.is_plugin_installed('vim-airline') and helpers.is_plugin_installed('asyncrun.vim') then

    -- intentionally global
    function asyncrun_airline_init()
      g['airline_section_z'] = call('airline#section#create_right', {'%{g:asyncrun_status} ' .. g['airline_section_z']})
    end

    helpers.create_augroup('asyncrun_airline', {
      {'User', 'AirlineAfterInit', ':lua asyncrun_airline_init()'},
    })
  end
end
configure_vim_airline()
-- }}}

-- vim-commentary {{{
local function configure_vim_commentary()
  helpers.create_augroup('vim_commentary_config', {
    {'FileType', 'php', 'setlocal commentstring=//\\ %s'},
    {'FileType', 'haproxy', 'setlocal commentstring=#\\ %s'},
    {'FileType', 'neon', 'setlocal commentstring=#\\ %s'},
    {'FileType', 'gitconfig', 'setlocal commentstring=#\\ %s'},
    {'BufRead,BufNewFile', '.myclirc', 'setlocal commentstring=#\\ %s'},
    {'BufRead,BufNewFile', '.my.cnf', 'setlocal commentstring=#\\ %s'},
    {'FileType', 'plantuml', "setlocal commentstring=' %s"},
    {'BufRead,BufNewFile', '.env', 'setlocal commentstring=#\\ %s'},
  })

  if helpers.is_plugin_installed('vim-commentary') then
    nvim_set_keymap('n', '<leader>c<space>', ':Commentary<cr>', {noremap = true})
    nvim_set_keymap('v', '<leader>c<space>', ':Commentary<cr>', {noremap = true})
  end
end
configure_vim_commentary()
-- }}}

-- vim-devicons {{{
local function configure_vim_devicons()
  g['webdevicons_enable_airline_tabline'] = 0 -- takes up too much horizontal space
end
configure_vim_devicons()
-- }}}

-- vim-fugitive {{{
local function configure_vim_fugitive()
  g['fugitive_git_executable'] = 'git -c "color.ui=never"' -- Why is this not default?
end
configure_vim_fugitive()
-- }}}

-- vim-gist {{{
local function configure_vim_gist()
  g['gist_detect_filetype'] = 1
  g['gist_open_browser_after_post'] = 1
end
configure_vim_gist()
-- }}}

-- vim-git {{{
local function configure_vim_git()
  if helpers.is_plugin_installed('vim-git') then
    -- intentionally global
    function vim_git_mappings()
      nvim_buf_set_keymap(0, 'n', 'I', ':Pick<cr>', {noremap = true, silent = true})
      nvim_buf_set_keymap(0, 'n', 'R', ':Reword<cr>', {noremap = true, silent = true})
      nvim_buf_set_keymap(0, 'n', 'E', ':Edit<cr>', {noremap = true, silent = true})
      nvim_buf_set_keymap(0, 'n', 'S', ':Squash<cr>', {noremap = true, silent = true})
      nvim_buf_set_keymap(0, 'n', 'F', ':Fixup<cr>', {noremap = true, silent = true})
      nvim_buf_set_keymap(0, 'n', 'D', ':Drop<cr>', {noremap = true, silent = true})
    end

    helpers.create_augroup('vim_git', {
      {'FileType', 'gitrebase', 'lua vim_git_mappings()'},
    })
  end
end
configure_vim_git()
-- }}}

-- vim-ghost {{{
local function configure_vim_ghost()
  g['ghost_darwin_app'] = 'iTerm2'

  if helpers.is_plugin_installed('vim-ghost') then
    nvim_set_keymap('n', '<leader>g+', ':GhostStart<cr>', {noremap = true})
    nvim_set_keymap('n', '<leader>g=', ':GhostStop<cr>', {noremap = true})
  end
end
configure_vim_ghost()
-- }}}

-- vim-gutentags {{{
local function configure_vim_gutentags()
  g['gutentags_ctags_executable_ruby'] = 'ripper-tags -R --ignore-unsupported-options'
  g['gutentags_project_info'] = {
    {type = 'php', file = 'composer.json'}
  }
  g['gutentags_ctags_exclude_wildignore'] = 0
  g['gutentags_exclude_filetypes'] = {
    'gitcommit',
    'gitconfig',
    'gitrebase',
    'gitsendemail',
    'git',
    'json',
    'yaml'
  }
  g['gutentags_modules'] = {'ctags'}

  helpers.create_augroup('git_no_gutentags', {
    {'FileType', 'gitrebase', 'let g:gutentags_modules = []'},
    {'FileType', 'gitcommit', 'let g:gutentags_modules = []'},
    {'FileType', 'git', 'let g:gutentags_modules = []'},
  })

  -- TODO how do I check for &diff?
  -- if &diff
  --     let g:gutentags_modules = []
  -- endif

  g['gutentags_ctags_exclude'] = {
    '.git',
    '*.log',
    '*.min.js',
    '*.coffee',
    'bootstrap.php.cache',
    'classes.php.cache',
    'app/cache',
    '__TwigTemplate_*'
  }

  -- tells cscope to respect the same exclude settings in ~/.ctags
  -- NOTE: this applies to all gutentags modules, not just cscope! As such it
  -- ignores files in .ignore, which broke _ide_helper.php integration. In the
  -- end I just turned off cscope... it's not that helpful in php. Grepping for
  -- usage is faster and more accurate.
  g['gutentags_file_list_command'] = getenv('HOME') .. '/.support/cscope_find.sh'
end
configure_vim_gutentags()
-- }}}

-- vim-intentLine {{{
local function configure_vim_indentline()
  g['indentLine_char'] = '┊'
  g['indentLine_faster'] = 1
  g['indentLine_fileTypeExclude'] = {'fzf', 'help', 'startify', 'markdown'}

  -- if you want to see dots for all leading spaces:
  -- g['indentLine_leadingSpaceEnabled'] = 1
  -- g['indentLine_leadingSpaceChar'] = '.'
end
configure_vim_indentline()
-- }}}

-- vim-json {{{
local function configure_vim_json()
  g['vim_json_syntax_conceal'] = 0 -- ensure json shows quotes
end
configure_vim_json()
-- }}}

-- vim-javascript {{{
local function configure_vim_javascript()
  g['javascript_plugin_jsdoc'] = 1 -- enable jsdoc syntax highlighting
  g['javascript_plugin_flow'] = 1 -- enable flowtype syntax highlighting
end
configure_vim_javascript()
-- }}}

-- vim-lost {{{
local function configure_vim_lost()
  helpers.create_augroup('vim_lost', {
    {'FileType', 'php', "let b:lost_regex = '\\v^    \\w+.*function'"},
  })

  if helpers.is_plugin_installed('vim-lost') then
    nvim_set_keymap('n', 'gL', ':Lost<cr>', {noremap = true})
  end
end
configure_vim_lost()
-- }}}

-- vim-markdown {{{
local function configure_vim_markdown()
  -- built-in markdown plugin settings
  -- https://github.com/tpope/vim-markdown
  g['markdown_folding'] = 1
  g['markdown_syntax_conceal'] = 0
  g['markdown_minlines'] = 100

  -- https://old.reddit.com/r/vim/comments/2x5yav/markdown_with_fenced_code_blocks_is_great/
  g['markdown_fenced_languages'] = {
    'sh',
    'css',
    'javascript=javascript.jsx',
    'js=javascript.jsx',
    'json=javascript',
    'php',
    'ruby',
    'scss',
    'sql',
    'xml',
    'html',
  }
end
configure_vim_markdown()
-- }}}

-- vim-markdown-folding {{{
local function configure_vim_markdown_folding()
  g['markdown_fold_style'] = 'nested'
end
configure_vim_markdown_folding()
-- }}}

-- vim-matchup {{{
local function configure_vim_matchup()
  g['matchup_matchparen_status_offscreen'] = 0
end
configure_vim_matchup()
-- }}}

-- vim-pasta {{{
local function configure_vim_pasta()
  g['pasta_disabled_filetypes'] = {'netrw', 'nerdtree'}
end
configure_vim_pasta()
-- }}}

-- vim-php-namespace {{{
local function configure_vim_php_namespace()
  g['php_namespace_sort_after_insert'] = 1

  if helpers.is_plugin_installed('vim-php-namespace') then
    -- intentionally global
    function set_up_vim_php_namespace()
      nvim_set_keymap('i', '<leader><leader>u', '<C-O>:call PhpInsertUse()<cr>', {noremap = true})
      nvim_set_keymap('n', '<leader><leader>u', ':call PhpInsertUse()<cr>', {noremap = true})

      nvim_set_keymap('i', '<leader><leader>e', '<C-O>:call PhpExpandClass()<cr>', {noremap = true})
      nvim_set_keymap('n', '<leader><leader>e', '<C-O>:call PhpexpandClass()<cr>', {noremap = true})
    end

    helpers.create_augroup('vim_lost', {
      {'FileType', 'php', "lua set_up_vim_php_namespace()"},
    })
  end
end
configure_vim_php_namespace()
-- }}}

-- vim-phpqa {{{
local function configure_vim_phpqa()
  g['phpqa_run_on_write'] = 0 -- default: 1. this config value is misleading - it runs on write _and_ on read
  g['phpqa_messdetector_autorun'] = 0
  g['phpqa_codesniffer_autorun'] = 0
  g['phpqa_codecoverage_autorun'] = 0
  g['phpqa_open_loc'] = 0
  g['phpqa_codecoverage_file'] = 'coverage/clover.xml'
end
configure_vim_phpqa()
-- }}}

-- vim-rest-console {{{
local function configure_vim_rest_console()
  local vrc_curl_opts = {}
  vrc_curl_opts['--connect-timeout'] = 9999
  vrc_curl_opts['-sS'] = ''
  vrc_curl_opts['-i'] = ''
  -- vrc_curl_opts[''] = '-L'
  vrc_curl_opts['-L'] = ''
  g['vrc_curl_opts'] = vrc_curl_opts
  g['vrc_response_default_content_type'] = 'json'

  -- fix a problem where vrc buffers lose syntax sync setting, causing the buffer
  -- to lose syntax highlighting on scroll
  helpers.create_augroup('vrc_syntax_fix', {
    {'WinEnter', '__REST_response__', "syntax sync minlines=200"},
  })
end
configure_vim_rest_console()
-- }}}

-- vim-php-refactoring-toolbox {{{
local function configure_vim_php_refactoring_toolbox()
  if helpers.is_plugin_installed('vim-php-refactoring-toolbox') then
    -- intentionally global
    function setup_vim_php_refactoring_toolbox_mappings()
      nvim_set_keymap('n', '<leader>reu', ':call PhpExtractUse()<cr>', {noremap = true})
      nvim_set_keymap('n', '<leader>rec', ':call PhpExtractConst()<cr>', {noremap = true})
      nvim_set_keymap('n', '<leader>rep', ':call PhpExtractClassProperty()<cr>', {noremap = true})
      nvim_set_keymap('n', '<leader>rem', ':call PhpExtractMethod()<cr>', {noremap = true})
    end

    helpers.create_augroup('vim_php_refactoring_toolbox_mappings', {
      {'FileType', 'php', "lua setup_vim_php_refactoring_toolbox_mappings()"},
    })
  end
end
configure_vim_php_refactoring_toolbox()
-- }}}

-- vim-startify {{{
local function configure_vim_startify()
  g['ascii'] = {}
  g['startify_custom_header'] = 'map(g:ascii + startify#fortune#boxed(), "\\"   \\".v:val")'
  g['startify_bookmarks'] = {'~/.vimrc', '~/.vimrc.plugins'}

  g['startify_enable_special'] = 0 -- show empty buffer and quit
  g['startify_enable_unsafe'] = 1 -- speeds up startify but sacrifices some accuracy
  g['startify_session_sort'] = 1 -- sort descending by last used
  g['startify_skiplist'] = {'COMMIT_EDITMSG', '.DS_Store'} -- disable common but unimportant files
  g['startify_files_number'] = 9 -- recently used
  g['startify_session_persistence'] = 0 -- auto save session on exit like obsession
  g['startify_session_dir'] = getenv('HOME') .. '/.vim/sessions' .. getcwd() -- gitsessions dir... but actually it's a pretty good idea to use even outside of gitsessions.

  -- reorder and whitelist certain groups
  g['startify_lists'] = {
    {type = 'sessions', header = {'   Sessions'}},
    {type = 'dir', header = {'   MRU ' .. getcwd()}},
    {type = 'commands', header = {'   Commands'}},
  }
  g['startify_change_to_dir'] = 0 -- this feature should not even exist. It is stupid.
end
configure_vim_startify()
-- }}}

-- vim-tbone {{{
local function configure_vim_tbone()
  if helpers.is_plugin_installed('vim-tbone') then
    nvim_set_keymap('n', 'g>', '<esc>vap:Twrite buttom-right<cr>', {noremap = true})
    nvim_set_keymap('x', 'g>', ':Twrite buttom-right<cr>', {noremap = true})
  end
end
configure_vim_tbone()
-- }}}

-- vim-test {{{
local function configure_vim_test()
  if helpers.is_plugin_installed('vimux') then
    g['test#strategy'] = 'vimux'
  end

  if helpers.is_plugin_installed('vim-test') then
    nvim_set_keymap('n', '<leader>tn', ':TestNearest<cr>', {noremap = true})
    nvim_set_keymap('n', '<leader>tf', ':TestFile<cr>', {noremap = true})
    nvim_set_keymap('n', '<leader>ts', ':TestSuite<cr>', {noremap = true})
  end
end
configure_vim_test()
-- }}}

-- vim-togglelist {{{
local function configure_vim_togglelist()
  g['toggle_list_no_mappings'] = 1
  if helpers.is_plugin_installed('vim-togglelist') then
      nvim_set_keymap('n', '<leader>ll', ':call ToggleLocationList()<cr>', {noremap = true})
      nvim_set_keymap('n', '<leader>qq', ':call ToggleQuickfixList()<cr>', {noremap = true})
  end
end
configure_vim_togglelist()
-- }}}

-- vimux {{{
local function configure_vimux()
  g['VimuxHeight'] = '40'
end
configure_vimux()
-- }}}

-- vista.vim {{{
local function configure_vista()
  g['vista_close_on_jump'] = 1
  g['vista_default_executive'] = 'ale'
  g['vista#renderer#enable_icon'] = 0
  g['vista_fzf_preview'] = {'right:50%'}

  if helpers.is_plugin_installed('vista.vim') then
    nvim_set_keymap('n', '<leader>bb', ':Vista ale<cr>', {noremap = true, silent = true})
  end
end
configure_vista()
-- }}}
