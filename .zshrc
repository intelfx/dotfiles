#!/hint/zsh

function load_zshrc_d() {
	local dir=$1 f
	for f in $dir/*(-.N); do
		source $f
	done
}

function load_plugin() {
	local dir=$1 dirname=${1:t} f

	# a bit of blacklisting for shells inside mc
	if (( ${+MC_SID} )); then
		case $dirname in
		#zsh-autosuggestions) return 0 ;;
		*) ;;
		esac
	fi

	for f in $dir/$dirname.{plugin.zsh,zsh}(-.N); do
		source $f
		return 0
	done

	print "Cannot load plugin from '$dir'" >&2
	return 1
}

function load_plugin_d() {
	local dir=$1 p
	for p in $dir/*(-/N); do
		load_plugin $p
	done
}

#
# early snippets, before switching to tmux
#
load_zshrc_d $HOME/.zshrc.early.d

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
# plugins' settings
#
ZSH_AUTOSUGGEST_USE_ASYNC=1

#
# plugins
#
load_plugin_d /usr/share/zsh/plugins
load_plugin_d ~/.zsh/plugins

#
# snippets (aliases, colors etc.)
#
load_zshrc_d ~/.zshrc.d

#
# late plugins
#
load_plugin_d ~/.zsh/plugins.late

#
# late snippets
#
load_zshrc_d ~/.zshrc.late.d
