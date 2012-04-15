Vim�UnDo� ��"r�S�fǚ/�i��ưz�5��c�_�   �                                   OS�U    _�                              ����                                                                                                                                                                                                                                                                                                                                                           OS�T    �   �   �          endfunction�   �   �          	return s:Unfold()�   �   �          
	endwhile�   �   �          		endif�   �   �          &			call cursor(foldclosedend('.'), 1)�   �   �          		else�   �   �          			let l:count = l:count - 1�   �   �          .		if !g:ip_skipfold || foldclosedend('.') < 0�   �   �          		endif�   �   �          			return s:Unfold()�   �   �          			call cursor(line('$'),1)�   �   �          		if l:res <= 0�   �   �          &		let l:res = search(l:boundary, 'W')�   �   �          *		let l:res = search(l:notboundary, 'cW')�   �   �          	while l:count > 0�   �   �          	endif�      �          		let l:count = v:count1�   ~   �          %		call cursor(foldclosedend('.'), 1)�   }             	else�   |   ~          		let l:count = v:count1 - 1�   {   }          -	if !g:ip_skipfold || foldclosedend('.') < 0�   z   |          	endif�   y   {          		return s:Unfold()�   x   z          		call cursor(line('$'),1)�   w   y          	if l:res <= 0�   v   x          %	let l:res = search(l:boundary, 'W')�   u   w          	endif�   t   v          		endif�   s   u          			return s:Unfold()�   r   t          			call cursor(line('$'),1)�   q   s          		if l:res <= 0�   p   r          *		let l:res = search(l:notboundary, 'sW')�   o   q           	if getline('.') =~# l:boundary�   n   p          $	let l:notboundary=l:boundary.'\@!'�   m   o          V	let l:boundary='^\%('.(exists('b:ip_boundary') ? b:ip_boundary : g:ip_boundary).'\)'�   l   n          function! <SID>ParagFore()�   k   m          �   j   l          endfunction�   i   k          	return s:Unfold()�   h   j          
	endwhile�   g   i          		endif�   f   h          #			call cursor(foldclosed('.'), 1)�   e   g          		else�   d   f          			let l:count = l:count - 1�   c   e          +		if !g:ip_skipfold || foldclosed('.') < 0�   b   d          		endif�   a   c          			return s:Unfold()�   `   b          			call cursor(1,1)�   _   a          		if l:res <= 0�   ^   `          '		let l:res = search(l:boundary, 'Wb')�   ]   _          +		let l:res = search(l:notboundary, 'cWb')�   \   ^          	while l:count > 0�   [   ]          	endif�   Z   \          		let l:count = v:count1�   Y   [          "		call cursor(foldclosed('.'), 1)�   X   Z          	else�   W   Y          		let l:count = v:count1 - 1�   V   X          *	if !g:ip_skipfold || foldclosed('.') < 0�   U   W          	endif�   T   V          		return s:Unfold()�   S   U          		call cursor(1,1)�   R   T          	if l:res <= 0�   Q   S          &	let l:res = search(l:boundary, 'Wb')�   P   R          	endif�   O   Q          		return s:Unfold()�   N   P          		call cursor(1,1)�   M   O          	if l:res <= 0�   L   N          +	let l:res = search(l:notboundary, 'scWb')�   K   M          $	let l:notboundary=l:boundary.'\@!'�   J   L          V	let l:boundary='^\%('.(exists('b:ip_boundary') ? b:ip_boundary : g:ip_boundary).'\)'�   I   K          function! <SID>ParagBack()�   H   J          �   G   I          endfunction�   F   H          
	endwhile�   E   G          		normal za�   D   F          	while foldclosed('.') > 0�   C   E          function! s:Unfold()�   B   D          �   A   C          Ivnoremap <silent> } :<C-U>exe "normal! gv"<Bar>call <SID>ParagFore()<CR>�   @   B          Ivnoremap <silent> { :<C-U>exe "normal! gv"<Bar>call <SID>ParagBack()<CR>�   ?   A          4nnoremap <silent> } :<C-U>call <SID>ParagFore()<CR>�   >   @          4nnoremap <silent> { :<C-U>call <SID>ParagBack()<CR>�   =   ?          �   <   >          endif�   ;   =          	let g:ip_skipfold=0�   :   <          if !exists('g:ip_skipfold')�   9   ;          endif�   8   :          	let g:ip_boundary='\s*$'�   7   9          if !exists('g:ip_boundary')�   6   8          �   5   7          let g:loaded_ipmotion = 1�   4   6          endif�   3   5          	finish�   2   4          if exists('g:loaded_ipmotion')�   1   3          �   0   2          &"                   Default is unset.�   /   1          H"                   local buffer or only apply to particular file type.�   .   0          M"                   g:ip_boundary if set. Useful when customize boundary for�   -   /          M" b:ip_boundary     Local definition of paragraph boundary. It will override�   ,   .          "�   +   -          ="                   beginning. It is enforced by the script.�   *   ,          H"                   Note that there is no need adding a "^" sign at the�   )   +          "�   (   *          0"                   contains '"' as boundaries.�   '   )          G"                   Setting that will make empty lines, and lines only�   &   (          7"                       :let g:ip_boundary = '"\?\s*$'�   %   '          "                   Example:�   $   &          "�   #   %          >"                   b:ip_boundary will override this setting.�   "   $          E"                   It can be changed in .vimrc or anytime. Defining�   !   #          -"                   Default value is "\s*$".�       "          A" g:ip_boundary     The global definition of paragraph boundary.�      !          "�                 ""                   Default is 0.�                0"                   boundaries in closed folds.�                M" g:ip_skipfold     Set as 1 will make the "{" and "}" motion skip paragraph�                " Configuration Variables:�                "�                " paragraph boundary.�                K" Without any setting, it will treat blank line (with or without space) as�                "�                A" check with "USING A GLOBAL PLUGIN" under :help standard-plugin�                (" If you do not know where to place it,�                "�                9" Simply copy the file to plugin folder and restart vim.�                " Install:�                "�                " boundary.�                H" also support redefine the regexp for boundary, or local definition of�                K" It supports in normal and visual mode, and able to handle with count. It�                "�                '" avoid strange behaviour when moving.�                L" Note that the regexp will be enforced to match from the start of line, to�   
             6" matched line will be treated as paragraph boundary.�   	             G" The utility uses a custom regexp to define paragraph boundaries, the�      
          "�      	          C" boundary, this utility remap the key "{" and "}" to handle that.�                F" In vim, a blank line only containing white space is NOT a paragraph�                K" A simple utility improve the "{" and "}" motion in normal / visual mode.�                " Description:�                " Version: 1.0�                *" Maintainer: Luke Ng <kalokng@gmail.com>�                " Last Change: 2012-02-27�                 " Improved paragraph motion5��