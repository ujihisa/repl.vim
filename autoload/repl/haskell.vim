scriptencoding utf-8

function! repl#haskell#open_repl() abort
  " Setting up the file for the current file
  if &modified
    " Create new file temporary
    let l:module_file = tempname() . '.hs'
    call writefile(getline(1, expand('$')), l:module_file)
  else
    let l:module_file = expand('%:p')
  endif

  let l:repl = get(g:, 'repl_filetype_repl.haskell.repl', g:repl#default_filetype_repl.haskell['repl'])
  let l:opt  = get(g:, 'repl_filetype_repl.haskell.opt', g:repl#default_filetype_repl.haskell['opt'])
  if !executable(l:repl)
    call repl#echo_error(printf("You don't have repl: '%s'", l:repl))
    return
  endif
  let l:args                 = printf('%s %s %s', l:repl, l:opt, l:module_file)
  let l:vimshell_interactive = ':VimShellInteractive' . printf("--split='%s'", g:repl_split_command)
  execute l:vimshell_interactive l:args
endfunction
