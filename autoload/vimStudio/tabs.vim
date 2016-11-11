let g:tab_count = 0
let g:tab_changed = 0
let g:curr_wnd_count = 1

"--------------------------------------------------------------------------------------------------

function! vimStudio#tabs#init_module()
	let g:tab_count = 0
	let g:tab_changed = 0
	let g:curr_wnd_count = 1
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#tabs#new_untitled_tab()
	tabe
	new "Untitled"
	buffer "Untitled"
endfunction

function! vimStudio#tabs#check_current_tab()
	if g:curr_wnd_count != winnr("$")
		if g:curr_wnd_count > winnr("$")
			let curr_wnd_num = winnr()
			if vimStudio#integration#on_check_current_tab() == 1 || vimStudio#wnd#switch_to_wnd("editor") == 1
				call vimStudio#maskpanel#set_default_width()
				
				if g:vimStudio#maskpanel#mask_bufname_status == 1
					if vimStudio#wnd#switch_to_wnd("mask") == 0
						call vimStudio#maskpanel#show()
					endif
				endif
				
				call vimStudio#integration#on_after_check_current_tab()
			else
				if tabpagenr("$") > 1
					tabc
				else
					call vimStudio#project#close(0)
				endif
			endif
		endif
		
		let g:curr_wnd_count = winnr("$")
	endif
endfunction

"--------------------------------------------------------------------------------------------------

autocmd TabLeave ?* :if g:vimStudio#project#project_init_flag == 1 | call vimStudio#integration#on_tab_leave() | endif

function! vimStudio#tabs#on_tab_changed()
	let continue_def_proc = vimStudio#integration#on_tab_changed()
	
	if continue_def_proc == 1
		call vimStudio#maskpanel#reload()
		
		call vimStudio#wnd#switch_to_wnd("editor")
		let g:curr_wnd_count = winnr("$")
	endif
	
	let g:tab_count = tabpagenr("$")
endfunction

function! vimStudio#tabs#on_tab_enter()
	let g:tab_changed = 1
	
	if g:tab_count >= tabpagenr("$")
		call vimStudio#tabs#on_tab_changed()
	endif
endfunction

autocmd TabEnter ?* :if g:vimStudio#project#project_init_flag == 1 | call vimStudio#tabs#on_tab_enter() | endif

function! vimStudio#tabs#on_buf_enter()
	if g:tab_changed == 1 && g:tab_count < tabpagenr("$")
		let g:tab_count = tabpagenr("$")
		call vimStudio#tabs#on_tab_changed()
	elseif g:tab_changed == 0
		call vimStudio#tabs#check_current_tab()
		call vimStudio#integration#on_buf_enter()
	endif
	
	let g:tab_changed = 0
endfunction

autocmd BufEnter ?* :if g:vimStudio#project#project_init_flag == 1 | if vimStudio#wnd#previewWindowOpened() == 0 | call vimStudio#tabs#on_buf_enter() | endif | endif
