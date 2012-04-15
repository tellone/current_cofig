" <+FILENAME+> - <+TITLE+>
" Maintainer:   <+EMAIL+>

if exists("g:loaded_<+FILE NAME+>") || v:version < 700 || &cp
  finish
endif
let g:loaded_<+FILE NAME+> = 1

" vim:set sw=2 sts=2:
