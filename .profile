#!/bin/sh

# we cannot set $PATH from .pam_environment because /etc/profile overrides it
. $HOME/bin/lib.env
. $HOME/bin/bin.env
