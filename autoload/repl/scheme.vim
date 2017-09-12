scriptencoding utf-8

function! repl#scheme#open_repl() abort
  if &modified
    let l:module_file = tempname() . '.rkt'
    call writefile(getline(1, expand('$')), l:module_file)
  else
    let l:module_file = expand('%:p')
  endif

  let l:repl      = repl#get_filetype_repl('scheme')
  let l:exec_name = split(l:repl['repl'], ' ')[0]
  if !executable(l:exec_name)
    call repl#echo_error(printf("You don't have repl: '%s'", l:exec_name))
    return
  endif
  let l:args                 = printf('%s -f %s %s', l:repl['repl'], l:module_file, l:repl['opt'])
  let l:vimshell_interactive = ':VimShellInteractive' . printf("--split='%s'", g:repl_split_command)
  execute l:vimshell_interactive l:args
  let l:resize = ':resize 10'
  execute l:resize
endfunction

