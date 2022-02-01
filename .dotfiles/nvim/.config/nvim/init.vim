set nocp
set hidden
set encoding=utf-8
set path+=**

" quick vimrc editing
nnoremap <Leader>cv :e $MYVIMRC<cr>
if !exists('*ReloadVimrc')
   fun! ReloadVimrc()
       let save_cursor = getcurpos()
       source $MYVIMRC
       call setpos('.', save_cursor)
   endfun
endif
autocmd! BufWritePost $MYVIMRC call ReloadVimrc()

" plugins
call plug#begin('~/vimfiles/plugged')

Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'

Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'neovim/nvim-lspconfig'

Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'vim-test/vim-test'

Plug 'bakstenen/vim-envstack'

call plug#end()

" look and feel
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
set mouse=a
set showtabline=0
set colorcolumn=80

set number
set relativenumber
set noshowmode

set splitbelow
set splitright

set listchars=tab:>-,trail:.,space:.
set list

" tab and line break options
set expandtab
set nowrap
set linebreak
set autoindent
set wrapmargin=0
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=0

" keyboard shortcuts
" nnoremap <C-p> :e 
nnoremap <C-w>c :bd<CR>
nnoremap <C-Tab> :bNext<CR>
" nnoremap <Leader>b :ls<CR>:b

" airline
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#coc#enabled = 0
let g:airline_section_x = "%{fnamemodify(getcwd(), ':t')}"

" NERDTree (file browser)
nnoremap <C-w>e :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '.git']
let NERDTreeMinimalUI = 1

" ctrlp
let g:ctrlp_working_path_mode = ""
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/](\.git|node_modules)$',
    \ 'file': '\v\.(pyc)$'
\}
nnoremap <C-p> :CtrlP<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>

" Lsp
if has('win32')
    let $PATH.=';' . stdpath("data") . '\lsp\python\node_modules\.bin'
    let $PATH.=';' . stdpath("data") . '\lsp\vim\node_modules\.bin'
else
    let $PATH.=':' . stdpath("data") . '/lsp/python/node_modules/.bin'
    let $PATH.=':' . stdpath("data") . '/lsp/vim/node_modules/.bin'
endif
lua require('lspconfig').pyright.setup{}
lua require('lspconfig').vimls.setup{}

nnoremap <silent> <leader>i :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>d :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
" nnoremap <expr> <Leader>i lua vim.tbl_isempty(vim.lsp.diagnostic.get_line_diagnostics()) ? 'lua vim.diagnostic.open_float()<CR>' : ':lua vim.lsp.buf.hover()<CR>'
inoremap <C-Space> <C-x><C-o>
set omnifunc=v:lua.vim.lsp.omnifunc
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
nnoremap <expr> <Leader>q len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) != 0 ? ':cclose<CR>' : ':copen<CR>'
nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>

lua <<EOF
    vim.diagnostic.config({
        virtual_text = false,
        signs = false,
        underline = true
    })
EOF

" asynctasks
let g:asynctasks_config_name = '.vim/tasks.ini'
let g:asyncrun_open = 6
let g:asynctasks_term_pos = 'right'
nnoremap <Leader>ct :AsyncTaskEdit<cr>
nnoremap <silent><f5> :AsyncTask npm-start<cr>
"nnoremap <Leader>ct :e $MYVIMRC<cr>

" config files
" vimrc (\cv), global env (\ce), project env (\cl), coc (\cc), async tasks (\ct)

" sessions
set wildmenu
set wildmode=full
set wildignorecase
let g:sessions_dir = '~/vimfiles/sessions'
exec 'nnoremap <Leader>ss :mks!' . g:sessions_dir . '/'
exec 'nnoremap <Leader>sr :so ' . g:sessions_dir . '/'
exec 'nnoremap <Leader>sR :silent ! start /I nvim-qt -- -S ' . g:sessions_dir . '/'
" autocmd! SessionLoadPost * let g:latest_session=v:this_session " useful to load environment?
" execute ':so ' . g:sessions_dir . '/vim_playground.vim'
nnoremap <expr> <Leader>cs ":edit " . v:this_session . "<cr>"

" grep
command -nargs=1 ProjSearch vimgrep /<args>/gj **/*.py | cw | redraw!
nnoremap <leader>f :ProjSearch 

" terminal
tnoremap <Esc> <C-\><C-n>
nnoremap <expr> <Leader>t expand('%') =~ 'term://' ? ':close<CR>' : ':split \| terminal<CR>a'
tnoremap <Leader>t <C-\><C-n>:bd!<CR>


