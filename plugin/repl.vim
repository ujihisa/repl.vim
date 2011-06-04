function! Repl()
  if &filetype == 'ruby'
    call ReplRuby()
  elseif &filetype == 'haskell'
    call ReplHaskell()
  elseif &filetype == 'erlang'
    call ReplErlang()
  elseif &filetype == 'python'
    call ReplPython()
  elseif &filetype == 'scala'
    call ReplScala()
  endif
endfunction

function! ReplRuby()
  let l:contents = getline(0, expand('$'))
  let l:args = 'irb --simple-prompt'
  call vimshell#execute_internal_command(
        \ 'iexe', vimproc#parser#split_args(l:args), { 'stdin' : '', 'stdout' : '', 'stderr' : '' },
        \ { 'is_interactive' : 0, 'is_single_command' : 1 })
  let b:interactive.is_close_immediately = 1
  for l:line in l:contents
    call vimshell#interactive#send_string(l:line . "\n")
  endfor
endfunction

function! ReplHaskell()
  let l:tmpfile = tempname() . '.hs'
  let l:tmpobj = tempname() . '.o'
  call writefile(getline(1, expand('$')), l:tmpfile, 'b')
  call vimproc#system('ghc ' . l:tmpfile . ' -o ' . l:tmpobj)
  let l:args = 'ghci ' . l:tmpfile
  call vimshell#execute_internal_command(
        \ 'iexe', vimproc#parser#split_args(l:args), { 'stdin' : '', 'stdout' : '', 'stderr' : '' },
        \ { 'is_interactive' : 0, 'is_single_command' : 1 })
  let b:interactive.is_close_immediately = 1
endfunction

function! ReplErlang()
  " FIXME: this function messes current directly with a .bean file.
  let l:modulename = get(matchlist(join(getline(1, line('$'))), '-module(\(.\{-}\))\.'), 1, "ujihisa")
  let l:tmppath = substitute(tempname(), "[^/]*$", l:modulename, '')
  let l:tmpfile = l:tmppath . '.erl'
  "let l:tmpobj = tempname() . '.o'
  call writefile(getline(1, expand('$')), l:tmpfile, 'b')
  "call vimproc#system('ghc ' . l:tmpfile . ' -o ' . l:tmpobj)
  let l:args = 'erl'
  call vimshell#execute_internal_command(
        \ 'iexe', vimproc#parser#split_args(l:args), { 'stdin' : '', 'stdout' : '', 'stderr' : '' },
        \ { 'is_interactive' : 0, 'is_single_command' : 1 })
  let b:interactive.is_close_immediately = 1
  call vimshell#interactive#send_string(printf("c('%s').\n", l:tmppath))
endfunction

function! ReplPython()
  let l:currentFile = expand('%:r') " current file without the extension
  let l:args = 'python -'
  call vimshell#execute_internal_command(
      \ 'iexe', vimproc#parser#split_args(l:args), { 'stdin': '', 'stdout': '', 'stderr': '' },
      \ { 'is_interactive' : 0, 'is_single_command' : 1 })
  let b:interactive.is_close_immediately = 1
  call vimshell#interactive#send_string("from " . l:currentFile . " import *\n")
endfunction

function! ReplScala()
  let l:currentFile = expand('%') 
  let l:args = 'scala -i ' . l:currentFile
  call vimshell#execute_internal_command(
        \ 'iexe', vimproc#parser#split_args(l:args), { 'stdin' : '', 'stdout' : '', 'stderr' : '' },
        \ { 'is_interactive' : 0, 'is_single_command' : 1 })
  let b:interactive.is_close_immediately = 1
endfunction
  
command! -nargs=0 Repl call Repl()
nnoremap <Space>i :<C-u>Repl<Cr>
