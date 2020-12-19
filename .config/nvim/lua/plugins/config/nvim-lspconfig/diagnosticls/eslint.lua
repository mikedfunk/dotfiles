-- https://github.com/iamcco/diagnostic-languageserver/wiki/Linters#eslint
local eslint = {
  sourceName = 'eslint',
  command = './node_modules/.bin/eslint',
  debounce = 100,
  args = {
    '--stdin',
    '--stdin-filename=%filepath',
    '--format=json',
  },
  parseJson = {
    -- see examples at https://lodash.com/docs/#get
    errorsRoot = '[0].messages',
    line = 'line',
    column = 'column',
    endLine = 'endLine',
    endColumn = 'endColumn',
    message = '${message} [${ruleId}]',
    security = 'severity',
  },
  securities = {
    [2] = 'error',
    [1] = 'warning'
  },
  rootPatterns = {
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json',
    '.eslintrc',
    'package.json',
  },
  requiredFiles = {
    '.eslintrc.json',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc',
    '.eslintrc.yaml',
    '.eslintrc.yml',
  }
}

return eslint
