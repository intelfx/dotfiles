#!/hint/bash

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
export2() {
	local var="$1" arg="$2"
	export "$var=$arg"
}
maybe() {
	local op="$1" var="$2" arg
	shift 2
	for arg; do
		if [[ -e $arg ]]; then
			"$op" "$var" "$arg"
		fi
	done
}

maybe export2 RUSTC_WRAPPER \
	"$(command -v sccache 2>/dev/null)"

maybe prepend PATH \
	/usr/lib/ccache/bin \
	"$HOME"/ct-ng/bin/*/bin \
	"$HOME/.local/share/flatpak/exports/bin" \
	"$HOME/.local/bin" \
	"$HOME/.cargo/bin" \
	# EOL

. $HOME/bin/lib.env
. $HOME/bin/bin.env

maybe prepend PATH \
	"$HOME/bin/local" \
	# EOL

if ! [[ "$SSH_AUTH_SOCK" ]]; then
	if [[ "$WSLENV" ]]; then
		export SSH_AUTH_SOCK=/mnt/c/util/wsl-ssh-pageant/ssh-agent.sock
	# elif [[ -e "$(systemd-path user-runtime)/keyring/ssh" ]]; then
	# 	export SSH_AUTH_SOCK="$(systemd-path user-runtime)/keyring/ssh"
	# elif [[ -e "$(systemd-path user-runtime)/gcr/ssh" ]]; then
	# 	export SSH_AUTH_SOCK="$(systemd-path user-runtime)/gcr/ssh"
	else
		export SSH_AUTH_SOCK="$(systemd-path user-runtime)/gnupg/S.gpg-agent.ssh"
	fi
fi
export EDITOR="$(command -v vim)"
export PAGER="$(command -v less)"
export BROWSER="$(command -v xdg-open)"
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_EXTENSIONS_DIR="$HOME/bin/pass"
# direct pass(1) to use a separate GnuPG config, which is a less-invasive
# alternative to using a separate $GNUPGHOME (which would entail running
# a separate gpg-agent and writing units for it)
export PASSWORD_STORE_GPG_OPTS="--options $HOME/.gnupg/gpg.pass.conf"

# XXX: Wayland
#      (copy to ~/.profile.machine if this host uses Wayland)
#export MOZ_ENABLE_WAYLAND=1
#export QT_QPA_PLATFORMTHEME=qgnomeplatform
#export QT_QPA_PLATFORM=wayland-egl
#export TDESKTOP_I_KNOW_ABOUT_GTK_INCOMPATIBILITY=1

# Seems like a sane default
export CCACHE_BASEDIR="$HOME"

# Isolate different users' sccache instances
export SCCACHE_SERVER_UDS="$(systemd-path user-state-cache)/sccache/sccache.sock"
export SCCACHE_DIR="$(systemd-path user-state-cache)/sccache"
export SCCACHE_CONF="$(systemd-path user-configuration)/sccache/sccache.toml"

function get_sysfs_count() {
	local file="$1"
	local -a ranges
	local r m n count

	# zsh, why can't you just be normal?
	[[ ${ZSH_VERSION+set} ]] && local flags=('-rA') || local flags=('-ra')
	IFS=, read "${flags[@]}" ranges <"$file"

	for r in "${ranges[@]}"; do
		IFS=- read -r a b <<<"$r"
		if [[ $a && $b ]]
		then (( count += (b - a + 1) ))
		else (( count += 1 ))
		fi
	done

	[[ $count ]] || return 1
	printf "%s\n" "$count"
}
function get_nproc() {
	local ncpu

	# XXX: we'd rather use `nproc --all`, but it reads /sys/devices/system/cpu/possible
	#      which can be inaccurate: Steam Deck has 8 CPUs, but possible=0-15
	if [[ -r /sys/devices/system/cpu/present ]] \
	&& ncpu="$(get_sysfs_count /sys/devices/system/cpu/present)" \
	&& (( ncpu > 0 )) \
	; then
		printf "%s\n" "$ncpu"
		return 0

	# fall back to `nproc --all`
	elif command -v nproc &>/dev/null \
	&& ncpu="$(nproc --all 2>/dev/null)" \
	&& (( ncpu > 0 )) \
	; then
		printf "%s\n" "$ncpu"
		return 0
	fi

	return 1
}

# use a better htoprc if the current machine has more than 8 CPUs
if ncpu="$(get_nproc)" \
&& (( ncpu > 8 )); then
	export HTOPRC="$(systemd-path user-configuration)/htop/htoprc.big"
fi

# use a better htoprc if the current machine is a fucking meteor lake
if grep -q -Fx $'model name\t: Intel(R) Core(TM) Ultra 9 185H' /proc/cpuinfo; then
	export HTOPRC="$(systemd-path user-configuration)/htop/htoprc.mtl"
fi

# "It sets the number of cached data chunks; additional memory usage can be up to ~8 MiB times this number. The default is the number of CPU cores."
# Allow `borg mount` to use up to 1 GiB of RAM for aggressive caching
export BORG_MOUNT_DATA_CACHE_ENTRIES=$(( 1024*1024*1024 / (8*1024*1024) ))

# `podman login` stores auth info in $XDG_RUNTIME_DIR by default. totally moronic, if you ask me
export REGISTRY_AUTH_FILE="$(systemd-path user-shared)/containers/auth.json"

# It's 2024 and Go(vno) still thinks it owns the entire machine. Wrong.
export GOMODCACHE="$(systemd-path user-state-cache)/go-mod"

# Please learn about XDG.
export RAD_HOME="$(systemd-path user-state-private)/radicle"

# Fuck you!
# https://github.com/kubernetes/minikube/issues/3724
export MINIKUBE_IN_STYLE=0

# Fuck you too!
#export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dsun.java2d.uiScale=2"

# Et tu, Brute?..
export SYSTEMD_EMOJI=0

# Really?
export SYSTEMD_TINT_BACKGROUND=0
export SYSTEMD_ADJUST_TERMINAL_TITLE=0

# Prevent myself and anyone else from turning the system into a landfill,
# unless PEP 668 is in effect.
if ! { command -v python3 &>/dev/null \
    && _python_stdlib="$(python3 -c 'import sysconfig; print(sysconfig.get_path("stdlib"))' 2>/dev/null)" \
    && [[ -e "$_python_stdlib/EXTERNALLY-MANAGED" ]]; }; then
	export PIP_REQUIRE_VIRTUALENV=true
fi
unset _python_stdlib

# Screw you.
# > I find it disappointing that people react to the RUSTC_BOOTSTRAP hack
# > by thinking "How do we forbid this?" instead of "How has Rust failed to
# > stabilize useful features in a timely manner to necessitate such a hack,
# > and how can we do better on getting useful features to stable?"
# https://github.com/rust-lang/cargo/issues/7088#issuecomment-508373796
export RUSTC_BOOTSTRAP=1

# setting /org/gnome/desktop/interface/gtk-im-module in dconf doesn't work somehow...
#export GTK_IM_MODULE="gtk-im-context-simple"

# Point $DOCKER_HOST to the podman system instance (if it is present)
if ! [[ "$DOCKER_HOST" ]]; then
	if [[ "$XDG_RUNTIME_DIR" && -e "$XDG_RUNTIME_DIR/podman/podman.sock" ]]; then
		export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
	fi
fi

# port `cpan` local::lib auto-install blurb
if command -v perl &>/dev/null \
&& [[ -d "$HOME/perl5/bin" && -d "$HOME/perl5/lib/perl5" ]]; then
	export PATH="$HOME/perl5/bin${PATH:+:${PATH}}"
	export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
	export PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
	export PERL_MB_OPT="--install_base \"$HOME/perl5\""
	export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
fi


#
# less(1) options and other interactive configuration
#

# sane defaults: enable ANSI escape sequences passthrough and mouse support
export LESS="-RM --mouse"
# default is FRSXMK
export SYSTEMD_LESS="-FRSXMK --mouse"
# This uses our custom variant of the Solarized color scheme defined
# using the 16-color ANSI palette with precise colors, and is thus
# invariant with respect to dark/light mode switch.
export BAT_THEME='Solarized-ANSI'


#
# site-specific configuration
#

if test -r "$HOME/.profile.private"; then
	. "$HOME/.profile.private"
fi

if test -r "$HOME/.profile.machine"; then
	. "$HOME/.profile.machine"
fi
