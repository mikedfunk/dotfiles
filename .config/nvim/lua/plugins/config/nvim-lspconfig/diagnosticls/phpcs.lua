-- https://github.com/iamcco/diagnostic-languageserver/wiki/Linters#php_codesniffer
local getenv = vim.fn.getenv

local phpcs = {
  sourceName = 'phpcs',
  command = './vendor/bin/phpcs',
  debounce = 100,
  args = {
    '--standard=./phpcs-mike.xml',
    '--warning-severity=0',
    '--report=emacs',
    '-s', -- show sniffs on all code reports
    '-',
  },
  -- parseJson = {
  --   -- see examples at https://lodash.com/docs/#get
  --   errorsRoot = 'files.STDIN.messages',
  --   line = 'line',
  --   column = 'column',
  --   endLine = 'line',
  --   endColumn = 'column',
  --   -- message = '${message} [${source}]',
  --   security = 'severity',
  -- },
  offsetLine = 0,
  offsetColumn = 0,
  formatLines = 1,
  formatPattern = {
    "^.*:(\\d+):(\\d+):\\s+(.*)\\s+-\\s+(.*)(\\r|\\n)*$",
    {
      line = 1,
      column = 2,
      message = 4,
      security = 3,
    },
  },
  -- TODO something like this to assemble the message
  -- formatPattern = {
  --   '^[^ =]+ =(\\d+) =(.*)(\\r|\\n)*$',
  --   {
  --     line = 1,
  --     message = 2
  --   }
  -- },
  securities = {
    error = 'error',
    warning = 'warning'
  },
  rootPatterns = {
    'phpcs.xml',
    'composer.json',
  },
  requiredFiles = {
    'phpcs.xml',
    'phpcs-mike.xml',
  }
}

return phpcs
