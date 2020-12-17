local getenv = vim.fn.getenv

local phpcs = {
  sourceName = 'phpcs',
  -- command = 'cat',
  command = './vendor/bin/phpcs',
  debounce = 100,
  args = {
    -- '%filepath',
    -- '|',
    -- getenv('HOME') .. '/Code/saatchi/palette/vendor/bin/phpcs',
    '--standard',
    './phpcs-mike.xml',
    -- TODO figure out how to make this relative to the filepath
    -- getenv('HOME') .. '/Code/saatchi/palette/phpcs-mike.xml',
    '--warning-severity',
    '0',
    '--format',
    'json',
    '-',
  },
  parseJson = {
    errorsRoot = 'files.STDIN.messages',
    line = 'line',
    column = 'column',
    endLine = 'line',
    endColumn = 'column',
    message = '${message} [${source}]',
    security = 'severity',
  },
  securities = {
    [2] = 'error',
    [1] = 'warning'
  },
  rootPatterns = {
    'phpcs.xml',
    'phpcs-mike.xml',
    'composer.json',
  },
}

return phpcs
