#!/bin/bash
#
# ~/.bash_profile
#

function arch_specific_symlink() {
	local TARGET_DIR="$1-$(uname -m)"
	mkdir -p "$HOME/$TARGET_DIR"
	if [[ "$(realpath -q "$HOME/$1")" != "$TARGET_DIR" ]]; then
		rm -rf "$HOME/$1"
		ln -sf "$TARGET_DIR" "$HOME/$1"
	fi
}

#arch_specific_symlink kde
#arch_specific_symlink toolchains

### Create the trash path
mkdir -p "$(realpath -q "$HOME/.local/share/Trash")"

### Configure various PATHes
PATH="$HOME/bin:$PATH"
#PATH="$HOME/kde/bin${PATH:+:$PATH}"
#LD_LIBRARY_PATH="$HOME/kde/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
#LD_RUN_PATH="$HOME/kde/lib${LD_RUN_PATH:+:$LD_RUN_PATH}"
#KDEDIRS="$( kde4-config --prefix ):$HOME/kde"

for dir in "$HOME/bin/toolchains/"*"/bin"; do
	[[ -d "$dir" ]] && PATH="$dir:$PATH"
done

export PATH
#export LD_LIBRARY_PATH LD_RUN_PATH KDEDIRS

# For awesome and so on
#export DE=kde

# Wine
export WINEDLLOVERRIDES="winemenubuilder.exe=d"

[[ -r "$HOME/.bash_profile-common" ]] && source "$HOME/.bash_profile-common"
