#!/bin/sh

# we cannot set $PATH from .pam_environment because /etc/profile overrides it
PATH="$HOME/bin/wrappers:$HOME/bin/session:$HOME/bin/git:$PATH"
export PATH
