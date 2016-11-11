if exists("g:vimStudio_%templMain%_init")
	if g:vimStudio_%templMain%_init == 1
		finish
	endif
endif

let g:vimStudio_%templMain%_init = 1

"-------------------------------------------------------------------------

let g:vimStudio_%templMain%#plugin_dir = expand("<sfile>:p:h:h")

let g:vimStudio_%templMain%#is_valid_project = 0

"-------------------------------------------------------------------------

function! vimStudio_%templMain%#on_project_before_open()
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_project_before_open]')
	
	let g:vimStudio_%templMain%#is_valid_project = 0
	
	"...
	"...
	"..
	
	let projectType = vimStudio#js#call(g:vimStudio#plugin_dir, "get_conf_property", "", ['"' . g:vimStudio#buf#mask_bufname . '"', '"vimStudio"', '"projectType"'])
	call vimStudio#debug#append_log(3, cdil, 'projectType = ' . projectType)
	
	if projectType == "%templMain%"
		call vimStudio#debug#append_log(2, cdil, 'projectType == "%templMain%"')
		
		"...
		"...
		"...
		
		call add(g:vimStudio#integration#context_menu_dir, g:vimStudio_%templMain%#plugin_dir . "/menu")
		
		g:vimStudio_%templMain%#is_valid_project = 1
	else
		call vimStudio#debug#append_log(2, cdil, 'projectType != "%templMain%"')
	endif
	
	call vimStudio#debug#append_log(3, cdil, 'g:vimStudio_%templMain%#is_valid_project = ' . g:vimStudio_%templMain%#is_valid_project)
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_project_after_open()
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_project_after_open]')
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_before_project_close()
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_before_project_close]')
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
		
		let g:vimStudio_%templMain%#is_valid_project = 0
		call remove(g:vimStudio#integration#context_menu_dir, index(g:vimStudio#integration#context_menu_dir, g:vimStudio_%templMain%#plugin_dir . "/menu"))
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_after_project_rename(old_mask_bufname, result)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_after_project_rename]')
	call vimStudio#debug#append_log(1, cdil, 'a:old_mask_bufname = ' . a:old_mask_bufname)
	call vimStudio#debug#append_log(1, cdil, 'a:result = ' . a:result)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		if a:result == 1
			call vimStudio#debug#append_log(2, cdil, 'a:result == 1')
			
			"...
			"...
			"...
		else
			call vimStudio#debug#append_log(2, cdil, 'a:result != 1')
			
			"...
			"...
			"...
		endif
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_make_project()
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_make_project]')
	
	let continue_to_make = 1
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		let continue_to_make = 0
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#append_log(3, cdil, 'continue_make = ' . continue_to_make)
	
	call vimStudio#debug#decrase_ierarchy_level()
	return continue_to_make
endfunction

function! vimStudio_%templMain%#on_after_update_project()
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_after_update_project]')
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_after_update_mask()
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_after_update_mask]')
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

"-------------------------------------------------------------------------

function! vimStudio_%templMain%#on_before_add_file(parent_index, file_path, new_name, is_copy)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_before_add_file]')
	call vimStudio#debug#append_log(3, cdil, 'a:parent_index = ' . a:parent_index)
	call vimStudio#debug#append_log(3, cdil, 'a:file_path = ' . a:file_path)
	call vimStudio#debug#append_log(3, cdil, 'a:new_name = ' . a:new_name)
	call vimStudio#debug#append_log(3, cdil, 'a:is_copy = ' . a:is_copy)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_after_add_file(parent_index, file_path, new_name, is_copy, result)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_after_add_file]')
	call vimStudio#debug#append_log(3, cdil, 'a:parent_index = ' . a:parent_index)
	call vimStudio#debug#append_log(3, cdil, 'a:file_path = ' . a:file_path)
	call vimStudio#debug#append_log(3, cdil, 'a:new_name = ' . a:new_name)
	call vimStudio#debug#append_log(3, cdil, 'a:is_copy = ' . a:is_copy)
	call vimStudio#debug#append_log(3, cdil, 'a:result = ' . a:result)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		if a:result == 1
			call vimStudio#debug#append_log(2, cdil, 'a:result == 1')
			
			"...
			"...
			"...
		else
			call vimStudio#debug#append_log(2, cdil, 'a:result != 1')
			
			"...
			"...
			"...
		endif
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_before_delete_file(file_index, file_path, delete_from_disk)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_before_delete_file]')
	call vimStudio#debug#append_log(3, cdil, 'a:file_index = ' . a:file_index)
	call vimStudio#debug#append_log(3, cdil, 'a:file_path = ' . a:file_path)
	call vimStudio#debug#append_log(3, cdil, 'a:delete_from_disk = ' . a:delete_from_disk)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_after_delete_file(file_index, file_path, delete_from_disk, result)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_after_delete_file]')
	call vimStudio#debug#append_log(3, cdil, 'a:file_index = ' . a:file_index)
	call vimStudio#debug#append_log(3, cdil, 'a:file_path = ' . a:file_path)
	call vimStudio#debug#append_log(3, cdil, 'a:delete_from_disk = ' . a:delete_from_disk)
	call vimStudio#debug#append_log(3, cdil, 'a:result = ' . a:result)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		if a:result == 1
			call vimStudio#debug#append_log(2, cdil, 'a:result == 1')
			
			"...
			"...
			"...
		else
			call vimStudio#debug#append_log(2, cdil, 'a:result != 1')
			
			"...
			"...
			"...
		endif
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_before_open_file(file_index, file_path, o_type)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_before_open_file]')
	call vimStudio#debug#append_log(3, cdil, 'a:file_index = ' . a:file_index)
	call vimStudio#debug#append_log(3, cdil, 'a:file_path = ' . a:file_path)
	call vimStudio#debug#append_log(3, cdil, 'a:o_type = ' . a:o_type)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_after_open_file(file_index, file_path, o_type, result)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_after_open_file]')
	call vimStudio#debug#append_log(3, cdil, 'a:file_index = ' . a:file_index)
	call vimStudio#debug#append_log(3, cdil, 'a:file_path = ' . a:file_path)
	call vimStudio#debug#append_log(3, cdil, 'a:o_type = ' . a:o_type)
	call vimStudio#debug#append_log(3, cdil, 'a:result = ' . a:result)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		if a:result == 1
			call vimStudio#debug#append_log(2, cdil, 'a:result == 1')
			
			"...
			"...
			"...
		else
			call vimStudio#debug#append_log(2, cdil, 'a:result != 1')
			
			"...
			"...
			"...
		endif
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_before_rename_file(file_index, selected_file, new_name)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_before_rename_file]')
	call vimStudio#debug#append_log(3, cdil, 'a:file_index = ' . a:file_index)
	call vimStudio#debug#append_log(3, cdil, 'a:selected_file = ' . a:selected_file)
	call vimStudio#debug#append_log(3, cdil, 'a:new_name = ' . a:new_name)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_after_rename_file(file_index, selected_file, new_name, result)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_after_rename_file]')
	call vimStudio#debug#append_log(3, cdil, 'a:file_index = ' . a:file_index)
	call vimStudio#debug#append_log(3, cdil, 'a:file_path = ' . a:selected_file)
	call vimStudio#debug#append_log(3, cdil, 'a:new_name = ' . a:new_name)
	call vimStudio#debug#append_log(3, cdil, 'a:result = ' . a:result)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		if a:result == 1
			call vimStudio#debug#append_log(2, cdil, 'a:result == 1')
			
			"...
			"...
			"...
		else
			call vimStudio#debug#append_log(2, cdil, 'a:result != 1')
			
			"...
			"...
			"...
		endif
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_before_exec_file(file_index, file_path)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_before_exec_file]')
	call vimStudio#debug#append_log(3, cdil, 'a:file_index = ' . a:file_index)
	call vimStudio#debug#append_log(3, cdil, 'a:file_path = ' . a:file_path)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_after_exec_file(file_index, file_path, result)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_after_exec_file]')
	call vimStudio#debug#append_log(3, cdil, 'a:file_index = ' . a:file_index)
	call vimStudio#debug#append_log(3, cdil, 'a:file_path = ' . a:file_path)
	call vimStudio#debug#append_log(3, cdil, 'a:result = ' . a:result)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		if a:result == 1
			call vimStudio#debug#append_log(2, cdil, 'a:result == 1')
			
			"...
			"...
			"...
		else
			call vimStudio#debug#append_log(2, cdil, 'a:result != 1')
			
			"...
			"...
			"...
		endif
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_before_exec_parent_dir(file_index, file_path)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_before_exec_parent_dir]')
	call vimStudio#debug#append_log(3, cdil, 'a:file_index = ' . a:file_index)
	call vimStudio#debug#append_log(3, cdil, 'a:file_path = ' . a:file_path)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_after_exec_parent_dir(file_index, file_path, result)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_after_exec_parent_dir]')
	call vimStudio#debug#append_log(3, cdil, 'a:file_index = ' . a:file_index)
	call vimStudio#debug#append_log(3, cdil, 'a:file_path = ' . a:file_path)
	call vimStudio#debug#append_log(3, cdil, 'a:result = ' . a:result)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		if a:result == 1
			call vimStudio#debug#append_log(2, cdil, 'a:result == 1')
			
			"...
			"...
			"...
		else
			call vimStudio#debug#append_log(2, cdil, 'a:result != 1')
			
			"...
			"...
			"...
		endif
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_before_insert_new_file(parent_index, file_name, file_template)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_before_insert_new_file]')
	call vimStudio#debug#append_log(3, cdil, 'a:parent_index = ' . a:parent_index)
	call vimStudio#debug#append_log(3, cdil, 'a:file_name = ' . a:file_name)
	call vimStudio#debug#append_log(3, cdil, 'a:file_template = ' . a:file_template)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_after_insert_new_file(parent_index, file_name, file_template, result)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_after_insert_new_file]')
	call vimStudio#debug#append_log(3, cdil, 'a:parent_index = ' . a:parent_index)
	call vimStudio#debug#append_log(3, cdil, 'a:file_name = ' . a:file_name)
	call vimStudio#debug#append_log(3, cdil, 'a:file_template = ' . a:file_template)
	call vimStudio#debug#append_log(3, cdil, 'a:result = ' . a:result)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		if a:result == 1
			call vimStudio#debug#append_log(2, cdil, 'a:result == 1')
			
			"...
			"...
			"...
		else
			call vimStudio#debug#append_log(2, cdil, 'a:result != 1')
			
			"...
			"...
			"...
		endif
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

"-------------------------------------------------------------------------

function! vimStudio_%templMain%#on_tab_leave()
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_tab_leave]')
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_tab_changed()
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_tab_changed]')
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_buf_enter()
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_buf_enter]')
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_check_current_tab()
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_check_current_tab]')
	
	let checking_result = 0
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#append_log(3, cdil, 'checking_result = ' . checking_result)
	
	call vimStudio#debug#decrase_ierarchy_level()
	return checking_result
endfunction

function! vimStudio_%templMain%#on_after_check_current_tab()
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_after_check_current_tab]')
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

"-------------------------------------------------------------------------

function! vimStudio_%templMain%#on_maskpanel_before_refresh()
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_maskpanel_before_refresh]')
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

function! vimStudio_%templMain%#on_maskpanel_after_refresh()
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_maskpanel_after_refresh]')
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		"...
		"...
		"...
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

"-------------------------------------------------------------------------

function! vimStudio_%templMain%#on_menu_item(menu_id)
	let cdil = vimStudio#debug#incrase_ierarchy_level()
	call vimStudio#debug#append_log(1, cdil, '[vimStudio_%templMain%#on_menu_item]')
	call vimStudio#debug#append_log(3, cdil, 'a:menu_id = ' . a:menu_id)
	
	if g:vimStudio_%templMain%#is_valid_project == 1
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project == 1')
		
		if a:menu_id == "%templMain%_item"
			"...
			"...
			"...
		endif
	else
		call vimStudio#debug#append_log(2, cdil, 'g:vimStudio_%templMain%#is_valid_project != 1')
	endif
	
	call vimStudio#debug#decrase_ierarchy_level()
	return 1
endfunction

"-------------------------------------------------------------------------

call vimStudio#integration#register_module("vimStudio_%templMain%")

call add(g:vimStudio#integration#project_template_dir, g:vimStudio_%templMain%#plugin_dir . "/template/project")
call add(g:vimStudio#integration#file_template_dir, g:vimStudio_%templMain%#plugin_dir . "/template/file")
