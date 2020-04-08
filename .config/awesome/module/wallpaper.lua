local gears = require("gears")
local lfs = require("lfs")

function random_wallpaper()
  local wallpapers = {}
  local wp_dir = string.format("%s/.wallpaper/", os.getenv("HOME"))
  mode = lfs.attributes(wp_dir, "mode")
  if mode ~= "directory" then
    return
  end
  for filename in lfs.dir(wp_dir) do
    local filepath = wp_dir..filename
    if lfs.attributes(filepath, "mode") == "file" then
      table.insert(wallpapers, filepath)
    end
  end
  math.randomseed(os.time())
  if #wallpapers == 0 then
    return
  end
  wallpaper = wallpapers[math.random(1, #wallpapers)]
  gears.wallpaper.maximized(wallpaper, s, true)
end

random_wallpaper()
