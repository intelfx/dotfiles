PROMPT='>>> %{$fg[cyan]%}%n%{$fg[default]%} >> %{$fg[magenta]%}%m%{$reset_color%} >%{$reset_color%} %{$fg_bold[green]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}
╌╼ · '
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%} < %{$fg[magenta]%}git%{$reset_color%} << %{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%} %{$fg[yellow]%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}"
