local mp = require 'mp'

package.path = mp.command_native({"expand-path", "~~/script-libs/?.lua;"})..package.path
local inspect = require 'inspect'
local url = require 'net/url'
local lib = require 'lib'

mp.add_hook('on_load', 10, function()
	local pat_ext = '%.[^/.]+$'

	local path = mp.get_property('path')
	local parsed = url.parse(path)

	if parsed.authority ~= '' and parsed.path:match(pat_ext) then
		parsed.path = parsed.path:gsub(pat_ext, '.srt')
		mp.commandv('change-list', 'sub-files', 'append', tostring(parsed))
	end
end)
