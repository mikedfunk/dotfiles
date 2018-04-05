#!/usr/bin/expect
# TODO get relative path... not as easy as it sounds
spawn php "/Users/mikefunk/.phpenv/bin/go-pear.phar"

expect "1-11, 'all' or Enter to continue:"
send "1\r"
send "/Users/mikefunk/.phpenv/pear\r"
send "\r"
expect eof
