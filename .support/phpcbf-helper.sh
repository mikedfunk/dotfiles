#!/bin/sh
out="$(phpcbf -q $@)"
# if there are no errors, don't show me any text! Used by vim-ale. If this
# isn't used, when the "No fixable errors found" output shows up, vim will
# replace the contents of the file with that output!
if [[ "$( echo \"$out\" | grep 'No fixable' )" ]]; then
    exit
fi
echo "$out"
