function grx --description 'Run a command on every commit since the tracking branch'
  set -l tracking_branch (git rev-parse --abbrev-ref @{upstream})
  git rebase --exec "$argv && git commit -a --amend --no-edit" $tracking_branch
end
