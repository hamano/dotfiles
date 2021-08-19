--local hostname = { VERSION = '0.1' }

function hostname()
  local p = io.popen("/bin/hostname")
  local host = p:read("*a") or ""
  p:close()
  host = string.gsub(host, "\n$", "")
  return host
end

return hostname

