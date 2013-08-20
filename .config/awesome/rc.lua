------------------------------------------------
-- awesome config (rc.lua)
-- by intelfx
--   intelfx100 at gmail dot com
-- skeleton by TheImmortalPhoenix
--   http://theimmortalphoenix.deviantart.com
-- inspired by KniRen
--   http://kniren.deviantart.com/art/Archlinux-Xmonad-May-07-13-370268797
------------------------------------------------

-- {{{ Standard awesome library

awful = require ("awful")
require ("awful.autofocus")
awful.rules = require ("awful.rules")
wibox = require ("wibox")
-- Theme handling library
beautiful = require ("beautiful")
revelation = require ("revelation")
-- Notification library
naughty = require ("naughty")
gears = require ("gears")
vicious = require ("vicious")
menubar = require ("menubar")
-- "Scratch" drop-down library
scratch = require ("scratch")
-- Generated XDG menu
xdgmenu = require ("xdgmenu")

-- Own functions and overrides
require ("custom.util")
battery = require ("custom.battery")
textlayoutbox = require ("custom.textlayoutbox")
--}}}



-- {{{ Error Handling

-- This is not a fallback config, so startup error handling code
-- will never execute from here.
-- (a startup error means that Awesome could not process user config
--  and had to fall back to the default one)
if awesome.startup_errors then
	naughty.notify ({ preset = naughty.config.presets.critical,
	                  title = "There were errors during startup.",
	                  text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal ("debug::error",
		function (err)
			-- Make sure we don't go into an endless error loop
			if in_error then return end
			in_error = true

			naughty.notify ({ preset = naughty.config.presets.critical,
			                  title = "A runtime error happened.",
			                  text = err })
			in_error = false
		end)
end

-- }}}



-- {{{ Theme setup

-- Themes define colours, icons, and wallpapers
beautiful.init (awful.util.getdir ("config") .. "/themes/current/theme.lua")

-- Setup wallpaper
if beautiful.wallpaper then
	for s = 1, screen.count () do
		gears.wallpaper.maximized (beautiful.wallpaper, s, true)
	end
end

-- }}}



-- {{{ Tags and layouts

layouts =
{
    awful.layout.suit.floating,             -- 1
    awful.layout.suit.tile,                 -- 2
    awful.layout.suit.tile.bottom,          -- 3
    awful.layout.suit.fair,                 -- 4
    awful.layout.suit.fair.horizontal,      -- 5
    awful.layout.suit.spiral,               -- 6
    awful.layout.suit.spiral.dwindle,       -- 7
    awful.layout.suit.max,                  -- 8
    --awful.layout.suit.max.fullscreen,     -- 9
    --awful.layout.suit.magnifier           -- 10
}

tags = { }
for s = 1, screen.count () do
    -- Each screen has its own tag table.
    tags[s] = awful.tag ({ "term",     "web",      "files",    "msg",      "media",    "work",       "virt",       "wine",     "other" }, s,
  		                 { layouts[3], layouts[4], layouts[5], layouts[3], layouts[4], layouts[8],   layouts[8],   layouts[6], layouts[6]})
end

-- }}}



-- {{{ Basic command definitions

terminal = "urxvtc"
terminal_run = terminal .. " -e "
editor = os.getenv ("EDITOR") or "vim"

c_music_player = "amarok"
c_im = "konversation"
c_mail = "kmail"
c_mail_create = "kmail --composer"

c_editor_gui = "kate"
c_browser_gui = "google-chrome"
c_file_manager_gui = "dolphin"

c_editor_cli = terminal_run .. editor
c_browser_cli = terminal_run .. "elinks"
c_file_manager_cli = terminal_run .. "mc"

c_powertop = terminal_run .. "sudo powertop"

modkey = "Mod4"
altkey = "Mod1"
sound_mixer = "Master"

last_spawned = nil

-- }}}



-- {{{ Menubar configuration

menubar.utils.terminal = terminal

-- }}}



-- {{{ Main menu

myaccessories = {
	{ "Editor [GUI]", c_editor_gui },
	{ "Editor [CLI]", c_editor_cli }
}

myinternet = {
	{ "Browser" , c_browser_gui },
	{ "IM", c_im },
	{ "Mail" , c_mail },
	{ "Skype" , "skype" }
}

mymedia = {
	{ "Amarok" , "amarok" },
	{ "Avidemux" , "avidemux2_qt" },
	{ "K3B" , "k3b" },
	{ "SMPlayer" , "smplayer" },
	{ "VLC" , "vlc" }
}

mygraphics = {
	{ "Blender" , "blender" },
	{ "Colors" , "kcolorchooser" },
	{ "GIMP" , "gimp" },
	{ "Inkscape" , "inkscape" },
	{ "DigiKam" , "digikam" }
}

myoffice = {
	{ "Formula" , "lomath" },
	{ "Impress" , "loimpress" },
	{ "Okular" , "okular" },
	{ "Spreadsheet" , "localc" },
	{ "Writer" , "lowriter" }
}

mysystem = {
	{ "KDE configuration" , "systemsetings" },
	{ "Filelight" , "filelight" },
	{ "Powertop" , c_powertop },
	{ "QtConfig" , "qtconfig" },
	{ "Task Manager" , c_task_manager }
}

mysystemroot = {
	{ "Filelight" , "sudo filelight" },
	{ "Partition Manager" , "sudo partitionmanager" },
	{ "GPartEd", "sudo gparted" },
	{ "Qtconfig" , "sudo qtconfig" }
}

mystudy = {
	{ "Calculator" , "qalculate-gtk" },
	{ "Cantor" , "cantor" },
	{ "KAlgebra" , "kalgebra" },
	{ "Geogebra" , "geogebra" },
	{ "Chemistry" , "kalzium" },
	{ "Circuits" , "ktechlab" },
	{ "KDevelop" , "kdevelop -ps" },
	{ "Graphs" , "kmplot" },
}

myfolders = {
	{ "Home" , c_file_manager_gui .. " " .. os.getenv ("HOME") },
	{ "Temp" , c_file_manager_gui .. " /tmp" },
	{ "Media" , c_file_manager_gui .. " /media" },
	{ "Mounts" , c_file_manager_gui .. " /mnt" }
}

myexit = {
	{ "Hibernate" , "systemctl hibernate" },
	{ "Suspend" , "systemctl suspend" },
	{ "Hybrid suspend" , "systemctl hybrid-sleep" },
	{ "Shutdown" , "systemctl poweroff" },
	{ "Reboot" , "systemctl reboot" },
	{ "Quit" ,  "systemctl --user exit" },
	{ "Restart" , awesome.restart }
}

mymainmenu = awful.menu ({ items = {
	{ "File Manager", c_file_manager_gui },
	{ "Terminal", terminal },
	{ "Browser" , c_browser_gui },
	{ " ", nil, nil}, -- separator
	{ "Folders" , myfolders },
	{ "Freedesktop" , xdgmenu },
	{ " ", nil, nil}, -- separator
	{ "Accessories" , myaccessories },
	{ "Graphics" , mygraphics },
	{ "Internet" , myinternet },
	{ "Multimedia" , mymedia },
	{ "Office" , myoffice },
	{ "System" , mysystem },
	{ "System Root" , mysystemroot },
	{ "University" , mystudy },
	{ " ", nil, nil}, -- separator
	{ "Exit", myexit },
	{ "Edit config" , c_editor_cli .. " " .. awful.util.getdir ("config") .. "/rc.lua"  }
}})

-- }}}



-- {{{ Wibox widgets

-- Helpers
space = textbox (" ")
separator_pipe = textbox (colorize (beautiful.separator_fg) (" | "))
widget = widget_text (beautiful.widget_text_fg, beautiful.widget_icon_fg, nil, beautiful.font_symbols)

-- Setup caches
vicious.cache (vicious.widgets.bat)
vicious.cache (vicious.widgets.volume)
vicious.cache (vicious.widgets.os)
vicious.cache (vicious.widgets.thermal)
vicious.cache (vicious.widgets.hddtemp)


-- Clock widget
clockwidget = awful.widget.textclock (widget (theme.widget_clock, "%a %b %d %H:%M"))


-- System widget
syswidget = vicious_box (vicious.widgets.os, widget (theme.widget_sys, "$2"), 600)


-- Uptime widget
uptimewidget = vicious_box (vicious.widgets.uptime, widget (beautiful.widget_uptime, "$1d $2h $3m"), 61)

exitmenu = awful.menu ({ items = myexit })

uptimewidget:buttons (awful.util.table.join (
	awful.button ({ }, 1, function () exitmenu:toggle () end)
))


-- Temperature widget
tempwidget = vicious_box (vicious.widgets.thermal, widget (beautiful.widget_temp, colorize (theme.fg_importance_0) ("Core ") .. "$1°C"), 31, { "coretemp.0", "core", "temp1_input" })
hddtempwidget = awful.tooltip ({ objects = { tempwidget } })

vicious.register (hddtempwidget, vicious.widgets.hddtemp,
	function (widget,args)
		local output={ }
		for disk, temp in pairs (args) do
			table.insert (output, colorize (theme.fg_importance_0) (disk) .. " " .. temp .. "°C")
		end
		hddtempwidget:set_text (table.concat (output, "\n"))
	end, 31)

tempwidget:buttons (awful.util.table.join (
	awful.button ({ }, 3, function () awful.util.spawn ("ksysguard") end)
))


-- Gmail widget

mygmail = textbox()
gmail_t = awful.tooltip ({ objects = { mygmail } })

vicious.register (mygmail, vicious.widgets.gmail,
	function (w, args)
		gmail_t:set_text (args["{subject}"])
		return widget (args["{count}"] > 0 and beautiful.widget_mail
		                                    or beautiful.widget_mail_empty,
		               args["{count}"])
	end, 600)

mygmail:buttons (awful.util.table.join (
	awful.button ({ }, 1, function () awful.util.spawn ("kmail") end)
))


-- Pacman widget
pacwidget = textbox()
pacwidget_t = awful.tooltip ({ objects = { pacwidget } })

vicious.register (pacwidget, vicious.widgets.pkg,
	function (w, args)
		pacwidget_t:set_text (awful.util.pread ("yaourt -Qu"))
		return widget (beautiful.widget_pac, args[1])
	end, 1800, "Arch")

pacwidget:buttons (awful.util.table.join (
	awful.button ({ }, 1, function () awful.util.spawn (exec_and_update_term("yaourt -Syu", "pacwidget")) end),
	awful.button ({ }, 3, function () awful.util.spawn (exec_and_update_term("yaourt -Sy", "pacwidget")) end)
))


-- Network widget
netinfo = wibox.widget.textbox ()
netwidget_t = awful.tooltip ({ objects = { netinfo } })

vicious.register (netinfo, vicious.widgets.wifi,
	function (w, args)
		netwidget_t:set_text (awful.util.pread ("netctl-auto-ng status --wpa=address,bssid,key_mgmt,ip_address,ssid"))

		if args["{ssid}"] == "N/A" then
			return widget (theme.widget_wifi_0, "Not connected")
		else
			local percent = args["{linp}"]
			local icon

			if percent >= 70 then
				icon = theme.widget_wifi_3
			elseif percent >= 35 then
				icon = theme.widget_wifi_2
			else
				icon = theme.widget_wifi_1
			end
			
			return widget (icon, args["{linp}"] .. "% " ..
			                     colorize (theme.fg_importance_2) (args["{ssid}"]) ..
			                     colorize (theme.fg_importance_0) (" (" .. args["{rate}"] .. " Mbps)"))
		end
	end, 37, "wlan0")

netmenu = awful.menu ({ items = {
	{ "Refresh status",                function () vicious.force ({ netinfo }) end },
	{ "Set mode [running-continuous]", function () awful.util.spawn (exec_and_update_term_hold ("sudo netctl-auto-ng continuous", "netinfo")) end },
	{ "Set mode [running-once]",       function () awful.util.spawn (exec_and_update_term_hold ("sudo netctl-auto-ng once", "netinfo")) end },
	{ "Set mode [halted]",             function () awful.util.spawn (exec_and_update_term_hold ("sudo netctl-auto-ng halt", "netinfo")) end },
	{ "Set mode [halted-suspend]",     function () awful.util.spawn (exec_and_update_term_hold ("sudo netctl-auto-ng suspend", "netinfo")) end },
	{ "Set mode [resume]",             function () awful.util.spawn (exec_and_update_term_hold ("sudo netctl-auto-ng resume", "netinfo")) end }
}})

netinfo:buttons (awful.util.table.join (
	awful.button ({ }, 1, function () netmenu:toggle () end),
	awful.button ({ }, 3, function () awful.util.spawn (exec_and_update_term_hold ("sudo netctl-auto-ng halt; sudo wifi-menu", "netinfo")) end)
))


-- CPU widget
cpufreqs = vicious_box (vicious.widgets.cpuinf,
	function (w, data)
		local output = { }

		local cpus_present =            cpu_list ("/sys/devices/system/cpu/present")
		local cpus_online  = hashtable (cpu_list ("/sys/devices/system/cpu/online"))

		for i, cpu in ipairs (cpus_present) do
			if cpus_online[cpu] then
				local freq = data["{cpu" .. cpu .. " mhz}"]
				local color

				if freq then
					if     freq > 2700 then color = beautiful.fg_importance_4 -- single-core turbo
					elseif freq > 2300 then color = beautiful.fg_importance_3 -- multi-core turbo
					elseif freq > 1700 then color = beautiful.fg_importance_2 -- above average
					elseif freq > 1000 then color = beautiful.fg_importance_1 -- core active
					else                    color = beautiful.fg_importance_0 -- core idle
					end

					table.insert (output, colorize (color) (freq .. "MHz"))
				else
					table.insert (output, "(no freq)")
				end
			else
				table.insert (output, "(stopped)")
			end
		end

		return table.concat (output, " ")
	end, 3)

cpuusage = vicious_box (vicious.widgets.cpu, widget (beautiful.widget_cpu, "$1%"), 3)

cpumenu = awful.menu ({ items = {
	{ "powersave",    function () awful.util.spawn ("sudo cpupower -c all frequency-set -g powersave") end },
	{ "performance",  function () awful.util.spawn ("sudo cpupower -c all frequency-set -g performance") end },
	{ "conservative", function () awful.util.spawn ("sudo cpupower -c all frequency-set -g conservative") end },
	{ "ondemand",     function () awful.util.spawn ("sudo cpupower -c all frequency-set -g ondemand") end }
}})

cpubuttons = awful.util.table.join (
	awful.button ({ }, 1, function () cpumenu:toggle () end),
	awful.button ({ }, 3, function () awful.util.spawn (c_task_manager) end)
)
cpufreqs:buttons (cpubuttons)
cpuusage:buttons (cpubuttons)


-- Battery widget
batbar = progressbar()
batwidget = vicious_box (battery,
	function (w, data)
		local state = data[1]
		local value = data[2]
		local power = data[4]
		local icon
		local color
		local aux = ""

		batbar:set_value (value / 100)
		
		if state == "↯" then -- full
			icon = beautiful.widget_bat_ac
		elseif state == "+" then -- charging
			icon = beautiful.widget_bat_chg
		else -- discharging
			if value >= 50 then
				icon = beautiful.widget_bat_3
			elseif value >= 25 then
				icon = beautiful.widget_bat_2
			elseif value >= 10 then
				icon = beautiful.widget_bat_1
			else
				icon = beautiful.widget_bat_0
			end
		end
		
		if power and power > 0 then
			if power > 20 then color = beautiful.fg_importance_4
			elseif power > 15 then color = beautiful.fg_importance_3
			elseif power > 11 then color = beautiful.fg_importance_2
			end

			aux = aux .. " " .. colorize (color) (power .. "W")
		end

		return widget (icon, value .. "%") .. aux
	end, 7, "BAT0")

powermenu = awful.menu ({ items = {
	{ "performance", function () awful.util.spawn ("sudo pm-powersave false") end },
	{ "powersave",   function () awful.util.spawn ("sudo pm-powersave true") end },
	{ "automatic",   function () awful.util.spawn ("sudo pm-powersave") end },
}})

batbuttons = awful.util.table.join (
	awful.button ({ }, 1, function () powermenu:toggle () end),
	awful.button ({ }, 3, function () awful.util.spawn (powertop) end)
)
batbar:buttons (batbuttons)
batwidget:buttons (batbuttons)


-- Sound volume widget
volbar = progressbar()
volwidget = vicious_box (vicious.widgets.volume,
	function (w, data)
		local value = data[1]
		local icon

		volbar:set_value (value / 100)
		
		if data[2] == "♫" then -- unmute
			if value > 66 then
				icon = beautiful.widget_vol_2
			elseif value > 33 then
				icon = beautiful.widget_vol_1
			else
				icon = beautiful.widget_vol_0
			end
		else -- mute
			icon = beautiful.widget_vol_m
		end
		
		return widget (icon, value .. "%")
	end, 13, sound_mixer)

function volume_toggle ()
	awful.util.spawn (exec_and_update("amixer -q sset " .. sound_mixer .. " toggle", "volwidget"))
end

function volume_up ()
	awful.util.spawn (exec_and_update("amixer -q sset " .. sound_mixer .. " 5%+", "volwidget"))
end

function volume_down ()
	awful.util.spawn (exec_and_update("amixer -q sset " .. sound_mixer .. " 5%-", "volwidget"))
end

function volume_mixer ()
	awful.util.spawn (exec_and_update_term("alsamixer", "volwidget"))
end

volbuttons = awful.util.table.join (
	awful.button ({ }, 1, volume_toggle),
	awful.button ({ }, 3, volume_mixer),
	awful.button ({ }, 4, volume_up),
	awful.button ({ }, 5, volume_down)
)
volbar:buttons (volbuttons)
volwidget:buttons (volbuttons)


-- Memory widget
membar = progressbar()
vicious.register (membar, vicious.widgets.mem, "$1", 11)

memwidget = wibox.widget.textbox ()
memwidget = vicious_box (vicious.widgets.mem,
	function (w, args)
		membar:set_value (args[1] / 100)
		return widget (beautiful.widget_mem, args[1] .. "%") .. " " .. args[2] .. "M"
	end, 11)

membuttons = awful.util.table.join (
    awful.button ({ }, 1, function () awful.util.spawn (c_task_manager) end)
)
memwidget:buttons (membuttons)
membar:buttons (membuttons)

-- }}}



-- {{{ Core wibox widgets

-- Create a wibox for each screen and add it
top_wibox = { }
bottom_wibox = { }
promptbox = { }
layout_selector = { }
tag_selector = { }
tag_selector.buttons = awful.util.table.join (
	awful.button ({ }, 1, awful.tag.viewonly),
	awful.button ({ "Shift" }, 1, awful.tag.viewtoggle),
	awful.button ({ }, 3, awful.client.movetotag),
	awful.button ({ "Shift" }, 3, awful.client.toggletag),
	awful.button ({ }, 4, awful.tag.viewnext),
	awful.button ({ }, 5, awful.tag.viewprev)
)

task_list = { }
task_list.buttons = awful.util.table.join (
	awful.button ({ }, 1,
		function (c)
			if c == client.focus then
				c.minimized = true
			else
				if not c:isvisible () then
					awful.tag.viewonly (c:tags ()[1])
				end
				-- This will also un-minimize
				-- the client, if needed
				client.focus = c
				c:raise ()
			end
		end),

	awful.button ({ }, 2,
		function ()
			awful.client.focus.byidx (1)
			if client.focus then client.focus:kill () end
		end),

	awful.button ({ }, 3,
		function ()
			if instance then
				instance:hide ()
				instance = nil
			else
				instance = awful.menu.clients ({ width = 250 })
			end
		end),

	awful.button ({ }, 4,
		function ()
			awful.client.focus.byidx (1)
			if client.focus then client.focus:raise () end
		end),

	awful.button ({ }, 5,
		function ()
			awful.client.focus.byidx (-1)
			if client.focus then client.focus:raise () end
		end)
)

for s = 1, screen.count () do
	-- Create a promptbox for each screen
	promptbox[s] = awful.widget.prompt ({ prompt = colorize (beautiful.taglist_fg_occupied) (" Run: ") })

	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	layout_selector[s] = textlayoutbox (s)
	layout_selector[s]:buttons (awful.util.table.join (
		awful.button ({ }, 1, function () awful.layout.inc (layouts, 1) end),
		awful.button ({ }, 3, function () awful.layout.inc (layouts, -1) end),
		awful.button ({ }, 4, function () awful.layout.inc (layouts, 1) end),
		awful.button ({ }, 5, function () awful.layout.inc (layouts, -1) end)
	))

	-- Create a taglist widget
	tag_selector[s] = awful.widget.taglist (s, awful.widget.taglist.filter.all, tag_selector.buttons)

	-- Create a tasklist widget
	task_list[s] = awful.widget.tasklist (s, awful.widget.tasklist.filter.currenttags, task_list.buttons)


	-- Left-aligned top panel widgets
	local top_left_layout = wibox.layout.fixed.horizontal ()
	top_left_layout:add (tag_selector[s])
	top_left_layout:add (promptbox[s])
	top_left_layout:add (separator_pipe)
	top_left_layout:add (layout_selector[s])
	top_left_layout:add (separator_pipe)

	-- Right-aligned top panel widgets
	local top_right_layout = wibox.layout.fixed.horizontal ()
	top_right_layout:add (build_bracketed (clockwidget))
	top_right_layout:add (build_bracketed (syswidget))
	top_right_layout:add (build_bracketed (wibox.widget.systray()))

	-- Build the top wibox
	local top_wibox_layout = wibox.layout.align.horizontal ()
	top_wibox_layout:set_left (top_left_layout)
	top_wibox_layout:set_middle (task_list[s])
	top_wibox_layout:set_right (top_right_layout)

	top_wibox[s] = awful.wibox ({ position = "top", screen = s, border_width = 0, height = 16 })
	top_wibox[s]:set_widget (top_wibox_layout)

	-- Left-aligned bottom panel widgets
	local down_left_layout = wibox.layout.fixed.horizontal ()
	down_left_layout:add (build_bracketed (volwidget, build_bar (volbar)))
	down_left_layout:add (build_bracketed (batwidget, build_bar (batbar)))
	down_left_layout:add (build_bracketed (memwidget, build_bar (membar)))
	down_left_layout:add (build_bracketed (cpuusage, cpufreqs))

	-- Right-aligned bottom panel widgets
	local down_right_layout = wibox.layout.fixed.horizontal ()
	down_right_layout:add (build_bracketed (mygmail))
	down_right_layout:add (build_bracketed (pacwidget))
	down_right_layout:add (build_bracketed (netinfo))
	down_right_layout:add (build_bracketed (tempwidget))
	down_right_layout:add (build_bracketed (uptimewidget))

	-- Build the bottom wibox
	local down_layout = wibox.layout.align.horizontal ()
	down_layout:set_left (down_left_layout)
	down_layout:set_right (down_right_layout)

	bottom_wibox[s] = awful.wibox ({ position = "bottom", screen = s, border_width = 0, height = 16 })
	bottom_wibox[s]:set_widget (down_layout)
end

-- }}}



-- {{{ Global mouse bindings

root.buttons (awful.util.table.join (
	awful.button ({ }, 3, function () mymainmenu:toggle () end),
	awful.button ({ }, 4, awful.tag.viewnext),
	awful.button ({ }, 5, awful.tag.viewprev)
))

-- }}}



-- {{{ Per-client mouse bindings

clientbuttons = awful.util.table.join (
    awful.button ({                 }, 1, function (c) client.focus = c; c:raise () end),
    awful.button ({ modkey          }, 1, awful.mouse.client.move),
    awful.button ({ modkey          }, 3, awful.mouse.client.resize),
	awful.button ({ modkey          }, 2, function (c) c.minimized = not c.minimized end))

-- }}}}



-- {{{ Global key bindings

globalkeys = awful.util.table.join (
	-- Layout and focus manipulations
    awful.key ({ modkey, "Control" }, "Left",   awful.tag.viewprev),
    awful.key ({ modkey, "Control" }, "Right",  awful.tag.viewnext),
    awful.key ({ modkey, "Control" }, "Escape", function () mymainmenu:show ({ keygrabber = true }) end),

    awful.key ({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key ({ modkey,           }, "u",      awful.client.urgent.jumpto),

    awful.key ({ modkey,           }, "Left",
		function ()
			awful.client.focus.byidx (1)
			if client.focus then client.focus:raise () end
		end),

    awful.key ({ modkey,           }, "Right",
		function ()
			awful.client.focus.byidx (-1)
			if client.focus then client.focus:raise () end
		end),

    awful.key ({ modkey            }, "b", -- Show/Hide Wibox
		function ()
			top_wibox[mouse.screen].visible = not top_wibox[mouse.screen].visible
			bottom_wibox[mouse.screen].visible = not bottom_wibox[mouse.screen].visible
		end),

    awful.key ({ modkey, "Shift"   }, "Left",
		function ()
			awful.client.swap.byidx (1)
		end),

    awful.key ({ modkey, "Shift"   }, "Right",
		function ()
			awful.client.swap.byidx (-1)
		end),

    awful.key ({ modkey,           }, "l",     function () awful.tag.incmwfact (0.05)     end),
    awful.key ({ modkey,           }, "h",     function () awful.tag.incmwfact (-0.05)    end),
    awful.key ({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster (1)       end),
    awful.key ({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster (-1)      end),
    awful.key ({ modkey, "Control" }, "h",     function () awful.client.incwfact (1)      end),
    awful.key ({ modkey, "Control" }, "l",     function () awful.client.incwfact (-1)     end),
    awful.key ({ modkey,           }, "space", function () awful.layout.inc (layouts,  1) end),
    awful.key ({ modkey, "Shift"   }, "space", function () awful.layout.inc (layouts, -1) end),

    -- Standard programs
	awful.key ({                           }, "F12",     function () scratch.drop ("urxvt -name urxvt.drop", "top", "center", 0.8, 0.4, true) end),
    awful.key ({ modkey,                   }, "Return", function () awful.util.spawn (terminal)                                               end),
    awful.key ({ modkey, "Control"         }, "Return",
		function ()
			local alter_func
			alter_func = function (c)
				awful.client.floating.set (c, true)
				c.sticky = true
				c.ontop = true
				client.disconnect_signal ("manage", alter_func)
			end

			client.connect_signal ("manage", alter_func)
			awful.util.spawn (terminal)
		end),
    awful.key ({ modkey,            altkey }, "Return", function () awful.util.spawn ("sudo " .. terminal)                         end),
    awful.key ({ modkey, "Control", altkey }, "q",      function () awful.util.spawn (c_file_manager_gui)                          end),
    awful.key ({ modkey, "Control", altkey }, "w",      function () awful.util.spawn (c_browser_gui)                               end),
    awful.key ({ modkey, "Control", altkey }, "e",      function () awful.util.spawn (c_editor_gui)                                end),
    awful.key ({ modkey, "Control", altkey }, "r",      function () awful.util.spawn (c_mail)                                      end),
    awful.key ({ modkey, "Control", altkey }, "t",      function () awful.util.spawn (c_im)                                        end),
    awful.key ({ modkey, "Control", altkey }, "y",      function () awful.util.spawn (c_mail_create)                               end),
    awful.key ({ modkey, "Control", altkey }, "a",      function () awful.util.spawn (c_music_player)                              end),
    awful.key ({ modkey, "Control", altkey }, "s",      function () awful.util.spawn (c_task_manager)                              end),
    awful.key ({ modkey, "Control", altkey }, "d",      function () awful.util.spawn ("kdevelop")                                  end),
    awful.key ({ modkey, "Control", altkey }, "f",      function () awful.util.spawn (terminal_run .. "sudo wifi-menu")            end),

    -- Window manager
    awful.key ({ modkey,                   }, "l",      function () awful.util.spawn ("/usr/lib/kde4/libexec/kscreenlocker_greet") end),
    awful.key ({ modkey,                   }, "x",      function () awful.util.spawn ("xkill")                                     end),
	awful.key ({ modkey, "Control"         }, "r",      awesome.restart                                                               ),
    awful.key ({                           }, "Print",  function () awful.util.spawn ("ksnapshot")                                 end),

    -- Prompt
    awful.key ({ modkey                    }, "r",      function () promptbox[mouse.screen]:run ()                                 end),
    awful.key ({ modkey, "Control"         }, "r",
		function ()
			awful.prompt.run (
				{ prompt = "Run in terminal: " },
				promptbox[mouse.screen].widget,
				function (...) awful.util.spawn (terminal .. " -hold -e " .. ...) end,
				awful.completion.shell,
				awful.util.getdir ("cache") .. "/history")
		end),

	-- Functional keys
    awful.key ({                           }, "XF86AudioRaiseVolume", volume_up                                                       ),
    awful.key ({                           }, "XF86AudioLowerVolume", volume_down                                                     ),
    awful.key ({                           }, "XF86AudioMute",        volume_toggle                                                   ),
    awful.key ({                           }, "XF86Sleep",            function () awful.util.spawn ("systemctl suspend")           end),
    awful.key ({         "Shift"           }, "XF86Sleep",            function () awful.util.spawn ("systemctl hibernate")         end)
)

-- }}}



-- {{{ Per-client key bindings

clientkeys = awful.util.table.join (
    awful.key ({ modkey,                   }, "s",      function (c) c.fullscreen = not c.fullscreen    end),
    awful.key ({ modkey,                   }, "c",      function (c) c:kill ()                          end),
    awful.key ({ modkey,                   }, "f",      awful.client.floating.toggle                       ),
    awful.key ({ modkey,                   }, "d",      awful.placement.centered                           ),
    awful.key ({ modkey, "Shift"           }, "Return", function (c) c:swap (awful.client.getmaster ()) end),
    awful.key ({ modkey,                   }, "o",      awful.client.movetoscreen                          ),
    awful.key ({ modkey, "Shift"           }, "r",      function (c) c:redraw ()                        end),
    awful.key ({ modkey,                   }, "t",      function (c) c.ontop = not c.ontop              end),
    awful.key ({ modkey,                   }, "k",      function (c) c.sticky = not c.sticky            end),
    awful.key ({ modkey,                   }, "n",      function (c) c.minimized = not c.minimized      end),
    awful.key ({ modkey,                   }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end)
)

-- }}}



-- {{{ Tag manipulation bindings

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count () do
	keynumber = math.min (9, math.max (#tags[s], keynumber));
end

-- For the rules
rules_do_switchtotag = true

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
	globalkeys = awful.util.table.join (globalkeys,
		awful.key ({ modkey }, "#" .. i + 9,
			function ()
				local screen = mouse.screen
				if tags[screen][i] then
					awful.tag.viewonly (tags[screen][i])

					if not (i == 9) then awful.tag.viewtoggle (tags[screen][9]) end -- the "other" tag
					rules_do_switchtotag = true
				end
			end),

		awful.key ({ modkey, "Shift" }, "#" .. i + 9,
			function ()
				local screen = mouse.screen
				if tags[screen][i] then
					awful.tag.viewtoggle (tags[screen][i])
					rules_do_switchtotag = false
				end
			end),

		awful.key ({ modkey, "Control" }, "#" .. i + 9,
			function ()
				local screen = client.focus.screen
				if client.focus and tags[screen][i] then
					awful.client.movetotag (tags[screen][i])
					awful.tag.viewonly (tags[screen][i])
					rules_do_switchtotag = true
				end
			end),

		awful.key ({ modkey, altkey, "Shift" }, "#" .. i + 9,
			function ()
				if client.focus and tags[client.focus.screen][i] then
					awful.client.toggletag (tags[client.focus.screen][i])
				end
			end))
end

-- }}}



-- {{{ Set global keys (no reorder, this is after key number binding!)

root.keys (globalkeys)

-- }}}



-- {{{ Rules

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     maximized_vertical = false,
                     maximized_horizontal = false,
                     size_hints_honor = false,
                     tag = tags[1][9],
                     switchtotag = function () return rules_do_switchtotag end
                    } },

    { rule = { class = "Qt4-ssh-askpass" },
      properties = { sticky = true, ontop = true, border_width = 0, above = true, modal = true, floating = true, size_hints_honor = true, tag = nil, switchtotag = false } },

    { rule = { class = "Kcolorchooser" },
      properties = { sticky = true, ontop = true, floating = true, tag = nil, switchtotag = false } },

    { rule = { class = "Vncviewer" },
      properties = { tag = tags[1][7] } },

    { rule = { class = "Wine" },
      properties = { tag = tags[1][8] } },

    { rule = { instance = "plugin-container" },
      properties = { floating = true, ontop = true, switchtotag = true } },

    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },

    { rule = { class = "Konqueror" },
      properties = { tag = tags[1][2] } },

    { rule = { class = "Rekonq" },
      properties = { tag = tags[1][2] } },

    { rule = { class = "Google-chrome" },
      properties = { tag = tags[1][2], maximized_vertical = true, maximized_horizontal = true, floating = false } },

    { rule = { class = "Firefox", instance = "Download" },
      properties = { tag = tags[1][2], floating = true } },

    { rule_any = { class = { "URxvt", "Konsole" } },
      properties = { tag = tags[1][1] } },

    { rule = { instance = "urxvt.drop" },
      properties = { tag = tags[1][1], switchtotag = false } },

    { rule = { class = "Qjackctl" },
      properties = { tag = tags[1][1] } },

    { rule = { class = "Thunderbird" },
      properties = { tag = tags[1][4] } },

    { rule = { class = "Kmail", role = "kmail-composer#1" },
      properties = { tag = tags[1][4], floating = true } },

    { rule_any = { class = { "Skype", "Kopete", "Kmail", "Konversation" } },
      properties = { tag = tags[1][4] } },

    { rule = { class = "Gpicview" },
      properties = { tag = tags[1][3] } },

    { rule = { class = "Qalculate-gtk" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "Convertall.py" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "QtConverter.pyw" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "Kmplot" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "Kdenlive" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "Gelemental" },
      properties = { tag = tags[1][6] } },

    { rule_any = { class = { "Ktechlab", "Kate", "Kdevelop" } },
      properties = { tag = tags[1][6] } },

    { rule = { class = "Gimp" },
      properties = { tag = tags[1][6] } },

    { rule = { instance = "Blender" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "Gitk" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "Git-cola" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "Qtcreator" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "Eclipse" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "libreoffice-*" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "FBReader" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "Gucharmap" },
      properties = { tag = tags[1][3] } },

    { rule = { class = "Thunar" },
      properties = { tag = tags[1][3] } },

    { rule_any = { class = { "Dolphin", "7zG", "Ark" } },
      properties = { tag = tags[1][3] } },

    { rule = { class = "Hardinfo" },
      properties = { tag = tags[1][3] } },

    { rule = { class = "Gpartedbin" },
      properties = { tag = tags[1][3] } },

    { rule = { class = "Partitionmanager-bin" },
      properties = { tag = tags[1][3] } },

    -- these KDE windows are of type "normal"
    { rule_any = { name = { "Перемещение*",
                            "Перемещение",
                            "Копирование*",
                            "Копирование",
                            "Передача*",
                            "Передача",
                            "Удаление*",
                            "Удаление",
                            "Moving*",
                            "Moving",
                            "Copying*",
                            "Copying",
                            "Deleting*",
                            "Deleting" } },
      properties = { floating = true } },

    { rule = { name = "Процесс выполнения" },
      properties = { floating = true } },

    { rule = { class = "Okular" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "Digikam" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "Amarok" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "Cantata" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "Puddletag" },
      properties = { tag = tags[1][3] } },

    { rule = { class = "K3b" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "Avidemux2_gtk" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "Avidemux2_qt" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "SMPlayer" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "MPlayer" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "Vlc" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "Gwenview" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "Showfoto" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "Wxcam" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "VirtualBox" },
      properties = { tag = tags[1][7] } },

    { rule = { class = "emulator*" },
      properties = { tag = tags[1][7] } },

    { rule = { type = "dialog" },
      properties = { floating = true } }
}

-- }}}



-- {{{ Signals

function client_configure_border_width (c)
	if awful.client.floating.get (c) == true then
		c.border_width = 2
	else
		c.border_width = 0
	end
end


client.connect_signal ("property::floating", client_configure_border_width)
client.connect_signal ("manage", client_configure_border_width)

-- Signal function to execute when a new client appears.
client.connect_signal ("manage",
	function (c)

		-- Add a titlebar
		-- awful.titlebar.add (c, { modkey = modkey })

		-- Enable sloppy focus
		c:connect_signal ("mouse::enter",
			function (c)
				if awful.layout.get (c.screen) ~= awful.layout.suit.magnifier
				and awful.client.focus.filter (c) then
					client.focus = c
				end
			end)

		if not startup then
			-- Set the windows at the slave,
			-- i.e. put it at the end of others instead of setting it master.
			awful.client.setslave (c)

			-- Put windows in a smart way, only if they does not set an initial position.
			if not c.size_hints.user_position
			and not c.size_hints.program_position then
				-- awful.placement.no_overlap (c)
				-- awful.placement.no_offscreen (c)
			end
		end
	end)

client.connect_signal ("focus",
	function (c)
		c.border_color = beautiful.border_focus
	end)
client.connect_signal ("unfocus",
	function (c)
		c.border_color = beautiful.border_normal
	end)

--mymainmenu.connect_signal ("focus",     function (c) c.border_color = beautiful.border_focus; c.opacity = 1 end)
--mymainmenu.connect_signal ("unfocus",   function (c) c.border_color = beautiful.border_normal; c.opacity = 1 end)

-- }}}



-- {{{ Functions to help launch run commands in a terminal using ":" keyword

function check_for_terminal (command)
	if command:sub (1,1) == ":" then
		command = terminal .. ' -e "' .. command:sub (2) .. '"'
	end
	awful.util.spawn (command)
end

function clean_for_completion (command, cur_pos, ncomp, shell)
	local term = false

	if command:sub (1,1) == ":" then
		term = true
		command = command:sub (2)
		cur_pos = cur_pos - 1
	end

	command, cur_pos = awful.completion.shell (command, cur_pos, ncomp, shell)

	if term == true then
		command = ':' .. command
		cur_pos = cur_pos + 1
	end

	return command, cur_pos
end

-- }}}

-- {{{ Disable startup-notification globally

local oldspawn = awful.util.spawn
awful.util.spawn = function (s) oldspawn (s, false) end

-- }}}
