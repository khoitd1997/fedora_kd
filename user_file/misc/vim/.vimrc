syntax on
set number relativenumber
set showcmd

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

set ttimeoutlen=50

set tabstop=4
set softtabstop=4
filetype indent on
set wildmenu
set showmatch

nnoremap j gj
nnoremap k gk
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>

nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>
au BufWrite * :Autoformat

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

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

set scrolloff=25

call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'takac/vim-hardtime'
Plug 'tpope/vim-surround'
Plug 'Chiel92/vim-autoformat'
"Plug 'scrooloose/syntastic'
Plug 'morhetz/gruvbox'
Plug 'enricobacis/vim-airline-clock'
Plug 'justinmk/vim-sneak'
"Plug 'pseewald/vim-anyfold'
call plug#end()

"autocmd Filetype * AnyFoldActivate
"filetype plugin indent on " required


syntax enable
set background=dark
colorscheme gruvbox

let g:hardtime_default_on = 1

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

nnoremap <M-J> <C-W><C-J>
nnoremap <M-K> <C-W><C-K>
nnoremap <M-L> <C-W><C-L>
nnoremap <M-h> <C-W><C-H>

set foldenable
set foldmethod=syntax
set foldnestmax=1
"set nofoldenable
set foldlevel=0
function! NeatFoldText()
		let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
		let lines_count = v:foldend - v:foldstart + 1
		let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
		let foldchar = matchstr(&fillchars, 'fold:\zs.')
		let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
		let foldtextend = lines_count_text . repeat(foldchar, 8)
		let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
		return foldtextstart . repeat("") . foldtextend
endfunction

set fillchars=fold:\ "fold stuffs
set foldexpr=getline(v:lnum)
