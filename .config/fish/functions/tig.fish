function tig
    if in_google3
        hg xl $argv
    else if is_mac_os
        /opt/homebrew/bin/tig $argv
    else
        /usr/bin/tig $argv
    end
end
