scriptencoding utf-8
if exists('g:loaded_repl_vim')
  finish
endif
let g:loaded_repl_vim = 1
let s:save_cpo = &cpo
set cpo&vim
"-------------------"

" If didn't define g:repl_filetype_repl, repl.vim use this
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
\ },
\ 'javascript' : {
\   'repl' : 'node',
\   'opt'  : '-i'
\ },
\ 'clojure' : {
\   'repl' : 'lein',
\   'opt'  : 'repl'
\ },
\ 'idris' : {
\   'repl' : 'idris',
\   'opt'  : ''
\ },
\ 'scheme' : {
\   'repl' : 'racket',
\   'opt' : '-i'
\ },
\ 'prolog' : {
\   'repl' : 'swipl',
\   'opt' : ''
\ }
\}

" 'split' or 'vertical split'
let g:repl_split_command = get(g:, 'repl_split_command', 'split')

command! -bar -nargs=0 Repl call repl#run_repl()
nnoremap <silent> <Plug>(repl-run) :<C-u>call repl#run_repl()<CR>

"-------------------"

" Define default keymappings
function! s:define_default_keymappings()
  if !exists('g:repl_no_default_keymappings') || !g:repl_no_default_keymappings
    nmap <space>i <Plug>(repl-run)
  endif
endfunction
call s:define_default_keymappings()

"-------------------"
let &cpo = s:save_cpo
unlet s:save_cpo
