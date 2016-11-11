let g:vimStudio#search#search_results_count = 0

"--------------------------------------------------------------------------------------------------

function! vimStudio#search#init_module()
	let g:vimStudio#search#search_results_count = 0
endfunction

"--------------------------------------------------------------------------------------------------

function! vimStudio#search#search_and_replace_in_files(find_struct_str)
	if fnamemodify(bufname("%"), ":p") == g:vimStudio#buf#mask_bufname
		let fnd_res_str = vimStudio#request(g:vimStudio#plugin_dir, "project", "search_text_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', line(".") - 1, '"' . a:find_struct_str . '"'])
	else
		let fnd_res_str = 0
	endif
	
	if fnd_res_str != "0"
		e
		let fnd_res = split(fnd_res_str, "|")
		
		if len(fnd_res) > 0
			let g:vimStudio#search#search_results_count += 1
			
			let sr_buf_name = "SearchResults(" . g:vimStudio#search#search_results_count . ")"
			
			execute "tabe"
			execute "badd" fnameescape(sr_buf_name)
			execute "buffer" fnameescape(sr_buf_name)
			
			call vimStudio#keymapping#set_search_mapping()
			
			setlocal buftype=nofile
			setlocal nowrap
			setlocal nonumber
			setlocal modifiable
			
			1,$delete
			
			let fnd_i = 0
			while fnd_i < len(fnd_res)
				if fnd_i > 0
					call append(line("$"), "")
				endif
				
				call append(line("$"), (fnd_i + 1) . ")")
				
				let fnd_info_arr = split(fnd_res[fnd_i], ":")
				let fnd_pos_arr = split(fnd_info_arr[1], ",")
				
				for fnd_pos in fnd_pos_arr
					call append(line("$"), "	" . fnd_info_arr[0] . ":" . fnd_pos)
				endfor
				
				let fnd_i += 1
			endwhile
			
			1delete
			
			setlocal nomodified
			setlocal nomodifiable
		endif
	endif
endfunction

function! vimStudio#search#search_open_file()
	let sch_info = split(getline("."), ":")
	
	if len(sch_info) < 2
		return
	endif
	
	let sch_path = substitute(sch_info[0], '^\s*\(.\{-}\)\s*$', '\1', '')
	execute "tabe" fnameescape(sch_path)
	
	let sch_row = 1
	let sch_col = sch_info[1] + 1
	
	while sch_row < line("$")
		let curr_row_len = len(getline(sch_row))
		
		if curr_row_len > sch_col
			break
		endif
		
		let sch_row += 1
		let sch_col -= curr_row_len + 1
	endwhile
	
	call cursor(sch_row, sch_col)
endfunction
