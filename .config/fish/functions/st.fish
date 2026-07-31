function st
  if in_google3
    jj status $argv
  else
    git status $argv
  end
end
