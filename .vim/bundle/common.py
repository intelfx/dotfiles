import sys
import io
import os
import itertools
from contextlib import contextmanager

import vim
import snake

logfile = io.open("%s/snake.log" % (os.environ["HOME"]), "w")
ctr = 0

def incctr():
	global ctr
	ctr = ctr + 1
	return ctr

def log(arg):
#	pass
	print(arg, file=logfile, flush=True)
#	print(f"Log {incctr()}: {arg}")

@contextmanager
def preserve_options(*options):
	""" prevents a change of said Vim options """

	old_options = { snake.get_option(o) for o in options }

	try:
		yield
	finally:
		for o, v in old_options.items():
			snake.set_option(o, v)

@contextmanager
def assume_options(**options):
	""" temporarily sets Vim options """

	old_options = { }

	for o, v in options.items():
		old_options[o] = snake.get_option(o)
		snake.set_option(o, v)

	try:
		yield
	finally:
		for o, v in old_options.items():
			snake.set_option(o, v)

def get_path():
	with assume_options(iskeyword = snake.get_option("isfname")):
		path = snake.get_word()
	return path

def fnameescape(arg):
	# TODO: reimplement in pure Python
	return vim.eval(f"fnameescape('{snake.escape_string_sq(arg)}')")

def ranges(lines):
	"""lines must be sorted"""
	for key, sublist in itertools.groupby(enumerate(lines), lambda p: p[1] - p[0]):
		sublist = list(sublist)
		yield sublist[0][1], sublist[-1][1] # first, last in sublist

#  vim: set ft=python ts=8 sw=8 tw=0 noet :
