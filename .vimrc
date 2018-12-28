"
" OGUZHAN VIM SETTINGS
"

" search options
set ignorecase
set smartcase
set incsearch
set hlsearch

" tabbing and spacing
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" linewidth, formatoptions...
set tw=79
set wrap
set ruler

" spell checker
nmap <silent> <leader>sp :set spell!<CR>
set spelllang=en_us

" tab completion (in cmd mode)
set wildmenu
set wildmode=longest,list,full

" window split navigation
" CTRL-W <arrow-keys> works!

" code coloring...
colo desert
filetype on " try to detect filetypes
syntax on
filetype plugin indent on  " enable loading indent file for filetype

" nerd tree config
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyc$', '\.swp$']
let NERDTreeShowBookmarks=1
nmap <silent> <leader>nt :NERDTreeToggle<CR>

" taglist configuration
let Tlist_Ctags_Cmd='/usr/bin/ctags'
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
let Tlist_Use_Right_Window = 1
let Tlist_File_Fold_Auto_Close = 1
nmap <silent> <leader>tl :TlistToggle<CR>
set tags=tags

" ctags
set notagbsearch
map <F10> :!ctags -R .<CR>

" re-create and re-connect to the new cscope db w/o exiting vim:
"                         \! -iwholename "*mock*" > \
nmap <C-\>r :!find $PWD \( -iname "*.c" -o -iname "*.h" -o -iname "*.cpp" -o -iname "*.cc" -o -iname "*.c++" -o -iname "*.py" -o -iname "*.java" \) > $PWD\/cscope.files; cscope -b -q -R<CR>:cs kill 0<CR>:cs add cscope.out<CR>

" python programming
set foldmethod=indent
set foldlevel=0
" pyflakes:
let g:pyflakes_use_quickfix = 0
" pep8
let g:pep8_map='<leader>8'
" pylint - pylint --generate-rcfile > ~/.pylintrc and change max-line-length
autocmd FileType python compiler pylint
let g:pylint_onwrite = 0

" ack (replacement of grep)
nmap <leader>a <Esc>:Ack!

" git fugitive ???
" %{fugitive#statusline()}

" show filename and make it always visible
" set laststatus=2
" set statusline +=%F    "full filename
" set statusline+=%c    "cursor column
" set statusline+=%l/%L "cursor line/total lines
" set statusline+=\ %P  "percent through file

" to grep a text other than 'text-under-cursor'
command -nargs=1 Defn :cs find g <args>
command -nargs=1 Grep :cs find e <args>


"set showtabline=2
hi TabLineSel ctermfg=White ctermbg=Yellow

" tabbing: zoom in/out a splitted pane(window)
" nmap <C-w>z :tabedit %<CR>
function! OpenCurrentAsNewTab()
let l:currentPos = getpos(".")
    tabedit %
    call setpos(".", l:currentPos)
endfunction
nmap <C-w>z :call OpenCurrentAsNewTab()<CR>
nmap <C-w>x :tabclose<CR>


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


" long lines
nmap <silent> <leader>ll /\%>80v.\+

" long lines and extra whitespaces
" highlight OverLength ctermbg=red ctermfg=white guibg=darkred
" highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" 
" au BufRead,BufNewFile *.py syntax match OverLength /\%80v.\+/
" au BufRead,BufNewFile *.py syntax match ExtraWhiteSpace /\s\+$\|\t/
