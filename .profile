#!/bin/sh

# we cannot set $PATH from .pam_environment because /etc/profile overrides it
export PATH="$HOME/.local/bin:$PATH"
# we cannot set $SSH_AUTH_SOCK from .pam_environment because it overrides ssh agent forwarding
if ! [[ $SSH_AUTH_SOCK ]]; then
	export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
fi
. $HOME/bin/lib.env
. $HOME/bin/bin.env
