# if not running interactively, don't do anything
[[ $- != *i* ]] && return

### utility functions

_have() { type "$1" &>/dev/null; }
_source_if() { [[ -r "$1" ]] && source "$1"; }

### environment variables

export LANG=en_US.UTF-8
export USER="${USER:-$(whoami)}"
export GITUSER="$USER"
export EDITOR=vi
export VISUAL=vi
export EDITOR_PREFIX=vi

### shell options

export HISTCONTROL=ignoreboth # ignores commands with leading spaces/consecutive duplicates
export HISTSIZE=5000
export HISTFILESIZE=10000

shopt -s autocd # automatically change directories to named directories
shopt -s cdspell # autocorrect cd misspellings
shopt -s checkwinsize # update window size after command if necessary
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s direxpand # autocorrect mispelled directory names during <Tab> completion (if dirspell opt is also set)
shopt -s dirspell # autocorrect mispelled directory names during <Tab> completion (if direxpand is also set)
shopt -s dotglob # include filenames beginning with a `.` in the results of pathname expansion
shopt -s expand_aliases # enable use of aliases
shopt -s extglob # use extended globbing in pathname expansion
shopt -s globstar # allow use of `**` globbing patterns
shopt -s histappend # do not overwrite history
shopt -s nocaseglob # ignore case in filename expansion

bind "set completion-ignore-case on" # ignore upper and lowercase for <Tab> completion

### bash quality of life

# colorize ls/grep/dir command output
alias ls="ls --color=auto"
alias dir="dir --color=auto"
alias vdir="vdir --color=auto"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

# default human-readable output
alias df="df -h"

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# make non-text input files readable
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

### editor

_have vim && alias vi=vim && EDITOR=vim # set to vim if installed
_have nvim && alias vi=nvim && EDITOR=nvim # set to nvim if installed

### aliases

# apps
alias t="tmux"

# list
alias la="ls -A" # look-all
alias ll="ls -lA" # look-long
alias l="ls" # look
alias l.="ls -A | egrep '^\.'" # look-dotfiles

# git
alias gs="git status" # git status
alias gl="git log" # git log
alias ga="git add" # git add
alias gu="git rm --cached " # git unstage
alias gaa="git add ." # git add all files
alias gd="git diff" # git list diff
alias gr="git restore" # git restore
alias gp="git push" # git push
alias gsw="git switch" # git switch to branch
alias gcb="git checkout -b" # git create and switch to branch
alias gc="git commit -m" # git commit
alias gcm="git commit -m" # git commit
alias rmgit="rmd .git" # Remove .git folder

# typos
alias cd..="cd .."
alias pdw="pwd"
alias cho="echo"
# more to come lol

### prompt

PS1='\u@\h:\W\n\$ '

# username@hostname:workingdir
# $ ...

### sourcing/PATH configuration and completion

# Enable programmable completion features 
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# add user binaries to path
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

_have z && . <(z completion bash)

### personalized configuration

_source_if "$HOME/.bash_personal"
_source_if "$HOME/.bash_work"
