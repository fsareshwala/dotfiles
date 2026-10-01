function ensure_exists
    set -l program $argv[1]
    command -v "$program" >/dev/null 2>&1; or log_error "$program not available on path"
end
