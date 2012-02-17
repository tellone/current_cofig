
if exists('current_compiler')
  finish
endif
let current_compiler = 'mlint'

if !exists('g:mlint_onwrite')
    let g:mlint_onwrite = 1
endif

if !exists('g:mlint_show_rate')
    let g:mlint_show_rate = 1
endif

if !exists('g:mlint_cwindow')
    let g:mlint_cwindow = 1
endif

if exists(':mlint') != 2
    command mlint :call mlint(0)
endif

if exists(":CompilerSet") != 2          " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

" We should echo filename because mlint truncates .m
" If someone know better way - let me know :) 
CompilerSet makeprg=(echo\ '[%]';\ mlint\ -r\ y\ %)

" We could omit end of file-entry, there is only one file
" %+I... - include code rating information
" %-G... - remove all remaining report lines from quickfix buffer
CompilerSet efm=%+P[%f],%t:\ %#%l:%m,%Z,%+IYour\ code%m,%Z,%-G%.%#

if g:mlint_onwrite
    augroup matlab
        au!
        au BufWritePost * call mlint
    augroup end
endif

function! mlint(writing)
    if !a:writing && &modified
        " Save before running
        write
    endif	

    if has('win32') || has('win16') || has('win95') || has('win64')
        setlocal

    else
        setlocal sp=>%s\ 2>&1
    endif

    " If check is executed by buffer write - do not jump to first error
    if !a:writing
        silent make
    else
        silent make!
    endif

    if g:mlint_cwindow
        cwindow
    endif

    call mlintEvaluation()

    if g:mlint_show_rate
        echon 'code rate: ' b:mlint_rate ', prev: ' b:mlint_prev_rate
    endif
endfunction

function! mlintEvaluation()
    let l:list = getqflist()
    let b:mlint_rate = '0.00'
    let b:mlint_prev_rate = '0.00'
    for l:item in l:list
        if l:item.type == 'I' && l:item.text =~ 'Your code has been rated'
            let b:mlint_rate = substitute(l:item.text, '.*rated at '.l:re_rate.'.*', '\1', 'g')
            " Only if there is information about previous run
            if l:item.text =~ 'previous run: '
                let b:mlint_prev_rate = substitute(l:item.text, '.*previous run: '.l:re_rate.'.*', '\1', 'g')
            endif    
        endif
    endfor
endfunction
