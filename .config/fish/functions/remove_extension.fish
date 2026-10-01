function remove_extension
    set -l filename $argv[1]
    string replace -r '\.[^.]*$' '' -- "$filename"
end
