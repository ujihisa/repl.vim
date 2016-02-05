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
  elseif &filetype ==# 'javascript'
    call repl#javascript#open_repl()
  else
    call repl#echo_error("Sorry, repl.vim didn't support this filetype")
  endif
endfunction

" Example:
" if you didn't set g:repl_filetype_repl
"     echo repl#get_filetype_repl('python')
" => {'repl': 'python', 'opt': '-i'}
function! repl#get_filetype_repl(filetype) abort
  if !exists('g:repl_filetype_repl')
    return g:repl#default_filetype_repl[a:filetype]
  endif
  let l:filetype_repl = deepcopy(g:repl#default_filetype_repl)
  call extend(l:filetype_repl, g:repl_filetype_repl)
  return l:filetype_repl[a:filetype]
endfunction

"-------------------"
let &cpo = s:save_cpo
unlet s:save_cpo
