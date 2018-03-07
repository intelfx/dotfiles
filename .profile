#!/bin/sh

# we cannot set $PATH from .pam_environment because /etc/profile overrides it
PATH="$HOME/bin/local/session:$HOME/bin/misc/wrappers:$HOME/bin/misc/git:$HOME/bin/lib:$PATH"
export PATH
PYTHONPATH="$HOME/bin"
export PYTHONPATH
