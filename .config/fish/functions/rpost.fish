function rpost
  if in_google3
    hg upload chain
  else if in_fuchsia
    jiri upload
  else if in_pigweed
    git push origin HEAD:refs/for/main
  end
end
