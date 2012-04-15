setopt prompt_subst
local current_dir='%{$terminfo[bold]$fg[blue]%}%~%{$reset_color%}'
local user_host='%{$terminfo[bold]$fg[yellow]%}%n%{$reset_color%}'
local vc_info='%{$fg[black]%}$(vcprompt)%{$reset_color%}'
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT="${vc_info}${user_host}:${current_dir}:$ "

RPS1="${return_code}"

