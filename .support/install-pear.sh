#!/usr/bin/expect
spawn php "$env(HOME)/.bin/go-pear.phar"

expect "1-12, 'all' or Enter to continue:" {
    exp_send "1\r"
    exp_send "$env(PHP_PATH)/pear\r"
}
expect "1-12, 'all' or Enter to continue:" {
    exp_send "\r"
}
# expect "Would you like to alter php.ini <$env(PHP_PATH)/etc/php.ini>? \\\[Y/n\\\] : " {
#     exp_send "Y\r"
# }
expect "Press Enter to continue:" {
    exp_send "\r"
}
expect eof
