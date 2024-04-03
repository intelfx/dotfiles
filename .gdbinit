set disassembly-flavor intel
set debuginfod enabled on
set auto-load safe-path $debugdir:$datadir/auto-load:/usr

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

define bugreport-terse
	set pagination off
	set logging file gdblog-terse.txt
	set logging enable on
	thread apply all backtrace
	set logging enable off
end

source ~/.gdb.d/gdb-dashboard/.gdbinit
