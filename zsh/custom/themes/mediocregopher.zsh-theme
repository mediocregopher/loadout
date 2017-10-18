#!/usr/bin/env zsh

# Unique string based on hostname
sha1=$(echo $(hostname) | sha1sum | awk '{print $1}' | grep -oP '[0-9a-f]{8}' | head -n1)
# Turn sha1 into int
asint=$(printf "%d" 0x$sha1)

colorint=$(printf "%03d" $(expr $asint % 255))
color=$FG[$colorint]

PROMPT='%{$color%} %~%{$reset_color%}$(git_prompt_info)$(git_prompt_status)%{$reset_color%} :: '

ZSH_THEME_GIT_PROMPT_PREFIX=" ::%{$fg[green]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED=" +"
ZSH_THEME_GIT_PROMPT_MODIFIED=" ^"
ZSH_THEME_GIT_PROMPT_DELETED=" -"
ZSH_THEME_GIT_PROMPT_RENAMED=" >"
ZSH_THEME_GIT_PROMPT_UNMERGED=" @"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" *"
