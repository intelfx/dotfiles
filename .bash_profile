#!/bin/bash
#
# ~/.bash_profile
#

#
# Configure various PATHes
#

PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/bin:$PATH"
#PATH="$HOME/kde/bin${PATH:+:$PATH}"
#LD_LIBRARY_PATH="$HOME/kde/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
#LD_RUN_PATH="$HOME/kde/lib${LD_RUN_PATH:+:$LD_RUN_PATH}"
#KDEDIRS="$( kde4-config --prefix ):$HOME/kde"

for dir in "$HOME/bin/toolchains/"*"/bin"; do
	[[ -d "$dir" ]] && PATH="$dir:$PATH"
done

export PATH #LD_LIBRARY_PATH LD_RUN_PATH KDEDIRS

#
# Wine
#

export WINEDLLOVERRIDES="winemenubuilder.exe=d"

#
# Common
#

[[ -r "$HOME/.bash_profile-common" ]] && source "$HOME/.bash_profile-common"
