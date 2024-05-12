#!/hint/zsh

# Very first thing.
setopt extended_glob

function load_zshrc_d() {
	local dir=$1 f

	# load "completion" first because other snippets define completions
	for f in \
		$dir/completion*(-.N) \
		$dir/(^completion*)(-.N) \
		# EOL
	do
		source $f
	done
}

function do_load_plugin() {
	local dir=$1 dirname=${1:t} f

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
		do_load_plugin $p
	done
}

function load_plugin() {
	local name=$1 p
	for p in {~/.zsh/plugins,/usr/share/zsh/plugins}/$name(-/N); do
		do_load_plugin $p
		return
	done

	print "Cannot find plugin '$name'" >&2
	return 1
}

#
# early snippets, before switching to tmux
#
load_zshrc_d $HOME/.zshrc.early.d

#
# tmux shortcut
#
[[ -z "$WSLENV" 
&& -z "$NOTMUX" 
&& -z "$TMUX" 
&& -z "$SUDO_USER" 
&& "$UID" == "$(stat -c "%u" "${(%):-%x}")"
&& "$TERMINAL_EMULATOR" != *JetBrains*
]] \
	&& command -v tmx &>/dev/null \
	&& exec tmx

#
# snippets (aliases, colors etc.)
#
load_zshrc_d ~/.zshrc.d

#
# plugins
#
load_plugin fzf-tab  # ordering: first thing to load after zshrc.d
load_plugin zsh-autosuggestions

#
# late snippets (prompt)
#
load_zshrc_d ~/.zshrc.late.d

#
# late plugins
#
load_plugin zsh-syntax-highlighting
