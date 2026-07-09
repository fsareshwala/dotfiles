function in_fuchsia
  if string match -q "$HOME/code/fuchsia*" "$PWD"
    return 0
  end

  return 1
end
