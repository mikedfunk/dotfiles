local g = vim.g

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
