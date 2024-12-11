{ pkgs }:
''
  " Leader character is useful for personal mappings
  let mapleader = "\<Space>"

  " Vim is based on Vi. Setting `nocompatible` switches from the default
  " Vi-compatibility mode and enables useful Vim functionality. This
  " configuration option turns out not to be necessary for the file named
  " '~/.vimrc', because Vim automatically enters nocompatible mode if that file
  " is present. But we're including it here just in case this config file is
  " loaded some other way (e.g. saved as `foo`, and then Vim started with
  " `vim -u foo`).
  set nocompatible

  " Turn on syntax highlighting.
  syntax on

  " Encoding to rule them all
  set encoding=UTF-8

  " Disable the default Vim startup message.
  set shortmess+=I

  " Show line numbers.
  set number
  " set relativenumber

  " Show the line that the cursor is on
  set cursorline

  " Always show the status line at the bottom, even if you only have one window open.
  set laststatus=2

  " The backspace key has slightly unintuitive behavior by default. For example,
  " by default, you can't backspace before the insertion point set with 'i'.
  " This configuration makes backspace behave more reasonably, in that you can
  " backspace over anything.
  set backspace=indent,eol,start

  " By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
  " shown in any window) that has unsaved changes. This is to prevent you from "
  " forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
  " hidden buffers helpful enough to disable this protection. See `:help hidden`
  " for more information on this.
  set hidden

  " This setting makes search case-insensitive when all characters in the string
  " being searched are lowercase. However, the search becomes case-sensitive if
  " it contains any capital letters. This makes searching more convenient.
  set ignorecase
  set smartcase

  " Enable searching as you type, rather than waiting till you press enter.
  set incsearch

  " Unbind some useless/annoying default key bindings.
  nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

  " Disable audible bell because it's annoying.
  set noerrorbells visualbell t_vb=

  " Enable mouse support. You should avoid relying on this too much, but it can
  " sometimes be convenient.
  set mouse+=a

  " Prevent bad habits
  nnoremap <Left>  :echoe "Use h"<CR>
  nnoremap <Right> :echoe "Use l"<CR>
  nnoremap <Up>    :echoe "Use k"<CR>
  nnoremap <Down>  :echoe "Use j"<CR>
  " ...and in insert mode
  inoremap <Left>  <ESC>:echoe "Use h"<CR>
  inoremap <Right> <ESC>:echoe "Use l"<CR>
  inoremap <Up>    <ESC>:echoe "Use k"<CR>
  inoremap <Down>  <ESC>:echoe "Use j"<CR>

  " Make a tab insert four spaces"
  set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

  " Auto newlines
  set linebreak " Break lines at word (requires Wrap lines)
  set showbreak=+++ " Wrap-broken line prefix
  set textwidth=80 " Line wrap (number of cols)

  " Wrapping options
  "set formatoptions=tc " wrap text and comments using textwidth
  set formatoptions+=r " continue comments when pressing ENTER in I mode
  set formatoptions+=q " enable formatting of comments with gq
  set formatoptions+=n " detect lists for formatting
  set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

  " Rulers
  set colorcolumn=80
  set colorcolumn+=100

  " Permanent undo
  set undodir=~/.vimdid
  set undofile

  " Rust
  let g:rustfmt_autosave = 1
  let g:rustfmt_emit_files = 1
  let g:rustfmt_fail_silently = 0
  let g:rust_clip_command = 'xclip -selection clipboard'

  " Start NERDTree. If a file is specified, move the cursor to its window.
  "autocmd StdinReadPre * let s:std_in=1
  "autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

  " Exit Vim if NERDTree is the only window left.
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

  " Toggle between NERDTree and working directory
  nnoremap <leader>t :NERDTreeFocus<CR>

  " Jenkins file support
  autocmd BufNewFile,BufRead Jenkinsfile setf groovy

  " Stop folding with markdown plugin
  let g:vim_markdown_folding_disabled = 1

  " Allow Strikethroughs in vim
  let g:vim_markdown_strikethrough = 1

  " Run Ale for only C#
  let g:ale_linters_explicit = 1
  let g:ale_linters = {
  \ 'cs': ['OmniSharp']
  \}

  " Auto fill shell.nix files
  autocmd BufNewFile shell.nix 0r ~/.config/nvim/skeletons/shell.nix

  " Set spacing for .nix files to 2 spaces
  autocmd FileType nix setlocal ts=2 sts=2 sw=2

  " Auto format nix files
  augroup NixAutoFormat
    autocmd!
    autocmd BufWritePre *.nix :Autoformat
  augroup END
  let g:autoformat_autoindent = 0
  let g:formatdef_nixpkgsfmt = '"nixpkgs-fmt"'
  let g:formatters_nix = ['nixpkgsfmt']

  " package.nix skeleton
  autocmd BufNewFile package.nix 0r ~/.config/nvim/skeletons/package.nix

  let g:autoformat_python = '"black"'
  let g:formatters_python = ['black']
  autocmd BufWritePre *.py :Autoformat

  " Auto format shell files
  function! FormatWithShfmt()
    " Preserve cursor position and current buffer state
    let l:save = winsaveview()
    let l:current_buffer = getline(1, '$')

    " Attempt to format with shfmt
    let l:output = system('shfmt --indent 4 --binary-next-line --keep-padding', join(l:current_buffer, "\n"))

    " Check if shfmt ran successfully
    if v:shell_error == 0
        " Replace buffer with formatted text
        call setline(1, split(l:output, "\n"))
        " Write the buffer
        write
    else
        " Report error
        echoerr 'shfmt failed to format the file'
    endif
    " Restore cursor position
    call winrestview(l:save)
  endfunction
  autocmd BufWritePre *.sh call FormatWithShfmt()
''
+ import ./coc-config.nix
+ import ./colors.nix
  + import ./terraform-ls-config.nix
