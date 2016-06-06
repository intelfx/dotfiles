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

	lines = [int(x) for x in my_get("modified_lines").split(None)]

	diff = last - first + 1
	lines = [r        for r in lines if r < first] + \
		[r        for r in range(first, last + 1)] + \
	        [r + diff for r in lines if r >= first]

	my_let(context, "modified_lines", " " + " ".join(str(x) for x in lines) + " ")

def trim_whitespace_lines_removed(context, first, last):
	log("trim_whitespace_lines_removed: [%d; %d]" % (first, last))

	lines = [int(x) for x in my_get("modified_lines").split(None)]

	diff = last - first + 1
	lines = [r        for r in lines if r < first] + \
	        [r - diff for r in lines if r > last]

	my_let(context, "modified_lines", " " + " ".join(str(x) for x in lines) + " ")

@on_autocmd("TextChanged,TextChangedI", "*")
def trim_whitespace_remember_line(context):
	line_count_old = int(my_get("line_count"))
	line_count = int(vim.eval("line(\"$\")"))

	if line_count_old != line_count:
		change_start = int(vim.eval("line(\"'[\")"))
		change_end = int(vim.eval("line(\"']\")"))
		line = int(vim.eval("line(\".\")"))

		log("trim_whitespace_remember_line: line_count %d -> %d" % (line_count_old, line_count))
		log("trim_whitespace_remember_line: last change range [%d; %d]" % (change_start, change_end))

		if line_count > line_count_old:
			diff = line_count - line_count_old
			if change_end - change_start + 1 != diff:
				# HACK: line insertion by Enter produces ranges spanning two lines
				assert diff == 1, \
				       "trim_whitespace_remember_line: last change range does not match line count diff: " + \
				       "[%d; %d] (assuming line inserted by Enter), but %d != 1 lines added" % (change_start, change_end, diff)
				change_start = line
				change_end = change_start

			log("trim_whitespace_remember_line: %d lines inserted, first inserted = %d" % (diff, change_start))
			trim_whitespace_lines_inserted(context, change_start, change_end)
		else:
			diff = line_count_old - line_count
			if change_start != change_end:
				# HACK: line removal by Backspace produces arbitrary ranges
				assert diff == 1, \
				       "trim_whitespace_remember_line: last change range does not collapse: " + \
				       "[%d; %d] (assuming line removed by Backspace), but %d != 1 lines removed" % (change_start, change_end, diff)
				change_start = line + 1

			change_end = change_start + diff - 1

			log("trim_whitespace_remember_line: %d lines removed, first deleted = %d" % (diff, change_start))
			trim_whitespace_lines_removed(context, change_start, change_end)
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
