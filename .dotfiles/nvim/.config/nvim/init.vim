set nocp
set hidden
set encoding=utf-8
set path+=**

" quick zshrc editing
nnoremap <Leader>cz :e ~/.zshrc<cr>

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

"- looks
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'

"- git
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'

"- navigation
Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'justinmk/vim-sneak'

"- language features
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}
Plug 'vim-test/vim-test'

Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'rcarriga/nvim-dap-ui'


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

set listchars=tab:>-,trail:.
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
nnoremap <C-w>c :bd<CR>
nnoremap <C-Tab> :bNext<CR>

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#coc#enabled = 0
" let g:airline_section_x = "%{fnamemodify(getcwd(), ':t')}"
let g:airline_section_x = ""
let g:airline_section_b = ""
let g:airline_section_y = ""

" NERDTree (file browser)
nnoremap <C-w>e :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '.git']
let NERDTreeMinimalUI = 1
let NERDTreeShowHidden = 1

" ctrlp (files and buffers)
let g:ctrlp_working_path_mode = ""
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](\.git|node_modules)$',
  \ 'file': '\v\.(pyc)$'
\}
nnoremap <C-p> :CtrlP<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>

" grep (file contents)
command -nargs=1 ProjSearch vimgrep /<args>/gj **/*.py | cw | redraw!
nnoremap <leader>f :ProjSearch 

" vim sneak (jump motion, s)
let g:sneak#label = 1

" lsp
if has('win32')
    let $PATH.=';' . stdpath("data") . '\lsp\python\node_modules\.bin'
    let $PATH.=';' . stdpath("data") . '\lsp\vim\node_modules\.bin'
else
    let $PATH.=':' . stdpath("data") . '/lsp/python/node_modules/.bin'
    let $PATH.=':' . stdpath("data") . '/lsp/vim/node_modules/.bin'
endif
lua require('lspconfig').pyright.setup{}
lua require('lspconfig').vimls.setup{}
lua require('lspconfig').sourcekit.setup{}

nnoremap <silent> <leader>i :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>d :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> <leader>dl :lua vim.lsp.diagnostic.set_loclist()<CR>
inoremap <C-space> <C-x><C-o>
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

" treesitter
lua <<EOF
    require 'nvim-treesitter.configs'.setup {
        highlight = {enable = true, additional_vim_regex_highlighting = false}
    }
EOF
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99

" sessions
set wildmenu
set wildmode=full
set wildignorecase
let g:sessions_dir = stdpath("data") . '/sessions'
exec 'nnoremap <Leader>ss :mks!' . g:sessions_dir . '/'
exec 'nnoremap <Leader>sr :so ' . g:sessions_dir . '/'
exec 'nnoremap <Leader>sR :silent ! start /I nvim-qt -- -S ' . g:sessions_dir . '/'
nnoremap <expr> <Leader>cs ":edit " . v:this_session . "<cr>"

" terminal
tnoremap <Esc> <C-\><C-n>
nnoremap <expr> <Leader>t expand('%') =~ 'term://' ? ':close<CR>' : ':split \| terminal<CR>a'
tnoremap <Leader>t <C-\><C-n>:bd!<CR>

" dap
lua <<EOF
    local dap, dapui, dappy = require("dap"), require("dapui"), require('dap-python')
    vim.fn.sign_define('DapBreakpoint', {text='◆', texthl='DiagnosticError', linehl='', numhl=''})
    vim.fn.sign_define('DapStopped', {text='→', texthl='ModeMsg', linehl='', numhl='Search'})
    dapui.setup({
        mappings = {
            expand = "o",
            open = "<CR>",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
        },
        layouts = {
            {
              elements = {
                { id = "scopes", size = 0.25 },
                "breakpoints",
                --"stacks",
                --"watches",
              },
              size = 40, -- 40 columns
              position = "left",
            },
            {
              elements = {
                --"repl",
                "console",
              },
              size = 0.25, -- 25% of total lines
              position = "bottom",
            },
          }
    })
    dappy.setup('~/.local/share/nvim/debug/python/bin/python')
    dappy.test_runner = 'pytest'

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
EOF

nmap <F2> :DapToggleBreakpoint<cr>
nmap <F9> :DapStepInto<cr>
nmap <F7> :DapStepOut<cr>
nmap <F8> :DapStepOver<cr>
nmap <F3> :DapContinue<cr>
nmap <F4> :DapTerminate<cr>

" vimtest
function! DapPythonStrategy(cmd)
  let l:args = split(split(a:cmd, '-m pytest ')[-1])
  lua require('dap').run({type='python', request='launch', module='pytest', args=vim.api.nvim_eval('l:args')}, {})
endfunction

let test#custom_strategies={'dap_python': function('DapPythonStrategy')}
let test#strategy={'nearest':'dap_python', 'file':'neovim', 'suite':'neovim'}
let test#python#runner='pytest'
let test#python#pytest#executable='python -m pytest'  " run without pipenv
let test#python#pytest#options='-rA --disable-warnings -vv --tb=native'

nmap <silent> tn :TestNearest<CR>
nmap <silent> tf :TestFile<CR>
nmap <silent> ts :TestSuite<CR>
nmap <silent> tl :TestLast<CR>

