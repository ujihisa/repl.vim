scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim
"-------------------"

function! repl#echo_error(msg) abort
  echohl Error
  echomsg a:msg
  echohl None
endfunction

function! repl#run_repl() abort
  if &filetype ==# 'ruby'
    call repl#ruby#open_repl()
  elseif &filetype ==# 'haskell'
    call repl#haskell#open_repl()
  elseif &filetype ==# 'erlang'
    call repl#erlang#open_repl()
  elseif &filetype ==# 'python'
    call repl#python#open_repl()
  else
    call repl#echo_error("Sorry, repl.vim didn't support this filetype")
  endif
endfunction

"-------------------"
let &cpo = s:save_cpo
unlet s:save_cpo
