#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
#[[ -z "$TMUX" && "$UID" == "$(stat -c "%u" ${BASH_SOURCE[0]})" ]] && exec tmx

if [[ -t 2 ]]; then
	if [[ "$TERM" == linux ]]; then
		cat <<-"EOF"
			]P8073642
			]P1dc322f
			]P2859900
			]P3b58900
			]P4268bd2
			]P5d33682
			]P62aa198
			]P7eee8d5
			]P0002b36
			]P9cb4b16
			]PA586e75
			]PB657b83
			]PC839496
			]PD6c71c4
			]PE93a1a1
			]PFfdf6e3
			[H[J
		EOF
	fi
	export IS_SOLARIZED=1
fi

function fs_umount_recursive() {
	if [[ -z "$1" ]]; then
		echo "No argument passed" >&2
		return 1
	fi

	local MOUNTS
	readarray -t MOUNTS < <(cut -d " " -f2 /proc/mounts | grep -E "^$1" | sort -ru) 

	if (( "${#MOUNTS[@]}" )); then
		echo "Recursively unmounting directory: \"$1\""

		for mountpoint in "${MOUNTS[@]}"; do
			echo "unmounting \"$mountpoint\"..."
			umount "$mountpoint" || { echo "failed to unmount \"$mountpoint\"" >&2; return 1; }
		done
	fi
}

function svg() {
	local FILE="$(mktemp)"
	trap "rm -f \"$FILE\"" RETURN
	cat > "$FILE"
	xdg-open "$FILE"
}

function android-cmake() {
	cmake -DCMAKE_TOOLCHAIN_FILE=~/devel/cmake/Android.cmake -DANDROID_ABI="armeabi-v7a with NEON" "$@"
}

function arm-cmake() {
	cmake -DCMAKE_TOOLCHAIN_FILE=~/devel/cmake/ARM.cmake "$@"
}

function clang-cmake() {
	CC=clang \
	CXX=clang++ \
		cmake "$@"
}

function clang-cmake-release() {
	CC=clang \
	CXX=clang++ \
	CFLAGS="-O3 -flto -march=native" \
	CXXFLAGS="$CFLAGS" \
	LDFLAGS="-O3 -flto -fuse-linker-plugin -Wl,-O1,-z,relro,--as-needed,--relax,--sort-common,--hash-style=gnu" \
		cmake -DCMAKE_BUILD_TYPE=Release "$@"
}

alias nethack="nethack-save-scum.sh"

alias reburp='rm -vrf *.src.tar* && makepkg --force --source && burp *.src.tar*'

if (( "$IS_SOLARIZED" )); then
	case "$TERM" in
	xterm-256color|screen-256color)
		export TERM="${TERM%-256color}"
		;;
	esac
	eval $(dircolors -b "$HOME/.dircolors-solarized")
	alias mc="mc -S solarized"
fi

alias git='LC_MESSAGES=C git'

[[ -r "$HOME/.bashrc-common" ]] && source "$HOME/.bashrc-common"
