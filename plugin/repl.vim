"TODO: Branch python2 and python3
"TODO: DRY

let g:repl#default_filetype_repl = get(g:, 'repl_filetype_repl', {
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
\ }
\})

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
    echohl Error
    echo "Sorry, repl.vim didn't support this filetype"
    echohl None
    "call ReplScala()
  elseif &filetype == 'clojure'
    echohl Error
    echo "Sorry, repl.vim didn't support this filetype"
    echohl None
    "call ReplClojure()
  endif
endfunction

"function! s:CallVimShell(args)
"  execute ':VimShellInteractive' a:args
"endfunction

function! ReplRuby()
  " Setting up the obj file for the current file
  if &modified
    let l:module_file = tempname() . '.rb'
    call writefile(getline(1, expand('$')), l:module_file)
  else
    let l:module_file = expand('%:p')
  endif

  let l:repl = exists('g:repl_filetype_repl.ruby') ? g:repl_filetype_repl.ruby['repl']
  \                                                : g:repl#default_filetype_repl.ruby['repl']
  let l:opt  = exists('g:repl_filetype_repl.ruby') ? g:repl_filetype_repl.ruby['opt']
  \                                                : g:repl#default_filetype_repl.ruby['opt']
  let l:args = printf('%s %s %s', l:repl, l:opt, l:module_file)
  execute ':VimShellInteractive' l:args
endfunction

function! ReplHaskell()
  " Setting up the file for the current file
  if &modified
    " Create new file temporary
    let l:module_file = tempname() . '.hs'
    call writefile(getline(1, expand('$')), l:module_file)
  else
    let l:module_file = expand('%:p')
  endif

  let l:repl = exists('g:repl_filetype_repl.haskell') ? g:repl_filetype_repl.haskell['repl']
  \                                                   : g:repl#default_filetype_repl.haskell['repl']
  let l:opt  = exists('g:repl_filetype_repl.haskell') ? g:repl_filetype_repl.haskell['opt']
  \                                                   : g:repl#default_filetype_repl.haskell['opt']
  let l:args = printf('%s %s %s', l:repl, l:opt, l:module_file)
  execute ':VimShellInteractive' l:args
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
  call vimshell#interactive#send_string(printf("c('%s').\n", l:tmppath), 1)
endfunction

function! ReplPython()
  " Setting up the file for the current file
  if &modified
    " Create new file temporary
    let l:module_file = tempname() . '.py'
    call writefile(getline(1, expand('$')), l:module_file)
  else
    let l:module_file = expand('%:p')
  endif

  let l:repl = exists('g:repl_filetype_repl.python') ? g:repl_filetype_repl.python['repl']
  \                                                  : g:repl#default_filetype_repl.python['repl']
  let l:opt  = exists('g:repl_filetype_repl.python') ? g:repl_filetype_repl.python['opt']
  \                                                  : g:repl#default_filetype_repl.python['opt']
  let l:args = printf('%s %s %s', l:repl, l:opt, l:module_file)
  execute ':VimShellInteractive' l:args
endfunction

"function! ReplScala()
"  let l:currentFile = expand('%') 
"  let l:args = 'scala -i ' . l:currentFile
"  call s:CallVimShell(l:args)
"endfunction
"
"function! ReplClojure()
"  let l:currentFile = expand('%') 
"  let l:args = 'clj -i ' . l:currentFile . ' -r'
"  call s:CallVimShell(l:args)
"endfunction
  
command! -nargs=0 Repl call Repl()
nnoremap <Plug>(repl-run) :<C-u>Repl<Cr>
