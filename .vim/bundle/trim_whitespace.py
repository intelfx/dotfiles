#
# FIXME: unfinished, doesn't work
#

import tempfile
import os.path as p
import subprocess

import vim
import snake
from snake.plugins.common import *


@snake.on_autocmd("BufWritePre", "*")
@snake.preserve_cursor()
def trim_whitespace_commit_pipe(ctx):
	src_path = snake.expand('<afile>:p')
	vim.command(f"silent '[,']! diff -u {src_path} - | sed -r '/^\+/s|[[:blank:]]+$||' | patch --force --silent -o- {src_path} -")


@snake.on_autocmd("FileWritePre,FileAppendPre,FilterWritePre", "*")
def trim_whitespace_not_implemented(ctx):
	print('trim_whitespace: autocommand not implemented!')
