from os import path as p
from functools import partial
import importlib

import vim
import snake
from snake.plugins import common

class Rooter:
	def __init__(self, path):
		self.path = path

		# update project root
		self.root = None
		path = self.path
		while True:
			if not p.exists(p.join(path, ".rooter-ignore")):
				if p.exists(p.join(path, ".git")):
					self.root = path
					break

				if p.isfile(p.join(path, ".pvimrc")):
					self.root = path
					break

				if p.isfile(p.join(path, ".pvimrc.py")):
					self.root = path
					break

			path, oldpath = p.dirname(path), path
			if path == oldpath:
				break

		# update vimrc list
		self.rcfiles = []
		path = self.path
		while True:
			# we are walking pathes from most specific to least specific,
			# so process rc files in order of decreasing priority
			# and reverse the list afterwards.
			self.rcfiles += self.update_process_vimrc_py(p.join(path, ".lvimrc.py"))
			self.rcfiles += self.update_process_vimrc(p.join(path, ".lvimrc"))
			self.rcfiles += self.update_process_vimrc_py(p.join(path, ".pvimrc.py"))
			self.rcfiles += self.update_process_vimrc(p.join(path, ".pvimrc"))

			path, oldpath = p.dirname(path), path
			if path == oldpath:
				break

		self.rcfiles.reverse()

	def update_process_vimrc(self, vimrc_path):
		if p.isfile(vimrc_path):
			cmd = f"source {common.fnameescape(vimrc_path)}"
			return [ partial(vim.command, cmd) ]
		return []

	def update_process_vimrc_py(self, vimrc_py_path):
		if p.isfile(vimrc_py_path):
			spec = importlib.util.spec_from_file_location("", vimrc_py_path)
			module = importlib.util.module_from_spec(spec)
			return [ partial(spec.loader.exec_module, module) ]
		return []

	def apply(self, cd = True, vimrc = True):
		# apply project root
		if cd and self.root is not None:
			vim.command(f"lcd {common.fnameescape(self.root)}")

		# apply lvimrc files
		if vimrc:
			for rc in self.rcfiles:
				rc()

rooter_objs = {}

@snake.on_autocmd("BufNew,BufFilePost,BufWinEnter", "*")
def rooter(ctx):
	# due to the completely horrible and brain-dead way Vim emits autocmds,
	# we will catch all autocmd events with a single handler and deduce our
	# way disregarding the exact event that happened.
	#
	# TODO: when Vim is opened without arguments in a non-root directory and
	#       the empty buffer is saved under a certain name, Vim is re-rooted
	#       before the save occurs and the file is saved in the root instead
	#       of what user wants.

	b = vim.current.buffer.number

	path = p.dirname(snake.expand("%:p"))
	cd = True
	if path == "":
		path = vim.eval("getcwd()")
		cd = False

	try:
		obj = rooter_objs[b]
		if obj.path != path:
			raise KeyError # inject
	except KeyError:
		obj = Rooter(path)
		rooter_objs[b] = obj

	obj.apply(cd = cd)

@snake.on_autocmd("BufDelete", "*")
def rooter_delete(ctx):
	b = snake.expand("<abuf>")

	try:
		del rooter_objs[b]
	except KeyError:
		pass
