" Grep oppertor
" Maintainer:   filip.diloom@gmail.com

if exists("g:loaded_grep_opp") || v:version < 700 || &cp
  finish
endif
let g:loaded_grep_opp = 1

nnoremap <leader>g :set operatorfunc=GrepOperator<cr>g@
vnoremap <leader>g :<C-U>call GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)

  let saved_unnamed_register = @@
 
  if a:type ==# 'v'
    execute "normal! `<v`>y 
  elseif a:type ==# 'char'
    execute "normal! `[v`]y 
  else
    return
  endif 
        silent execute "grep! -R " . shellescape(@@) . " ."
        copen

        let @@ = saved_unnamed_register
endfunction















" vim:set sw=2 sts=2:
