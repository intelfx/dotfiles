#!/hint/sh

export PATH="$HOME/.local/bin:$PATH"

. $HOME/bin/lib.env
. $HOME/bin/bin.env

if ! [[ "$SSH_AUTH_SOCK" ]]; then
	export SSH_AUTH_SOCK="$(systemd-path user-runtime)/gnupg/S.gpg-agent.ssh"
fi
export EDITOR="$(which vim)"
export PAGER="$(which less)"
export RUSTC_WRAPPER="$(which sccache)"
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_EXTENSIONS_DIR="$HOME/bin/pass"
export MOZ_ENABLE_WAYLAND=1

# `podman login` stores auth info in $XDG_RUNTIME_DIR by default. totally moronic, if you ask me
export REGISTRY_AUTH_FILE="$(systemd-path user-shared)/containers/auth.json"

# Fuck you!
# https://github.com/kubernetes/minikube/issues/3724
export MINIKUBE_IN_STYLE=0

# Fuck you too!
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

if test -r "$HOME/.profile.private"; then
	. "$HOME/.profile.private"
fi
