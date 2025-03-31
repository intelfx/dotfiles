lib = {}

local mp = require 'mp'
local inspect = require 'inspect'

function lib.copy(obj, seen)
	if type(obj) ~= 'table' then return obj end
	if seen and seen[obj] then return seen[obj] end
	local s = seen or {}
	local res = {}
	s[obj] = res
	for k, v in next, obj do res[lib.copy(k, s)] = lib.copy(v, s) end
	return setmetatable(res, getmetatable(obj))
end
table.copy = lib.copy

local function iteradjpairs(t, i)
	local v1, v2 = t[i+1], t[i+2]
	if v1 and v2 then
		i = i + 2
		return i, v1, v2
	end
end

function lib.adjpairs(t)
	return iteradjpairs, t, 0
end

function lib.dump_props(...)
	for _, k in ipairs{...} do
		local v = mp.get_property_native(k)
		mp.msg.info('XXX: ' .. k .. ' = ' .. inspect(v))
	end
end

function lib.dump_vars(...)
	for _, n, v in lib.adjpairs{...} do
		mp.msg.info('XXX: ' .. n .. ' = ' .. inspect(v))
	end
end

function os.system(cmd)
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))
	f:close()
	return s
end
function os.capture(cmd)
	local s = os.system(cmd)
	s = string.gsub(s, '^%s+', '')
	s = string.gsub(s, '%s+$', '')
	s = string.gsub(s, '[\n\r]+', ' ')
	return s
end

return lib
