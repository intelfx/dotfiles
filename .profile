#!/hint/sh

# guard against double-loading of ~/.profile in login shells spawned by tmux
if [[ "$_HAVE_DOT_PROFILE" ]]; then
	return
fi
export _HAVE_DOT_PROFILE=1

# adapted from Arch' /etc/profile
# zsh has no nameref; sunrise by hand
append() {
	local name="$1" var="$(eval "echo \"\$$1\"")"; shift
	local arg
	for arg; do
		case ":$var:" in
		*:"$arg":*) ;;
		*) var="${var:+$var:}$arg" ;;
		esac
	done
	eval "$name=\"$var\""
}
prepend() {
	local name="$1" var="$(eval "echo \"\$$1\"")"; shift
	local arg
	for arg; do
		case ":$var:" in
		*:"$arg":*) ;;
		*) var="$arg${var:+:$var}" ;;
		esac
	done
	eval "$name=\"$var\""
}
path_remove() {
	local arg="$1"

	PATH=":$PATH:"
	PATH=${PATH//":"/"::"}
	PATH=${PATH//":$arg:"/}
	PATH=${PATH//"::"/":"}
	PATH=${PATH#:}; PATH=${PATH%:}
}

if command -v sccache &>/dev/null; then
	export RUSTC_WRAPPER="$(command -v sccache)"
fi

if [[ -d /usr/lib/ccache/bin ]]; then
	prepend PATH /usr/lib/ccache/bin
fi

if [[ -d "$HOME/.local/bin" ]]; then
	prepend PATH "$HOME/.local/bin"
fi

if [[ -d "$HOME/.local/share/flatpak/exports/bin" ]]; then
	prepend PATH "$HOME/.local/share/flatpak/exports/bin"
fi

if [[ -d "$HOME/ct-ng/bin" ]]; then
	export CT_PREFIX="$HOME/ct-ng/bin"
	for d in "$CT_PREFIX"/*/bin; do
		# word splitting and pathname expansion are not performed on the words between [[ and ]]
		gcc=( "$d"/*-gcc )
		if [[ -d "$d" && -x "$gcc" ]]; then
			prepend PATH "$d"
		fi
	done
fi
unset d gcc

. $HOME/bin/lib.env
. $HOME/bin/bin.env

if ! [[ "$SSH_AUTH_SOCK" ]]; then
	if [[ "$WSLENV" ]]; then
		export SSH_AUTH_SOCK=/mnt/c/util/wsl-ssh-pageant/ssh-agent.sock
	else
		export SSH_AUTH_SOCK="$(systemd-path user-runtime)/gnupg/S.gpg-agent.ssh"
	fi
fi
export EDITOR="$(command -v vim)"
export PAGER="$(command -v less)"
export BROWSER="$(command -v xdg-open)"
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_EXTENSIONS_DIR="$HOME/bin/pass"
# XXX: Wayland
#      (copy to ~/.profile.private if this host uses Wayland)
#export MOZ_ENABLE_WAYLAND=1
#export QT_QPA_PLATFORMTHEME=qgnomeplatform
#export QT_QPA_PLATFORM=wayland-egl
export TDESKTOP_I_KNOW_ABOUT_GTK_INCOMPATIBILITY=1

# "It sets the number of cached data chunks; additional memory usage can be up to ~8 MiB times this number. The default is the number of CPU cores."
# Allow `borg mount` to use up to 1 GiB of RAM for aggressive caching
export BORG_MOUNT_DATA_CACHE_ENTRIES=$(( 1024*1024*1024 / (8*1024*1024) ))

# `podman login` stores auth info in $XDG_RUNTIME_DIR by default. totally moronic, if you ask me
export REGISTRY_AUTH_FILE="$(systemd-path user-shared)/containers/auth.json"

# Fuck you!
# https://github.com/kubernetes/minikube/issues/3724
export MINIKUBE_IN_STYLE=0

# Fuck you too!
#export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

# Et tu, Brute?..
export SYSTEMD_EMOJI=0

# Prevent myself and anyone else from turning the system into a landfill,
# unless PEP 668 is in effect.
if ! { command -v python3 &>/dev/null \
    && _python_stdlib="$(python3 -c 'import sysconfig; print(sysconfig.get_path("stdlib"))' 2>/dev/null)" \
    && [[ -e "$_python_stdlib/EXTERNALLY-MANAGED" ]]; }; then
	export PIP_REQUIRE_VIRTUALENV=true
fi
unset _python_stdlib

# setting /org/gnome/desktop/interface/gtk-im-module in dconf doesn't work somehow...
#export GTK_IM_MODULE="gtk-im-context-simple"

# Point $DOCKER_HOST to the podman system instance (if it is present)
if ! [[ "$DOCKER_HOST" ]]; then
	if [[ "$XDG_RUNTIME_DIR" && -e "$XDG_RUNTIME_DIR/podman/podman.sock" ]]; then
		export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
	fi
fi

if test -r "$HOME/.profile.private"; then
	. "$HOME/.profile.private"
fi

if test -r "$HOME/.profile.machine"; then
	. "$HOME/.profile.machine"
fi
