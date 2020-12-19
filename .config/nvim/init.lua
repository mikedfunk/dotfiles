-- vim: set fdm=marker:

require'plugins'
require'sensible'
require'general'
require'php'
require'lua'
require'completion'
require'abbreviations'
require'mappings'
require'netrw'
require'visuals'
require'lsp-diagnostics'
require'plugins.config'

-- exrc fix {{{
-- TODO exrc isn't working even if I change it to .nvimrc... doing this in the mean time
local filereadable, cmd = vim.fn.filereadable, vim.cmd

if filereadable('.vimrc') == 1 then
  cmd('source .vimrc')
end
-- }}}

-- FileType autocmds stopped working. This is a BAD temp solution. Thanks, i hate it. {{{
local create_augroup = require'helpers'.create_augroup

create_augroup('fix_filetype', {
  {'BufRead,BufNewFile', '*', 'e!'}
})
-- }}}
