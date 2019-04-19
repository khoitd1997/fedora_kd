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

"format on save
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
  Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }

  "Plug 'shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
endif
Plug 'terryma/vim-multiple-cursors'
Plug 'jiangmiao/auto-pairs'
Plug 'luochen1990/rainbow'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-surround'
Plug 'Chiel92/vim-autoformat'
Plug 'scrooloose/nerdcommenter'
Plug 'morhetz/gruvbox'
Plug 'enricobacis/vim-airline-clock'
Plug 'justinmk/vim-sneak'
Plug 'yggdroot/indentline'
Plug 'nathanaelkane/vim-indent-guides'

"Plug 'scrooloose/syntastic'
"Plug 'takac/vim-hardtime'
"Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
call plug#end()

let g:indentLine_enabled = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:deoplete#enable_at_startup = 1
let g:rainbow_active = 1

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

map <C-\> :vsplit<enter>

"alt-shift-j,k to duplicate line
nnoremap <M-J> yyp
nnoremap <M-K> yypk
inoremap <M-J> <ESC>yypi
inoremap <M-K> <ESC>yypki

nnoremap <c-j> <c-d>
nnoremap <c-k> <c-u>

"vinegar binding
autocmd FileType netrw nmap <buffer> <esc> <C-^>

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

"set tab completion
set wildmode=longest,list,full
set wildmenu
"verbose imap <tab>
inoremap <expr><TAB> pumvisible() ? "<C-y>" : "<TAB>"

"coc nvim settings
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set signcolumn=yes

set list lcs=tab:\|\ "space at the end
set list

set completeopt=menu,noinsert

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
"autocmd CursorHold * silent call CocActionAsync('highlight')
"nnoremap <silent> <space>o  :<C-u>CocList outline<cr>

"let g:coc_global_extensions = [
"    \ 'coc-pairs',
"    \ 'coc-lists',
"    \ 'coc-dictionary',
"    \ 'coc-html',
"    \ 'coc-css',
"    \ 'coc-tsserver',
"    \ 'coc-json',
"    \ 'coc-yaml',
"    \ 'coc-snippets',
"    \ 'coc-python',
"    \ 'coc-rls',
"    \]

"language server settings
let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'cpp': ['clangd'],
    \ }
nnoremap <silent> <C-r> :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <C-o> :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <silent> ' :call LanguageClient#textDocument_definition()<CR>

"highlight word under cursor
:autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

"multicursor
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_word_key      = '<C-d>'
let g:multi_cursor_next_key            = '<C-d>'
let g:multi_cursor_quit_key            = '<Esc>'

"let g:indent_guides_auto_colors = 0
"hi IndentGuidesOdd  ctermbg=grey
"hi IndentGuidesEven ctermbg=darkgrey
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
