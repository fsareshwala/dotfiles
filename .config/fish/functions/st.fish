function st
  if in_google3
    hg status $argv
  else
    git status $argv
  end
end
