#!/usr/bin/env fish

# This file contains various utility functions that are used in other shell scripts

function log_warn
    echo "warn: $argv[1]"
end

function log_error
    echo "error: $argv[1]"
    exit 1
end

function ensure_exists
    set -l program $argv[1]
    command -v "$program" >/dev/null 2>&1; or log_error "$program not available on path"
end

function get_extension
    set -l filename $argv[1]
    set -l ext (string replace -r '.*\.' '' -- "$filename")
    echo "$ext"
end

function remove_extension
    set -l filename $argv[1]
    string replace -r '\.[^.]*$' '' -- "$filename"
end
