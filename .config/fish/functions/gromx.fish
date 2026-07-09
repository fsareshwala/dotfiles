function gromx --description 'Run a command on every commit since origin/master'
  set -l tracking_branch (git rev-parse --abbrev-ref @{upstream})
  git rebase --exec "$argv" $tracking_branch
end
