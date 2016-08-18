from snake import *
from snake.plugins.common import *
import vim
import os

@key_map("gf")
def goto_file_ex():
	filetype = get_option("filetype")

	if filetype == "cmake":
		# interpret path rel. to current file
		path = os.path.join(os.path.dirname(expand("%")), get_path(), "CMakeLists.txt")
		if os.path.isfile(path):
			vim.command("e %s" % escape_spaces(path))
			return

	keys("!gf")

#  vim: set ft=python ts=8 sw=8 tw=0 noet :
