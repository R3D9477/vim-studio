let g:vimStudio#maskpanel#is_busy = 0
let g:vimStudio#maskpanel#mask_bufname_status = 0

let g:vimStudio#maskpanel#tree_bar_width = 0

"--------------------------------------------------------------------------------------------------

function! vimStudio#maskpanel#init_module()
	let g:vimStudio#maskpanel#is_busy = 0
	let g:vimStudio#maskpanel#mask_bufname_status = 0
	let g:vimStudio#maskpanel#tree_bar_width = 0
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#maskpanel#show()
	let result = 0
	
	if g:vimStudio#maskpanel#is_busy == 0
		let g:vimStudio#maskpanel#is_busy = 1
		
		if vimStudio#wnd#switch_to_wnd("mask") == 0
			if vimStudio#wnd#switch_to_wnd("editor") == 1
				let g:vimStudio#maskpanel#mask_bufname_status = 1
				let curr_wnd_num = winnr() + 1
				vsplit
				1wincmd w
				execute "buffer" fnameescape(g:vimStudio#buf#mask_bufname)
				setlocal nowrap
				"setlocal nonumber
				call vimStudio#maskpanel#refresh()
				call vimStudio#keymapping#set_mask_mapping()
				call vimStudio#maskpanel#set_default_width()
				execute curr_wnd_num . "wincmd w"
				let result = 1
			endif
		endif
		
		let g:vimStudio#maskpanel#is_busy = 0
	endif
	
	return result
endfunction

function! vimStudio#maskpanel#hide()
	let result = 0
	
	if g:vimStudio#maskpanel#is_busy == 0
		let g:vimStudio#maskpanel#is_busy = 1
		
		if vimStudio#wnd#switch_to_wnd("mask") == 1
			silent q!
		endif
		
		let g:vimStudio#maskpanel#mask_bufname_status = 0
		let result = 1
		let g:vimStudio#maskpanel#is_busy = 0
	endif
	
	return result
endfunction

function! vimStudio#maskpanel#toogle()
	if exists("g:vimStudio#maskpanel#mask_bufname_status")
		if g:vimStudio#maskpanel#mask_bufname_status == 1
			return vimStudio#maskpanel#hide()
		endif
	endif
	
	return vimStudio#maskpanel#show()
endfunction

function! vimStudio#maskpanel#reload()
	let result = 0
	
	if g:vimStudio#maskpanel#mask_bufname_status == 1
		if vimStudio#maskpanel#refresh() == 1
			let result = 1
		else
			let result = vimStudio#maskpanel#show()
		endif
	elseif vimStudio#wnd#switch_to_wnd("mask") == 1
		if vimStudio#maskpanel#hide() == 1
			let result = 2
		endif
	endif
	
	return result
endfunction

function! vimStudio#maskpanel#refresh()
	let result = 0
	let curr_wnd = winnr()
	
	if vimStudio#wnd#switch_to_wnd("mask") == 1
		setlocal modifiable
		call vimStudio#integration#on_maskpanel_before_refresh()
		e!
		call vimStudio#integration#on_maskpanel_after_refresh()
		setlocal nomodifiable
		let result = 1
	endif
	
	execute curr_wnd . "wincmd w"
	return result
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#maskpanel#set_width(width)
	let curr_wnd = winnr()
	
	if vimStudio#wnd#switch_to_wnd("mask") == 1
		execute "vertical" "resize" a:width
	endif
	
	execute curr_wnd . "wincmd w"
endfunction

function! vimStudio#maskpanel#set_default_width()
	let def_width = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_conf_property", ['"' . g:vimStudio#buf#mask_bufname . '"', '"vimStudio"', '"treeBarWidth"'])
	call vimStudio#maskpanel#set_width(def_width)
endfunction

function! vimStudio#maskpanel#get_width()
	if vimStudio#wnd#switch_to_wnd("mask") == 1
		return winwidth(0)
	endif
	
	return 0
endfunction

function! vimStudio#maskpanel#width_plus_plus()
	call vimStudio#wnd#switch_to_wnd("mask")
	
	let new_width = vimStudio#maskpanel#get_width() + 10
	
	if new_width > 0
		call vimStudio#maskpanel#set_width(new_width)
	endif
endfunction

function! vimStudio#maskpanel#width_minus_minus()
	call vimStudio#wnd#switch_to_wnd("mask")
	
	let new_width = vimStudio#maskpanel#get_width() - 10
	
	if new_width > 0
		call vimStudio#maskpanel#set_width(new_width)
	endif
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#maskpanel#fold_or_open(o_type)
	let sel_ftype = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_type_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', line(".") - 1])
	
	if sel_ftype == "p" || sel_ftype == "d"
		let child_count = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_childs_count_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', line(".") - 1])
		
		if child_count > 1
			call feedkeys((line(".") + 1) . "G")
			call feedkeys("`")
			call feedkeys("\<C-s>")
			call feedkeys(line(".") . "G")
		endif
	elseif sel_ftype == "f"
		call vimStudio#maskpanel_file#open_file(a:o_type)
	endif
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#maskpanel#rename(new_name)
	let item_ftype = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_type_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', (line(".") - 1)])
	
	if item_ftype == "p"
		call vimStudio#project#rename(a:new_name)
	else
		call vimStudio#maskpanel_file#rename(a:new_name)
	endif
endfunction
