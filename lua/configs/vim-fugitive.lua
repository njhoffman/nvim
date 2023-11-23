local cmd = {
  'GBrowse',
  'GDelete',
  'GMove',
  'GRemove',
  'GRename',
  'Gblame',
  'Gdiff',
  'Gdiffsplit',
  'Gedit',
  'Gfetch',
  'Ggrep',
  'Git',
  'Glgrep',
  'Gpull',
  'Gpush',
  'Gread',
  'Gsplit',
  'Gstatus',
  'Gvdiffsplit',
  'Gwrite',
}

-- function! ChangeDirectoryCustom(dir_path)
--     let before_dir= getcwd()
--     execute 'cd '.fnameescape(a:dir_path)
--     let after_dir= getcwd()
--     if before_dir !=# after_dir
--         " place custom current directory changed event handler code here
--         " Make vim-fugitive use the new current directory repository if there is no current file
--         let current_file_name= expand('%')
--         if current_file_name == ''
--             if exists('b:git_dir')
--                 unlet b:git_dir
--             endif
--             call FugitiveDetect(getcwd())
--         endif
--     endif
-- endfunction
-- call FugitiveDetect(getcwd())
