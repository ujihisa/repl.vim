let s:suite  = themis#suite('variable')
let s:assert = themis#helper('assert')
let s:scope  = themis#helper('scope')

function! s:suite.after_each()
  call ResetVariables()
endfunction

"-------------------"

function! s:suite.g_repl_default_filetype_repl_is_valid()
  let l:TARGET_FILETYPE = 'ruby' | lockvar l:TARGET_FILETYPE

  " Default value
  let l:DEFAULT_REPL_NAME = g:repl#default_filetype_repl[l:TARGET_FILETYPE]['repl'] | lockvar l:DEFAULT_REPL_NAME
  let l:DEFAULT_REPL_OPT  = g:repl#default_filetype_repl[l:TARGET_FILETYPE]['opt']  | lockvar l:DEFAULT_REPL_OPT
  let l:filetype_repl     = repl#get_filetype_repl(l:TARGET_FILETYPE)
  call s:assert.equals(l:filetype_repl['repl'], l:DEFAULT_REPL_NAME)
  call s:assert.equals(l:filetype_repl['opt'], l:DEFAULT_REPL_OPT)
endfunction

function! s:suite.g_repl_filetype_repl_is_valid()
  let l:TARGET_FILETYPE = 'ruby' | lockvar l:TARGET_FILETYPE
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

  " and Default value
  let l:ANOTHER_TARGET_FILETYPE = 'python' | lockvar l:ANOTHER_TARGET_FILETYPE
  let l:default_repl_name = g:repl#default_filetype_repl[l:ANOTHER_TARGET_FILETYPE].repl
  let l:default_repl_opt  = g:repl#default_filetype_repl[l:ANOTHER_TARGET_FILETYPE].opt
  let l:filetype_repl     = repl#get_filetype_repl(l:ANOTHER_TARGET_FILETYPE)
  call s:assert.equals(l:filetype_repl['repl'], l:default_repl_name)
  call s:assert.equals(l:filetype_repl['opt'], l:default_repl_opt)
endfunction

"function! s:suite.g_repl_no_default_keymappings_is_valid_if_disabled()
"  " Case: g:repl_no_default_keymappings is undefined
"  let s:funcs = s:scope.funcs('plugin/repl.vim')
"  call s:funcs.define_default_keymappings()
"  call s:assert.true(hasmapto("\i", 'n'))
"  nunmap <leader>i
"endfunction
"
"function! s:suite.g_repl_no_default_keymappings_is_valid_if_enabled()
"  " Case: g:repl_no_default_keymappings is defined to 1
"  let g:repl_no_default_keymappings = 1
"  let s:funcs = s:scope.funcs('plugin/repl.vim')
"  call s:funcs.define_default_keymappings()
"  call s:assert.false(hasmapto("\i", 'n'))
"endfunction
