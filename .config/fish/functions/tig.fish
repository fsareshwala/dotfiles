function tig
  if is_mac_os
    /opt/homebrew/bin/tig $argv
  else
    /usr/bin/tig $argv
  end
end
