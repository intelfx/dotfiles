import tempfile
import os.path as p
import subprocess

import vim
import snake
from snake.plugins import common

@snake.on_autocmd("BufWritePre", "*")
@snake.preserve_cursor()
def trim_whitespace_commit_pipe(ctx):
	# call Vim's fnameescape directly on <afile> to avoid multiple Vim-Python roundtrips
	src_path = common.fnameescape('<afile>:p')
	#src_path = snake.expand('<afile>:p')
	#src_path = common.fnameescape(src_path)
	vim.command(f"silent '[,']! diff -Nu '{src_path}' - | sed -r '/^\+/s|[[:blank:]]+$||' | (cd /tmp && patch --force --silent -o- '{src_path}' -)")


@snake.on_autocmd("FileWritePre,FileAppendPre,FilterWritePre", "*")
def trim_whitespace_not_implemented(ctx):
	print('trim_whitespace: autocommand not implemented!')
