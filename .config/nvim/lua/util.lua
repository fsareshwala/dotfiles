local util = {}

function string.startswith(haystack, needle)
  return string.sub(haystack, 0, string.len(needle)) == needle
end

function string.endswith(haystack, suffix)
  return string.sub(haystack, -#suffix) == suffix
end

function string.trim(str)
  return string.gsub(str, '%s+', '')
end

function util.get_hostname()
  local f = io.popen('/bin/hostname')
  if f == nil then
    return 'unknown'
  end

  local value = f:read('*a')
  f:close()
  return string.gsub(value, '\n$', '')
end

function util.at_work()
  local hostname = util.get_hostname()

  if string.startswith(hostname, 'fsareshwala-office') then
    return true
  elseif string.startswith(hostname, 'fsareshwala-cloudtop') then
    return true
  elseif string.startswith(hostname, 'fsareshwala-macbookpro') then
    return true
  end

  return false
end

return util
