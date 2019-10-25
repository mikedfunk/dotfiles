#!/bin/sh
for relative_path_to_file in "$@"; do
    ./vendor/bin/phpunit -d display_errors=on --stop-on-error --stop-on-failure --stop-on-incomplete --stop-on-risky --debug "$relative_path_to_file"
done
