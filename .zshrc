# .zshrc
# $Id: .zshrc,v 1.8 2007/12/11 05:09:19 hamano Exp $

# autoload
autoload run-help
autoload -U compinit
if [ `uname -s` = "CYGWIN_NT-5.1" ]; then
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

bindkey -e

# zstyle
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# set bindkey
bindkey "^?" backward-delete-char

# set prompts
PROMPT="%B[%b%n@%{[${color[$HOSTATTR]}m%}%{[${color[$HOSTCOLOR]}m%}"\
"%m%{${reset_color}%}%B]%b%# "
RPROMPT=' %~'

# history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
REPORTTIME=1

# set alias
#alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias urxvtf='urxvt -g 40x20 \
-fn "xft:vl.pgothic:size=20:antialias=true" \
-fb "xft:vl.pgothic:weight=bold:size=20:antialias=true"'

if [ `uname -s` = "SunOS" ]; then
    alias ec='emacs-clean \( -type d -a \! -name . -prune \) -o -type f'
    alias ecr='emacs-clean'
    function emacs-clean(){
        find . $@ \( -name "*~" -o -name ".*~" -o -name "*#" \)\
            -exec echo removed {} \; -exec rm -f {} \;
    }
else
    alias ls='ls --color=auto'
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

