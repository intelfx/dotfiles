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


-- Hwmon: read temperature sensors in /sys/class/hwmon
-- vicious.widgets.hwmon
local hwmon = {}


-- {{{ Hwmon widget type
local function worker(format, warg)
    if not warg then return end

    -- Get temperature from thermal zone
    local _thermal = helpers.pathtotable("/sys/class/hwmon/" .. warg[1])

	local name  = _thermal["name"]
	local label = _thermal[(warg[2] or "temp1") .. "_label"]
	local data  = _thermal[(warg[2] or "temp1") .. "_input"]

    if data then
		return { data / 1000, name and name:rtrim() or "N/A", label and label:rtrim() or "N/A" }
	else
		return { 0, "N/A", "N/A" }
    end
end
-- }}}

return setmetatable(hwmon, { __call = function(_, ...) return worker(...) end })
