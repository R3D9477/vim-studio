let g:vimStudio#buf#mask_bufname = ""
let g:vimStudio#buf#conf_bufname = ""
let g:vimStudio#buf#tree_bufname = ""

"--------------------------------------------------------------------------------------------------

function! vimStudio#buf#init_module()
	let g:vimStudio#buf#mask_bufname = ""
	let g:vimStudio#buf#conf_bufname = ""
	let g:vimStudio#buf#tree_bufname = ""
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#buf#is_mask(buf_number)
	return fnamemodify(bufname(a:buf_number), ":p") == g:vimStudio#buf#mask_bufname
endfunction

function! vimStudio#buf#is_conf(buf_number)
	return fnamemodify(bufname(a:buf_number), ":p") == g:vimStudio#buf#conf_bufname
endfunction

function! vimStudio#buf#is_tree(buf_number)
	return fnamemodify(bufname(a:buf_number), ":p") == g:vimStudio#buf#tree_bufname
endfunction

function! vimStudio#buf#is_editor(buf_number)
	if buflisted(a:buf_number) != 1
		return 0
	endif
	
	let cnd_1 = ( vimStudio#buf#is_mask(a:buf_number) != 1 )
	let cnd_2 = ( getbufvar(a:buf_number, "&modifiable") == 1 || getbufvar(a:buf_number, "is_vimStudio_search_result") == 1 )
		
	return cnd_1 && cnd_2
endfunction

"--------------------------------------------------------------------------------------------------

autocmd BufEnter,BufWinEnter ?* :if vimStudio#wnd#previewWindowOpened() == 0 | if &modifiable == 0 | call feedkeys("\<esc>") | endif | endif
