-- standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Widget and layout library
require("wibox")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("menubar")
require("vicious")
require("calendar2")
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
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/alex/.config/awesome/themes/propio/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.floating,
    awful.layout.suit.max,
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ " main ", " web ", " term ", " media ", " misc "}, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu

games = {
   { "zsnes", "zsnes" },
   { "diablo 2", "wine explorer /desktop=0,1366x786 /home/alex/Misc/Games/Diablo2/Diablo\ II.exe" },
   { "w3:ROC", "wine explorer /desktop=0,1366x786 /home/alex/Misc/Games/Warcraft\ III/Warcraft\ III.exe"},
   { "w3:FT", "wine explorer /desktop=0,1366x786 /home/alex/Misc/Games/Warcraft\ III/Frozen\ Throne.exe"}
}

myawesomemenu = {
   { "restart", awesome.restart },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "quit", awesome.quit }
}

mypowermenu = {
   { "shutdown", "sudo halt -p" },
   { "reboot", "sudo reboot"},
   { "suspend", "sudo pm-suspend" }
}
myaudiomenu = {
    {"qjackctl","qjackctl"},
    {"rakarrack","rakarrack"},
    {"kill p.a.",terminal .. " -e killall pulseaudio"}
}

myappsmenu = {
   { "gimp", "gimp" },
   { "v.box", "virtualbox" },
   { "ranger", terminal .. " -e ranger" },
   { "tmux", terminal .. " -e tmux" },
   { "ncmpcpp", terminal .. " -e ncmpcpp" },
   { "mutt", terminal .. " -e mutt" },
   { "gvim", "gvim" },
   { "weechat", terminal .. " -e weechat-curses" }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu },
                                    { "audio", myaudiomenu},
                                    { "games", games },
                                    { "apps", myappsmenu },
                                    { "chromium", "chromium" },
                                    { "open terminal", terminal },
                                    { "nautilus", "nautilus" },
                                    { "power", mypowermenu}
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Battery Widget
batwidget = awful.widget.progressbar()
batwidget:set_width(9)
batwidget:set_height(6)
batwidget:set_vertical(true)
batwidget:set_background_color("#151515")
batwidget:set_border_color(nil)
batwidget:set_color("#d0d0ff")
--awful.widget.layout.margins[batwidget.widget] = {top = 5}
batwidtext = wibox.widget.textbox()
batwidtoolt = awful.tooltip({ objects = { batwidtext,batwidget },})
vicious.register(batwidget,vicious.widgets.bat, 
                function (widget,args)
                    batwidtoolt:set_text("Battery: "..args[2].."%")
                    return args[2]
                end, 120, "BAT0")

vicious.register(batwidtext,vicious.widgets.bat,
                function(widget, args)
                    if args[2] < 25 then
                        return '<span color="red"> Ã </span>'
                    else
                        return " Ã  "
                    end
                end, 120, "BAT0")

batmenu = awful.menu({items = {
			     { "Auto" , function () awful.util.spawn("sudo cpufreq-set -r -g ondemand", false) end },
			     { "Ondemand" , function () awful.util.spawn("sudo cpufreq-set -r -g ondemand", false) end },
			     { "Powersave" , function () awful.util.spawn("sudo cpufreq-set -r -g powersave", false) end },
			     { "Performance" , function () awful.util.spawn("sudo cpufreq-set -r -g performance", false) end }

}
})
batwidget:buttons(awful.util.table.join(
                awful.button({ }, 1, function () batmenu:toggle() end)
))

batwidtext:buttons(awful.util.table.join(
                awful.button({ }, 1, function () batmenu:toggle() end)
))
-- {{{ Misc Texts
separator = wibox.widget.textbox()
separator.set_markup(separator, ' ')
separator2 = wibox.widget.textbox()
separator2.set_markup(separator2, '<span color="#1b2736">  </span>')
percent = wibox.widget.textbox()
percent.set_markup(percent, '%')
myclockicon = wibox.widget.textbox()
myclockicon.set_text(myclockicon, ' Õ ')
-- {{{ CPU Usage
cpuwidget = awful.widget.progressbar()
cpuwidget:set_width(9)
cpuwidget:set_height(6)
cpuwidget:set_vertical(true)
cpuwidget:set_background_color("#151515")
cpuwidget:set_border_color(nil)
cpuwidget:set_color("#6d9cbe")
cpuwidtext = wibox.widget.textbox()
cpuwidtoolt = awful.tooltip({ objects = { cpuwidget,cpuwidtext },})
vicious.register(cpuwidtext, vicious.widgets.cpu, " Ï  ", 0.9)
vicious.register(cpuwidget, vicious.widgets.cpu,  
                function (widget,args)
                    cpuwidtoolt:set_text("CPU: "..args[1].."%")
                    return args[1]
                end,0.9)

-- {{{ Volume 
volwidtext = wibox.widget.textbox()
vicious.register(volwidtext, vicious.widgets.volume,"  Ô $1% ", 0.3, "Master")

volwidtext:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("amixer -q sset Master toggle", false) end),
    awful.button({ }, 3, function () awful.util.spawn(terminal .. " -e alsamixer", false) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 2000+", false) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 2000-", false) end)
))

-- {{{ MPD 
-- Initialize MPD Widget
music_play = wibox.widget.textbox()
music_play.set_text(music_play, ' à ')
music_play:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("ncmpcpp toggle", false) end)
))
  music_pause = awful.widget.launcher({
    image = beautiful.widget_pause,
    command = "ncmpcpp toggle"
  })
  music_pause.visible = false
music_stop = wibox.widget.textbox()
music_stop.set_text(music_stop, ' ä ')
music_stop:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("ncmpcpp stop", false) end)
))

music_prev = wibox.widget.textbox()
music_prev.set_text(music_prev, ' â ')
music_prev:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("ncmpcpp prev", false) end)
))


music_next = wibox.widget.textbox()
music_next.set_text(music_next, ' ã ')
music_next:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("ncmpcpp next", false) end)
))

mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then 
            music_play.set_text(music_play, ' à ')
            music_prev.set_text(music_prev, '')
            music_next.set_text(music_next, '')
            music_stop.set_text(music_stop, '')
            return " Î "
        elseif args["{state}"] == "Pause" then
            music_play.set_text(music_play, ' à ')
            music_prev.set_text(music_prev, ' â ')
            music_next.set_text(music_next, ' ã ')
            --music_stop.set_markup(music_stop, '<span color="white"> ä </span>')
            music_stop.set_text(music_stop, ' ä ')
            return "Î [ Paused ]"
        else 
            music_stop.set_text(music_stop, ' ä ')
            music_prev.set_text(music_prev, ' â ')
            music_next.set_text(music_next, ' ã ')
            music_play.set_text(music_play, ' á ')
            return " Î [ " .. args["{Title}"]..' - '.. args["{Artist}"] .. " ]"
        end
    end, 0.5)

mpdwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e ncmpcpp", false) end)
))

-- {{{ Memory Usage

memwidget  = awful.widget.progressbar()
memwidget:set_width(9)
memwidget:set_height(6)
memwidget:set_vertical(true)
memwidget:set_background_color("#151515")
memwidget:set_border_color(nil)
memwidget:set_color("#6d9cbe")
memwidtext = wibox.widget.textbox()
memwidtoolt = awful.tooltip({ objects = { memwidget,memwidtext },})
vicious.register(memwidtext, vicious.widgets.mem, " Þ  ")
vicious.register(memwidget, vicious.widgets.mem, 
                function (widget,args)
                    memwidtoolt:set_text("Memory: "..args[1].."%")
                    return args[1]
                end,12)

-- {{{ Pacman Widget 

pacwidget = wibox.widget.textbox()
pacwidget.set_text(pacwidget, "Æ ")
pacwidgettex = wibox.widget.textbox()
pacwidtoolt = awful.tooltip({objects = { pacwidget, pacwidgettex},})
vicious.register(pacwidgettex, vicious.widgets.pkg,
                function(widget,args)
                    local io = { popen = io.popen }
                    local s = io.popen("pacman -Qu")
                    local str = ''
                    for line in s:lines() do
                        str = str .. line .. "\n"
                    end
                    if str == '' then
                        pacwidtoolt:set_text("no updates available")
                    else
                        pacwidtoolt:set_text(str)
                    end
                    s:close()
                    return " " .. args[1]
                end,30,"Arch")

pacwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e yaourt -Syua",false) end) 
))
-- {{{ Uptime and OS info 

uptime = wibox.widget.textbox()
vicious.register(uptime, vicious.widgets.uptime, "Up: $2H:$3M ")

osinfo = wibox.widget.textbox()
vicious.register(osinfo, vicious.widgets.os, " $2 ")

network = wibox.widget.textbox()
vicious.register(network, vicious.widgets.net, " Ð ${wlan0 down_kb} Ñ ${wlan0 up_kb}  ")

hdspace = wibox.widget.textbox()
vicious.register(hdspace, vicious.widgets.fs, "Ê ${/ avail_gb}/${/ size_gb}GB")

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mywibox2 = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
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
                                                  instance = awful.menu.clients({ width=250 })
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

    mywibox[s] = awful.wibox({ position = "top", height= "16", screen = s })
    mywibox2[s] = awful.wibox({ position = "bottom", height= "17", screen = s })
    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    left_layout:add(separator2)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(myclockicon)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    local layoutbat = wibox.layout.fixed.horizontal()
    layoutbat:add(batwidget)
    layoutbat:add(batwidtext)
    layoutbat:add(cpuwidget)
    layoutbat:add(cpuwidtext)
    layoutbat:add(memwidget)
    layoutbat:add(memwidtext)
    layoutbat:add(separator)
    layoutbat:add(uptime)
    layoutbat:add(separator)
    layoutbat:add(network)
    layoutbat:add(separator)
    layoutbat:add(hdspace)
    layoutbat:add(separator)
    layoutbat:add(volwidtext)
    layoutbat:add(separator)

    local layoutsys = wibox.layout.fixed.horizontal()
    layoutsys:add(mpdwidget)
    layoutsys:add(music_play)
    layoutsys:add(music_prev)
    layoutsys:add(music_next)
    layoutsys:add(music_stop)
    layoutsys:add(separator)
    layoutsys:add(pacwidget)
    layoutsys:add(separator)
    layoutsys:add(osinfo)
    layoutsys:add(separator)


    local layout2 = wibox.layout.align.horizontal()
    layout2:set_left(layoutbat)
    layout2:set_right(layoutsys)

    mywibox[s]:set_widget(layout)
    mywibox2[s]:set_widget(layout2)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),


    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey,           }, "i", function () awful.util.spawn("chromium") end),
    awful.key({ modkey,           }, "e", function () awful.util.spawn("gvim") end),
    awful.key({ modkey, "Shift"   }, "n", function () awful.util.spawn("nautilus") end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),


    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey },            "b",     function () mywibox2[mouse.screen].visible = not mywibox2[mouse.screen].visible end),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Vlc" },
      properties = { floating = true , tag = tags[1][4]} },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true, tag = tags[1][4] } },
    -- Set Chromium to always map on tags number 2 of screen 1.
    { rule = { class = "Chromium"}, properties = {tag = tags[1][2] }},
    { rule = { class = "banshee"}, properties = {tag = tags[1][4] }},
    { rule = { class = "Gvim"}, properties = {size_hints_honor = false}},
    { rule = { class = "URxvt"}, properties = {size_hints_honor = false}},
    --   properties = { tag = tags[1][2] } ,
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

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
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- {{{ AutoStart Apps


--awful.util.spawn_with_shell("killall wicd-client")
--awful.util.spawn_with_shell("wicd-client --tray")

--awful.util.spawn_with_shell("killall nm-applet")
awful.util.spawn_with_shell("sleep 3")
awful.util.spawn_with_shell("setxkbmap es")
--awful.util.spawn_with_shell("nm-applet")
awful.util.spawn_with_shell("sleep 3")
awful.util.spawn_with_shell("xmodmap ~/.speedswapper")
awful.util.spawn_with_shell("sleep 3")
awful.util.spawn_with_shell("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
awful.util.spawn_with_shell("compton -cG -o 0.38 -O 200 -I 200 -t 0.02 -l 0.02 -r 3.2 -D2 -m 0.88")
awful.util.spawn_with_shell("sleep 3")
--awful.util.spawn_with_shell("killall ncmpcpp")
