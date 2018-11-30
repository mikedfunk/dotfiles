#!/usr/bin/expect
spawn php "$env(HOME)/.bin/go-pear.phar"

expect "1-12, 'all' or Enter to continue:" {
    exp_send "1\r"
    exp_send "$env(HOME)/.phpenv/versions/$env(PHP_VERSION)/pear\r"
}
expect "1-12, 'all' or Enter to continue:" {
    exp_send "\r"
}
expect "Would you like to alter php.ini <$env(HOME)/.phpenv/versions/$env(PHP_VERSION)/etc/php.ini>? \\\[Y/n\\\] : " {
    exp_send "Y\r"
}
expect "Press Enter to continue:" {
    exp_send "\r"
}
expect eof
