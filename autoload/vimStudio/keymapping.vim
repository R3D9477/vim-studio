function! vimStudio#keymapping#init_module()
	noremap <silent> <C-n> <esc>:call vimStudio#dialogs#new_project()<CR>
	noremap <silent> <C-p> <esc>:call vimStudio#dialogs#open_project<CR>
	
	noremap <silent> <F4> <esc>:call vimStudio#maskpanel#toogle()<CR>
	
	noremap <silent> <F6> <esc>:call vimStudio#project#make()<CR>
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#keymapping#set_mask_mapping()
	if vimStudio#wnd#switch_to_wnd("mask") == 1
		map <buffer><silent> o :call vimStudio#maskpanel#fold_or_open("T")<CR>
		map <buffer><silent> <2-LeftMouse> :call vimStudio#maskpanel#fold_or_open("T")<CR>
		map <buffer><silent> O :call vimStudio#maskpanel#fold_or_open("")<CR>
		map <buffer><silent> v :call vimStudio#maskpanel#fold_or_open("V")<CR>
		map <buffer><silent> h :call vimStudio#maskpanel#fold_or_open("H")<CR>
		map <buffer><silent> <CR> :call vimStudio#maskpanel#fold_or_open("T")<CR>
		
		map <buffer><silent> <del> :call vimStudio#dialogs#delete_file()<CR>
		
		map <buffer><silent> nd :call vimStudio#dialogs#insert_new_folder()<CR>
		map <buffer><silent> nf :call vimStudio#dialogs#insert_new_file()<CR>
		
		map <buffer><silent> f :call vimStudio#dialogs#insert_file()<CR>
		map <buffer><silent> F :call vimStudio#dialogs#insert_link()<CR>
		map <buffer><silent> d :call vimStudio#dialogs#insert_dir()<CR>
		map <buffer><silent> D :call vimStudio#dialogs#insert_link_dir()<CR>
		map <buffer><silent> t :call vimStudio#dialogs#insert_dirR()<CR>
		map <buffer><silent> T :call vimStudio#dialogs#insert_link_dirR()<CR>
		
		map <buffer><silent> e :call vimStudio#maskpanel_file#exec()<CR>
		map <buffer><silent> p :call vimStudio#maskpanel_file#exec_parent_dir()<CR>
		
		map <buffer><silent> <F2> :call vimStudio#dialogs#rename()<CR>
		
		map <buffer><silent> <F5> :call vimStudio#project#refresh()<CR>
		map <buffer><silent> <C-F5> :call vimStudio#project#update()<CR>
		
		map <buffer><silent> <C-h> :call vimStudio#dialogs#search_and_replace_in_files()<CR>
		
		map <buffer><silent> m :call vimStudio#dialogs#context_menu("normal", "mask")<CR>
		map <buffer><silent> <RightMouse> <LeftMouse>:call vimStudio#dialogs#context_menu("normal", "mask")<CR>
		
		map <buffer><silent> <C-c> :call vimStudio#maskpanel_file#copy_file()<CR>
		map <buffer><silent> <C-x> :call vimStudio#maskpanel_file#cut_file()<CR>
		map <buffer><silent> <C-v> :call vimStudio#maskpanel_file#paste_file()<CR>
		
		map <buffer><silent> s :call vimStudio#project#open_settings()<CR>
		
		map <buffer><silent> - :call vimStudio#maskpanel#width_minus_minus()<CR>
		map <buffer><silent> = :call vimStudio#maskpanel#width_plus_plus()<CR>
	endif
endfunction

function! vimStudio#keymapping#set_editor_mapping()
	let curr_buf_num = bufnr("%")
	
	if vimStudio#buf#is_editor(curr_buf_num) == 1
		map  <buffer><silent> <2-LeftMouse> i
		
		vmap <buffer><silent> <RightMouse> :call vimStudio#dialogs#context_menu("visual", "editor_v")<CR>
		nmap <buffer><silent> <RightMouse> :call vimStudio#dialogs#context_menu("normal", "editor_ni")<CR>
		imap <buffer><silent> <RightMouse> <esc>:call vimStudio#dialogs#context_menu("normal", "editor_ni")<CR>i
	endif
endfunction

function! vimStudio#keymapping#set_search_mapping()
	map <buffer><silent> <CR> :call vimStudio#search#search_open_file()<CR>
	map <buffer><silent> <2-LeftMouse> <CR>
endfunction
