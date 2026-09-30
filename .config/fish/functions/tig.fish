function tig
  if in_fuchsia
    git log --pretty=format:"%h %an %s" @{upstream}..HEAD
  else if is_mac_os
    /opt/homebrew/bin/tig $argv
  else
    /usr/bin/tig $argv
  end
end
