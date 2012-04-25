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
  au filetype text,txt call s:ChangeColors() 
        
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
  
    if exists('g:Powerline_loaded')
      sinlent! execute "Pl#Load"
    endif 
 
  endif
endfunction


" vim:set sw=2 sts=2:
