let b:atp_TexCompile="pdflatex"			
let b:atp_Viewer="evince"			
let g:lucius_style="light"
colorscheme morning
let g:atp_folding=1
let g:atp_tab_map=1
let b:atp_updatetime_insert = 0
let b:atp_updatetime_normal = 8000
if exists("&breakindent")
  set breakindent showbreak=""
endif

if has("gui_running")
  set showbreak=\ \ \ \ +
endif
