scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim
"-------------------"
"
"TODO: Branch python2 and python3
"TODO: DRY

function! s:sorry()
  echohl Error
  echo "Sorry, repl.vim didn't support this filetype"
  echohl None
endfunction

"function! s:CallVimShell(args)
"  execute ':VimShellInteractive' a:args
"endfunction

"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"

function! repl#run_repl()
  if &filetype ==# 'ruby'
    call repl#start_ruby()
  elseif &filetype ==# 'haskell'
    call repl#start_haskell()
  elseif &filetype ==# 'erlang'
    call repl#start_erlang()
  elseif &filetype ==# 'python'
    call repl#start_python()
  elseif &filetype ==# 'scala'
    call s:sorry()
    "call ReplScala()
  elseif &filetype ==# 'clojure'
    call s:sorry()
    "call ReplClojure()
  else
    call s:sorry()
  endif
endfunction

"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"

function! repl#start_ruby()
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

function! repl#start_haskell()
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

function! repl#start_python()
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


function! repl#start_erlang()
  " FIXME: this function messes current directly with a .bean file.
  " Setting up the file for the current file
  if &modified
    " Create new file temporary
    let l:module_file = tempname() . '.erl'
    call writefile(getline(1, expand('$')), l:module_file)
  else
    let l:module_file = expand('%:p')
  endif

  let l:repl = exists('g:repl_filetype_repl.erlang') ? g:repl_filetype_repl.erlang['repl']
  \                                                  : g:repl#default_filetype_repl.erlang['repl']
  let l:opt  = exists('g:repl_filetype_repl.erlang') ? g:repl_filetype_repl.erlang['opt']
  \                                                  : g:repl#default_filetype_repl.erlang['opt']
  let l:args = printf('%s %s %s', l:repl, l:opt, l:module_file)

  " Change current directory temporary
  let l:pwd = getcwd()
  cd %:p:h
  execute ':VimShellInteractive' l:args
  call vimshell#interactive#send(printf('c(%s).', fnamemodify(l:module_file, ':t:r')))
  execute 'cd' l:pwd
endfunction

"function! ReplScala()
"  let l:currentFile = expand('%')
"  let l:args = 'scala -i ' . l:currentFile
"  call s:CallVimShell(l:args)
"endfunction

"function! ReplClojure()
"  let l:currentFile = expand('%')
"  let l:args = 'clj -i ' . l:currentFile . ' -r'
"  call s:CallVimShell(l:args)
"endfunction

"-------------------"
let &cpo = s:save_cpo
unlet s:save_cpo
