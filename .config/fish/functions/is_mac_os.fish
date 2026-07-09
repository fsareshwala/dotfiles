function is_mac_os --description 'Check if the host platform is macOS'
  if test (uname) = Darwin
    return 0
  end

  return 1
end
