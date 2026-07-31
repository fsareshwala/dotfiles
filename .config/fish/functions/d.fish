function d
  if in_google3
    jj diff $argv
  else
    git diff $argv
  end
end
