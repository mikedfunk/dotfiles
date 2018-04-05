#!/usr/bin/expect
spawn wget -O $HOME/.phpenv/bin/go-pear.phar http://pear.php.net/go-pear.phar
expect eof

spawn php $HOME/.phpenv/bin/go-pear.phar

expect "1-11, 'all' or Enter to continue:"
send "1\r"
send "$HOME/.phpenv/pear\r"
send "\r"
expect eof
