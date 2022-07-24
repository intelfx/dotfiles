#!/hint/sh

export PATH="$HOME/.local/bin:$PATH"

. $HOME/bin/lib.env
. $HOME/bin/bin.env

if ! [[ "$SSH_AUTH_SOCK" ]]; then
	if [[ "$WSLENV" ]]; then
		export SSH_AUTH_SOCK=/mnt/c/util/wsl-ssh-pageant/ssh-agent.sock
	else
		export SSH_AUTH_SOCK="$(systemd-path user-runtime)/gnupg/S.gpg-agent.ssh"
	fi
fi
export EDITOR="$(which vim)"
export PAGER="$(which less)"
export RUSTC_WRAPPER="$(which sccache)"
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_EXTENSIONS_DIR="$HOME/bin/pass"
export MOZ_ENABLE_WAYLAND=1
export MOZ_DISABLE_RDD_SANDBOX=1
export QT_QPA_PLATFORMTHEME=qgnomeplatform
export QT_QPA_PLATFORM=wayland-egl
export TDESKTOP_I_KNOW_ABOUT_GTK_INCOMPATIBILITY=1

# `podman login` stores auth info in $XDG_RUNTIME_DIR by default. totally moronic, if you ask me
export REGISTRY_AUTH_FILE="$(systemd-path user-shared)/containers/auth.json"

# Fuck you!
# https://github.com/kubernetes/minikube/issues/3724
export MINIKUBE_IN_STYLE=0

# Fuck you too!
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

# setting /org/gnome/desktop/interface/gtk-im-module in dconf doesn't work somehow...
GTK_IM_MODULE="gtk-im-context-simple"

if test -r "$HOME/.profile.private"; then
	. "$HOME/.profile.private"
fi
