#!/bin/sh

# we cannot set $PATH from .pam_environment because /etc/profile overrides it
export PATH="$HOME/.local/bin:$PATH"
. $HOME/bin/lib.env
. $HOME/bin/bin.env
