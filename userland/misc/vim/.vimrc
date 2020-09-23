syntax on
set number relativenumber
set showcmd

"set hybrid mode for line number
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

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

" format and change to normal on ctrl-s save
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR><Esc>
inoremap <silent> <C-S>         <C-O>:update<CR><Esc>

"NERDCommenter stuffs
let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
nmap <C-/> <plug>NERDCommenterInvert
vmap <C-/> <Plug>NERDCommenterInvert<CR>gv

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

let g:indentLine_enabled = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:deoplete#enable_at_startup = 1
let g:rainbow_active = 1

"color scheme
syntax enable
filetype plugin on
set background=dark
" silent! colorscheme industry
silent! colorscheme onedark

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

"alt key bindings
"not necessary in nvim
if !has('nvim')
    execute "set <M-h>=\eh"
    execute "set <M-H>=\eH"
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

" Open new line below and above current line
nnoremap <leader>o o<esc>kO<esc>j

nnoremap <c-j> <c-d>
nnoremap <c-k> <c-u>

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

"nnoremap <c-z> :u<CR>
"inoremap <c-z> <c-o>:u<CR>

" set clipboard=unnamedplus

"buffer config
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1

"set tab completion
set wildmode=longest,list,full
set wildmenu
"verbose imap <tab>
inoremap <expr><TAB> pumvisible() ? "<C-y>" : "<TAB>"

set list lcs=tab:\|\ "space at the end
set list

set completeopt=menu,noinsert

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

"multicursor
"let g:multi_cursor_use_default_mapping=0
"let g:multi_cursor_start_word_key      = '<C-d>'
"let g:multi_cursor_next_key            = '<C-d>'
"let g:multi_cursor_quit_key            = '<Esc>'

"let g:indent_guides_auto_colors = 0
"hi IndentGuidesOdd  ctermbg=grey
"hi IndentGuidesEven ctermbg=darkgrey
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

augroup HiglightTODO
    autocmd!
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'TODO\|FIXME\|HACK\|NOTE', -1)
augroup END

let g:vim_markdown_no_extensions_in_markdown = 1
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
