" Title:		Vim plugin file of Automatix LaTex Plugin
" Author:		Marcin Szamotulski
" Web Page:		http://atp-vim.sourceforge.net
" Mailing List: 	atp-vim-list [AT] lists.sourceforge.net

" Note: autocommand events BufRead, BufAdd are not executed from ftplugin
" directory, they should all should be here. Loading once on startup when
" filetype is set, may be achived using:
"    au BufRead *.tex au! BufEnter *.tex :call Function()
"    \

" KpsewhichEdit command: {{{1
function! <SID>KpsewhichEdit(args)
    let [ string, edit_args, file]  = matchlist(a:args, '\(.\{-}\)\s*\(\f\+\)$')[0:2]
    let file_path = matchstr(system("kpsewhich '".file."'"),'^.*\ze\n')
    if empty(file_path)
	echohl WarningMsg | echo "Kpsewhich cannot find the file: ".file | echohl Normal
    else
	exe "edit ".escape(edit_args, '\ ')." ".fnameescape(file_path)
    endif
    " Setting filetype=plaintex leads to errors.
endfunction
function! <SID>KpsewhichEditComp(ArgLead, CmdLine, CursorPos)
    let completion_list = []
    if exists("g:atp_LatexPackages")
" 	let g:atp_LatexPackages	= atplib#search#KpsewhichGlobPath("tex", "", "*.sty")
	call extend(completion_list, map(deepcopy(g:atp_LatexPackages), 'v:val.".sty"'))
    endif
    if exists("g:atp_LatexClasses")
" 	let g:atp_LatexClasses	= atplib#search#KpsewhichGlobPath("tex", "", "*.cls")
	call extend(completion_list, map(deepcopy(g:atp_LatexClasses), 'v:val.".cls"'))
    endif
    return join(completion_list, "\n")
endfunction
command! -nargs=1 -complete=custom,<SID>KpsewhichEditComp KpsewhichEdit :call <SID>KpsewhichEdit('<args>')
augroup ATP_LoadVimSettings "{{{1
    " In this way settings from project.vim script will overwrite vimrc file.
    au!
    au! BufRead *.tex :au BufEnter *.tex :call ATP_LoadVimSettings()
augroup END

" Set options and maps for tex log file.
function! TexLogCurrentFile() " {{{1
    let saved_pos = getpos(".")
    let savedview = winsaveview()
    let skip = 'getline(".") =~ ''^l\.\d\+.*'' || getline(line(".")-1) =~ ''^l\.\d\+.*'' && getline(".") =~ ''^\s\+'' || getline(line(".")-1) =~ ''^Runaway argument?'' || getline(line(".")-1) =~ ''^\(Over\|Under\)full\>'''
    let skip=""
    call searchpair('(', '', ')', 'cbW', skip)
    let file = matchstr(getline(".")[col("."):], '^\f*')
    if filereadable(file)
	call setpos(".", saved_pos)
	call winrestview(savedview) 
	return file
    else
	call searchpair('(', '', ')', 'bW', skip)
	let file = matchstr(getline(".")[col("."):], '^\f*')
	call setpos(".", saved_pos)
	call winrestview(savedview) 
	call setpos(".", saved_pos)
	call winrestview(savedview) 
	if filereadable(file)
	    return file
	else
	    return ""
	endif
    endif
endfunction
function! <SID>TexLogSettings(fname) "{{{1
    " This function should also have the SyncTex section of
    " atplib#various#OpenLog, but since it requires b:atp_ProjectDir and
    " possibly b:atp_MainFile variables, it is not yet done.
    if filereadable(fnamemodify(expand(a:fname), ":r").".tex")
	setl nomodifiable
	setl buftype=nowrite
	setl nospell
	setl syn=log_atp
	setl autoread
	setl autowriteall
	nnoremap <silent> <buffer> ]m :call atplib#various#Search('\CWarning\\|^!', 'W')<CR>
	nnoremap <silent> <buffer> [m :call atplib#various#Search('\CWarning\\|^!', 'bW')<CR>
	nnoremap <silent> <buffer> ]w :call atplib#various#Search('\CWarning', 'W')<CR>
	nnoremap <silent> <buffer> [w :call atplib#various#Search('\CWarning', 'bW')<CR>
	nnoremap <silent> <buffer> ]c :call atplib#various#Search('\CLaTeX Warning: Citation', 'W')<CR>
	nnoremap <silent> <buffer> [c :call atplib#various#Search('\CLaTeX Warning: Citation', 'bW')<CR>
	nnoremap <silent> <buffer> ]r :call atplib#various#Search('\CLaTeX Warning: Reference', 'W')<CR>
	nnoremap <silent> <buffer> [r :call atplib#various#Search('\CLaTeX Warning: Reference', 'bW')<CR>
	nnoremap <silent> <buffer> ]e :call atplib#various#Search('^!', 'W')<CR>
	nnoremap <silent> <buffer> [e :call atplib#various#Search('^!', 'bW')<CR>
	nnoremap <silent> <buffer> ]f :call atplib#various#Search('\CFont \%(Info\\|Warning\)', 'W')<CR>
	nnoremap <silent> <buffer> [f :call atplib#various#Search('\CFont \%(Info\\|Warning\)', 'bW')<CR>
	nnoremap <silent> <buffer> ]p :call atplib#various#Search('\CPackage', 'W')<CR>
	nnoremap <silent> <buffer> [p :call atplib#various#Search('\CPackage', 'bW')<CR>
	nnoremap <silent> <buffer> ]P :call atplib#various#Search('\[\_d\+\zs', 'W')<CR>
	nnoremap <silent> <buffer> [P :call atplib#various#Search('\[\_d\+\zs', 'bW')<CR>
	nnoremap <silent> <buffer> ]i :call atplib#various#Search('\CInfo', 'W')<CR>
	nnoremap <silent> <buffer> [i :call atplib#various#Search('\CInfo', 'bW')<CR>
	nnoremap <silent> <buffer> % :call atplib#various#Searchpair('(', '', ')', 'W')<CR>
 
	call atplib#ReadATPRC()
	if !exists("g:atp_LogStatusLine")
	    let g:atp_LogStatusLine = 1
	endif
	if g:atp_LogStatusLine
	    let atplog_StatusLine = '%<%f %(%h%m%r%) %*%=  %-14.16(%l,%c%V%)%P'
	    let &statusline=atplog_StatusLine
	endif
	let b:atp_ProjectDir = expand("%:p:h")
	let b:atp_MainFile   = expand("%:p:r").".tex" 
	if !exists("g:atp_debugST")
	    let g:atp_debugST = 0
	endif
	if !exists("g:atp_LogSync")
	    let g:atp_LogSync = 0
	endif
	if !exists("b:atp_Viewer")
	    let b:atp_Viewer = "xpdf"
	endif
	if !exists("b:atp_XpdfServer")
	    let b:atp_XpdfServer = fnamemodify(b:atp_MainFile,":t:r")
	endif
	if !exists("g:atp_SyncXpdfLog")
	    let g:atp_SyncXpdfLog 	= 0
	endif
	if !exists("g:atp_TempDir")
	    call atplib#TempDir()
	endif
	if !exists("g:atp_tex_extensions")
	    let g:atp_tex_extensions	= ["tex.project.vim", "aux", "_aux", "log", "bbl", "blg", "bcf", "run.xml", "spl", "snm", "nav", "thm", "brf", "out", "toc", "mpx", "idx", "ind", "ilg", "maf", "glo", "mtc[0-9]", "mtc1[0-9]", "pdfsync", "synctex.gz" ]
	endif
	if !exists("b:atp_OutDir")
	    let b:atp_OutDir = substitute(fnameescape(fnamemodify(resolve(expand("%:p")),":h")) . "/", '\\\s', ' ' , 'g')
	endif
	if !exists("b:atp_TempDir")
	    let b:atp_TempDir = substitute(b:atp_OutDir . "/.tmp", '\/\/', '\/', 'g')
	endif
	command! -buffer -bang SyncTex	:call atplib#various#SyncTex(<q-bang>)
	nnoremap <buffer> <Enter>		:<C-U>SyncTex<CR>
	nnoremap <buffer> <LocalLeader>f	:<C-U>SyncTex<CR>	
	augroup ATP_SyncLog
	    au!
	    au CursorMoved *.log :call atplib#various#SyncTex("", 1)
	augroup END

	command! -buffer SyncXpdf 	:call atplib#various#SyncXpdfLog(0)
	command! -buffer Xpdf 	:call atplib#various#SyncXpdfLog(0)
	map <buffer> <silent> <F3> 	:<C-U>SyncXpdf<CR>
	augroup ATP_SyncXpdfLog
	    au CursorMoved *.log :call atplib#various#SyncXpdfLog(1)
	augroup END
    endif
endfunction
augroup ATP_texlog "{{{1
    au!
    au BufEnter *.log call <SID>TexLogSettings(expand("<afile>:p"))
augroup END
" Commands: "{{{1
command! -bang	UpdateATP				:call atplib#various#UpdateATP(<q-bang>)
command! 	ATPversion				:echo atplib#various#ATPversion()

" With bang: add most of the packages loaded in the current preambule. Also
" sets --tex (-t) and --class (-c) texdef option. Without bang only the --tex
" (-t) option is set ('tex', 'latex', 'contex', 'xelatex', 'lualatex', ...) 
" NOTE: only the first three are supported.
command! -bang -nargs=* TexDef :call atplib#tools#TexDef(<q-bang>,<q-args>)
