"call vimproc#system_bg(["neko", g:vimStudio#plugin_dir . "/module.hx/VimStudioServer.n"])
"autocmd VimLeave ?* :call vimStudio#request(g:vimStudio#plugin_dir, "server", "shutdown", ["'" . g:vimStudio#buf#mask_bufname . "'"])

if exists("g:vimStudio#project#project_init_flag")
	if g:vimStudio#project#project_init_flag == 1
		finish
	endif
endif

call vimStudio#project#open(bufname("%"))
