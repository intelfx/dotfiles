#
# FIXME: unfinished, doesn't work
#

import itertools

import vim
import snake
from snake.plugins.common import *

trim_whitespace_objs = {}


# check-init handler
@snake.on_autocmd("BufEnter", "*")
def trim_whitespace_init(ctx):
	b = vim.current.buffer.number

	if not b in trim_whitespace_objs:
		trim_whitespace_objs[b] = TrimWhitespace()


# change handler
@snake.on_autocmd("TextChanged,TextChangedI", "*")
def trim_whitespace_textchanged(ctx):
	b = vim.current.buffer.number

	try:
		obj = trim_whitespace_objs[b]

	except KeyError:
		obj = TrimWhitespace()
		trim_whitespace_objs[b] = obj

	obj.update()


# drop handler
@snake.on_autocmd("BufDelete", "*")
def trim_whitespace_bufdelete(ctx):
	b = vim.current.buffer.number

	try:
		del trim_whitespace_objs[b]

	except KeyError:
		pass


# commit handler
@snake.on_autocmd("BufWritePre,FileWritePre,FileAppendPre,FilterWritePre", "*")
def trim_whitespace_commit(ctx):
	b = vim.current.buffer.number

	try:
		obj = trim_whitespace_objs[b]
		obj.commit()

	except KeyError:
		pass


class TrimWhitespace:
	def __init__(self):
		self.lines = set()
		self.count = int(vim.eval("line(\"$\")"))
		log(f"initializing with {self.count} lines")

	def update(self):
		# new line count in buffer
		count = int(vim.eval("line(\"$\")"))
		# current line
		line = int(vim.eval("line(\".\")"))
		# line count diff after the change
		diff = count - self.count
		# whether reported change span is obviously incorrect
		mismatch = False

		if self.count == count:
			chg_start = int(vim.eval("line(\"'[\")"))
			chg_end = int(vim.eval("line(\"']\")"))
			chg_span = chg_end - chg_start + 1

			log(f"line changed: change range [{chg_start}; {chg_end}]: span {chg_span}")
			log(f"line changed: current line {line}")

		else:
			chg_start = int(vim.eval("line(\"'[\")"))
			chg_end = int(vim.eval("line(\"']\")"))
			chg_span = chg_end - chg_start + 1

			log(f"lines count changed: count {self.count} -> {count}: diff {diff}") 
			log(f"lines count changed: change range [{chg_start}; {chg_end}]: span {chg_span}")
			log(f"lines count changed: current line {line}") 

			if count > self.count:
				if chg_span == diff:
					# normal case, marks are well-formed
					log(f"lines inserted: common case: marks well-formed")
					self.lines_inserted(chg_start, chg_end)
				elif diff == 1:
					# fast workaround for Enter
					log(f"lines inserted: special handling Enter")
					self.lines_inserted(line, line)
				else:
					# slow workaround for anything else
					log(f"lines inserted: general case, using diff")
					mismatch = True

			else:
				assert count < self.count
				assert diff < 0
				diff = -diff
				if chg_start == chg_end:
					# normal case, range collapsed into first (topmost) removed line
					log(f"lines removed: common case: marks collapsed")
					self.lines_removed(chg_start, chg_start + diff - 1)
				elif diff == 1:
					# fast workaround for Backspace
					log(f"lines removed: special handling Backspace")
					self.lines_removed(line + 1, line + 1)
				else:
					# slow workaround for anything else
					log(f"lines removed: general case, using diff")
					mismatch = True

			if mismatch:
				log("lines changed: general case not implemented")

			self.count = count

	def commit(self):
		log(f"committing {len(self.lines)} changes in {self.count} lines")
		for rng in ranges(sorted(self.lines)):
			command("%d,%ds/\\s\\+$//e" % (rng[0], rng[1]))
		self.lines = set()

	def lines_inserted(self, first, last):
		log(f"lines inserted: [{first}; {last}]")

	def lines_removed(self, first, last):
		log(f"lines removed: [{first}; {last}]")


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

def trim_whitespace_remember_line(context):
	line_count_old = int(my_get("line_count"))
	line_count = int(vim.eval("line(\"$\")"))

	if line_count_old != line_count:
		change_start = int(vim.eval("line(\"'[\")"))
		change_end = int(vim.eval("line(\"']\")"))
		line = int(vim.eval("line(\".\")"))

		log("trim_whitespace_remember_line: line_count %d -> %d" % (line_count_old, line_count))
		log("trim_whitespace_remember_line: last change range [%d; %d]" % (change_start, change_end))
		log("trim_whitespace_remember_line: current line %d" % line)

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


#  vim: set ft=python ts=8 sw=8 tw=0 noet :
