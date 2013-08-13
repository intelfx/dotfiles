------------------------------------------------
-- awesome theme (theme.lua)
-- by intelfx
--   intelfx100 at gmail dot com
-- skeleton by TheImmortalPhoenix
--   http://theimmortalphoenix.deviantart.com
-- inspired by KniRen
--   http://kniren.deviantart.com/art/Archlinux-Xmonad-May-07-13-370268797
------------------------------------------------

require ("custom.util")

-- {{{ Main
theme = {}
theme.confdir = awful.util.getdir("config") .. "/themes/current"
theme.wallpaper = awful.util.getdir("config") .. "/wallpapers/surface.png"
theme.colors_solarized = {}
theme.colors_solarized.base03  = "#002b36"
theme.colors_solarized.base02  = "#073642"
theme.colors_solarized.base01  = "#586e75"
theme.colors_solarized.base00  = "#657b83"
theme.colors_solarized.base0   = "#839496"
theme.colors_solarized.base1   = "#93a1a1"
theme.colors_solarized.base2   = "#eee8d5"
theme.colors_solarized.base3   = "#fdf6e3"
theme.colors_solarized.yellow  = "#b58900"
theme.colors_solarized.orange  = "#cb4b16"
theme.colors_solarized.red     = "#dc322f"
theme.colors_solarized.magenta = "#d33682"
theme.colors_solarized.violet  = "#6c71c4"
theme.colors_solarized.blue    = "#268bd2"
theme.colors_solarized.cyan    = "#2aa198"
theme.colors_solarized.green   = "#859900"

theme.colors_kniren = {}
theme.colors_kniren.black      = { "#393939", "#121212" }
theme.colors_kniren.red        = { "#da3955", "#ff4775" }
theme.colors_kniren.green      = { "#308888", "#53a6a6" }
theme.colors_kniren.yellow     = { "#54777d", "#348d9d" }
theme.colors_kniren.blue       = { "#6d9cbe", "#91c1e3" }
theme.colors_kniren.magenta    = { "#6f4484", "#915eaa" }
theme.colors_kniren.cyan       = { "#2b7694", "#47959e" }
theme.colors_kniren.white      = { "#d6d6d6", "#a3a3a3" }
theme.colors_kniren.background = { "#000000", "#444444" }

theme.colors_solarized.STUB1 = theme.colors_solarized.magenta
theme.colors_solarized.STUB2 = theme.colors_solarized.violet

-- }}}

-- {{{ Styles

theme.font       = "Terminus 8"
theme.icon_theme = "KFaenza"

theme.font_symbols = "symbols 8"

-- {{{ Colors
theme.fg_normal  = theme.colors_kniren.background[2]
theme.bg_normal  = theme.colors_kniren.background[1]

theme.fg_focus = theme.colors_kniren.white[1]
theme.bg_focus = theme.fg_normal

theme.fg_urgent = theme.colors_kniren.red[1]
theme.bg_urgent = theme.bg_normal

theme.fg_importance_0 = theme.fg_normal
theme.fg_importance_1 = theme.colors_kniren.white[2]
theme.fg_importance_2 = theme.colors_kniren.yellow[1]
theme.fg_importance_3 = theme.colors_kniren.magenta[1]
theme.fg_importance_4 = theme.colors_kniren.red[1]

-- }}}

-- {{{ Widgets
theme.bar_fg = theme.fg_focus
theme.bar_bg = theme.bg_focus

theme.separator_fg = "#888888"
theme.widget_text_fg = theme.fg_importance_1
theme.widget_icon_fg = theme.fg_focus
-- }}}

-- {{{ Borders
theme.border_width  = "2"
theme.border_normal = theme.colors_kniren.black[2]
theme.border_focus  = theme.colors_kniren.cyan[1]
theme.border_marked = theme.colors_kniren.red[1]
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
-- }}}

-- {{{ Mouse finder
-- theme.mouse_finder_color =
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
-- theme.menu_border_width = "1"
-- theme.menu_border_color = "#afa72e"
theme.menu_height = "12"
theme.menu_width  = "200"
theme.menu_border_width  = "0"

theme.menu_fg_focus = theme.fg_focus
theme.menu_bg_focus = theme.bg_normal
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
-- theme.taglist_bg_focus = "#CC9393"

-- {{{ Tasklist
theme.tasklist_disable_icon = true

theme.tasklist_fg_focus = theme.fg_importance_1
theme.tasklist_bg_focus = theme.bg_normal
-- }}}


-- {{{ Taglist
theme.taglist_fg_urgent = theme.colors_kniren.red[1]
theme.taglist_bg_urgent = theme.bg_normal
theme.taglist_fg_focus = theme.fg_focus
theme.taglist_bg_focus = theme.colors_kniren.green[1]
theme.taglist_fg_occupied = theme.colors_kniren.green[1]
theme.taglist_bg_occupied = theme.bg_normal
-- }}}

-- }}}


-- {{{ Titlebar
theme.titlebar_close_button_focus  = theme.confdir .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.confdir .. "/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = theme.confdir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.confdir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.confdir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.confdir .. "/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = theme.confdir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.confdir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.confdir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.confdir .. "/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = theme.confdir .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.confdir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.confdir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.confdir .. "/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = theme.confdir .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.confdir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.confdir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "/titlebar/maximized_normal_inactive.png"
-- }}}

-- {{{ Layout
theme.layout_fg = theme.colors_kniren.green[1]
theme.layout_bg = theme.bg_normal

theme.layout_fairh      = private_char(4)
theme.layout_fairv      = private_char(3)
theme.layout_floating   = private_char(5)
theme.layout_magnifier  = nil
theme.layout_max        = private_char(0)
theme.layout_fullscreen = nil
theme.layout_tilebottom = private_char(2)
theme.layout_tileleft   = nil
theme.layout_tile       = private_char(1)
theme.layout_tiletop    = nil
theme.layout_spiral     = private_char(8)
theme.layout_dwindle    = private_char(9)
-- }}}

-- {{{ Misc
theme.menu_submenu_icon      = theme.confdir .. "/submenu.png"
-- }}}

-- {{{  Widget icons
theme.widget_sys = private_char (0xF0)
theme.widget_clock = private_char (0xFB)
theme.widget_uptime = private_char (0x20)
theme.widget_temp = private_char (0xE3)
theme.widget_mail_empty = private_char (0xF6)
theme.widget_mail = private_char (0xF5)
theme.widget_pac = private_char (0xF1)

theme.widget_wifi_0 = private_char (0x40)
theme.widget_wifi_1 = private_char (0x41)
theme.widget_wifi_2 = private_char (0x42)
theme.widget_wifi_3 = private_char (0x43)

theme.widget_vol_m = private_char (0x30)
theme.widget_vol_0 = private_char (0x31)
theme.widget_vol_1 = private_char (0x32)
theme.widget_vol_2 = private_char (0x33)

theme.widget_bat_ac = private_char (0x21)
theme.widget_bat_chg = private_char (0x23)
theme.widget_bat_0 = private_char (0x24)
theme.widget_bat_1 = private_char (0x25)
theme.widget_bat_2 = private_char (0x26)
theme.widget_bat_3 = private_char (0x27)

theme.widget_cpu = private_char (0xEB)
theme.widget_mem = private_char (0xE4)
-- }}}

return theme
