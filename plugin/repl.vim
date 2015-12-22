scriptencoding utf-8
if exists('g:loaded_repl_vim')
  finish
endif
let g:loaded_repl_vim = 1
let s:save_cpo = &cpo
set cpo&vim
"#--- --- ---#"

let g:repl#default_filetype_repl = {
\ 'haskell' : {
\   'repl' : 'ghci',
\   'opt'  : ''
\ },
\ 'ruby' : {
\   'repl' : 'irb',
\   'opt'  : '--simple-prompt -r'
\ },
\ 'python' : {
\   'repl' : 'python',
\   'opt'  : '-i'
\ },
\ 'erlang' : {
\   'repl' : 'erl',
\   'opt'  : ''
\ }
\}

command! -bar -nargs=0 Repl call repl#run_repl()
nnoremap <silent> <Plug>(repl-run) :<C-u>call repl#run_repl()<CR>

"-------------------"
let &cpo = s:save_cpo
unlet s:save_cpo
