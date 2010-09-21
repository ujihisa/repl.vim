function! Repl()
  if &filetype == 'ruby'
    call ReplRuby()
  elseif &filetype == 'haskell'
    call ReplHaskell()
  endif
endfunction

function! ReplRuby()
  let l:tmpfile = tempname() . '.rb'
  call writefile(getline(1, expand('$')), l:tmpfile, 'b')
  let l:args = 'irb --simple-prompt -r ' . l:tmpfile
  call vimshell#execute_internal_command(
        \ 'iexe', vimproc#parser#split_args(l:args), { 'stdin' : '', 'stdout' : '', 'stderr' : '' },
        \ { 'is_interactive' : 0, 'is_single_command' : 1 })
  let b:interactive.close_immediately = 1
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
  let b:interactive.close_immediately = 1
endfunction


command! -nargs=0 Repl call Repl()
nnoremap <Space>i :<C-u>Repl<Cr>
