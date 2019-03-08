syntax on
set number relativenumber
set showcmd

"set hybrid mode for line number
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

"for vim airline
set ttimeoutlen=50

"misc stuffs
set scrolloff=25
set tabstop=4
set softtabstop=4
filetype indent on
filetype plugin on
set wildmenu
set showmatch

"default to visual line movement for j and k
nnoremap j gj
nnoremap k gk
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>

"format and change to normal on ctrl-s save
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>
au BufWrite * :Autoformat

"NERDCommenter stuffs
let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
nmap <C-_> <plug>NERDCommenterInvert
vmap <C-_> <Plug>NERDCommenterInvert<CR>gv

"gnome terminal stuffs
if has("autocmd")
		au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
		au InsertEnter,InsertChange *
								\ if v:insertmode == 'i' |
								\   silent execute '!echo -ne "\e[6 q"' | redraw! |
								\ elseif v:insertmode == 'r' |
								\   silent execute '!echo -ne "\e[4 q"' | redraw! |
								\ endif
		au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif

"syntastic stuffs
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:airline#extensions#whitespace#enabled = 0

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"vimplug plugins
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'takac/vim-hardtime'
Plug 'tpope/vim-surround'
Plug 'Chiel92/vim-autoformat'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdcommenter'
Plug 'morhetz/gruvbox'
Plug 'enricobacis/vim-airline-clock'
Plug 'justinmk/vim-sneak'
call plug#end()

"color scheme
syntax enable
set background=dark
colorscheme gruvbox

"hard time mode
let g:hardtime_default_on = 1

"alt key bindings
execute "set <M-h>=\eh"
execute "set <M-H>=\eH"
execute "set <M-j>=\ej"
execute "set <M-S-J>=\eJ"
execute "set <M-k>=\ek"
execute "set <M-K>=\eK"
execute "set <M-l>=\el"
execute "set <M-L>=\eL"

nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi

nnoremap <M-l> <C-W><C-L>
nnoremap <M-h> <C-W><C-H>
nnoremap <M-J> yyp
nnoremap <M-K> yypk

"folding settings
set foldenable
set foldmethod=syntax
set foldnestmax=1
set foldlevel=1

set fillchars=fold:\ "fold stuffs
set foldexpr=getline(v:lnum)

"auto indent settings
autocmd FileType vim,tex,md let b:autoformat_autoindent=0
let g:autoformat_autoindent = 0

"checking if file has been changed and redraw
set autoread
set updatetime=200
au CursorHold,CursorHoldI * checktime
au FocusGained,BufEnter * :checktime

