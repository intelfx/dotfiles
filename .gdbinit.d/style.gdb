dashboard -layout assembly breakpoints expressions history memory registers source stack threads variables
dashboard -style syntax_highlighting 'solarized-dark'
dashboard -style prompt_running '\\[\\e[1;95m\\]>>>\\[\\e[0m\\]'
dashboard -style prompt_not_running '\\[\\e[1;92m\\]>>>\\[\\e[0m\\]'

define hookpost-up
  dashboard
end
define hookpost-down
  dashboard
end
define hookpost-frame
  dashboard
end
