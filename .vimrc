" Configuration file for vim
" $Id: .vimrc,v 1.5 2008-01-17 05:44:30 hamano Exp $
"filetype on
set backspace=indent,eol,start
if $LANG == "ja_JP.eucJP"
    set encoding=euc-jp
else
    set encoding=utf-8
endif
set fileencodings=utf-8,iso-2022-jp,eucjp,cp932
set noexpandtab
set nocompatible
set history=50
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>
set ignorecase
set laststatus=1
set nobackup
set autoindent
set cindent
set nolinebreak
set nolist
set nosmartindent
set ruler
set shiftwidth=4
set showmatch
set tabstop=4
set notitle
set viminfo='10,\"10
set visualbell
set wrap
set scrolloff=4

"break for vim-tiny
if !1 | finish | endif

if has("folding")
    set nofoldenable
endif
set mouse=

"keybind
nnoremap tp :pop<CR>

"set paste

if has("syntax")
    syntax on
    "colorscheme torte
    "colorscheme monokai
    colorscheme gruvbox
    set background=dark
    function! ActivateInvisibleIndicator()
        syntax match TrailedWhiteSpace "[ \t\r　]\+$" display containedin=ALL
        highlight TrailedWhiteSpace term=underline ctermbg=cyan guibg=cyan
    endf
    augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
    augroup END
endif

if exists('&ambw')
    set ambw=double
endif
if exists('&cursorline')
    set cursorline
"    hi cursorline term=underline cterm=underline
"hi cursorline ctermbg=8
endif

"highlight cursorline ctermbg=gray
au BufEnter ?akefile* set noexpandtab
au BufEnter *.mk set noexpandtab
au BufEnter *.makefile set noexpandtab
au BufEnter rules set noexpandtab

" for git
au BufEnter COMMIT_EDITMSG set fenc=utf-8

" Transparent editing of gpg encrypted files.
" By Wouter Hanegraaff <wouter@blub.net>
augroup encrypted
    au!
    " First make sure nothing is written to ~/.viminfo while editing
    " an encrypted file.
    autocmd BufReadPre,FileReadPre     *.gpg set viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk
    autocmd BufReadPre,FileReadPre     *.gpg set noswapfile
    " Switch to binary mode to read the encrypted file
    autocmd BufReadPre,FileReadPre     *.gpg set bin
    autocmd BufReadPre,FileReadPre     *.gpg let ch_save = &ch|set ch=2
    autocmd BufReadPost,FileReadPost   *.gpg '[,']!gpg --decrypt 2> /dev/null
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost   *.gpg set nobin
    autocmd BufReadPost,FileReadPost   *.gpg let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost   *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
    autocmd BufReadPost,FileReadPost   *.gpg redraw!

    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre   *.gpg '[,']!gpg --default-recipient-self -ae 2>/dev/null
    " Undo the encryption so we are back in the normal text, directly
    " after the file has been written.
    autocmd BufWritePost,FileWritePost *.gpg u
augroup END
