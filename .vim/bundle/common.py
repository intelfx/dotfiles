from snake import *
import vim
import itertools
import sys
import io

logfile = io.open("%s/snake.log" % (os.environ["HOME"]), "w")

def log(*args):
#	pass
	print(file=logfile, flush=True, *args)

#  vim: set ft=python ts=8 sw=8 tw=0 noet :
