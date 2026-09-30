function grx --description 'Run a command on every commit since the tracking branch'
  git rebase --exec "$argv && git commit -a --amend --no-edit" @{upstream}
end
