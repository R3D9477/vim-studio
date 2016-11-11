let g:vimStudio#dialogs#confirm_gui = has("gui_running")
let g:vimStudio#dialogs#choose_name_gui = has("gui_running")
let g:vimStudio#dialogs#choose_template_gui = has("gui_running")
let g:vimStudio#dialogs#choose_project_gui = has("gui_running")
let g:vimStudio#dialogs#choose_dir_gui = has("gui_running")
let g:vimStudio#dialogs#choose_file_gui = has("gui_running")

"--------------------------------------------------------------------------------------------------

function! vimStudio#dialogs#init_module()
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#dialogs#confirm(question)
	let answer = -1
	
	while answer == -1
		if g:vimStudio#dialogs#confirm_gui == 1
			let answer = vimStudio#request(g:vimStudio#plugin_dir, "dialogs", "confirm", ['"' . a:question . '"'])
		else
			let answer = input(a:question . " (y/n): ")
		endif
		
		if answer == "y" || answer == "Y" || answer == "yes" || answer == "Yes" || answer == "YES" || answer == 1
			let answer = 1
		elseif answer == "n" || answer == "N" || answer == "no" || answer == "No" || answer == "NO" || answer == 0
			let answer = 0
		else
			let answer = -1
		endif
	endwhile
	
	return answer
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#dialogs#choose_name(orig_name)
	if g:vimStudio#dialogs#choose_name_gui == 1
		let selected_name = vimStudio#request(g:vimStudio#plugin_dir, "dialogs", "choose_name", ['"' . a:orig_name . '"'])
	else
		let selected_name = input("Name: ", a:orig_name)
	endif
	
	return selected_name
endfunction

function! vimStudio#dialogs#choose_template(root_dirs)
	let args = []
	
	let i = 0
	while i < len(a:root_dirs)
		call add(args, '"' . a:root_dirs[i] . '"')
		let i = i + 1
	endwhile
	
	if g:vimStudio#dialogs#choose_template_gui == 1
		let selected_template = vimStudio#request(g:vimStudio#plugin_dir, "dialogs", "choose_template", args)
	else
		let selected_template = input("Template: ")
	endif
	
	return selected_template
endfunction

function! vimStudio#dialogs#choose_project()
	if g:vimStudio#dialogs#choose_project_gui == 1
		let selected_project = vimStudio#request(g:vimStudio#plugin_dir, "dialogs", "choose_project", [])
	else
		let selected_project = input("Project: ")
	endif
	
	return selected_project
endfunction

function! vimStudio#dialogs#choose_dir()
	if g:vimStudio#dialogs#choose_dir_gui == 1
		let selected_dir = vimStudio#request(g:vimStudio#plugin_dir, "dialogs", "choose_dir", [])
	else
		let selected_dir = input("Directory: ")
	endif
	
	return selected_dir
endfunction

function! vimStudio#dialogs#choose_file()
	if g:vimStudio#dialogs#choose_file_gui == 1
		let selected_file = vimStudio#request(g:vimStudio#plugin_dir, "dialogs", "choose_file", [])
	else
		let selected_file = input("File: ")
	endif
	
	return selected_file
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#dialogs#new_project()
	let result = 0
	
	let selected_template = vimStudio#dialogs#choose_template(g:vimStudio#integration#project_template_dir)
	
	if selected_template != ""
		let project_name = vimStudio#dialogs#choose_name("")
		
		if project_name != ""
			let result = vimStudio#project#new(project_name, selected_template)
		endif
	endif
	
	return result
endfunction

function! vimStudio#dialogs#open_project()
	let selected_project = vimStudio#dialogs#choose_project()
	call vimStudio#project#open(selected_project)
endfunction

function! vimStudio#dialogs#del_project()
	let selected_project = vimStudio#dialogs#choose_project()
	call vimStudio#project#delete_path(selected_project)
endfunction

function! vimStudio#dialogs#rename_project()
	let new_name = vimStudio#dialogs#choose_name(fnamemodify(g:vimStudio#buf#mask_bufname, ":t:r"))
	
	if len(new_name) > 0
		call vimStudio#project#rename(new_name)
	endif
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#dialogs#insert_dir()
	let selected_dir = vimStudio#dialogs#choose_dir()
	call vimStudio#maskpanel_file#insert_file(selected_dir, '')
endfunction

function! vimStudio#dialogs#insert_link_dir()
	let selected_dir = vimStudio#dialogs#choose_dir()
	call vimStudio#maskpanel_file#insert_link(selected_dir, '')
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#dialogs#insert_file()
	let selected_file = vimStudio#dialogs#choose_file()
	call vimStudio#maskpanel_file#insert_file(selected_file, '')
endfunction

function! vimStudio#dialogs#insert_link()
	let selected_file = vimStudio#dialogs#choose_file()
	call vimStudio#maskpanel_file#insert_link(selected_file, '')
endfunction

function! vimStudio#dialogs#insert_new_file()
	let result = 0
	
	let selected_template = vimStudio#dialogs#choose_template(g:vimStudio#integration#file_template_dir)
	
	if selected_template != ""
		let file_name = vimStudio#dialogs#choose_name("")
	endif
	
	return result
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#dialogs#rename()
	let selected_file = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_path_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', line(".") - 1])
	let new_name = vimStudio#dialogs#choose_name(fnamemodify(selected_file, ":t"))
	
	if len(new_name) > 0
		call vimStudio#maskpanel#rename(new_name)
	endif
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#dialogs#search_and_replace_in_files()
	let find_struct = vimStudio#request(g:vimStudio#plugin_dir, "dialogs", "search_and_replace", [])
	
	if len(find_struct) > 0
		call vimStudio#search#search_and_replace_in_files(find_struct)
	endif
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#dialogs#delete_file()
	let answer = vimStudio#dialogs#confirm("Delete from disk?")
	call vimStudio#maskpanel_file#delete_file(answer)
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#dialogs#insert_curr_buf()
	let is_link_answer = vimStudio#dialogs#confirm("Insert as link?")
	let rename_answer = vimStudio#dialogs#confirm("Insert with new name?")
	
	if rename_answer == 1
		let new_name = vimStudio#dialogs#choose_name("")
	else
		let new_name = ""
	endif
	
	return vimStudio#maskpanel_file#insert_curr_buf(is_link_answer, new_name)
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#dialogs#context_menu(vim_mode, menu_name) range
	let menu_name = "invalid_item"
	
	if a:menu_name == "mask"
		let item_fpath = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_path_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', line(".") - 1])
		let item_ftype = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_type_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', line(".") - 1])
		
		if item_ftype == "p" || item_ftype == "d" || (item_ftype == "f" && !empty(glob(item_fpath)))
			let menu_name = "mask_" . item_ftype
		endif
	elseif a:menu_name == "editor_ni" || a:menu_name == "editor_v"
		let menu_name = a:menu_name
	endif
	
	let args = ['"' . menu_name . '"']
	
	let i = 0
	while i < len(g:vimStudio#integration#context_menu_dir)
		call add(args, '"' . g:vimStudio#integration#context_menu_dir[i] . '"')
		let i = i + 1
	endwhile
	
	let action_id = vimStudio#request(g:vimStudio#plugin_dir, "dialogs", "context_menu", args)
	
	if a:vim_mode == "visual"
		normal! gv
	endif
	
	let continue_def_proc = vimStudio#integration#on_menu_item(action_id)
	
	if continue_def_proc == 1
		if action_id == "vimStudio_fold_unfold"
			call feedkeys("`")
		elseif action_id == "vimStudio_fold_unfold_all"
			call feedkeys("~")
		"----------------------------------------------------------------
		elseif action_id == "vimStudio_fopen"
			call vimStudio#maskpanel#fold_or_open("")
		elseif action_id == "vimStudio_fopen_tab"
			call vimStudio#maskpanel#fold_or_open("T")
		elseif action_id == "vimStudio_fopen_vsplit"
			call vimStudio#maskpanel#fold_or_open("V")
		elseif action_id == "vimStudio_fopen_hsplit"
			call vimStudio#maskpanel#fold_or_open("H")
		"----------------------------------------------------------------
		elseif action_id == "vimStudio_exec"
			call vimStudio#maskpanel_file#exec()
		elseif action_id == "vimStudio_exec_parent_dir"
			call vimStudio#maskpanel_file#exec_parent_dir()
		"----------------------------------------------------------------
		elseif action_id == "vimStudio_rename"
			call vimStudio#dialogs#rename()
		"----------------------------------------------------------------
		elseif action_id == "vimStudio_copy"
			call vimStudio#maskpanel_file#copy_file()
		elseif action_id == "vimStudio_cut"
			call vimStudio#maskpanel_file#cut_file()
		elseif action_id == "vimStudio_paste"
			call vimStudio#maskpanel_file#paste_file()
		"----------------------------------------------------------------
		elseif action_id == "vimStudio_delete_file"
			call vimStudio#dialogs#delete_file()
		"----------------------------------------------------------------
		elseif action_id == "vimStudio_new_file"
			call vimStudio#dialogs#insert_new_file()
		elseif action_id == "vimStudio_ins_file"
			call vimStudio#dialogs#insert_file()
		elseif action_id == "vimStudio_ins_file_link"
			call vimStudio#dialogs#insert_link()
		elseif action_id == "vimStudio_ins_dir"
			call vimStudio#dialogs#insert_dir()
		elseif action_id == "vimStudio_ins_dir_link"
			call vimStudio#dialogs#insert_link_dir()
		"----------------------------------------------------------------
		elseif action_id == "vimStudio_insert_to_project"
			call vimStudio#dialogs#insert_curr_buf()
		"----------------------------------------------------------------
		elseif action_id == "vimStudio_search_text"
			call SimpleSearch#SearchNext()
		elseif action_id == "vimStudio_search_and_replace_text"
			call SimpleSearch#ReplaceAll()
		elseif action_id == "vimStudio_search_and_replace_in_files"
			call vimStudio#dialogs#search_and_replace_in_files()
		"----------------------------------------------------------------
		elseif action_id == "vimStudio_toogle_side_panel"
			call vimStudio#maskpanel#toogle()
		"----------------------------------------------------------------
		elseif action_id == "vimStudio_update_mask"
			call vimStudio#project#refresh()
		elseif action_id == "vimStudio_update_project"
			call vimStudio#project#update()
		elseif action_id == "vimStudio_project_settings"
			call vimStudio#project#open_settings()
		elseif action_id == "vimStudio_open_project"
			call vimStudio#dialogs#open_project()
		elseif action_id == "vimStudio_close_project"
			call vimStudio#project#close(1)
		elseif action_id == "vimStudio_new_project"
			let new_project_name = vimStudio#dialogs#choose_name("")
			call vimStudio#project#new(new_project_name)
		elseif action_id == "vimStudio_delete_project"
			call vimStudio#project#delete_path(g:vimStudio#buf#mask_bufname)
		endif
		"----------------------------------------------------------------
	endif
endfunction
