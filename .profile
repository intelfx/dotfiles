#!/bin/sh

# /etc/profile overwrites $PATH set from pam_env.so
eval "$(grep '^PATH=' ~/.pam_environment)"
export PATH
