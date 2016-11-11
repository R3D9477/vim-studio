let g:vimStudio#project#project_init_flag = 0

"--------------------------------------------------------------------------------------------------

function! vimStudio#project#init_module()
	let g:vimStudio#project#project_init_flag = 0
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#project#new(vimStudio_path, template)
	if fnamemodify(a:vimStudio_path, ":h") == "."
		let vimStudio_path = getcwd() . "/" . a:vimStudio_path
	else
		let vimStudio_path = a:vimStudio_path
	endif
	
	if fnamemodify(vimStudio_path, ":e") == ""
		let vimStudio_path .= ".visp"
	endif
	
	let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "create_project", ['"' . vimStudio_path . '"', '"' . a:template . '"'])
	
	if result == 1
		call vimStudio#project#open(vimStudio_path)
	endif
	
	return result
endfunction

function! vimStudio#project#set_cwd(vimStudio_path)
	let vimStudio_dir = fnamemodify(a:vimStudio_path, ":h")
	
	if vimStudio_dir != getcwd()
		execute "cd" fnameescape(vimStudio_dir)
	endif
endfunction

function! vimStudio#project#set_vimStudio_buffers(vimStudio_path)
	let result = 0
	
	if !empty(glob(a:vimStudio_path))
		let vimStudio_path = a:vimStudio_path
	elseif !empty(glob(getcwd() . "/" . a:vimStudio_path))
		let vimStudio_path = getcwd() . "/" . a:vimStudio_path
	elseif !empty(glob(getcwd() . "/" . a:vimStudio_path . ".visp"))
		let vimStudio_path = getcwd() . "/" . a:vimStudio_path . ".visp"
	endif
	
	if exists("vimStudio_path") == 1
		call vimStudio#project#set_cwd(vimStudio_path)
		let g:vimStudio#buf#mask_bufname = getcwd() . "/" . fnamemodify(vimStudio_path, ":t")
		
		let g:vimStudio#buf#conf_bufname = fnamemodify(g:vimStudio#buf#mask_bufname, ":r") . ".json"
		let g:vimStudio#buf#tree_bufname = fnamemodify(g:vimStudio#buf#mask_bufname, ":r") . ".tree"
		
		let result = 1
	else
		let g:vimStudio#buf#mask_bufname = ""
		let g:vimStudio#buf#conf_bufname = ""
		let g:vimStudio#buf#tree_bufname = ""
	endif
	
	return result
endfunction

function! vimStudio#project#open(vimStudio_path)
	if g:vimStudio#project#project_init_flag == 0
		call vimStudio#buf#init_module()
		call vimStudio#search#init_module()
		call vimStudio#wnd#init_module()
		call vimStudio#tabs#init_module()
		call vimStudio#maskpanel#init_module()
		call vimStudio#dialogs#init_module()
		call vimStudio#keymapping#init_module()
		
		if vimStudio#project#set_vimStudio_buffers(a:vimStudio_path) == 0
			return
		endif
		
		let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "open_project", ['"' . g:vimStudio#buf#mask_bufname . '"'])
		
		if result == 1
			if !empty(glob(g:vimStudio#buf#conf_bufname)) == 1 && !empty(glob(g:vimStudio#buf#tree_bufname))
				let g:vimStudio#project#project_init_flag = 1
				
				let continue_def_proc = vimStudio#integration#on_project_before_open()
				
				if continue_def_proc == 1
					let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "update_mask", ['"' . g:vimStudio#buf#mask_bufname . '"'])
					
					if result != 1
						return
					endif
					
					execute "badd" fnameescape(g:vimStudio#buf#mask_bufname)
					
					for rm_buf_num in range(1, bufnr("$"))
						if vimStudio#buf#is_editor(rm_buf_num) == 1
							execute "bdelete" rm_buf_num
							execute "bwipe" rm_buf_num
						endif
					endfor
					
					execute "badd" fnameescape(g:vimStudio#buf#conf_bufname)
					call vimStudio#project#open_settings()
					1tabc
					
					call vimStudio#maskpanel#show()
					
					call vimStudio#integration#on_project_after_open()
				endif
			else
				call vimStudio#project#close(0)
			endif
		endif
	endif
endfunction

function! vimStudio#project#delete_path(vimStudio_path)
	if len(g:vimStudio#buf#mask_bufname) > 0
		if g:vimStudio#buf#mask_bufname == a:vimStudio_path
			call vimStudio#project#close(1)
		endif
	endif
	
	call vimStudio#request(g:vimStudio#plugin_dir, "project", "delete_project", ['"' . a:vimStudio_path . '"'])
endfunction

function! vimStudio#project#delete(vimStudio_name)
	call vimStudio#project#delete_path(getcwd() . "/" . a:vimStudio_name . ".visp")
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#project#clean()
	if exists("g:vimStudio#project#mask_bufname_status") == 1
		let vimStudio_bar_status_orig = g:vimStudio#project#mask_bufname_status
		
		if g:vimStudio#project#mask_bufname_status == 1
			call vimStudio#project#hide_bar()
		endif
	endif
	
	let result = call vimStudio#request(g:vimStudio#plugin_dir, "project", "create_project", ['"' . g:vimStudio#buf#mask_bufname . '"'])
	
	if result == 1
		if exists("vimStudio_bar_status_orig") == 1
			if vimStudio_bar_status_orig == 1
				call vimStudio#project#show_bar()
			endif
			
			unlet vimStudio_bar_status_orig
		endif
	endif
endfunction

function! vimStudio#project#close(show_untitled_tab)
	if exists("g:vimStudio#project#project_init_flag") == 1
		if g:vimStudio#project#project_init_flag == 1
			let continue_def_proc = vimStudio#integration#on_before_project_close()
			
			if continue_def_proc == 1
				let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "close_project", ['"' . g:vimStudio#buf#mask_bufname . '"'])
				
				call vimStudio#project#init_module()
				call vimStudio#maskpanel#hide()
				
				for rm_tab_num in range(1, tabpagenr("$") - 1)
					execute "tabclose" rm_tab_num
				endfor
				
				if a:show_untitled_tab == 1
					call vimStudio#tabs#new_untitled_tab()
				endif
				
				for rm_buf_num in range(1, bufnr("#"))
					if bufname(rm_buf_num) != "Untitled" && bufname(rm_buf_num) != ""
						execute "bwipeout" rm_buf_num
					endif
				endfor
				
				q!
			endif
		endif
	endif
endfunction

function! vimStudio#project#rename(new_name)
	let g:vimStudio#project#is_busy = 1
	while tabpagenr("$") > 1
		tabc
	endwhile
	let g:vimStudio#project#is_busy = 0
	
	let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "rename_project", ['"' . g:vimStudio#buf#mask_bufname . '"', '"' . a:new_name . '"'])
	
	if result == 1
		let old_mask_bufname = g:vimStudio#buf#mask_bufname
		
		if vimStudio#project#set_vimStudio_buffers(a:new_name) == 1
			let continue_def_proc = vimStudio#integration#on_after_project_rename(old_mask_bufname)
			
			if continue_def_proc == 1
				call vimStudio#project#set_vimStudio_buffers(g:vimStudio#buf#mask_bufname)
				
				execute "badd" fnameescape(g:vimStudio#buf#mask_bufname)
				
				if vimStudio#wnd#switch_to_wnd(old_mask_bufname) == 1
					execute "buffer" fnameescape(g:vimStudio#buf#mask_bufname)
				endif
				
				execute "badd" fnameescape(g:vimStudio#buf#conf_bufname)
				
				if vimStudio#wnd#switch_to_wnd("editor") == 1
					execute "buffer" g:vimStudio#buf#conf_bufname
					call vimStudio#keymapping#set_editor_mapping()
				endif
				
				for rm_buf_num in range(1, bufnr("$"))
					if buflisted(rm_buf_num) == 1
						if vimStudio#buf#is_mask(rm_buf_num) != 1 && vimStudio#buf#is_conf(rm_buf_num) != 1 && bufname(rm_buf_num) != "vim-minimap"
							execute "bdelete" rm_buf_num
							execute "bwipe" rm_buf_num
						endif
					endif
				endfor
				
				call vimStudio#project#update()
				
				if vimStudio#wnd#switch_to_wnd("mask") == 1
					call vimStudio#keymapping#set_mask_mapping()
				endif
			endif
		else
			call vimStudio#project#close(0)
		endif
	endif
	
	return result
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#project#update()
	let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "update_project", ['"' . g:vimStudio#buf#mask_bufname . '"'])
	
	if result == 1
		let continue_def_proc = vimStudio#integration#on_after_update_project()
		
		if continue_def_proc == 1
			call vimStudio#maskpanel#refresh()
		endif
	endif
	
	return result
endfunction

function! vimStudio#project#refresh()
	let result = vimStudio#request(g:vimStudio#plugin_dir, "project", "update_mask", ['"' . g:vimStudio#buf#mask_bufname . '"'])
	
	if result == 1
		let continue_def_proc = vimStudio#integration#on_after_update_mask()
		
		if continue_def_proc == 1
			call vimStudio#maskpanel#refresh()
		endif
	endif
	
	return result
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#project#open_settings()
	execute "tabe" fnameescape(g:vimStudio#buf#conf_bufname)
	call vimStudio#keymapping#set_editor_mapping()
endfunction
