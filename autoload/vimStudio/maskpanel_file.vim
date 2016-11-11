function! vimStudio#maskpanel_file#init_module()
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#maskpanel_file#open_file(o_type)
	let result = 0
	
	let file_index = line(".") - 1
	let selected_file = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_path_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', file_index])
	let continue_def_proc = vimStudio#integration#on_before_open_file(file_index, selected_file, a:o_type)
	
	if continue_def_proc == 1
		if !empty(glob(selected_file))
			if a:o_type == "T"
				execute "tabe" fnameescape(selected_file)
			elseif a:o_type == "V"
				call vimStudio#wnd#goto_last_editor_wnd()
				vsplit
				call vimStudio#wnd#goto_last_editor_wnd()
				execute "edit" fnameescape(selected_file)
			elseif a:o_type == "H"
				call vimStudio#wnd#goto_last_editor_wnd()
				split
				call vimStudio#wnd#goto_last_editor_wnd()
				execute "edit" fnameescape(selected_file)
			else
				call vimStudio#wnd#goto_last_editor_wnd()
				execute "edit" fnameescape(selected_file)
			endif
			
			call vimStudio#keymapping#set_editor_mapping()
			
			let result = 1
		endif
	endif
	
	call vimStudio#integration#on_after_open_file(file_index, selected_file, a:o_type, result)
	return result
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#maskpanel_file#insert_link(file_path, new_name)
	let result = 0
	
	let parent_index = line(".") - 1
	let continue_def_proc = vimStudio#integration#on_before_add_file(parent_index, a:file_path, a:new_name, 0)
	
	if continue_def_proc == 1
		let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "insert_file_into_index", ['"' . g:vimStudio#buf#mask_bufname . '"', parent_index, '"' . a:file_path . '"', 1])
		if result == 1
			call vimStudio#maskpanel#refresh()
		endif
	endif
	
	call vimStudio#integration#on_after_add_file(parent_index, a:file_path, a:new_name, 0, result)
	return result
endfunction

function! vimStudio#maskpanel_file#insert_file(file_path, new_name)
	let result = 0
	
	let parent_index = line(".") - 1
	let continue_def_proc = vimStudio#integration#on_before_add_file(parent_index, a:file_path, a:new_name, 1)
	
	if continue_def_proc == 1
		let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "insert_file_into_index", ['"' . g:vimStudio#buf#mask_bufname . '"', parent_index, '"' . a:file_path . '"', "true", "false", '"' . a:new_name . '"'])
		if result == 1
			call vimStudio#maskpanel#refresh()
		endif
	endif
	
	call vimStudio#integration#on_after_add_file(parent_index, a:file_path, a:new_name, 1, result)
	return result
endfunction

function! vimStudio#maskpanel_file#insert_linkR(file_path, new_name)
	let result = 0
	
	let parent_index = line(".") - 1
	let continue_def_proc = vimStudio#integration#on_before_add_file(parent_index, a:file_path, a:new_name, 0)
	
	if continue_def_proc == 1
		let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "insert_file_into_index", ['"' . g:vimStudio#buf#mask_bufname . '"', parent_index, '"' . a:file_path . '"', "false", "true", '"' . a:new_name . '"'])
		if result == 1
			call vimStudio#maskpanel#refresh()
		endif
	endif
	
	call vimStudio#integration#on_after_add_file(parent_index, a:file_path, a:new_name, 0, result)
	return result
endfunction

function! vimStudio#maskpanel_file#insert_fileR(file_path, new_name)
	let result = 0
	
	let parent_index = line(".") - 1
	let continue_def_proc = vimStudio#integration#on_before_add_file(parent_index, a:file_path, a:new_name, 1)
	
	if continue_def_proc == 1
		let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "insert_file_into_index", ['"' . g:vimStudio#buf#mask_bufname . '"', parent_index, '"' . a:file_path . '"', "true", "true", '"' . a:new_name . '"'])
		if result == 1
			call vimStudio#maskpanel#refresh()
		endif
	endif
	
	call vimStudio#integration#on_after_add_file(parent_index, a:file_path, a:new_name, 1, result)
	return result
endfunction

function! vimStudio#maskpanel_file#insert_new_file(file_name, template)
	let result = 0
	
	let parent_index = line(".") - 1
	let continue_def_proc = vimStudio#integration#on_before_insert_new_file(parent_index, a:file_name, a:template)
	
	if continue_def_proc == 1
		let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "init_template", ['"' . g:vimStudio#buf#mask_bufname . '"', '"' . a:template . '"', parent_index, '"' . a:file_name . '"'])
		if result == 1
			call vimStudio#maskpanel#refresh()
		endif
	endif
	
	call vimStudio#integration#on_after_insert_new_file(parent_index, a:file_name, a:template, result)
	return result
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#maskpanel_file#insert_curr_buf(as_link, new_name)
	let result = 0
	
	let curr_wnd = winnr()
	let curr_path = bufname("%")
	
	if vimStudio#wnd#switch_to_wnd("mask") == 1
		if a:as_link == 1
			let result = vimStudio#maskpanel_file#insert_link(curr_path, a:new_name)
		else
			let result = vimStudio#maskpanel_file#insert_file(curr_path, a:new_name)
		endif
	endif
	
	execute curr_wnd . "wincmd w"
	return result
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#maskpanel_file#delete_file(delete_from_disk)
	let result = 0
	
	let file_index = line(".") - 1
	let file_path = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_path_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', file_index])
	let continue_def_proc = vimStudio#integration#on_before_delete_file(file_index, file_path, a:delete_from_disk)
	
	if continue_def_proc == 1
		if a:delete_from_disk == 1
			let delete_from_disk = "true"
		else
			let delete_from_disk = "false"
		endif
		
		let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "delete_file_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', file_index, a:delete_from_disk])
		
		if result == 1
			call vimStudio#maskpanel#refresh()
		endif
	endif
	
	call vimStudio#integration#on_after_delete_file(file_index, file_path, a:delete_from_disk, result)
	return result
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#maskpanel_file#rename(new_name)
	let result = 0
	
	let file_index = line(".") - 1
	let selected_file = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_path_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', file_index])
	let continue_def_proc = vimStudio#integration#on_before_rename_file(file_index, selected_file, a:new_name)
	
	if continue_def_proc == 1
		let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "rename_file_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', line(".") - 1, '"' . a:new_name . '"'])
		
		if result == 1
			call vimStudio#maskpanel#refresh()
		endif
	endif
	
	call vimStudio#integration#on_after_rename_file(file_index, selected_file, a:new_name, result)
	return result
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#maskpanel_file#copy_file()
	let g:vimStudio#maskpanel_file#src_copy_index = line(".") - 1
	
	if exists("g:vimStudio#maskpanel_file#src_cut_index") == 1
		unlet g:vimStudio#maskpanel_file#src_cut_index
	endif
endfunction

function! vimStudio#maskpanel_file#cut_file()
	let g:vimStudio#maskpanel_file#src_cut_index = line(".") - 1
	
	if exists("g:vimStudio#maskpanel_file#src_copy_index") == 1
		unlet g:vimStudio#maskpanel_file#src_copy_index
	endif
endfunction

function! vimStudio#maskpanel_file#paste_file()
	let result = 0
	
	if exists("g:vimStudio#maskpanel_file#src_copy_index")
		let result = vimStudio#maskpanel_file#copy_file_from_to(g:vimStudio#maskpanel_file#src_copy_index, line(".") - 1)
	elseif exists("g:vimStudio#maskpanel_file#src_cut_index")
		let result = vimStudio#maskpanel_file#move_file_from_to(g:vimStudio#maskpanel_file#src_cut_index, line(".") - 1)
		unlet g:vimStudio#maskpanel_file#src_cut_index
	endif
	
	return result
endfunction

function! vimStudio#maskpanel_file#copy_file_from_to(src_index, dest_index)
	let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "copy_file_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', a:src_index, a:dest_index])
	
	if result == 1
		call vimStudio#maskpanel#refresh()
	endif
	
	return result
endfunction

function! vimStudio#maskpanel_file#move_file_from_to(src_index, dest_index)
	let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "move_file_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', a:src_index, a:dest_index])
	
	if result == 1
		call vimStudio#maskpanel#refresh()
	endif
	
	return result
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#maskpanel_file#exec()
	let result = 0
	
	let file_index = line(".") - 1
	let selected_file = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_path_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', file_index])
	let continue_def_proc = vimStudio#integration#on_before_exec_file(file_index, selected_file)
	
	if continue_def_proc == 1
		let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "exec_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', file_index])
	endif
	
	call vimStudio#integration#on_after_exec_file(file_index, selected_file, result)
	return result
endfunction

function! vimStudio#maskpanel_file#exec_parent_dir()
	let result = 0
	
	let file_index = line(".") - 1
	let selected_file = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_path_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', file_index])
	let continue_def_proc = vimStudio#integration#on_before_exec_parent_dir(file_index, selected_file)
	
	if continue_def_proc == 1
		let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "exec_parent_dir_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', file_index])
	endif
	
	call vimStudio#integration#on_after_exec_parent_dir(file_index, selected_file, result)
	return result
endfunction
