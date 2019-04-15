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
nnoremap <expr> j v:count == 0 ? 'gj' : "\<Esc>".v:count.'j'
nnoremap <expr> k v:count == 0 ? 'gk' : "\<Esc>".v:count.'k'

let g:mapleader = "\<Space>"

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

"terminal stuffs
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
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

"set statusline=%f
"set statusline=
"set statusline+=%#PmenuSel#
"set statusline+=%{StatuslineGit()}
"set statusline+=%#LineNr#
"set statusline+=\ %f
"set statusline+=%m\
"set statusline+=%=
"set statusline+=%#CursorColumn#
"set statusline+=\ %y
"set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
"set statusline+=\[%{&fileformat}\]
"set statusline+=\ %p%%
"set statusline+=\ %l:%c
"set statusline+=\

let g:airline#extensions#whitespace#enabled = 0
let g:airline_skip_empty_sections = 1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"easymotion stuffs
map <leader><leader>W <Plug>(easymotion-b)
map <leader><leader>E <Plug>(easymotion-ge)

"vim plug stuffs
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"vimplug plugins
call plug#begin('~/.vim/plugged')
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  "Plug 'shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
endif
Plug 'jeetsukumaran/vim-buffergator'
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
"Plug 'takac/vim-hardtime'
Plug 'tpope/vim-surround'
Plug 'Chiel92/vim-autoformat'
"Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdcommenter'
Plug 'morhetz/gruvbox'
Plug 'enricobacis/vim-airline-clock'
Plug 'justinmk/vim-sneak'
call plug#end()
let g:deoplete#enable_at_startup = 1

"color scheme
syntax enable
set background=dark
" silent! colorscheme gruvbox
silent! colorscheme onedark

"hard time mode
let g:hardtime_default_on = 1

"alt key bindings
"not necessary in nvim
if !has('nvim')
execute "set <M-h>=\eh"
execute "set <M-H>=\eH"
execute "set <M-j>=\ej"
execute "set <M-S-J>=\eJ"
execute "set <M-k>=\ek"
execute "set <M-K>=\eK"
execute "set <M-l>=\el"
execute "set <M-L>=\eL"
endif

nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi

nnoremap <M-l> <C-W><C-L>
nnoremap <M-h> <C-W><C-H>
nnoremap <M-J> yyp
nnoremap <M-K> yypk

nnoremap <c-j> <c-d>
nnoremap <c-k> <c-u>

"fzf mapping
nnoremap <c-p> :FZF<cr>

"buffer mapping
map <M-1> <Plug>AirlineSelectTab1
map <M-2> <Plug>AirlineSelectTab2
map <M-3> <Plug>AirlineSelectTab3
map <M-4> <Plug>AirlineSelectTab4
map <M-5> <Plug>AirlineSelectTab5
map <M-6> <Plug>AirlineSelectTab6
map <M-7> <Plug>AirlineSelectTab7
map <M-8> <Plug>AirlineSelectTab8
map <M-9> <Plug>AirlineSelectTab9
map <c-w> :bd<CR>

"buffer switching

"deoplete mapping
inoremap <expr> <M-j> pumvisible() ? "\<C-n>" :':m .+1<CR>=='
inoremap <expr> <M-k> pumvisible() ? "\<C-p>" :':m .-2<CR>=='
inoremap <expr> <CR> pumvisible() ? "\<C-y>" :'<CR>'

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

nnoremap <c-z> :u<CR>
inoremap <c-z> <c-o>:u<CR>

set clipboard=unnamedplus

"buffer config
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1