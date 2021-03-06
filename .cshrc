# $FreeBSD: src/share/skel/dot.cshrc,v 1.13 2001/01/10 17:35:28 archie Exp $
#
# .cshrc - csh resource script, read at beginning of execution by each shell
#
# see also csh(1), environ(7).
#

if($?shell) then
	setenv SHELL "${shell}"
endif

if( `uname` == FreeBSD ) then
	alias ls 'ls-F -I'
	alias la 'ls-F -A'
	alias ll 'ls-F -lThoA'
	alias pdiff "diff -urN -x CVS -x .svn -I '^# .FreeBSD: '"
else
	alias ls 'ls-F --color=auto'
	alias ll 'ls-F -lhA'
	alias la 'ls-F -A'
endif

# bsdgrep is FreeBSD >=9
if (-X bsdgrep) then
	alias grep "bsdgrep --color"
else
	alias grep "grep --color"
endif

# Override the tcsh builtins
if (-x /usr/bin/nice) then
	alias nice "/usr/bin/nice"
else if (-x /bin/nice) then
        alias nice "/bin/nice"
endif
if (-x /usr/bin/time) then
	alias time "/usr/bin/time -h"
endif

# A righteous umask
umask 022

if (-X nano) then
	setenv	EDITOR	nano
endif
if (-X less) then
	setenv	PAGER	less
endif
setenv LESS "--RAW-CONTROL-CHARS --chop-long-lines --quit-if-one-screen --ignore-case --LONG-PROMPT --SILENT --no-init"

if (-X elinks) then
	setenv BROWSER elinks
else if (-X links) then
	setenv BROWSER links
else if (-X lynx) then
	setenv BROWSER lynx
endif

if ($?prompt) then
	# An interactive shell -- set some stuff up

	if( `id -u` == "0") then
		set pcol='%{\e[1;31m%}'
		set ecol='%{\e[1;32m%}'
	else
		set pcol='%{\e[1;32m%}'
		set ecol='%{\e[1;31m%}'
	endif
	set ncol='%{\e[0m%}'

	alias precmd 'set prompt="${pcol}[%n@%m %c`if($? != 0) echo "\""${ecol} \\044\\077=%?${pcol}"\""`]%#${ncol} "'

	set promptchars = ">#"

	set filec
	set history = 8192
	set savehist = 8192 merge
	set mail = (/var/mail/$USER)
	if ( $?tcsh ) then
		bindkey "^W" backward-delete-word

		# F1
		bindkey ^[[M run-help
		bindkey OP run-help
		bindkey ^[[11~ run-help # Putty

		# Delete
		bindkey ^[[3~ delete-char

		# Home
		bindkey ^[[H beginning-of-line
		bindkey ^[[1~ beginning-of-line

		# End
		bindkey ^[[F end-of-line
		bindkey ^[[4~ end-of-line

		# Arrow keys
		bindkey -k up history-search-backward
		bindkey -k down history-search-forward

		bindkey ^[[L yank
		bindkey ^[[2 yank
	endif
endif

if( $?REMOTEHOST ) then
	if( $?TERM ) then
		if( $TERM == "xterm" ) then
			set term=xterm-color
			setenv LANG en_US.UTF-8
			setenv LC_CTYPE en_US.UTF-8
		endif
	endif
else
	set TERM cons25
#	/usr/sbin/kbdcontrol -r fast
endif

set autolist
set autocorrect
set autoexpand
set autologout
set echo_style=both
set rmstar
set filec
set listlinks
set listjobs
set noclober

set color
setenv GREP_COLOR 31 # red
setenv ACK_COLOR_FILENAME red

if( `uname` == Linux ) then
	eval `dircolors`
else
	setenv CLICOLOR
	setenv LSCOLORS  ExGxcxdxCxegedCxCxExEx
	#setenv LS_COLORS "no=00:fi=00:di=34:ln=01;31:pi=34;43:so=31;43:bd=30;43:cd=30;43:or=01;35:ex=01;31:"
	#setenv LSCOLORS ExGxFxdxCxDxDxhbadExEx
endif

if (-e ~/.cshrc-completions) then
	source ~/.cshrc-completions
endif
