" <+FILENAME+> - <+TITLE+>
" Maintainer:   filip.diloom@gmail.com

if exists("g:loaded_tempcolor") || v:version < 700 || &cp
  finish
endif
let g:loaded_tempcolor = 1


if (!exists("g:colorscheme"))
  let g:colorscheme = g:colors_name
endif

augroup localColors
  au!
  au WinEnter * call s:ChangeColors()
  au WinEnter * 
        \ if exists('g:Powerline_loaded') |
          \ sinlent! execute "Pl#ReloadColorscheme" |
        \ endif 
augroup END

" if the  variable 'b:colorscheme'  or 'g:colorscheme'  exists it  becomes the
" color of the currently entered window
"
" the  default is  to NOT  change the  color scheme  (if the  variable doesn't
" exist)
function! <SID>ChangeColors()
  let scheme = GetVar#GetVar("colorscheme", g:colors_name)

  " only change colors if necessary
  if (scheme != g:colors_name)
    execute "colorscheme " . scheme
  endif
endfunction

" if the  input parameter is  empty, display  the current local  color scheme.
" otherwise, set the local color scheme to what is specified and change colors
" is necessary.
function! <SID>SetLocalColors(colorChoice)
  if (a:colorChoice == "")
    echo "Local color scheme is:  " . (exists("b:colorscheme") ? b:colorscheme : "NONE")
  else
    le:t b:colorscheme = a:colorChoice
    call s:ChangeColors()
  endif
endfunction

function! <SID>RemoveLocalColors()
  " suppress the error message
  silent! execute "unlet b:colorscheme"
  call s:ChangeColors()
endfunction

" if the  input parameter is empty,  display the current window  color scheme.
" otherwise,  set the  window color  scheme to  what is  specified and  change
" colors is necessary.
function! <SID>SetWindowColors(colorChoice)
  if (a:colorChoice == "")
    echo "Window color scheme is:  " . (exists("w:colorscheme") ? w:colorscheme : "NONE")
  else
    let w:colorscheme = a:colorChoice
    call s:ChangeColors()
  endif
endfunction

function! <SID>RemoveWindowColors()
  " suppress the error message
  silent! execute "unlet w:colorscheme"
  call s:ChangeColors()
endfunction

com! -nargs=? Setwindowcolors call s:SetWindowColors(<q-args>)
com! Removewindowcolors call s:RemoveWindowColors()

com! -nargs=? Setlocalcolors call s:SetLocalColors(<q-args>)
com! Removelocalcolors call s:RemoveLocalColors()

" change the colorscheme and update the global colorscheme variable
com! -nargs=1 Globalscheme colorscheme <args> | let g:colorscheme = g:colors_name

nmap <leader>öw :execute "Setwindowcolors " . input("Enter window colorscheme [" . (exists("w:colorscheme") ? w:colorscheme : "NONE") . "]:  ")<cr>
nmap <leader>öö :execute "Setlocalcolors " . input("Enter local colorscheme [" . (exists("b:colorscheme") ? b:colorscheme : "NONE") . "]:  ")<cr>
nmap <leader>ög :execute "Globalscheme " . input("Enter global colorscheme [" . (exists("g:colorscheme") ? g:colorscheme : "NONE") . "]:  ")<cr>
nmap <leader>öd :Removewindowcolors<cr>
nmap <leader>ör :Removelocalcolors<cr>

" vim:set sw=2 sts=2:
