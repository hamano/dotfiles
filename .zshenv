# .zshenv
#
# This file is sourced on all invocations of the shell.
# If the -f flag is present or if the NO_RCS option is
# set within this file, all other initialization files
# are skipped.
#
# This file should contain commands to set the command
# search path, plus other important environment variables.
# This file should not contain commands that produce
# output or assume the shell is attached to a tty.
#
# Global Order: zshenv, zprofile, zshrc, zlogin
#
# $Id: .zshenv,v 1.10 2008-02-19 08:55:42 hamano Exp $

export SYSNAME=`uname -s`

if [[ -z "$PATH" || "$PATH" == "/bin:/usr/bin" ]]; then
	PATH="/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games"
fi

case "${SYSNAME}" in
    'SunOS'|'AIX')
        export TERM=xterm
esac

export WORKON_HOME=~/lib/venv

export CABAL_HOME=~/.cabal
if [ -d "${CABAL_HOME}" ]; then
	PATH=~/.cabal/bin:"${PATH}"
fi

export GEM_HOME=~/lib/gem
if [ -d "${GEM_HOME}" ]; then
	PATH=${GEM_HOME}/bin:"${PATH}"
fi

export GOPATH=~/lib/go
if [ -d "${GOPATH}" ]; then
    PATH=${GOPATH}/bin:"${PATH}"
fi

export NODE_PATH=~/lib/node
if [ -d "${NODE_PATH}" ]; then
	PATH=${NODE_PATH}/bin:"${PATH}"
fi

# default pip
if [ -d ~/.local/bin ]; then
	PATH=~/.local/bin:"${PATH}"
fi

if [ -d ~/etc/bin ]; then
	PATH=~/etc/bin:"${PATH}"
fi

if [ -d ~/bin ]; then
	PATH=~/bin:"${PATH}"
fi

if [ "${SYSNAME}" = "SunOS" ]; then
	export TERM=xterm
fi

export PATH
export EDITOR=vi
export CVSEDITOR=vi
export MALLOC_CHECK_=0
#export MALLOC_TRACE=mtrace.log
HOST=`hostname | sed 's/\..*//'`

# git settings
GIT_PAGER=cat

# for cocos2d-x
export ANT_ROOT=/usr/share/ant/bin

# for virsh
export LIBVIRT_DEFAULT_URI="qemu:///system"

if [ -f ~/.zshenv.local ]; then
    . ~/.zshenv.local
fi
