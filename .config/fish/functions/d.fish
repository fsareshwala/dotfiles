function d
  if in_google3
    hg diff $argv
  else
    git diff $argv
  end
end
