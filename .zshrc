# .zshrc
# $Id: .zshrc,v 1.8 2007/12/11 05:09:19 hamano Exp $

SYSNAME=`uname -s`
if [ "${SYSNAME}" = "Linux" ]; then
    GNU=1
fi

# autoload
autoload run-help
autoload -U compinit
if [ "${SYSNAME}" = "CYGWIN_NT-5.1" ]; then
    compinit -u
else
    compinit
fi
setopt auto_cd
setopt auto_pushd
setopt no_flow_control
setopt print_exit_value
setopt hist_ignore_dups
setopt no_share_history 
setopt checkjobs
autoload -U colors
colors

# bindkey
bindkey -e
bindkey ' ' magic-space

# zstyle
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# set prompts
precmd() {
    local pwdsize=${#${(%):-%~}}
    local fillsize=$(( ${COLUMNS} - $pwdsize - 2 ))
    if [ $fillsize -ge 0 ]
    then
        pad=${(l.${fillsize}.. .)}
    else
        pad=""
    fi
    PROMPT="${pad} %~
%B[%b%n@%{[${color[$HOSTATTR]}m%}%{[${color[$HOSTCOLOR]}m%}"\
"%m%{${reset_color}%}%B]%b%# "
    #RPROMPT=' %~'
}

# history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
REPORTTIME=1

# set alias
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias SL=`which sl`
alias sl='ls'
alias cal='cal -3'
alias emacs='emacs -nw'
alias w3m='w3m -no-mouse'
UA_ZAURUS="Mozilla/4.08 (PDA; SL-C3000/1.0;Qtopia/1.4.9) NetFront/3.1 "
alias w3m-zaurus="w3m -header \"User-Agent: $UA_ZAURUS\""
alias urxvtf='urxvt -g 40x20 \
-fn "xft:vl.pgothic:size=20:antialias=true" \
-fb "xft:vl.pgothic:weight=bold:size=20:antialias=true"'

if [ "${SYSNAME}" = "SunOS" ]; then
    alias ec='emacs-clean \( -type d -a \! -name . -prune \) -o -type f'
    alias ecr='emacs-clean'
    function emacs-clean(){
        find . $@ \( -name "*~" -o -name ".*~" -o -name "*#" \)\
            -exec echo removed {} \; -exec rm -f {} \;
    }
fi
if [ ${GNU} ]; then
    alias ls='ls --color=auto'
    alias grep="grep --color=auto"
    alias ec='emacs-clean -maxdepth 1'
    alias ecr='emacs-clean'
    function emacs-clean(){
        find . $@ \( -name "*~" -o -name ".*~" -o -name "*#" \)\
            -exec rm -fv {} \;
    }
fi

function bak(){
    mv $1{,.bak} && cp $1{.bak,};
}

