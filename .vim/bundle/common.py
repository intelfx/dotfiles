from snake import *
import vim
import itertools
import sys
import io

logfile = io.open("%s/snake.log" % (os.environ["HOME"]), "w")

def log(*args):
#	pass
	print(file=logfile, flush=True, *args)

@contextmanager
def preserve_options(*options):
	""" prevents a change of said Vim options """

	old_options = { get_option(o) for o in options }

	try:
		yield
	finally:
		for o, v in old_options.items():
			set_option(o, v)

@contextmanager
def assume_options(**options):
	""" temporarily sets Vim options """

	old_options = { }

	for o, v in options.items():
		old_options[o] = get_option(o)
		set_option(o, v)

	try:
		yield
	finally:
		for o, v in old_options.items():
			set_option(o, v)

def get_path():
	with assume_options(iskeyword = get_option("isfname")):
		path = get_word()
	return path

#  vim: set ft=python ts=8 sw=8 tw=0 noet :
