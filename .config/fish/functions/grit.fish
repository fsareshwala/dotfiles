function grit --description 'Interactively rebase commits from the tracking branch'
  git rebase -i --autostash @{upstream}
end
