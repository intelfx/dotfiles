#
# early snippets, before switching to tmux
#
for file in $HOME/.zshrc.early.d/*; do
	if [[ -r $file ]]; then
		source $file
	fi
done

#
# tmux shortcut
#
[[ -z "$NOTMUX" && -z "$TMUX" && "$UID" == "$(stat -c "%u" "${(%):-%x}")" ]] && type -f tmx 2>/dev/null && exec tmx

#
# zplugin
#
#source $HOME/.zsh/zplugin/zplugin.zsh

#
# general settings
#
# Lines configured by zsh-newuser-install
HISTFILE=~/.history
HISTSIZE=2147483647
SAVEHIST=2147483647
setopt appendhistory autocd extendedglob dotglob nomatch histignoredups nocompletealiases autolist sharehistory
unsetopt beep notify bashautolist listambiguous
fpath=( "$HOME/.zsh/fpath" $fpath )
# End of lines configured by zsh-newuser-install


#
# completion settings
#
# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'argument: %d'
zstyle ':completion:*' completer _complete _correct
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format 'completing %d:'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt $l (%p): Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
#zstyle ':completion:*' matcher-list '' 'l:|[._/-]=* r:|[._/-]=* l:|=* r:|=*'
zstyle ':completion:*' max-errors 1 numeric
zstyle ':completion:*' menu select
zstyle ':completion:*' original true
zstyle ':completion:*' prompt '%e corrections made:'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %l (%p)%s'
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/intelfx/.zshrc'

autoload -Uz compinit
compinit -u # do not whine about ~/.zshrc/fpath in `sudo -s`
# End of lines added by compinstall

#
# plugins
#
function plugin_load() {
	local dir=$1 dirname=${dir:t} pluginfile

	# a bit of blacklisting for shells inside mc
	if (( ${+MC_SID} )); then
		case $dirname in
		#zsh-autosuggestions) return 0 ;;
		*) ;;
		esac
	fi

	for pluginfile in $dir/$dirname.{plugin.zsh,zsh}; do
		if [[ -r $pluginfile ]]; then
			source $pluginfile
			return 0
		fi
	done

	print "Cannot load plugin from '$dir'" >&2
	return 1
}
for dir in /usr/share/zsh/plugins/*(N) ~/.zsh/plugins/*(N); do
	plugin_load $dir
done

#
# snippets (aliases, colors etc.)
#
for file in $HOME/.zshrc.d/*; do
	if [[ -r $file ]]; then
		source $file
	fi
done

#
# late plugins
#
for dir in ~/.zsh/plugins-late/*(N); do
	plugin_load $dir
done

#
# prompt eye-candy
#
autoload -Uz promptinit
promptinit
prompt pure

#
# cleanup
#
unset dir file
