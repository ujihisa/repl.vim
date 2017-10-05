scriptencoding utf-8
"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"

function! s:writefile_with_erlang_module(lines, filepath) abort
  let l:module_defined_line = match(a:lines, '-module')
  if l:module_defined_line is -1
    throw "REPL_VIM: repl.vim couldn't -module difinition !"
  endif
  let a:lines[l:module_defined_line] = printf('-module(%s).', fnamemodify(a:filepath, ':t:r'))
  call writefile(a:lines, a:filepath)
endfunction

"#--- --- ---#"

function! repl#erlang#open_repl() abort
  " FIXME: this function messes current directly with a .bean file.
  let l:pwd = getcwd()

  " Setting up the file for the current file
  if &modified
    " Create new file temporary
    " -module don't allow module name number start
    let l:tempname    = tempname()
    let l:filename    = 't' . fnamemodify(l:tempname, ':t') . '.erl'
    let l:dirpath     = fnamemodify(l:tempname, ':h')
    let l:module_file = l:dirpath . '/' . l:filename
    try
      call s:writefile_with_erlang_module(getline(1, expand('$')), l:module_file)
    catch /^REPL_VIM/
      call repl#echo_error('REPL_VIM: fatal error')
      call repl#echo_error(v:exception)
      return
    endtry
    " Change current directory temporary
    execute 'cd' l:dirpath
  else
    let l:module_file = expand('%:p')
    " Change current directory temporary
    cd %:p:h
  endif

  let l:repl      = repl#get_filetype_repl('erlang')
  let l:exec_name = split(l:repl['repl'], ' ')[0]
  if !executable(l:exec_name)
    call repl#echo_error(printf("You don't have repl: '%s'", l:exec_name))
    return
  endif
  let l:args                 = printf('%s %s %s', l:repl['repl'], l:repl['opt'], l:module_file)
  let l:vimshell_interactive = ':VimShellInteractive' . printf("--split='%s'", g:repl_split_command)

  execute l:vimshell_interactive l:args
  call vimshell#interactive#send(printf('c(%s).', fnamemodify(l:module_file, ':t:r')))
  execute 'cd' l:pwd
endfunction
