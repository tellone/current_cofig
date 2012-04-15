" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
autoload/SpellCheck.vim	[[[1
107
" SpellCheck.vim: Check for spelling errors. 
"
" DEPENDENCIES:
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   1.00.002	06-Dec-2011	Publish. 
"	002	03-Dec-2011	New default behavior on &nospell is to just turn
"				on &spell, and cause an error when no &spelllang
"				has been set yet. 
"	001	02-Dec-2011	file creation

function! SpellCheck#AutoEnableSpell()
    setlocal spell
    if empty(&l:spelllang)
	throw 'No spell language defined; use :setl spl=... to enable spell checking'
    endif
endfunction

function! SpellCheck#CheckEnabledSpelling()
    if ! &l:spell
	if ! empty(g:SpellCheck_OnNospell)
	    " Allow hook to enable spelling using some sort of logic. 
	    try
		call call(g:SpellCheck_OnNospell, [])
	    catch
		" v:exception contains what is normally in v:errmsg, but with extra
		" exception source info prepended, which we cut away. 
		let v:errmsg = substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
		echohl ErrorMsg
		echomsg v:errmsg
		echohl None

		return 0
	    endtry
	endif
    endif
    if ! &l:spell || empty(&l:spelllang)
	let v:errmsg = 'E756: Spell checking is not enabled'
	echohl ErrorMsg
	echomsg v:errmsg
	echohl None

	return 0
    endif

    return 1
endfunction

function! s:GotoNextSpellError()
    let l:save_wrapscan = &wrapscan
    set wrapscan
	" XXX: Vim 7.3 does not move to the sole spell error when the cursor is
	" after the spell error in the same line. Work around this by trying the
	" other direction, too. 
	"silent! normal! ]s
	silent! normal! ]s[s
    let &wrapscan = l:save_wrapscan
endfunction
function! s:GotoFirstMisspelling()
    let l:save_wrapscan = &wrapscan
    set nowrapscan
	silent! normal! gg0]s[s
    let &wrapscan = l:save_wrapscan
    normal! zv
endfunction
function! SpellCheck#CheckErrors( isNoJump )
    if ! SpellCheck#CheckEnabledSpelling()
	return 2
    endif

    let l:save_view = winsaveview()
	let l:isError = 0
	let l:currentPos = getpos('.')

	call s:GotoNextSpellError()

	if getpos('.') != l:currentPos
	    let l:isError = 1
	else
	    " Either there are no spelling errors at all, or we're on the sole
	    " spelling error in the buffer. 
	    let l:isError = ! empty(spellbadword()[0])
	endif
    call winrestview(l:save_view)

    if l:isError
	if ! a:isNoJump
	    call s:GotoFirstMisspelling()
	endif

	let v:errmsg = 'There are spelling errors'
	echohl ErrorMsg
	echomsg v:errmsg
	echohl None
    else
	echomsg 'No spell errors found'
    endif

    return l:isError
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
autoload/SpellCheck/quickfix.vim	[[[1
118
" SpellCheck/quickfix.vim: Show all spelling errors as a quickfix list. 
"
" DEPENDENCIES:
"   - SpellCheck.vim autoload script. 
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   1.01.002	06-Dec-2011	ENH: Allow accumulating spelling errors from
"				multiple buffers (e.g. via :argdo SpellCheck). 
"   1.00.001	06-Dec-2011	Publish. 
"	001	02-Dec-2011	file creation

function! s:GotoNextLine()
    if line('.') < line('$')
	call cursor(line('.') + 1, 1)
	return 1
    else
	return 0
    endif
endfunction
function! s:RetrieveSpellErrors()
    let l:spellErrorInfo = {}
    let l:spellErrorList = []
    call cursor(1,1)

    while 1
	let [l:spellBadWord, l:errorType] = spellbadword()
	if empty(l:spellBadWord)
	    if s:GotoNextLine()
		continue
	    else
		break
	    endif
	endif

	if has_key(l:spellErrorInfo, l:spellBadWord)
	    let l:spellErrorInfo[l:spellBadWord].count += 1
	else
	    let l:spellErrorInfo[l:spellBadWord] = {'type': l:errorType, 'lnum': line('.'), 'col': col('.'), 'count': 1}
	    call add(l:spellErrorList, l:spellBadWord)
	endif

	let l:colAfterBadWord = col('.') + len(l:spellBadWord)
	if l:colAfterBadWord < col('$')
	    call cursor(line('.'), l:colAfterBadWord)
	elseif ! s:GotoNextLine()
	    break
	endif
    endwhile

    return [l:spellErrorList, l:spellErrorInfo]
endfunction
function! s:ToQfEntry( error, bufnr, spellErrorInfo )
    let l:entry = a:spellErrorInfo
    let l:entry.bufnr = a:bufnr
    let l:entry.text = a:error . (l:entry.count > 1 ? ' (' . l:entry.count . ')' : '')
    let l:entry.type = (l:entry.type ==# 'bad' || l:entry.type ==# 'caps' ? '' : 'W')
    return l:entry
endfunction
function! s:FillQuickfixList( bufnr, spellErrorList, spellErrorInfo, isNoJump, isUseLocationList )
    let l:qflist = map(a:spellErrorList, 's:ToQfEntry(v:val, a:bufnr, a:spellErrorInfo[v:val])')

    silent execute 'doautocmd QuickFixCmdPre' (a:isUseLocationList ? 'lspell' : 'spell') | " Allow hooking into the quickfix update. 

    if a:isUseLocationList
	let l:list = 'l'
	call setloclist(0, l:qflist, ' ')
    else
	let l:list = 'c'
	
	let l:errorsFromOtherBuffers = filter(getqflist(), 'v:val.bufnr != a:bufnr')
	if empty(l:errorsFromOtherBuffers)
	    " We haven't accumulated spelling errors from multiple buffers, just
	    " replace the entire quickfix list. 
	    call setqflist(l:qflist, ' ')
	else
	    " To allow accumulating spelling errors from multiple buffers (e.g.
	    " via :argdo SpellCheck), just remove the previous errors for the
	    " current buffer, and append the new list. 
	    call setqflist(l:errorsFromOtherBuffers + l:qflist, 'r')

	    " Jump to the first updated spelling error of the current buffer. 
	    let l:list = (len(l:errorsFromOtherBuffers) + 1) . 'c'
	endif
    endif

    if len(a:spellErrorList) > 0
	if ! a:isNoJump
	    execute l:list . 'first'
	    normal! zv
	endif
    endif

    silent execute 'doautocmd QuickFixCmdPost' (a:isUseLocationList ? 'lspell' : 'spell') | " Allow hooking into the quickfix update. 
endfunction

function! SpellCheck#quickfix#List( isNoJump, isUseLocationList )
    if ! SpellCheck#CheckEnabledSpelling()
	return 2
    endif

    let l:save_view = winsaveview()
	let [l:spellErrorList, l:spellErrorInfo] = s:RetrieveSpellErrors()
    call winrestview(l:save_view)

    call s:FillQuickfixList(bufnr(''), l:spellErrorList, l:spellErrorInfo, a:isNoJump, a:isUseLocationList)
    if len(l:spellErrorList) == 0
	echomsg 'No spell errors found'
    endif

    return (len(l:spellErrorList) > 0)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
plugin/SpellCheck.vim	[[[1
53
" SpellCheck.vim: Work with spelling errors. 
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher. 
"   - SpellCheck/quickfix.vim autoload script. 
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   1.00.003	06-Dec-2011	FIX: Missing :quit in :XitOrSpellCheck. 
"	002	03-Dec-2011	Rename configvar to g:SpellCheck_OnNospell. 
"	001	02-Dec-2011	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_SpellCheck') || (v:version < 700)
    finish
endif
let g:loaded_SpellCheck = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:SpellCheck_OnNospell')
    let g:SpellCheck_OnNospell = function('SpellCheck#AutoEnableSpell')
endif

if ! exists('g:SpellCheck_DefineAuxiliaryCommands')
    let g:SpellCheck_DefineAuxiliaryCommands = 1
endif


"- commands --------------------------------------------------------------------

if g:SpellCheck_DefineAuxiliaryCommands
    command! -bar -bang BDeleteUnlessSpellError     if ! SpellCheck#CheckErrors(0)      | bdelete<bang> | endif
    command! -bar -bang WriteUnlessSpellError       if ! SpellCheck#CheckErrors(0)      | write<bang> | endif
    command! -bar -bang WriteDeleteUnlessSpellError if ! SpellCheck#CheckErrors(0)      | write<bang> | bdelete<bang> | endif
    command! -bar -bang XitUnlessSpellError         if ! SpellCheck#CheckErrors(0)      | write<bang> | quit<bang> | endif

    command! -bar -bang BDeleteOrSpellCheck         if ! SpellCheck#quickfix#List(0, 0) | bdelete<bang> | endif
    command! -bar -bang WriteOrSpellCheck           if ! SpellCheck#quickfix#List(0, 0) | write<bang> | endif
    command! -bar -bang WriteDeleteOrSpellCheck     if ! SpellCheck#quickfix#List(0, 0) | write<bang> | bdelete<bang> | endif
    command! -bar -bang XitOrSpellCheck             if ! SpellCheck#quickfix#List(0, 0) | write<bang> | quit<bang> | endif

    command! -bar -bang UpdateAndSpellCheck         update<bang> | call SpellCheck#quickfix#List(0, 0)
endif

command! -bar -bang SpellCheck  call SpellCheck#quickfix#List(<bang>0, 0)
command! -bar -bang SpellLCheck call SpellCheck#quickfix#List(<bang>0, 1)

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
doc/SpellCheck.txt	[[[1
156
*SpellCheck.txt*        Work with spelling errors. 
		        
			SPELL CHECK    by Ingo Karkat
							      *SpellCheck.vim*
description			|SpellCheck-description|
usage				|SpellCheck-usage|
installation			|SpellCheck-installation|
configuration			|SpellCheck-configuration|
integration			|SpellCheck-integration|
limitations			|SpellCheck-limitations|
known problems			|SpellCheck-known-problems|
todo				|SpellCheck-todo|
history				|SpellCheck-history|

==============================================================================
DESCRIPTION					      *SpellCheck-description*

Vim offers built-in spell checking; when you enable it via 'spell' and
'spelllang', you can jump to the highlighted spelling errors in the buffer via
|]s|. With spelling errors scattered across a large document, Vim does not
provide an overview or report about the overall spell situation. 

This plugin populates the |quickfix|-list with all spelling errors found in a
buffer to give you that overview. You can use the built-in quickfix features
to navigate to the first occurrence of a particular spell error. 

A typical workflow (e.g. when composing email, commit messages, or any form of
documentation) includes writing and/or quitting the buffer, unless some
remaining spelling errors require further intervention. This plugin offers
auxiliary enhanced variants of |:bdelete|, |:write| and |:quit| that check for
spelling errors and only execute the action if none were found. So by using
these replacement commands, you'll never send or commit messages full of
embarrassing typos any more! 

==============================================================================
USAGE							    *SpellCheck-usage*
						  *:SpellCheck* *:SpellLCheck*
:SpellCheck[!]		Show all spelling errors as a quickfix list. 
			For multiple occurrences of the same error, the first
			location and the number of occurrences is shown. 
			If [!] is not given the first error is jumped to. 

			In the quickfix list, spelling errors from other
			buffers are kept, so you can use something like >
			    :argdo SpellCheck
<			to gather the spelling errors from multiple buffers. 

:SpellLCheck[!]		Same as ":SpellCheck", except the location list for the
			current window is used instead of the quickfix list. 

AUXILIARY COMMANDS							     *

The following set of commands just issue an error when spelling errors exist. 

			   *:BDeleteUnlessSpellError* *:WriteUnlessSpellError*
		       *:WriteDeleteUnlessSpellError*   *:XitUnlessSpellError*
:BDeleteUnlessSpellError[!]	|:bdelete| the current buffer, unless it
				contains spelling errors. 
:WriteUnlessSpellError[!]	|:write| the current buffer, unless it
				contains spelling errors. 
:WriteDeleteUnlessSpellError[!]	|:write| and |:bdelete| the current buffer,
				unless it contains spelling errors. 
:XitUnlessSpellError[!]		|:write|  the current buffer and |:quit|,
				unless it contains spelling errors. 

This set of commands automatically opens the quickfix list in case of spelling
errors.				   *:BDeleteOrSpellCheck* *:WriteOrSpellCheck*
			       *:WriteDeleteOrSpellCheck*   *:XitOrSpellCheck*
:BDeleteOrSpellCheck[!]		|:bdelete| the current buffer, or show the
				spelling errors in the quickfix list. 
:WriteOrSpellCheck[!]		|:write| the current buffer, or show the
				spelling errors in the quickfix list. 
:WriteDeleteOrSpellCheck[!]	|:write| and |:bdelete| the current buffer,
				or show the spelling errors in the quickfix
				list. 
:XitOrSpellCheck[!]		|:write| the current buffer and |:quit|, or
				show the spelling errors in the quickfix list. 

							*:UpdateAndSpellCheck*
:UpdateAndSpellCheck[!]		|:update| the current buffer, and show any
				spelling errors in the quickfix list. 

				A [!] is passed to the |:write| / |:bdelete| /
				|:quit| commands. 

==============================================================================
INSTALLATION					     *SpellCheck-installation*

This script is packaged as a |vimball|. If you have the "gunzip" decompressor
in your PATH, simply edit the *.vba.gz package in Vim; otherwise, decompress
the archive first, e.g. using WinZip. Inside Vim, install by sourcing the
vimball or via the |:UseVimball| command. >
    vim SpellCheck.vba.gz
    :so %
To uninstall, use the |:RmVimball| command. 

DEPENDENCIES					     *SpellCheck-dependencies*

- Requires Vim 7.0 or higher. 

==============================================================================
CONFIGURATION					    *SpellCheck-configuration*

For a permanent configuration, put the following commands into your |vimrc|: 

						      *g:SpellCheck_OnNospell*
By default, 'spell' will be automatically enabled when it's off, but you must
have already set 'spelllang' for a functioning spell check. If you have
written a custom auto-detection for the languages that you
frequently use, you can integrate this here through a funcref. The custom
function must take no arguments, and set 'spell' and 'spelllang' accordingly. >
    let g:SpellCheck_OnNospell = function('SpellCheck#AutoEnableSpell')
If you want :SpellCheck to fail when 'spell' is off: >
    let g:SpellCheck_OnNospell = ''
<
					*g:SpellCheck_DefineAuxiliaryCommands*
If you don't want the auxiliary commands, just the core |:SpellCheck| command,
use: >
    let g:SpellCheck_DefineAuxiliaryCommands = 0
If you just want some of the auxiliary commands, or under different names, or
similar commands, you can easily define them yourself, as the core spell check
functionality is available as global autoload functions. Have a look at
plugin/SpellCheck.vim for inspiration. 

==============================================================================
INTEGRATION					      *SpellCheck-integration*

==============================================================================
LIMITATIONS					      *SpellCheck-limitations*

KNOWN PROBLEMS					   *SpellCheck-known-problems*

TODO							     *SpellCheck-todo*

IDEAS							    *SpellCheck-ideas*

==============================================================================
HISTORY							  *SpellCheck-history*

1.01	14-Dec-2011
ENH: Allow accumulating spelling errors from multiple buffers (e.g. via :argdo
SpellCheck). 

1.00	06-Dec-2011
First published version. 

0.01	02-Dec-2011
Started development. 

==============================================================================
Copyright: (C) 2011 Ingo Karkat
The VIM LICENSE applies to this script; see |copyright|. 

Maintainer:	Ingo Karkat <ingo@karkat.de>
==============================================================================
 vim:tw=78:ts=8:ft=help:norl:
