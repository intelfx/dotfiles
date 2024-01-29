set disassembly-flavor intel
set debuginfod enabled on
set auto-load safe-path $debugdir:$datadir/auto-load:/usr
source ~/.gdb.d/gdb-dashboard/.gdbinit
