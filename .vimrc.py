from snake import *
import vim
import itertools
import sys
import io

#logfile = io.open("%s/snake.log" % (os.environ["HOME"]), "w")

def log(*args):
	pass
#	print(file=logfile, flush=True, *args)

def my_get(name):
	return get(name, namespace="rtrim", scope=NS_BUFFER)

def my_let(context, name, value):
	return context.let(name, value, namespace="rtrim")

@on_autocmd("BufNewFile,BufReadPost", "*")
def trim_whitespace_setup(context):
	log("trim_whitespace_setup")
	my_let(context, "modified_lines", " ")
	my_let(context, "line_count", vim.eval("line(\"$\")"))

def trim_whitespace_lines_inserted(context, first, last):
	log("trim_whitespace_lines_inserted: [%d; %d]" % (first, last))

	lines = sorted(set(int(x) for x in my_get("modified_lines").split(None)))

	diff = last - first
	lines = [r        for r in lines if r < first] + \
		[r        for r in range(first, last + 1)] + \
	        [r + diff for r in lines if r > last]

	my_let(context, "modified_lines", " " + " ".join(str(x) for x in lines) + " ")

def trim_whitespace_lines_removed(context, first, last):
	log("trim_whitespace_lines_removed: [%d; %d]" % (first, last))

	lines = sorted(set(int(x) for x in my_get("modified_lines").split(None)))

	diff = last - first
	lines = [r        for r in lines if r < first] + \
	        [r - diff for r in lines if r > last]

	my_let(context, "modified_lines", " " + " ".join(str(x) for x in lines) + " ")

@on_autocmd("TextChanged,TextChangedI", "*")
def trim_whitespace_remember_line(context):
	line_count_old = int(my_get("line_count"))
	line_count = int(vim.eval("line(\"$\")"))


	if line_count_old != line_count:
		log("trim_whitespace_remember_line: line_count %d -> %d" % (line_count_old, line_count))
		change_start = int(vim.eval("line(\"'[\")"))
		change_end = int(vim.eval("line(\"']\")"))

		log("trim_whitespace_remember_line: last change range [%s; %s]" % (change_start, change_end))
		if line_count > line_count_old:
			log("trim_whitespace_remember_line: lines inserted, using change range")
			trim_whitespace_lines_inserted(context, change_start, change_end)
		else:
			diff = line_count_old - line_count
			assert change_start == change_end
			log("trim_whitespace_remember_line: %d lines removed, first deleted = %d" % (diff, change_start))
			trim_whitespace_lines_removed(context, change_start, change_start + diff - 1)
	else:
		line = vim.eval("line(\".\")")
		log("trim_whitespace_remember_line: line changed, current line %s" % line)

		lines = my_get("modified_lines")
		line += " "
		if lines.rfind(" " + line) == -1:
			lines = lines + line
			my_let(context, "modified_lines", lines)

	my_let(context, "line_count", line_count)
	
	log("trim_whitespace_remember_line: new lines = '%s'" % my_get("modified_lines"))

def ranges(lines):
	"""lines must be sorted"""
	for key, sublist in itertools.groupby(enumerate(lines), lambda p: p[1] - p[0]):
		sublist = list(sublist)
		yield sublist[0][1], sublist[-1][1] # first, last in sublist

def trim_whitespace_do(context):
	lines = sorted(set(int(x) for x in my_get("modified_lines").split(None)))
	for rng in ranges(lines):
		command("%d,%ds/\\s\\+$//e" % (rng[0], rng[1]))

@on_autocmd("BufWritePre,FileReadPre,StdinReadPre", "*")
def trim_whitespace(context):
	with preserve_cursor():
		trim_whitespace_do(context)
	trim_whitespace_setup(context)

#  vim: set ft=python ts=8 sw=8 tw=0 noet :
