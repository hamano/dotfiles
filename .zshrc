# .zshrc
# $Id: .zshrc,v 1.8 2007/12/11 05:09:19 hamano Exp $

if [ "${SYSNAME}" = "Linux" ]; then
    GNU=1
fi

if [[ -d ~/.zsh.d/functions/ ]]; then
    fpath=(~/.zsh.d/functions/ $fpath)
elif [[ -d ~/git/dotfiles/.zsh.d/functions/ ]]; then
    fpath=(~/git/dotfiles/.zsh.d/functions/ $fpath)
fi

# autoload & call
autoload -U zgen-init && zgen-init
autoload -U compinit && compinit
autoload -U promptinit && promptinit
autoload -U colors && colors

# autoload
autoload run-help
autoload -U xdg-init
autoload -U errno
autoload -U disp
autoload -U click
autoload -U unrpm
autoload -U python-clean
alias pyc='python-clean'
autoload -U list-colors

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

# set prompts
PURE_PROMPT_SYMBOL='%%'
prompt pure
#precmd() {
#    PROMPT="%~
#%B[%b%n@%{[${color[$HOSTATTR]}m%}%{[${color[$HOSTCOLOR]}m%}"\
#"%m%{${reset_color}%}%B]%b%# "
#    RPROMPT=""
#}

# history
HISTSIZE=1000
#SAVEHIST=1000
#HISTFILE=~/.histfile
REPORTTIME=1

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
#alias screen='screen -xR'
alias screen='echo use tmux'
alias ta='tmux attach || tmux new'
alias x509='openssl x509'
alias s_client='openssl s_client'
alias s_server='openssl s_server'
alias bc="bc -l"
alias ixon="stty ixon"
alias ixoff="stty -ixon"
alias open="xdg-open"
alias fm="pcmanfm"

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
alias warchive="wget -rkpN"

alias emacs='emacs -nw'
alias elc='emacs --batch -Q -f batch-byte-compile'

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

alias b='backup'
function backup(){
    mv $1{,.bak} && cp $1{.bak,};
}

alias x='extract'
function extract(){
    if [ $# != 1 ]; then
        echo "usage: x file";
        return 2;
    fi

    local file=$1;
    local ext=${file##*.};
    local base=${file%.${ext}};

    if [ ${ext:u} = "GZ" -o ${ext:u} = "BZ2" -o ${ext:u} = "LZMA" ]; then
        local ext2=${base##*.};
        if [ ${ext2:u} = "TAR" -o ${ext2:u} = "STAR" ]; then
            ext=${ext2}.${ext};
        fi
    fi

    case "${ext:u}" in
        "GZ")
            gunzip -dc "$file" > "${base}";
            ;;
        "BZ2")
            bunzip2 -dk "$file"
            ;;
        "LZMA")
            lzma -dk "$file"
            ;;
        "TAR")
            tar xvf "$file"
            ;;
        "TGZ"|"TAR.GZ")
            tar xvzf "$file"
            ;;
        "TAR.BZ2")
            tar xvjf "$file"
            ;;
        "TAR.LZMA")
            # for old tar
            lzma -dc "$file" | tar xv;
            ;;
        "ZIP")
            unzip "${file}" -d "${base}"
            ;;
        "CPIO")
            mkdir "${base}"
            pushd "${base}"
            cpio -i < "../$file"
            popd
            ;;
        "LZH")
            mkdir "${base}"
            pushd "${base}"
            lha x "../${file}"
            popd
            ;;
        "DEB")
            mkdir "${base}"
            pushd "${base}"
            ar vx "../${file}"
            x control.tar.gz
            x data.tar.xz
            popd
            ;;
        "RPM")
            mkdir "${base}"
            pushd "${base}"
            rpm2cpio "../${file}" | cpio -idv
            popd
            ;;
        *)
            echo "unsupported archive: ${ext:u}"
            ;;
    esac
    return 0;
}

function git-ic(){
    git init
    git add .
    git commit -a -m "initial commit"
}

function git-tar(){
    if [ $# != 2 ]; then
        echo "usage: git-tar prefix tag";
        return 2;
    fi
    git archive --format=tar --prefix=$1/ $2 | gzip -9 > $1.tar.gz
}

function ssh-rm(){
    if [ $# != 1 ]; then
        echo "usage: ssh-rm host";
        return 2;
    fi
#	echo -ne "$1d\nw\n" | ed -s ~/.ssh/known_hosts
    ssh-keygen -f ~/.ssh/known_hosts -R "$1"
}

function urlencode () {
    perl -MURI::Escape -lne 'print uri_escape($_)' <<< "$1"
}

function urldecode () {
    perl -MURI::Escape -lne 'print uri_unescape($_)' <<< "$1";
}

function req() {
    openssl req -new -days 365 -x509 -nodes -keyout key.pem -out cert.pem
}

function echod() {
    if [ $# != 1 ]; then
        echo "usage: echod port";
        return 2;
    fi
    echo "Listning ${1}"
    while true; do
        nc -l -p ${1} -c 'xargs -n1 echo'
        test $? -ne 0 && break;
    done
}

alias sw="split-window"
function split-window(){
    if [ -z "$TMUX" ]; then
        tmux
    fi
    if [ $# -eq 0 ]; then
        tmux split-window -v "$SHELL"
    else
        tmux split-window -v "exec $*"
    fi
}

alias nw="new-window"
function new-window(){
    if [ -z "$TMUX" ]; then
        tmux
    fi
    if [ $# -eq 0 ]; then
        tmux new-window "$SHELL"
    else
        tmux new-window -n "$*" "exec $*"
    fi
}

if [ -f ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi

