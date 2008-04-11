# .zshrc
# $Id: .zshrc,v 1.8 2007/12/11 05:09:19 hamano Exp $

# autoload
autoload run-help
autoload -U compinit
compinit
setopt auto_cd
setopt auto_pushd
setopt no_flow_control
setopt print_exit_value
setopt hist_ignore_dups

bindkey -e

# zstyle
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# set prompts
if [ -f /etc/hostname ]; then
    PROMPT='[%n@'`cat /etc/hostname`']%# '
else
    PROMPT='[%n@%m]%# '
fi
RPROMPT=' %~'

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# set alias
#alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

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

