"" Install the plugin manager first
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"" Initiate the plugin manager and the plugins itself
call plug#begin()

Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'lambdalisue/fern.vim'
Plug 'airblade/vim-gitgutter'

call plug#end()

"" Configs for winbar
set winbar=
set winbar+=%#SignColumn#
set winbar+=\{
set winbar+=%=
set winbar+=%#WildMenu#
set winbar+=\%t
set winbar+=%#SignColumn#
set winbar+=%=
set winbar+=\}

"" Sensible defaults
syntax on
filetype plugin indent on
set tabstop=3
set shiftwidth=3
set termguicolors
set splitbelow
set wrap
set hlsearch
set incsearch
set ignorecase
set showmatch
set encoding=utf-8
set nobackup
set nowritebackup
set relativenumber
set updatetime=300
set signcolumn=yes
set noshowmode
colorscheme moonfly
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q" 

"" Variable for statusline and winbar
let g:currentmode={
    \ 'n'      : 'Normal ',
    \ 'no'     : 'N·Operator Pending ',
    \ 'v'      : 'Visual ',
    \ 'V'      : 'V·Line ',
    \ '\<C-V>' : 'V·Block ',
    \ 's'      : 'Select ',
    \ 'S'      : 'S·Line ',
    \ '\<C-S>' : 'S·Block ',
    \ 'i'      : 'Insert ',
    \ 'R'      : 'Replace ',
    \ 'Rv'     : 'V·Replace ',
    \ 'c'      : 'Command ',
    \ 'cv'     : 'Vim Ex ',
    \ 'ce'     : 'Ex ',
    \ 'r'      : 'Prompt ',
    \ 'rm'     : 'More ',
    \ 'r?'     : 'Confirm ',
    \ '!'      : 'Shell ',
    \ 't'      : 'Terminal '
    \}


"" Configs for statusline
set statusline=
set statusline+=%#Title#
set statusline+=\ %{g:currentmode[mode()]}
set statusline+=%-2#DiffText#
set statusline+=\%m
set statusline+=%#CursorLine#
set statusline+=%=
set statusline+=%#Todo#
set statusline+=\/
set statusline+=%#MoonflyTurquoiseMode#
set statusline+=\ %1l:\ %-1v
set statusline+=%#CocListLine#
set statusline+=\: 
set statusline+=%#NavicIconsFunction#
set statusline+=%y
set statusline+=%#Todo#
set statusline+=\/

"" Lua initiation code starts
lua << EOF
-- Initiate Treesitter highlighting
require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true
		}
	}

-- Moonfly colorscheme configs
vim.g.moonflyCursorColor = true
vim.g.moonflyItalics = false

EOF

"" Boilerplate code for coc.nvim
"" Activating IntelliSense
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"" Enabling C-Space for another completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

"" Symbol and reference highlighting
autocmd CursorHold * silent call CocActionAsync('highlight')

"" Enable keybinding for CoC diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>

"" User keybindings
"" Draw fern file manager
nnoremap <C-f> :Fern . -drawer -toggle<CR>

"" Visual selection and tabbing
vmap < <gv
vmap > >gv
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"" Save and close
nnoremap <C-o> :w!<CR>
nnoremap <C-x> :q!<CR>
