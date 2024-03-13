set disassembly-flavor intel
set debuginfod enabled on
set auto-load safe-path $debugdir:$datadir/auto-load:/usr

define gdblog
set pagination off
set logging file gdblog.txt
set logging on
end

define gdblogoff
set logging off
set pagination on
end

define bugreport
set pagination off
set logging file gdblog-full.txt
set logging on
thread apply all backtrace full
set logging off
end

define bugreport-terse
set pagination off
set logging file gdblog-terse.txt
set logging on
thread apply all backtrace
set logging off
end

source ~/.gdb.d/gdb-dashboard/.gdbinit
