#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
#[[ -z "$TMUX" && "$UID" == "$(stat -c "%u" ${BASH_SOURCE[0]})" ]] && exec tmx

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

function beet-modify() {
	local queries=()
	local pathes=()
	local assignments=()
	local flags=()
	local arg
	for arg; do
		if [[ "$arg" == -* ]]; then
			flags+=( "$arg" )
		elif [[ "$arg" == /* ]]; then
			pathes+=( "path:$arg" , )
		elif [[ "$arg" == */* ]]; then
			pathes+=( "path:$(pwd)/$arg" , )
		elif [[ "$arg" == ^* ]] || [[ "$arg" == -* ]] || [[ "$arg" == *:* ]]; then
			queries+=( "$arg" , )
		elif [[ "$arg" == *=* ]] || [[ "$arg" == *! ]]; then
			assignments+=( "$arg" )
		else
			pathes+=( "path:$(pwd)/$arg" , )
		fi
	done

	if (( "${#pathes[@]}" )); then
		unset pathes[-1] # remove last comma
	fi

	beet modify "${queries[@]}" "${pathes[@]}" "${assignments[@]}"
}

alias nethack="nethack-save-scum.sh"

alias reburp='rm -vrf *.src.tar* && makepkg --force --source && burp *.src.tar*'

alias r-cp-n='rsync -r --info=progress2 --human-readable --no-i-r'
alias r-cp='r-cp-n -a'
alias r-sync='r-cp --delete'

alias git='LC_MESSAGES=C git'

[[ -r "$HOME/.bashrc-solarized" ]] && source "$HOME/.bashrc-solarized"

[[ -r "$HOME/.bashrc-common" ]] && source "$HOME/.bashrc-common"

HISTSIZE=-1 # do not truncate history

