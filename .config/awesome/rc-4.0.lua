-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local assault = require('assault')

print_stdout = print
print = function(...)
  for i,v in ipairs({...}) do
    io.stderr:write(v)
  end
  io.stderr:write('\n')
end

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
if screen[1].workarea.width > 2000 then
  -- for retina display
  beautiful.init(awful.util.getdir("config") .. "/retina.lua")
else
  -- for normal display
  beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
  beautiful.border_width  = 1
end

-- This is used later as the default terminal and editor to run.
if os.execute('which urxvt') then
    terminal = "mlterm"
elseif os.execute('which urxvt') then
    terminal = "urxvt"
else
    terminal = "xterm"
end
--filemanager = "pcmanfm"
filemanager = "thunar"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
--    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
--    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
local f = io.popen("find ~/.wallpaper/ -name '*.jpg' -not -path '*/\.thumbnails/*'")
wallpapers = {}
for line in f:lines() do
  table.insert(wallpapers, line)
end

function random_wallpaper()
  if #wallpapers == 0 then
    return
  end
  wallpaper = wallpapers[math.random(1, #wallpapers)]
  gears.wallpaper.maximized(wallpaper, s, true)
--  for s = 1, screen.count() do
--    gears.wallpaper.maximized(wallpaper, s, true)
--  end
  --awful.util.spawn_with_shell('feh --bg-scale "' .. wallpaper .. '"')
end

random_wallpaper()

function screen_lock()
  awful.util.spawn("slock")
end

-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
awesomemenu = {
  { "arandr", "arandr" },
  { "xterm", "xterm" },
  { "manual", terminal .. " -e man awesome" },
  { "restart", awesome.restart },
  { "quit", awesome.quit },
}

systemmenu = {
  { "lock", screen_lock },
  { "logout", awesome.quit },
  { "shutdown", function(t) awful.util.spawn("systemctl poweroff") end },
  { "reboot", function(t) awful.util.spawn("systemctl reboot") end },
  { "suspend", function(t) awful.util.spawn("systemctl suspend") end },
}

mymainmenu = awful.menu(
  { items = {
      {"mlterm", "mlterm", "/usr/share/pixmaps/mlterm-icon-gnome.png"},
      {"urxvt", "urxvt", "/usr/share/pixmaps/urxvt_48x48.xpm"},
      {"chrome",
       "google-chrome --restore-last-session",
       "/opt/google/chrome/product_logo_32.xpm"},
      {"thunar", "thunar", "/usr/share/icons/Adwaita/scalable/mimetypes/inode-directory-symbolic.svg"},
      {"psi", "psi", "/usr/share/icons/hicolor/64x64/apps/psi.png"},
      {"psi+", "psi-plus", "/usr/share/icons/hicolor/128x128/apps/psi-plus.png"},
      {"clementine", "clementine", "/usr/share/icons/hicolor/64x64/apps/application-x-clementine.png"},
      {"awesome", awesomemenu, beautiful.awesome_icon},
      {"system", systemmenu, "/usr/share/icons/Adwaita/scalable/actions/system-shutdown-symbolic.svg"},
  }
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a assault widget
myassault = assault({
    adapter = "ADP1",
    critical_level = 0.15,
    critical_color = "#ff0000",
    charging_color = "#00ff00"
})

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])
    right_layout:add(myassault)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
))
-- }}}


function next_window()
  awful.client.focus.byidx(1)
  if client.focus then
    client.focus:raise()
  end
end

function prev_window()
  awful.client.focus.byidx(-1)
  if client.focus then
    client.focus:raise()
  end
end

function max_vertical()
  c = client.focus
  c.maximized_vertical   = not c.maximized_vertical
end

function max_horizontal()
  c = client.focus
  c.maximized_horizontal   = not c.maximized_horizontal
end

function max_window()
  c = client.focus
  c.maximized_horizontal = not c.maximized_horizontal
  c.maximized_vertical   = not c.maximized_vertical
end

function max_full_normal_window()
  c = client.focus
  if c.fullscreen then
    c.fullscreen = false
    c.maximized_horizontal = false
    c.maximized_vertical   = false
    return
  end
  if c.maximized_horizontal and c.maximized_vertical then
    c.fullscreen = true
    return
  end
  c.maximized_horizontal = true
  c.maximized_vertical   = true
end

function min_window()
  c = client.focus
  c.minimized = true
end

function debug_print()
  c = client.focus
  pos = c.geometry(c)
  print("geometry: ")
  print("x: " .. pos.x .. ", y: " .. pos.y)
  print("w: " .. pos.width .. ", h: " .. pos.height)
end

function move_left()
  c = client.focus
  pos = c.geometry(c)
  awful.client.moveresize(-pos.x, 0, 0, 0)
end

function move_right()
  c = client.focus
  pos = c.geometry(c)
  awful.client.moveresize(screen[1].workarea.width - pos.x - pos.width, 0, 0, 0)
end

function inc_width()
  c = client.focus
  pos = c.geometry(c)
  fact = screen[1].workarea.width / 100
  inc = fact * 5
  x = screen[1].workarea.width - (pos.x + pos.width + inc)
  if x > 0 then
    x = 0
  end
  awful.client.moveresize(x, 0, inc, 0)
end

function dec_width()
  c = client.focus
  pos = c.geometry(c)
  fact = screen[1].workarea.width / 100
  awful.client.moveresize(0, 0, -fact*5, 0)
end

function move_down()
  c = client.focus
  pos = c.geometry(c)
  awful.client.moveresize(0, screen[c.screen].geometry.height - pos.y - pos.height, 0, 0)
end

function move_up()
  c = client.focus
  pos = c.geometry(c)
  top = screen[c.screen].geometry.height - screen[c.screen].workarea.height
  awful.client.moveresize(0, top - pos.y, 0, 0)
end

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  awful.key({modkey}, "d", debug_print),
  awful.key({modkey}, "Tab", next_window),
  awful.key({modkey}, "Left", next_window),
  awful.key({modkey}, "Right", prev_window),
  awful.key({modkey}, "Up",   awful.tag.viewprev),
  awful.key({modkey}, "Down",  awful.tag.viewnext),
  awful.key({modkey}, "u", awful.tag.history.restore),
  awful.key({modkey}, "w", random_wallpaper),
  awful.key({modkey}, "Escape", screen_lock),
  awful.key({modkey}, "space", function () mymainmenu:show() end),
  awful.key({modkey}, "v", max_vertical),
  awful.key({modkey, "Control"}, "v", max_horizontal),
  awful.key({modkey}, "n", min_window),
  --awful.key({modkey}, "m", max_full_normal_window),
  awful.key({modkey}, "h", move_left),
  awful.key({modkey}, "l", move_right),
  awful.key({modkey}, "-", dec_width),
  awful.key({modkey}, ";", inc_width),
  awful.key({modkey}, "j", move_down),
  awful.key({modkey}, "k", move_up),
  awful.key({modkey}, "f", max_full_normal_window),
  awful.key({modkey}, "Return", function () awful.util.spawn(terminal) end),
  awful.key({modkey}, "/", function () awful.util.spawn(filemanager) end),
  awful.key({modkey, "Control"}, "Tab", function () awful.layout.inc(layouts,  1) end),
  awful.key({modkey, "Control" }, "r", awesome.restart),
  awful.key({modkey, "Shift" }, "q", awesome.quit),
  awful.key({modkey, "Control"}, "n", awful.client.restore),

  --
  awful.key({modkey}, "[", function ()
      c = client.focus
      c.ontop = not c.ontop
  end),
  awful.key({modkey, "Control"}, "q", function ()
      c = client.focus
      c:kill()
  end),

  awful.key({ }, "XF86MonBrightnessDown", function ()
      awful.util.spawn("xbacklight -dec 10") end),
  awful.key({ }, "XF86MonBrightnessUp", function ()
      awful.util.spawn("xbacklight -inc 10") end),
  awful.key({ }, "XF86AudioRaiseVolume", function ()
      awful.util.spawn("amixer set Master 5%+") end),
  awful.key({ }, "XF86AudioLowerVolume", function ()
      awful.util.spawn("amixer set Master 5%-") end),
  awful.key({ }, "XF86AudioMute", function ()
      awful.util.spawn("amixer sset Master toggle") end),
  awful.key({ }, "XF86Eject", function ()
      awful.util.spawn("eject") end),

  -- Layout manipulation
  -- awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
  -- awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
  -- awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
  -- awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
--  awful.key({modkey}, "Tab",
--    function ()
--      awful.client.focus.history.previous()
--      if client.focus then
--	    client.focus:raise()
--      end
--  end),

    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),
    -- Toggle touchpad
    awful.key({ modkey }, "t", function() toggle_touchpad() end)
)

clientkeys = awful.util.table.join(
  awful.key({modkey, "Control"}, "space",  awful.client.floating.toggle)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 3, awful.mouse.client.resize),
    awful.button({ modkey }, 1, awful.mouse.client.move))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        --right_layout:add(awful.titlebar.widget.stickybutton(c))
        --right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))
	
        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Toggle TouchPad for MBP
touchpad_off = 0
function toggle_touchpad()
  if touchpad_off == 0 then
    naughty.notify({ text = "Disable Touchpad" })
    awful.util.spawn_with_shell('synclient TouchpadOff=1')
    touchpad_off = 1
  else
    naughty.notify({ text = "Enable Touchpad" })
    awful.util.spawn_with_shell('synclient TouchpadOff=0')
    touchpad_off = 0
  end
end
-- default off
toggle_touchpad()

function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    if not arg_string then
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. " ".. arg_string .."' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end

function run_dropbox()
  rc = os.execute('dropbox running')
  if rc == 0 then
    awful.util.spawn_with_shell("dropbox start")
  end
end

-- for java ui
awful.util.spawn_with_shell("wmname LG3D")

--run_once("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")
--run_once("urxvtd")
run_once("volumeicon")
run_once("nm-applet")
--run_once("wicd-client", "-t", '/usr/bin/python -O /usr/share/wicd/gtk/wicd-client.py')
run_once("conky")

run_dropbox()

print("loaded rc.lua")
