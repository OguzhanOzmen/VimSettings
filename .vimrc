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
nmap <silent> <leader>ct :!ctags -R .<CR>

" re-create and re-connect to the new cscope db w/o exiting vim:
"                         \! -iwholename "*mock*" > \
nmap <C-\>r :!find $PWD \( -iname "*.c" -o -iname "*.h" -o -iname "*.cpp" -o -iname "*.cc" -o -iname "*.c++" -o -iname "*.py" -o -iname "*.java" \) > $PWD\/cscope.files; cscope -b -q -R<CR>:cs kill 0<CR>:cs add cscope.out<CR>

" to grep a text other than 'text-under-cursor'
command -nargs=1 Defn :cs find g <args>
command -nargs=1 Grep :cs find e <args>

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

" long lines
nmap <silent> <leader>ll /\%>79v.\+<CR>

" long lines and extra whitespaces
" highlight OverLength ctermbg=red ctermfg=white guibg=darkred
" highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" 
" au BufRead,BufNewFile *.py syntax match OverLength /\%80v.\+/
" au BufRead,BufNewFile *.py syntax match ExtraWhiteSpace /\s\+$\|\t/
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

"
" YouCompleteMe (YCM) auto-completion
"
" 1. get YouCompleteMe https://github.com/Valloric/YouCompleteMe
" 2. compile YCM:
"    cd <>/YouCompleteMe
"   ./install.py --clang-completer
" 3. add extra_conf thing
let g:ycm_global_ycm_extra_conf = '/Users/ozie/.vim/ycm_extra_conf.py'
" 4. Set PYTHONPATH - how to select python version???
"    - add it to bash_rc or somewhere else
"    - also need to set PYTHONPATH - can we do it as a ycm_* variable?
"    - need some python modules like "requests"
" export PYTHONPATH=$PYTHONPATH:/Users/ozie/Downloads/YouCompleteMe
" export PYTHONPATH=$PYTHONPATH:/Users/ozie/Downloads/YouCompleteMe/python
" export PYTHONPATH=$PYTHONPATH:/Users/ozie/Downloads/YouCompleteMe/third_party/
" export PYTHONPATH=$PYTHONPATH:/Users/ozie/Downloads/YouCompleteMe/third_party/python
" export PYTHONPATH=$PYTHONPATH:/Users/ozie/Downloads/YouCompleteMe/third_party/python-future/
" export PYTHONPATH=$PYTHONPATH:/Users/ozie/Downloads/YouCompleteMe/third_party/python-future/src/
" export PYTHONPATH=$PYTHONPATH:/Users/ozie/Downloads/YouCompleteMe/third_party/pythonfutures/
" export PYTHONPATH=$PYTHONPATH:/Users/ozie/Downloads/YouCompleteMe/third_party/requests-futures/
" export PYTHONPATH=$PYTHONPATH:/Users/ozie/Downloads/YouCompleteMe/third_party/requests_deps/
" export PYTHONPATH=$PYTHONPATH:/Users/ozie/Downloads/YouCompleteMe/third_party/ycmd
" 5. virtualenv support so that YCM finds the correct site packages
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
