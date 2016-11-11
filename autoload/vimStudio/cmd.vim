function! vimStudio#cmd#init_module()
endfunction

"--------------------------------------------------------------------------------------------------

command -nargs=0 -bar VrNew           : call vimStudio#dialogs#new_project()
command -nargs=0 -bar VrOpen          : call vimStudio#dialogs#open_project()
command -nargs=0 -bar VrDelete        : call vimStudio#dialogs#del_project()

command -nargs=0 -bar VrClean         : call vimStudio#project#clean()
command -nargs=0 -bar VrClose         : call vimStudio#project#close()
command -nargs=0 -bar VrRefresh       : call vimStudio#project#refresh()
command -nargs=0 -bar VrUpdate        : call vimStudio#project#update()

command -nargs=1 -bar VrRename        : call vimStudio#dialogs#rename()

command -nargs=0 -bar VrMask          : call vimStudio#maskpanel#toogle()

command -nargs=0 -bar VrOpenFile      : call vimStudio#maskpanel_file#open_file("")
command -nargs=0 -bar VrOpenFileT     : call vimStudio#maskpanel_file#open_file("T")
command -nargs=0 -bar VrOpenFileV     : call vimStudio#maskpanel_file#open_file("V")
command -nargs=0 -bar VrOpenFileH     : call vimStudio#maskpanel_file#open_file("H")

command -nargs=1 -bar VrNewFolder     : call vimStudio#maskpanel_file#new_folder("<args>")
command -nargs=1 -bar VrInsertLink    : call vimStudio#maskpanel_file#insert_link("<args>")
command -nargs=1 -bar VrInsertFile    : call vimStudio#maskpanel_file#insert_file("<args>")
command -nargs=1 -bar VrInsertLinkR   : call vimStudio#maskpanel_file#insert_linkR("<args>")
command -nargs=1 -bar VrInsertFileR   : call vimStudio#maskpanel_file#insert_fileR("<args>")
command -nargs=0 -bar VrDeleteFile    : call vimStudio#maskpanel_file#delete_file()
command -nargs=0 -bar VrDeleteFileF   : call vimStudio#maskpanel_file#delete_fileF()
command -nargs=1 -bar VrRenameFile    : call vimStudio#maskpanel_file#rename_file("<args>")
command -nargs=1 -bar VrCopyFileTo    : call vimStudio#maskpanel_file#copy_file_from_to(line(".") - 1, "<args>")
command -nargs=1 -bar VrMoveFileTo    : call vimStudio#maskpanel_file#move_file(line(".") - 1, "<args>")

command -nargs=0 -bar VrInsCurr       : call vimStudio#dialogs#insert_curr_buf()

command -nargs=0 -bar VrExec          : call vimStudio#maskpanel_file#exec()
command -nargs=0 -bar VrExecParentDir : call vimStudio#maskpanel_file#exec_parent_dir()
