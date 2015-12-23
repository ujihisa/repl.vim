let s:suite  = themis#suite('variable')
let s:assert = themis#helper('assert')

function! s:suite.after_each()
  call UnletReplUserVariables()
endfunction

"-------------------"

function! s:suite.g_repl_filetype_repl_is_valid()
  let l:TARGET_FILETYPE = 'ruby' | lockvar l:TARGET_FILETYPE

  " Default value
  let l:DEFAULT_REPL_NAME = g:repl#default_filetype_repl[l:TARGET_FILETYPE]['repl'] | lockvar l:DEFAULT_REPL_NAME
  let l:DEFAULT_REPL_OPT  = g:repl#default_filetype_repl[l:TARGET_FILETYPE]['opt']  | lockvar l:DEFAULT_REPL_OPT
  let l:filetype_repl     = repl#get_filetype_repl(l:TARGET_FILETYPE)
  call s:assert.equals(l:filetype_repl['repl'], l:DEFAULT_REPL_NAME)
  call s:assert.equals(l:filetype_repl['opt'], l:DEFAULT_REPL_OPT)

  " Not a default value
  let l:REPL_NAME = 'dummy'   | lockvar l:REPL_NAME
  let l:REPL_OPT  = '--dummy' | lockvar l:REPL_OPT
  let g:repl_filetype_repl = {
  \ l:TARGET_FILETYPE : {
  \   'repl' : l:REPL_NAME,
  \   'opt'  : l:REPL_OPT
  \ }
  \}
  let l:filetype_repl = repl#get_filetype_repl(l:TARGET_FILETYPE)
  call s:assert.equals(l:filetype_repl['repl'], l:REPL_NAME)
  call s:assert.equals(l:filetype_repl['opt'], l:REPL_OPT)
endfunction
