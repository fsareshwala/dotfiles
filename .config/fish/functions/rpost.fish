function rpost
  if in_google3
    hg upload
  else if in_fuchsia
    jiri upload
  else if in_pigweed
    set -l branch (git branch --show-current)
    set -l remote (git config --get branch.$branch.remote)
    if test -z "$remote"
      set remote origin
    end
    git push $remote HEAD:refs/for/main
  end
end
