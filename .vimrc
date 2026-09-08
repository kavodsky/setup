" ============================================================================
" ~/.vimrc — розумні дефолти + мінімум плагінів
" ============================================================================

" ----------------------------------------------------------------------------
" Базове
" ----------------------------------------------------------------------------
set nocompatible              " не тримати сумісність з дуже старим vi
set encoding=utf-8
set fileencoding=utf-8
filetype plugin indent on     " визначати тип файлу і підключати indent-правила
syntax on

set hidden                     " можна перемикати буфери без збереження
set autoread                   " автоматично підхоплювати зміни файлу ззовні
set backspace=indent,eol,start " нормальний backspace
set mouse=a                    " миша працює в усіх режимах (корисно в iTerm2)
set clipboard=unnamed          " yank/paste спільно з системним буфером macOS

" ----------------------------------------------------------------------------
" Інтерфейс
" ----------------------------------------------------------------------------
set number                     " номери рядків
set relativenumber             " відносна нумерація (зручно для d5j, y3k тощо)
set cursorline                 " підсвітка поточного рядка
set signcolumn=yes             " стала колонка зліва (під git-маркери/лінтер)
set scrolloff=8                " не даємо курсору впритул до краю екрана
set colorcolumn=100            " вертикальна лінія-орієнтир на 100 символів
set wrap                       " перенос довгих рядків візуально
set linebreak                  " перенос по словах, а не посередині слова
set showcmd                    " показувати набрану команду в статус-рядку
set laststatus=2               " статус-рядок завжди видимий
set noshowmode                 " (якщо стоїть lightline/airline — вимикає дублікат режиму)
set title                      " назва файлу у заголовку вікна термінала

" ----------------------------------------------------------------------------
" Пошук
" ----------------------------------------------------------------------------
set incsearch                  " показувати збіги під час набору
set hlsearch                   " підсвічувати всі збіги
set ignorecase                 " пошук без урахування регістру...
set smartcase                  " ...якщо в запиті нема великих літер

" швидке очищення підсвітки пошуку по Esc
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>

" ----------------------------------------------------------------------------
" Відступи (дефолт — 4 пробіли; мова-специфічні override нижче)
" ----------------------------------------------------------------------------
set expandtab                  " таб -> пробіли
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" ----------------------------------------------------------------------------
" Файли / бекапи
" ----------------------------------------------------------------------------
set nobackup
set nowritebackup
set noswapfile                 " менше сміття по проєктах (.viminfo вже й так росте)
set undofile                   " persistent undo — можна відкотити навіть після закриття vim
set undodir=~/.vim/undodir
if !isdirectory($HOME."/.vim/undodir")
    call mkdir($HOME."/.vim/undodir", "p")
endif

" ----------------------------------------------------------------------------
" Split-и та навігація
" ----------------------------------------------------------------------------
set splitright                 " вертикальний split відкривається праворуч
set splitbelow                 " горизонтальний split відкривається нижче

" рух між split-ами без Ctrl-w щоразу
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ----------------------------------------------------------------------------
" Leader-мапінги
" ----------------------------------------------------------------------------
let mapleader = " "            " пробіл як leader — стандарт для швидких комбо

nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" швидке перемикання між останніми двома буферами
nnoremap <leader><leader> <C-^>

" копіювати весь файл у системний буфер
nnoremap <leader>ya :%y+<CR>

" ----------------------------------------------------------------------------
" Мова-специфічні відступи
" ----------------------------------------------------------------------------
augroup FileTypeIndent
    autocmd!
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
    autocmd FileType rust   setlocal tabstop=4 shiftwidth=4 softtabstop=4
    autocmd FileType yaml   setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType json   setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType typescript setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType html   setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType css    setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType sh     setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType fish   setlocal tabstop=4 shiftwidth=4 softtabstop=4
augroup END

" прибирати зайві пробіли в кінці рядка перед збереженням
augroup TrimWhitespace
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

" повертатись на останню позицію курсора при повторному відкритті файлу
augroup RestoreCursor
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   execute "normal! g`\"" |
        \ endif
augroup END

" ----------------------------------------------------------------------------
" Netrw (вбудований файловий провідник) — трохи зручніший вигляд
" ----------------------------------------------------------------------------
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 25
nnoremap <leader>e :Lexplore<CR>

" ----------------------------------------------------------------------------
" Колірна схема
" ----------------------------------------------------------------------------
set background=dark
try
    colorscheme desert          " вбудована схема, є завжди — заміниш нижче, якщо став плагін
catch
endtry

if has('termguicolors')
    set termguicolors
endif

" ============================================================================
" ОПЦІЙНО: плагіни через vim-plug
" Розкоментуй блок нижче, якщо захочеш плагіни (fzf, git-gutter, статус-рядок).
" Спочатку встанови vim-plug:
"   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" ============================================================================

" call plug#begin('~/.vim/plugged')
"
" Plug 'junegunn/fzf', { 'dir': '/opt/homebrew/opt/fzf' }   " ти вже маєш fzf через brew
" Plug 'junegunn/fzf.vim'
" Plug 'airblade/vim-gitgutter'                              " git-маркери в signcolumn
" Plug 'vim-airline/vim-airline'                              " кращий статус-рядок
" Plug 'tpope/vim-fugitive'                                   " git-команди в vim
" Plug 'tpope/vim-commentary'                                 " gcc / gc для коментування
" Plug 'sheerun/vim-polyglot'                                 " синтаксис для купи мов одразу
" Plug 'morhetz/gruvbox'                                      " приємна темна тема
"
" call plug#end()
"
" if !empty(glob('~/.vim/plugged/gruvbox'))
"     colorscheme gruvbox
" endif
"
" nnoremap <leader>f :Files<CR>
" nnoremap <leader>g :GFiles<CR>
" nnoremap <leader>b :Buffers<CR>
