from snake import *
import vim
import itertools
import sys

def my_get(name):
	return get(name, namespace="rtrim", scope=NS_BUFFER)

def my_let(context, name, value):
	return context.let(name, value, namespace="rtrim")

@on_autocmd("BufNewFile,BufReadPost", "*")
def trim_whitespace_setup(context):
	my_let(context, "modified_lines", " ")
	my_let(context, "line_count", vim.eval("line(\"$\")"))

@on_autocmd("TextChanged,TextChangedI", "*")
def trim_whitespace_remember_line(context):
	line_count_old = int(my_get("line_count"))
	line_count = int(vim.eval("line(\"$\")"))
	line = int(vim.eval("line(\".\")"))

	lines = my_get("modified_lines")

	if line_count_old != line_count:
		diff = line_count - line_count_old
		lines = sorted(set(int(x) for x in lines.split(None)))
		if line_count > line_count_old:
			# lines inserted: (line - diff; line]
			lines = [r + line_count - line_count_old for r in lines if r > line - diff]
		else:
			# lines removed: (line; line - diff]
			lines = [r + line_count - line_count_old for r in lines if r > line]
		lines.append(line)
		my_let(context, "modified_lines", " ".join(str(x) for x in lines) + " ")
	else:
		line = str(line) + " "
		if lines.rfind(" " + line) == -1:
			lines = lines + line
			my_let(context, "modified_lines", lines)

	my_let(context, "line_count", line_count)

def ranges(lines):
	"""lines must be sorted"""
	for key, sublist in itertools.groupby(enumerate(lines), lambda (x, y): y - x):
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
