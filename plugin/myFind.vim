" =============================================================================
" File: myFind.vim
" Description: A little plugin for 'find'ing files/directories
" =============================================================================

" Init
" =============================================================================
if exists("g:loaded_myFind")
    finish
endif
let g:loaded_myFind = 1

" Find file in the given directory and edit it.
function! Find(...)
  let FindIgnore = ['.swp', '.pyc', '.class', '.git', '.svn']
  if a:0==2
    let path=a:1
    let query=a:2
  else
    let path="./"
    let query=a:1
  endif

  let ignore = " | egrep -v '".join(FindIgnore, "|")."'"

  let l:list=system("find ".path." -type f -iname '*".query."*'".ignore)
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
      echo "'".query."' not found"
      return
  endif

  if l:num == 1
    exe "open " . substitute(l:list, "\n", "", "g")
  else
    let tmpfile = tempname()
    exe "redir! > " . tmpfile
    silent echon l:list
    redir END

    let old_efm = &efm
    set efm=%f
    if exists(":cgetfile")
      execute "silent! cgetfile " . tmpfile
    else
      execute "silent! cfile " . tmpfile
    endif
    let &efm = old_efm

    " Open the quickfix window below the current window
    botright copen
    call delete(tmpfile)
  endif
endfunction
command! -nargs=* -complete=dir Find :call Find(<f-args>)
