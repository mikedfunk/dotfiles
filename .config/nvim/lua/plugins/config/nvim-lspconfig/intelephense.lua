-- NOTE: if intelephense is dying silently, first start by turning on debugging
-- in ~/.config/nvim/lua/plugins/config/nvim-lspconfig.lua. Then tail the logs,
-- open the php file, and try an action and view the logs. Recently this
-- happened when I tried to upgrade nodejs to 15.x latest. Intelephense breaks
-- on any node version over 14!
local intelephense_settings = {
  intelephense = {
    environment = {phpVersion = "7.4.7"},
    diagnostics = {
      enable = true,
      run = "onSave",
    },
    phpdoc = {
      classTemplate = {
        tags = {}
      }
    },
    telemetry = {enabled = false},
    -- on_attach = on_attach,
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
        "**/coverage/**",
      },
    },
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
}

return intelephense_settings
