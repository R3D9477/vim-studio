let g:vimStudio#wnd#is_busy = 0

"--------------------------------------------------------------------------------------------------

function! vimStudio#wnd#init_module()
	let g:vimStudio#wnd#is_busy = 0
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#wnd#is_editor_wnd_num(wnd_number)
	let result = 0
	let curr_wnd_num = winnr()
	
	if a:wnd_number <= winnr("$")
		execute a:wnd_number . "wincmd w"
		let curr_buf_num = bufnr("%")
		let result = vimStudio#buf#is_editor(curr_buf_num)
	endif
	
	execute curr_wnd_num . "wincmd w"
	return result
endfunction

function! vimStudio#wnd#switch_to_wnd(wnd_name)
	let g:vimStudio#wnd#is_busy = 1
	let curr_wnd = winnr()
	
	let wnd_num = 1
	while wnd_num <= winnr("$")
		execute wnd_num . "wincmd w"
		
		let condition = (a:wnd_name == "mask" && fnamemodify(bufname("%"), ":p") == g:vimStudio#buf#mask_bufname)
		let condition = condition || (a:wnd_name == "editor" && vimStudio#buf#is_editor(bufnr("%")))
		let condition = condition || (a:wnd_name == bufname("%"))
		let condition = condition || (a:wnd_name == fnamemodify(bufname("%"), ":p"))
		
		if condition | return 1 | endif
		
		let wnd_num += 1
	endwhile
	
	execute curr_wnd . "wincmd w"
	let g:vimStudio#wnd#is_busy = 0
	return 0
endfunction

function! vimStudio#wnd#goto_last_editor_wnd()
	let curr_winnr = winnr()
	
	if vimStudio#wnd#switch_to_wnd("editor") == 1
		while curr_winnr <= winnr("$")
			if vimStudio#buf#is_editor(bufnr("%")) != 1
				let curr_winnr -= 1
				break
			endif
			let curr_winnr += 1
		endwhile
	else
		execute curr_winnr . "wincmd w"
	endif
endfunction

"--------------------------------------------------------------------------------------------------

autocmd CompleteDone * :pclose

function! vimStudio#wnd#previewWindowOpened()
	for wnd_num in range(1, winnr('$'))
		if getwinvar(wnd_num, "&pvw") == 1
			return 1
		endif
	endfor
	
	return 0
endfun
