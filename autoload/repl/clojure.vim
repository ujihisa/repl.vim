scriptencoding utf-8

function! repl#clojure#open_repl() abort
  " Setting up the file for the current file
  if &modified
    " Create new file temporary
    let l:module_file = tempname() . '.clj'
    call writefile(getline(1, expand('$')), l:module_file)
  else
    let l:module_file = expand('%:p')
  endif

  let l:repl      = repl#get_filetype_repl('clojure')
  let l:exec_name = split(l:repl['repl'], ' ')[0]
  if !executable(l:exec_name)
    call repl#echo_error(printf("You don't have repl: '%s'", l:exec_name))
    return
  endif
  let l:args                 = printf('%s %s', l:repl['repl'], l:repl['opt'])
  let l:vimshell_interactive = ':VimShellInteractive' . printf("--split='%s'", g:repl_split_command)
  execute l:vimshell_interactive l:args
  let l:resize = ':resize 10'
  execute l:resize
  let l:nonum = ':set nonumber'
  execute l:nonum
  let l:swp = ':wincmd r'
  execute l:swp
  call vimshell#interactive#send(printf('(load-file "%s")', l:module_file))
endfunction
