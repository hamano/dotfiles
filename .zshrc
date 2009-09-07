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
bindkey '^t' ''

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
HISTSIZE=1000
#SAVEHIST=1000
#HISTFILE=~/.histfile
REPORTTIME=1

# set alias
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias j='jobs'
alias SL='env sl'
alias sl='ls'
alias u='uname -a'
alias cal='cal -3'
alias emacs='emacs -nw'
alias screen='screen -xR'
alias x509='openssl x509'
alias s_client='openssl s_client'
alias s_server='openssl s_server'
alias w3m='w3m -no-mouse'
UA_ZAURUS="Mozilla/4.08 (PDA; SL-C3000/1.0;Qtopia/1.4.9) NetFront/3.1 "
alias w3m-zaurus="w3m -header \"User-Agent: $UA_ZAURUS\""
UA_WS003="Opera/8.50 (Windows CE; U) [SHARP/WS003SH; PPC; 480x640]"
alias w3m-wzero3="w3m -header \"User-Agent: $UA_ZAURUS\""
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

alias b='backup'
function backup(){
    mv $1{,.bak} && cp $1{.bak,};
}
