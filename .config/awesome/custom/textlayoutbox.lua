---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2009 Julien Danjou
-- @release v3.5.1
--
-- modified by intelfx
--   intelfx100 at gmail dot com
---------------------------------------------------------------------------

local setmetatable = setmetatable
local ipairs = ipairs
local button = require("awful.button")
local layout = require("awful.layout")
local tag = require("awful.tag")
local beautiful = require("beautiful")
local textbox = require("wibox.widget.textbox")

-- Own utility functions
require("custom.util")

--- textlayoutbox widget, drop-in for awful.widget.layoutbox
local textlayoutbox = { mt = {} }

local function update(w, screen)
    local layout = layout.getname(layout.get(screen))
	local theme = beautiful.get()
	local fg = theme.layout_fg or theme.fg_normal
	local bg = theme.layout_bg or theme.bg_normal
    w:set_markup(layout and colorize (fg, bg, theme.font_symbols) (beautiful["layout_" .. layout]))
end

--- Create a textlayoutbox widget. It draws a symbol of layout of the current tag.
-- @param screen The screen number that the layout will be represented for.
-- @return A textbox widget configured as a textlayoutbox.
function textlayoutbox.new(screen)
    local screen = screen or 1
    local w = textbox()
    update(w, screen)

    local function update_on_tag_selection(t)
        return update(w, tag.getscreen(t))
    end

    tag.attached_connect_signal(screen, "property::selected", update_on_tag_selection)
    tag.attached_connect_signal(screen, "property::layout", update_on_tag_selection)

    return w
end

function textlayoutbox.mt:__call(...)
    return textlayoutbox.new(...)
end

return setmetatable(textlayoutbox, textlayoutbox.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
