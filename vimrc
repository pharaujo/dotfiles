set nocompatible       " Use Vim defaults instead of 100% vi compatibility
set autoindent         " Auto indent new lines
set smartindent        " Make autoindent smarter
set smarttab           " Proper indenting with <Tab>
set autowrite          " Automatically save before commands like :next and :make
set backspace=indent,eol,start " more powerful backspacing
"set cursorline         " Highlight current line
set hidden             " Hide buffers when they are abandoned
set history=50         " keep 50 lines of command line history
set ignorecase         " Wait for smartcase...
set smartcase          " Do smart case matching when searching
set incsearch          " Incremental search
set hlsearch           " Highlight search results
set list               " Show invisibles
set listchars=tab:▸-
"set mouse=a            " Enable mouse usage (all modes) in terminals
"set number             " Enable line numbers
set ruler              " show the cursor position all the time
set scrolloff=3        " Never lean to the top or bottom of the window
set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set softtabstop=4 tabstop=4 shiftwidth=4 expandtab " Default whitespace settings
set viminfo='20,\"50   " read/write a .viminfo file, don't store more than 50 lines of registers
set wildmenu           " Enhanced command-line completion.
set wildmode=list:longest " Show all alternatives and complete furtherest possible.
set completeopt=menuone,longest,preview " Better completion menu
set background=dark

if version >= 703
    set colorcolumn=73,80  " Vertical line on column 80
    set undofile           " Persistent undo history
    set undodir=~/.vim/backup
endif

if !exists("syntax_on")
  syntax on " Use syntax highlighting
endif

filetype plugin indent on  " Enables filetype specific stuff

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pyo,.pyc,.rbc

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWritePre * :%s/\s\+$//e "clean extra whitespace on write

" Retore last edit location when opening a file
autocmd BufReadPost * if line("'\"") > 0 && line ("'\"") <= line("$") | exe "normal g'\"" | endif

" Highlight space errors in C/C++ source files (Vim tip #935)
let c_space_errors=1

" use tabwidth 2 in ruby files
au FileType ruby setlocal expandtab tabstop=2 shiftwidth=2

