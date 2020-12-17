local g = vim.g
local create_augroup = require'helpers'.create_augroup

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
create_augroup('vrc_syntax_fix', {
  {'WinEnter', '__REST_response__', "syntax sync minlines=200"},
})
