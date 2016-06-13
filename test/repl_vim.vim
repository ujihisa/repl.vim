let s:suite = themis#suite('repl_vim')

function! s:suite.after_each()
  call ResetVariables()
endfunction

"-------------------"

function! s:suite.do_not_throw_exception_when_open_repl()
  " repl.vim can open repl
  setfiletype ruby       | Repl | new
  setfiletype haskell    | Repl | new
  setfiletype erlang     | Repl | new
  setfiletype python     | Repl | new
  setfiletype javascript | Repl | new
  setfiletype clojure    | Repl | new
  setfiletype idris      | Repl | new
  " repl.vim cannot open repl
  " but repl.vim don't throw some exception
  setfiletype unknown | Repl
endfunction
