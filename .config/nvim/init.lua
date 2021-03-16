-- vim: set fdm=marker:
local create_augroup = require'helpers'.create_augroup
local filereadable, cmd = vim.fn.filereadable, vim.cmd

require'plugins'
require'sensible'
require'general'
require'php'
require'lua'
require'completion-config'
require'abbreviations'
require'mappings'
require'netrw'
require'visuals'
require'lsp-diagnostics'
require'plugins.config'

-- exrc fix {{{
-- TODO exrc isn't working even if I change it to .nvimrc and set exrc and
-- secure in vimscript... doing this in the mean time. last tested 2021-03-15
if filereadable('.vimrc') == 1 then
  cmd('source .vimrc')
end
-- }}}

-- italic comments fix {{{
-- TODO This is also in visuals.lua but it's getting overridden somewhere
cmd('highlight! Comment cterm=italic, gui=italic') -- italic comments https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic
cmd('highlight! Special cterm=italic, gui=italic')
-- }}}
