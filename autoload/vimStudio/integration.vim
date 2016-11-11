let g:vimStudio#integration#modules = []

let g:vimStudio#integration#project_template_dir = [g:vimStudio#plugin_dir . "/template/project"]
let g:vimStudio#integration#file_template_dir = [g:vimStudio#plugin_dir . "/template/file"]
let g:vimStudio#integration#context_menu_dir = []

"--------------------------------------------------------------------------------------------------

function! vimStudio#integration#init_module()
	let g:vimStudio#integration#modules = []
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#integration#register_module(module_name)
	for module_name in g:vimStudio#integration#modules
		if module_name == a:module_name
			return
		endif
	endfor
	
	call add(g:vimStudio#integration#modules, a:module_name)
endfunction

function! vimStudio#integration#unregister_module(module_name)
	for module_name in g:vimStudio#integration#modules
		if module_name == a:module_name
			unlet g:vimStudio#integration#modules[module_name]
			return
		endif
	endfor
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#integration#call_event_handler(event_name, def_value, ...)
	let result = a:def_value
	
	if a:def_value == 0
		let c_str = "||"
	else
		let c_str = "&&"
	endif
	
	let args_str = ""
	
	for event_arg in a:000
		if len(args_str) > 0
			let args_str .= ","
		endif
			
		let args_str .= event_arg
	endfor
	
	for module_name in g:vimStudio#integration#modules
		if exists("*" . module_name . "#" . a:event_name) == 1
			execute "let result = result " . c_str . " " . module_name . "#" . a:event_name . "(" . args_str . ")"
		endif
	endfor
	
	return result
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#integration#on_project_before_open()
	return vimStudio#integration#call_event_handler("on_project_before_open", 1)
endfunction

function! vimStudio#integration#on_project_after_open()
	return vimStudio#integration#call_event_handler("on_project_after_open", 1)
endfunction

function! vimStudio#integration#on_before_project_close()
	return vimStudio#integration#call_event_handler("on_before_project_close", 1)
endfunction

function! vimStudio#integration#on_after_project_rename(old_mask_bufname)
	return vimStudio#integration#call_event_handler("on_after_project_rename", 1, "'" . a:old_mask_bufname . "'")
endfunction

function! vimStudio#integration#on_after_update_project()
	return vimStudio#integration#call_event_handler("on_after_update_project", 1)
endfunction

function! vimStudio#integration#on_after_update_mask()
	return vimStudio#integration#call_event_handler("on_after_update_mask", 1)
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#integration#on_before_add_file(parent_index, file_path, new_name, is_copy)
	return vimStudio#integration#call_event_handler("on_before_add_file", 1, a:parent_index, "'" . a:file_path . "'", "'" . a:new_name . "'", a:is_copy)
endfunction

function! vimStudio#integration#on_after_add_file(parent_index, file_path, new_name, is_copy, result)
	return vimStudio#integration#call_event_handler("on_after_add_file", 1, a:parent_index, "'" . a:file_path . "'", "'" . a:new_name . "'", a:is_copy, a:result)
endfunction

function! vimStudio#integration#on_before_delete_file(file_index, file_path, delete_from_disk)
	return vimStudio#integration#call_event_handler("on_before_delete_file", 1, a:file_index, "'" . a:file_path . "'", a:delete_from_disk)
endfunction

function! vimStudio#integration#on_after_delete_file(file_index, file_path, delete_from_disk, result)
	return vimStudio#integration#call_event_handler("on_after_delete_file", 1, a:file_index, "'" . a:file_path . "'", a:delete_from_disk, a:result)
endfunction

function! vimStudio#integration#on_before_open_file(file_index, file_path, o_type)
	return vimStudio#integration#call_event_handler("on_before_open_file", 1, a:file_index, "'" . a:file_path . "'", "'" . a:o_type . "'")
endfunction

function! vimStudio#integration#on_after_open_file(file_index, file_path, o_type, result)
	return vimStudio#integration#call_event_handler("on_after_open_file", 1, a:file_index, "'" . a:file_path . "'", "'" . a:o_type . "'", a:result)
endfunction

function! vimStudio#integration#on_before_insert_new_file(parent_index, file_name, file_template)
	return vimStudio#integration#call_event_handler("on_before_insert_new_file", 1, a:parent_index, "'" . a:file_name . "'", "'" . a:file_template . "'")
endfunction

function! vimStudio#integration#on_after_insert_new_file(parent_index, file_name, file_template, result)
	return vimStudio#integration#call_event_handler("on_after_insert_new_file", 1, a:parent_index, "'" . a:file_name . "'", "'" . a:file_template . "'", a:result)
endfunction

function! vimStudio#integration#on_before_rename_file(file_index, selected_file, new_name)
	return vimStudio#integration#call_event_handler("on_before_rename_file", 1, a:file_index, "'" . a:selected_file . "'", "'" . a:new_name . "'")
endfunction

function! vimStudio#integration#on_after_rename_file(file_index, selected_file, new_name, result)
	return vimStudio#integration#call_event_handler("on_after_rename_file", 1, a:file_index, "'" . a:selected_file . "'", "'" . a:new_name . "'", a:result)
endfunction

function! vimStudio#integration#on_before_exec_file(file_index, file_path)
	return vimStudio#integration#call_event_handler("on_before_exec_file", 1, a:file_index, "'" . a:file_path . "'")
endfunction

function! vimStudio#integration#on_after_exec_file(file_index, file_path, result)
	return vimStudio#integration#call_event_handler("on_after_exec_file", 1, a:file_index, "'" . a:file_path . "'", a:result)
endfunction

function! vimStudio#integration#on_before_exec_parent_dir(file_index, file_path)
	return vimStudio#integration#call_event_handler("on_before_exec_parent_dir", 1, a:file_index, "'" . a:file_path . "'")
endfunction

function! vimStudio#integration#on_after_exec_parent_dir(file_index, file_path, result)
	return vimStudio#integration#call_event_handler("on_after_exec_parent_dir", 1, a:file_index, "'" . a:file_path . "'", a:result)
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#integration#on_tab_leave()
	return vimStudio#integration#call_event_handler("on_tab_leave", 1)
endfunction

function! vimStudio#integration#on_tab_changed()
	return vimStudio#integration#call_event_handler("on_tab_changed", 1)
endfunction

function! vimStudio#integration#on_buf_enter()
	return vimStudio#integration#call_event_handler("on_buf_enter", 1)
endfunction

function! vimStudio#integration#on_check_current_tab()
	return vimStudio#integration#call_event_handler("on_check_current_tab", 0)
endfunction

function! vimStudio#integration#on_after_check_current_tab()
	return vimStudio#integration#call_event_handler("on_after_check_current_tab", 1)
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#integration#on_maskpanel_before_refresh()
	return vimStudio#integration#call_event_handler("on_maskpanel_before_refresh", 1)
endfunction

function! vimStudio#integration#on_maskpanel_after_refresh()
	return vimStudio#integration#call_event_handler("on_maskpanel_after_refresh", 1)
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#integration#on_menu_item(menu_id)
	return vimStudio#integration#call_event_handler("on_menu_item", 1, "'" . a:menu_id . "'")
endfunction
