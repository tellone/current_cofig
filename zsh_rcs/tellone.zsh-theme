#!/bin/zsh

setopt prompt_subst
local current_dir='%{$terminfo[bold]$fg[blue]%}%~%{$reset_color%}'
local user_host='%{$terminfo[bold]$fg[yellow]%}%n%{$reset_color%}'
local vc_info='%{$fg[white]%}$(vcprompt)%{$reset_color%}'
local return_code='%(%{?..%}%{$fg[red]%}%? ↵%{$reset_color%})'

if [[ "$EUID" == "0" ]]; then
	local user_host='%{$terminfo[bold]$fg[red]%}%n%{$reset_color%}'

	PROMPT="${user_host}%B:${current_dir}%B:#%b "
else

PROMPT="${vc_info}${user_host}%B:${current_dir}%B:$%b "

fi


RPS1="${return_code}"

# RPS1="%(?..(%{${e}[01;35m%}%?%{${e}[00m%}%)%<<)"

