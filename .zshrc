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
setopt no_auto_pushd
setopt no_flow_control
setopt print_exit_value
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks 
setopt hist_no_store
setopt hist_expand
setopt no_share_history
setopt checkjobs
autoload -U colors
colors

stty ixon

# bindkey
bindkey -e
bindkey ' ' magic-space
bindkey '^t' ''

# zstyle
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# set prompts
precmd() {
    PROMPT="%~
%B[%b%n@%{[${color[$HOSTATTR]}m%}%{[${color[$HOSTCOLOR]}m%}"\
"%m%{${reset_color}%}%B]%b%# "
    RPROMPT=""
    echo -n "\e]2;$USER@$HOST\a"
}

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
alias open="xdg-open"
alias fm="pcmanfm"
alias xdg-filetype="xdg-mime query filetype"

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

alias st='git status'
alias co='git checkout'
alias ci='git commit'
alias rebase='git pull --rebase'

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

    case ${ext:u} in
        "GZ")
            gunzip -dc $file > ${base};
            ;;
        "BZ2")
            bunzip2 -dk $file;
            ;;
        "LZMA")
            lzma -dk $file;
            ;;
        "TAR")
            tar xvf $file;
            ;;
        "TGZ"|"TAR.GZ")
            tar xvzf $file;
            ;;
        "TAR.BZ2")
            tar xvjf $file;
            ;;
        "TAR.LZMA")
            # for old tar
            lzma -dc $file | tar xv;
            ;;
        "ZIP")
            unzip ${file} -d ${base}
            ;;
        "CPIO")
            mkdir ${base}
            cd ${base}
            cpio -i < ../$file;
            cd ../
            ;;
        "LZH")
            mkdir ${base}
            cd ${base}
            lha x ../${file}
            cd ../
            ;;
        *)
            echo "unsupported archive."
            ;;
    esac
    return 0;
}

function errno(){
    if [ $# != 1 ]; then
        echo "usage: errno num";
        return 2;
    fi
    python -c "import os, errno; print errno.errorcode[$1], os.strerror($1)"
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

function unrpm(){
    if [ $# != 1 ]; then
        echo "usage: unrpm file";
        return 2;
    fi
    BASE_DIR="${1%.*}"
    echo $BASE_DIR
    mkdir "$BASE_DIR"
    pushd "$BASE_DIR"
    rpm2cpio "../$1" | cpio -idv
    popd
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

function click() {
    if [ $# != 1 ]; then
        echo "usage: click msec";
        return 2;
    fi
    while true; do
        echo -ne "mouseclick 1\nusleep ${1}000\n";
    done | xte
}

function disp() {
    case ${HOST} in
        retina)
        DP=eDP1
        OUT=DP1
        MODE=1280x800
        SCALE=2x2
        ;;
        *)
            echo "unknown laptop"
            return 1
        ;;
    esac
    
    case "$1" in
        off)
            set -x
            xrandr --output ${OUT} --off
            ;;
        right)
            set -x
            xrandr --output ${OUT} --mode ${MODE} --scale ${SCALE} --right-of ${DP}
            ;;
        left)
            set -x
            xrandr --output ${OUT} --mode ${MODE} --scale ${SCALE} --left-of ${DP}
            ;;
        *)
            set -x
            xrandr --output ${OUT} --mode ${MODE} --scale ${SCALE} --same-as ${DP}
            ;;
    esac
}

function xdg-init() {
    xdg-mime default pcmanfm.desktop inode/directory
    xdg-mime default atom.desktop text/plain
    xdg-mime default atom.desktop text/x-markdown
    xdg-mime default gpicview.desktop image/jpeg
    xdg-mime default gpicview.desktop image/png
    xdg-mime default gpicview.desktop image/gif
    xdg-mime default evince.desktop application/pdf
    xdg-mime default xarchive.desktop application/zip
    xdg-mime default xarchive.desktop application/x-compressed-tar
    xdg-mime default xarchive.desktop application/x-bzip-compressed-tar
}

if [ -f ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi

