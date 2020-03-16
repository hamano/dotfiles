# .zshrc
# $Id: .zshrc,v 1.8 2007/12/11 05:09:19 hamano Exp $

if [[ ${SYSNAME} = Linux ]]; then
    GNU=true
fi

if [[ ${SYSNAME} = Darwin ]]; then
    BSD=true
fi

if [[ ${ZSH_VERSION} < 4.3 ]]; then
    echo "zsh ${ZSH_VERSION} is too legacy"
else
    LOAD_ZPLUG=1
fi

if [[ -n ${LOAD_ZPLUG} && -f ~/.zplug/init.zsh ]]; then
    source ~/.zplug/init.zsh
    zplug 'zplug/zplug', hook-build:'zplug --self-manage'
    zplug "zsh-users/zsh-completions"
    zplug "zsh-users/zsh-history-substring-search"
    zplug "zsh-users/zsh-syntax-highlighting", defer:2
    zplug "mrowa44/emojify", as:command, use:emojify
    zplug "mafredri/zsh-async", from:github
    zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
    zplug "hamano/ame.sh", as:command, use:ame.sh
    if ! zplug check; then
        zplug install
    fi

    # pure settings
    PURE_PROMPT_SYMBOL='%%'
    prompt_pure_username=' %F{white}%n@%m%f'

    # load plugin
    zplug load
    # add path
    PATH=~/.zplug/bin:"${PATH}"
fi

# aliases
alias pyc='python-clean'
alias nw='tmux-new-window'
alias sw='tmux-split-window'
alias x='extract'

# setopt
setopt auto_cd
setopt no_auto_pushd
setopt print_exit_value
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_expand
setopt no_share_history
setopt checkjobs

stty -ixon

# bindkey
bindkey -e
bindkey '^t' ''

# zstyle
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# history
HISTSIZE=1000
#SAVEHIST=1000
#HISTFILE=~/.histfile
REPORTTIME=3

# set alias
alias l='ls -lh'
alias ll='ls -l'
alias la='ls -A'
alias j='jobs'
alias f='find'
alias SL='env sl'
alias sl='ls'
alias u='uname -a'
alias cal='cal -3'
alias lh='last -n 10 -a'
alias sr='screen -xR'
alias indentlk="indent -kr -i8 -ts8 -sob -l80 -ss -bs -psl"
alias indent4="indent -kr -i4 -ts4 -sob -l80 -ss -bs -psl"
alias screen='echo use tmux'
alias ta='tmux attach || tmux new'
alias x509='openssl x509 -subject -issuer -dates -fingerprint -noout -in'
alias x509text='openssl x509 -text -noout -in'
alias x509subject='openssl x509 -subject -noout -in'
alias x509issuer='openssl x509 -issuer -noout -in'
alias s_client='openssl s_client'
alias s_server='openssl s_server'
alias bc="bc -l"
alias ixon="stty ixon"
alias ixoff="stty -ixon"
alias open="xdg-open"
alias fm="nemo ./"

alias urxvtf='urxvt -g 40x20 \
-fn "xft:Ricty:size=22:antialias=true" \
-fb "xft:Ricty:weight=bold:size=22:antialias=true"'

alias urxvts='urxvt \
-fn "xft:vl.pgothic:size=6:antialias=true" \
-fb "xft:vl.pgothic:weight=bold:size=20:antialias=true"'

alias cvs-eliminate='test -d CVS && find ./ -type d -name CVS | xargs rm -rfv'
alias svn-eliminate='test -d .svn && find ./ -type d -name .svn | xargs rm -rfv'

#alias qwerty='setxkbmap -rules xorg -model jp106 -layout jp; xmodmap ~/.Xmodmap'
#alias dvorak='setxkbmap -rules xorg -model jp106 -layout dvorak; xmodmap ~/.Xmodmap'
alias qwerty='xmodmap ~/.Xmodmap.qwerty ~/.Xmodmap'
alias dvorak='xmodmap ~/.Xmodmap.dvorak ~/.Xmodmap'
alias aoeui=qwerty
alias warchive="wget -r -k -p -n -np"

alias elc='emacs --batch -Q -f batch-byte-compile'
alias xrdb-reload='xrdb ~/.Xresources'

if [[ ${SYSNAME} = SunOS ]]; then
    alias ec='emacs-clean \( -type d -a \! -name . -prune \) -o -type f'
    alias ecr='emacs-clean'
    function emacs-clean(){
        find . $@ \( -name "*~" -o -name ".*~" -o -name "*#" \)\
            -exec echo removed {} \; -exec rm -f {} \;
    }
fi

# settings for exa
if [[ -x ~/bin/exa ]]; then
    alias ls=exa
elif [[ $GNU ]]; then
    alias ls='ls --color=auto'
fi

# settings for grep
if [[ ${GNU} ]]; then
    alias grep="grep --color=auto"
fi

if [[ $GNU = true || $BSD = true ]]; then
    alias ec='emacs-clean -maxdepth 1'
    alias ecr='emacs-clean'
    function emacs-clean(){
        find . $@ \( -name "*~" -o -name ".*~" -o -name "*#" \)\
             -exec rm -fv {} \;
    }
fi

alias b='backup'
function backup(){
    mv $1{,.bak} && cp $1{.bak,};
}

function req() {
    openssl req -new -days 365 -x509 -nodes -keyout key.pem -out cert.pem
}


if [ -f ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi
