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

SYSNAME=`uname -s`

if [[ -z "$PATH" || "$PATH" == "/bin:/usr/bin" ]]; then
	PATH="/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games"
fi

if [ -d ~/.cabal/bin ]; then
	PATH=~/.cabal/bin:"${PATH}"
fi

export GOPATH=~/go
if [ -d "${GOPATH}" ]; then
	PATH=${GOPATH}/bin:"${PATH}"
fi

if [ -d ~/bin ]; then
	PATH=~/bin:"${PATH}"
fi

export PATH

if [ "${SYSNAME}" = "SunOS" ]; then
	export TERM=xterm
fi

export PATH
export EDITOR=vi
export CVSEDITOR=vi
export MALLOC_CHECK_=0
#export MALLOC_TRACE=mtrace.log
export GIT_PAGER=cat
HOST=`hostname | sed 's/\..*//'`

if [ -f ~/.zshenv.local ]; then
    . ~/.zshenv.local
fi
