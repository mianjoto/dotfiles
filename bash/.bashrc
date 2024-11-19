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

shopt -s autocd         # automatically change directories to named directories
shopt -s cdspell        # autocorrect cd misspellings
shopt -s checkwinsize   # update window size after command if necessary
shopt -s cmdhist        # save multi-line commands in history as single line
shopt -s direxpand      # autocorrect mispelled directory names during <Tab> completion (if dirspell opt is also set)
shopt -s dirspell       # autocorrect mispelled directory names during <Tab> completion (if direxpand is also set)
shopt -s dotglob        # include filenames beginning with a `.` in the results of pathname expansion
shopt -s expand_aliases # enable use of aliases
shopt -s extglob        # use extended globbing in pathname expansion
shopt -s globstar       # allow use of `**` globbing patterns
shopt -s histappend     # do not overwrite history
shopt -s nocaseglob     # ignore case in filename expansion

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

_have vim && alias vi=vim && EDITOR=vim    # set to vim if installed
_have nvim && alias vi=nvim && EDITOR=nvim # set to nvim if installed

### aliases

# apps
alias t="tmux"

# list
alias la="ls -A"               # look-all
alias ll="ls -lA"              # look-long
alias l="ls"                   # look
alias l.="ls -A | egrep '^\.'" # look-dotfiles

# git
alias gs="git status"       # git status
alias gl="git log"          # git log
alias ga="git add"          # git add
alias gu="git rm --cached " # git unstage
alias gaa="git add ."       # git add all files
alias gd="git diff"         # git list diff
alias gr="git restore"      # git restore
alias gp="git push"         # git push
alias gsw="git switch"      # git switch to branch
alias gcb="git checkout -b" # git create and switch to branch
alias gc="git commit -m"    # git commit
alias gcm="git commit -m"   # git commit
alias rmgit="rmd .git"      # Remove .git folder

# typos
alias cd..="cd .."
alias pdw="pwd"
alias cho="echo"
# more to come lol

### quality of life functions

# automatically run "ls" after changing dirs
cd() {
    if [ -n "$1" ]; then
        builtin cd "$@" && ls
    else
        builtin cd ~ && ls
    fi
}

# alias xdg-open to open
open() {
    command xdg-open "$@"
}

# open/reload configuration files
cfg() {
    # $1 - action
    #   reload/r or source/s = reload/source configuration
    #   open/o = edit the configuration file
    #
    # $2 - configuration
    #   supported configuration files include
    #   - dotfiles (~/dotfiles)
    #   - bash (~/.bashrc)
    #   - tmux (~/.tmux.conf)
    #   - neovim (~/.config/nvim)

    if [[ "$1" == "r"* ]]; then
        [[ "$2" == *"bash"* ]] && source ~/.bashrc
        [[ "$2" == *"tmux"* ]] && source ~/.tmux.conf
        [[ "$2" == *"nvim"* ]] && source ~/.config/nvim/init.lua
        [[ "$2" == *"dot"* ]] && cd ~/dotfiles && ./setup
    fi

    if [[ "$1" == "o"* ]]; then
        [[ "$2" == *"bash"* ]] && nvim ~/.bashrc
        [[ "$2" == *"tmux"* ]] && nvim ~/.tmux.conf
        [[ "$2" == *"nvim"* ]] && nvim ~/.config/nvim
        [[ "$2" == *"dot"* ]] && nvim ~/dotfiles
    fi
}

### prompt

GITPROMPTPATH="$HOME/scripts/bash/git-prompt"

function __setprompt {
    local LAST_COMMAND=$? # Must come first!

    # Define colors and styles
    # see https://stackoverflow.com/a/33206814 for more details
    local BOLD="\[\033[1m\]"  # the 1 determines bold
    local DIM="\[\033[2m\]"   # the 2 determines dim
    local PLAIN="\[\033[0m\]" # the 0 determines reset formatting
    local FG="\[\033[38;5;"   # start of color declaration, 38;5 determines foreground color
    local BG="\[\033[48;5;"   # start of color declaration, 48;5 determines background color
    local FG_DEFAULT="\[\033[39m\]"
    local BG_DEFAULT="\[\033[49m\]"
    local RED="\033[0;31m"
    local LIGHTRED="\033[1;31m"
    local WHITE="15m\]"
    local DARKGRAY="234m\]"
    local DEEPBLUE="33m\]"
    local ORANGE="209m\]"
    local FG_DARKGRAY="${FG}${DARKGRAY}"
    local BG_DARKGRAY="${BG}${DARKGRAY}"
    local FG_DEEPBLUE="${FG}${DEEPBLUE}"
    local BG_DEEPBLUE="${BG}${DEEPBLUE}"
    local FG_ORANGE="${FG}${ORANGE}"
    local BG_ORANGE="${BG}${ORANGE}"

    # Nerd font icons
    local LEFTCAP=""
    local RIGHTCAP=""
    local FOLDERICON="󰉋"
    local GITICON=""

    # Show error exit code if there is one
    if [[ $LAST_COMMAND != 0 ]]; then
        PS1="\[${RED}\](\[${LIGHTRED}\]ERROR\[${RED}\])-(\[${LIGHTRED}\]Exit Code ${FG}${WHITE}${LAST_COMMAND}\[${RED}\])-(\[${LIGHTRED}\]"
        if [[ $LAST_COMMAND == 1 ]]; then
            PS1+="General error"
        elif [ $LAST_COMMAND == 2 ]; then
            PS1+="Missing keyword, command, or permission problem"
        elif [ $LAST_COMMAND == 126 ]; then
            PS1+="Permission problem or command is not an executable"
        elif [ $LAST_COMMAND == 127 ]; then
            PS1+="Command not found"
        elif [ $LAST_COMMAND == 128 ]; then
            PS1+="Invalid argument to exit"
        elif [ $LAST_COMMAND == 129 ]; then
            PS1+="Fatal error signal 1"
        elif [ $LAST_COMMAND == 130 ]; then
            PS1+="Script terminated by Control-C"
        elif [ $LAST_COMMAND == 131 ]; then
            PS1+="Fatal error signal 3"
        elif [ $LAST_COMMAND == 132 ]; then
            PS1+="Fatal error signal 4"
        elif [ $LAST_COMMAND == 133 ]; then
            PS1+="Fatal error signal 5"
        elif [ $LAST_COMMAND == 134 ]; then
            PS1+="Fatal error signal 6"
        elif [ $LAST_COMMAND == 135 ]; then
            PS1+="Fatal error signal 7"
        elif [ $LAST_COMMAND == 136 ]; then
            PS1+="Fatal error signal 8"
        elif [ $LAST_COMMAND == 137 ]; then
            PS1+="Fatal error signal 9"
        elif [ $LAST_COMMAND -gt 255 ]; then
            PS1+="Exit status out of range"
        else
            PS1+="Unknown error code"
        fi
        PS1+="\[${RED}\])\n"
    else
        PS1=""
    fi

    # Add newlines between command outputs
    PS1+="\n"

    # Current directory
    PS1+="${BG_DEFAULT}${FG_DEEPBLUE}${LEFTCAP}"         # blue left cap
    PS1+="${BG_DEEPBLUE}${FG_DARKGRAY}${FOLDERICON}"     # dark gray folder icon
    PS1+="${BG_DARKGRAY}${FG_DEEPBLUE}${RIGHTCAP}"       # blue right cap (transition to dark gray)
    PS1+="${BG_DARKGRAY}${FG_DEFAULT}${BOLD} \w${PLAIN}" # white cwd on dark gray bg
    PS1+="${BG_DEFAULT}${FG_DARKGRAY}${RIGHTCAP}"        # ending right cap

    # Git branch and head info
    if [ -f "$GITPROMPTPATH" ]; then
        source $GITPROMPTPATH
        local GIT_INFO=$(__git_ps1 "%s")
        if [ -n $GIT_INFO ] && [ ${#GIT_INFO} -gt 0 ]; then
            PS1+=" "                                       # add space between chips
            PS1+="${BG_DEFAULT}${FG_ORANGE}${LEFTCAP}"     # orange left cap
            PS1+="${BG_ORANGE}${FG_DARKGRAY}${GITICON}"    # dark gray git icon
            PS1+="${BG_DARKGRAY}${FG_ORANGE}${RIGHTCAP}"   # orange right cap (transition to dark gray)
            PS1+="${BG_DARKGRAY}${FG_DEFAULT} ${GIT_INFO}" # white git info on dark gray bg
            PS1+="${BG_DEFAULT}${FG_DARKGRAY}${RIGHTCAP}"  # ending right cap
        else
            PS1+=""
        fi
    fi

    # Prompt sign below
    PS1+="\n${FG_DEFAULT}${DIM}\$${PLAIN} "

    # PS2 is used to continue a command using the \ character
    PS2="${FG_DARKGRAY}>${FG_DEFAULT} "

    # PS3 is used to enter a number choice in a script
    PS3="Please enter a number from above list: "

    # PS4 is used for tracing a script in debug mode
    PS4="${FG_DARKGRAY}+${FG_DEFAULT} "
}

PROMPT_COMMAND="__setprompt"

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
