#!/bin/sh
for relative_path_to_file in "$@"; do
    ./vendor/bin/phpspec run --format=pretty -vvv "$relative_path_to_file"
done
