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
[[ -z "$WSLENV" && -z "$NOTMUX" && -z "$TMUX" && "$UID" == "$(stat -c "%u" "${(%):-%x}")" ]] && command -v tmx &>/dev/null && exec tmx

#
# snippets (aliases, colors etc.)
#
load_zshrc_d ~/.zshrc.d

#
# early plugins
#
load_plugin_d ~/.zsh/plugins.early

#
# plugins
#
load_plugin_d /usr/share/zsh/plugins
load_plugin_d ~/.zsh/plugins

#
# late snippets
#
load_zshrc_d ~/.zshrc.late.d

#
# late plugins
#
load_plugin_d ~/.zsh/plugins.late
