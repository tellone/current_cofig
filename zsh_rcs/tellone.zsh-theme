#!/bin/zsh
docker_host() {
    if [[ ! -z "$DOCKER_MACHINE_NAME" ]]; then
        echo "$DOCKER_MACHINE_NAME%B:"
    elif [[ ! -z "$DOCKER_HOST" ]]; then
        echo "$DOCKER_HOST%B:"
    else
        echo ""
    fi
}

git_prompt() {
     ref=$(git symbolic-ref HEAD 2>/dev/null | cut -d'/' -f3)
     if [  -z "$ref" ]; then
      echo $ref
  else
      echo " br:$ref%B:"
  fi
}

setopt prompt_subst
local current_dir='%{$terminfo[bold]$fg[blue]%}%~%{$reset_color%}'
local user_host='%{$terminfo[bold]$fg[yellow]%}%n%{$reset_color%}'
local vc_info='%{$fg[white]%}$(git_prompt)%{$reset_color%}'
local docker_info='%{$fg[cyan]%}$(docker_host)%{$reset_color%}'
local return_code='%(%{?..%}%{$fg[red]%}%? ↵%{$reset_color%})'

if [[ "$EUID" == "0" ]]; then
	local user_host='%{$terminfo[bold]$fg[red]%}%n%{$reset_color%}'

	PROMPT="${user_host}%B:${current_dir}%B:#%b "
else

    PROMPT="${vc_info}${user_host}%B:${current_dir}%B:${docker_info}$%b "

fi


RPS1="${return_code}"


# RPS1="%(?..(%{${e}[01;35m%}%?%{${e}[00m%}%)%<<)"

