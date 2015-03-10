---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2010, Adrian C. <anrxc@sysphere.org>
-- modified by intelfx
--  * (c) 2015, Ivan Shapovalov <intelfx100@gmail.com>
---------------------------------------------------

-- {{{ Grab environment
local setmetatable = setmetatable
local string = { strip = string.strip }
local helpers = require("vicious.helpers")
-- }}}


-- Thermal: read temperature sensors in /sys/class/thermal
-- vicious.widgets.thermal
local thermal = {}


-- {{{ Thermal widget type
local function worker(format, warg)
    if not warg then return end

    -- Get temperature from thermal zone
    local _thermal = helpers.pathtotable("/sys/class/thermal/" .. warg[1])

	local name = _thermal["type"]
	local data = _thermal["temp"]

	if data then
		return { data /1000, name and name:rtrim() or "N/A" }
	else
		return { 0, "N/A" }
	end
end
-- }}}

return setmetatable(thermal, { __call = function(_, ...) return worker(...) end })
