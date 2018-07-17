#!/usr/bin/expect
# TODO this is very brittle currently - sometimes I get the offer to alter php.ini.
spawn php ".phpenv/bin/go-pear.phar"

expect "1-12, 'all' or Enter to continue:"
send "1\r"
# TODO get absolute path to relative path... not as easy as it sounds
send "/Users/mikefunk/.phpenv/pear\r"
expect "1-12, 'all' or Enter to continue:"
# expect "Would you like to alter php.ini </Users/mikefunk/.phpenv/versions/7.0.29/etc/php.ini>? [Y/n] :"
# send "Y\r"
send "\r"
expect eof
