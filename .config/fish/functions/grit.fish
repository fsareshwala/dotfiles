function grit --description 'Interactively rebase commits from the tracking branch'
  set -l tracking_branch (git rev-parse --abbrev-ref @{upstream})
  git rebase -i --autostash $tracking_branch
end
