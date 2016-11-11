let g:vimStudio#plugin_dir = expand("<sfile>:p:h:h")

function! vimStudio#request(plugin_dir, group, cmd, args)
	let node_expr = "neko '" . a:plugin_dir . "/sys/VimStudioClient.n' '" . a:group . "' '" . a:cmd . "'"
	
	let arg_i = 0
	while arg_i < len(a:args)
		let node_expr .= " " . a:args[arg_i]
		let arg_i += 1
	endwhile
	
	return system(node_expr)
endfunction
