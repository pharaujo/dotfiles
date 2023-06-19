set smartindent        " Make autoindent smarter
set autowrite          " Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set ignorecase         " Wait for smartcase...
set smartcase          " Do smart case matching when searching
" set hlsearch           " Highlight search results
set list               " Show invisibles
set listchars=tab:▸-
set mouse=             " Disable mouse
"set number             " Enable line numbers
set scrolloff=3        " Never lean to the top or bottom of the window
set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set softtabstop=4 tabstop=4 shiftwidth=4 expandtab " Default whitespace settings
set viminfo='20,\"50   " read/write a .viminfo file, don't store more than 50 lines of registers
set wildmode=list:longest " Show all alternatives and complete furtherest possible.
"set completeopt=menuone,longest,preview " Better completion menu
set completeopt=menuone,noselect " nvim-compe configuration
set background=dark

set colorcolumn=73,80  " Vertical line on column 80

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
" The empty entry (,,) matches files that have no extension (e.g. prefer
" 'prog.c' over 'prog'.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pyo,.pyc,,.rbc

augroup vimrc
  autocmd!
augroup END

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd vimrc BufWritePre * :%s/\s\+$//e "clean extra whitespace on write

" highlight trailing white space and spaces before a <Tab> in C source
let c_space_errors=1

call plug#begin(stdpath('data') . '/plugged')
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'tpope/vim-sensible'
Plug 'fatih/vim-go'
Plug 'google/vim-jsonnet'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'towolf/vim-helm'
call plug#end()

" set termguicolors
let g:solarized_use256=1
let g:solarized_extra_hi_groups=1
colorscheme solarized8

autocmd vimrc FileType ruby setlocal expandtab tabstop=2 shiftwidth=2
autocmd vimrc FileType yaml setlocal expandtab tabstop=2 shiftwidth=2
autocmd vimrc FileType json setlocal expandtab tabstop=2 shiftwidth=2
autocmd vimrc FileType markdown set wrap
autocmd vimrc FileType go setlocal nolist listchars&    " don't print tabs in go files
autocmd vimrc FileType make setlocal nolist listchars&    " don't print tabs in go files

" Emulate ctrlp with fzf.vim
nnoremap <C-p> :GFiles<Cr>

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "gopls", "yamlls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    nvim_lsp = true;
  };
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = {  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
      "bash",
      "comment",
      "dockerfile",
      "go",
      "gomod",
      "json",
      "lua",
      "python",
      "regex",
      "ruby",
      "rust",
      "toml",
      "yaml"
    },
  highlight = { enable = true },
  -- indent = { enable = true },
  incremental_selection = { enable = true },
}

EOF
