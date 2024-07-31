local mp = require 'mp'

mp.add_hook('on_load', 10, function()
	local path = mp.get_property('path')

	if path:find('://') then
		mp.commandv('change-list', 'sub-files', 'append', (path:gsub('[^.]+$', 'srt')))
	end
end)
