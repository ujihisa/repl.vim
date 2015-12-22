let s:suite  = themis#suite('can_open')

function! s:suite.after_each()
  call UnletReplUserVariables()
endfunction

"-------------------"

function! s:suite.some_repl()
  " repl.vim can open repl
  setfiletype ruby | Repl
  new | setfiletype haskell | Repl
  new | setfiletype erlang  | Repl
  new | setfiletype python  | Repl
  " repl.vim cannot open repl
  " but repl.vim don't throw some exception
  new | setfiletype unknown | Repl
endfunction

function! s:suite.some_repl_with_split_command()
  let g:repl_split_command = 'vertical split'
  call s:suite.some_repl()
endfunction
