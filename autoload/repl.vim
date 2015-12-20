scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim
"-------------------"
"TODO: Branch python2 and python3
"TODO: DRY

function! s:echo_error(msg)
  echohl Error
  echomsg a:msg
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
    call s:echo_error("Sorry, repl.vim didn't support this filetype")
    "call ReplScala()
  elseif &filetype ==# 'clojure'
    call s:echo_error("Sorry, repl.vim didn't support this filetype")
    "call ReplClojure()
  else
    call s:echo_error("Sorry, repl.vim didn't support this filetype")
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
  if !executable(l:repl)
    call s:echo_error(printf("You don't have repl: '%s'", l:repl))
    return
  endif
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
  if !executable(l:repl)
    call s:echo_error(printf("You don't have repl: '%s'", l:repl))
    return
  endif
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
  if !executable(l:repl)
    call s:echo_error(printf("You don't have repl: '%s'", l:repl))
    return
  endif
  let l:args = printf('%s %s %s', l:repl, l:opt, l:module_file)
  execute ':VimShellInteractive' l:args
endfunction


function! repl#start_erlang()
  " FIXME: this function messes current directly with a .bean file.
  let l:pwd = getcwd()

  " Setting up the file for the current file
  if &modified
    " Create new file temporary
    " -module don't allow module name number start
    let l:tempname    = tempname()
    let l:filename    = 't' . fnamemodify(l:tempname, ':t') . '.erl'
    let l:dirpath     = fnamemodify(l:tempname, ':h')
    let l:module_file = l:dirpath . '/' . l:filename
    try
      call s:writefile_with_erlang_module(getline(1, expand('$')), l:module_file)
    catch /^REPL_VIM/
      call s:echo_error('REPL_VIM: fatal error')
      call s:echo_error(v:exception)
      return
    endtry
    " Change current directory temporary
    execute 'cd' l:dirpath
  else
    let l:module_file = expand('%:p')
    " Change current directory temporary
    cd %:p:h
  endif

  let l:repl = exists('g:repl_filetype_repl.erlang') ? g:repl_filetype_repl.erlang['repl']
  \                                                  : g:repl#default_filetype_repl.erlang['repl']
  let l:opt  = exists('g:repl_filetype_repl.erlang') ? g:repl_filetype_repl.erlang['opt']
  \                                                  : g:repl#default_filetype_repl.erlang['opt']
  if !executable(l:repl)
    call s:echo_error(printf("You don't have repl: '%s'", l:repl))
    return
  endif
  let l:args = printf('%s %s %s', l:repl, l:opt, l:module_file)

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

function! s:writefile_with_erlang_module(lines, filepath)
  let l:module_defined_line = match(a:lines, '-module')
  if l:module_defined_line is -1
    throw "REPL_VIM: repl.vim couldn't -module difinition !"
  endif
  let a:lines[l:module_defined_line] = printf('-module(%s).', fnamemodify(a:filepath, ':t:r'))
  call writefile(a:lines, a:filepath)
endfunction

"-------------------"
let &cpo = s:save_cpo
unlet s:save_cpo
