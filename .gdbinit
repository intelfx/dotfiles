set disassembly-flavor intel
set debuginfod enabled on
set auto-load safe-path $debugdir:$datadir/auto-load:~/.idapro:/opt:/usr
dir /usr/lib/rustlib/etc
dir /usr/lib/go/src

set history save on
set history size 1048576
set history remove-duplicates unlimited
set history filename ~/.gdb_history

#
# WIP configuration for multiple inferiors
# (not tested extensively, thus in a function for now)
#

define setup-multiple-inferiors
	# keep both parent and child
	set detach-on-fork off
	# ...or "parent" (child is usually more convenient here)
	set follow-fork-mode child
	# allow all inferiors to run when you continue
	set schedule-multiple on
	# don't stop the whole session when one inferior stops/exits
	set non-stop on
	# required on GDB < 7.8; harmless on newer ones
	set target-async on
	# reduces noise
	#set print symbol-loading off
	# in case the child loads symbols a bit late
	#set breakpoint pending on
	# ...
	#set follow-exec-mode new
end

define gdblog
	set pagination off
	set logging file gdblog.txt
	set logging enable on
end

define gdblogoff
	set logging enable off
	set pagination on
end

define bugreport
	set pagination off
	set logging file gdblog-full.txt
	set logging enable on
	thread apply all backtrace full
	set logging enable off
end

define bugreport-cur
	set pagination off
	set logging file gdblog-full.txt
	set logging enable on
	backtrace full
	set logging enable off
end

define bugreport-terse
	set pagination off
	set logging file gdblog-terse.txt
	set logging enable on
	thread apply all backtrace
	set logging enable off
end

define bugreport-terse-cur
	set pagination off
	set logging file gdblog-terse.txt
	set logging enable on
	backtrace
	set logging enable off
end

source ~/.gdb.d/gdb-dashboard/.gdbinit
