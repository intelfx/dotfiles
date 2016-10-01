#!/bin/sh

# we cannot set $PATH from .pam_environment because /etc/profile overrides it
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export PATH
