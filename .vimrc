" erase 키 unmap
"iu 
"cu 
"
let mapleader = ","

" window 이동
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l
nmap <C-k> <C-w>k
nmap <C-j> <C-w>j

" blank line에 typename을 치고 ',td'를 치면 다음과 같은 형태를 만들어 준다.
" typedef struct typename_s typename_t;
" struct typename_s {
" };
autocmd BufEnter *.[chly] imap <buffer> ,td :let structName=expand("<cword>")<CR>0Ditypedef struct <C-R>=structName<CR>_s <C-R>=structName<CR>_t;<CR>struct <C-R>=structName<CR>_s {<CR>};O

" blank line에 typename을 치고 ',fd'를 치면 다음과 같은 형태를 만들어 준다.
" #ifndef _TYPENAME_T
" #define _TYPENAME_T
" typedef struct typename_s typename_t;
" #endif
autocmd BufEnter *.[chly] imap <buffer> ,fd :let structName=expand("<cword>")<CR>0:let upper=toupper(structName)<CR>:let lower=expand(structName)<CR>Di#ifndef _<C-R>=upper<CR>_T<CR>#define _<C-R>=upper<CR>_T<CR>typedef struct <C-R>=lower<CR>_s <C-R>=lower<CR>_t;<CR>#endif<CR>

set nu
set cinoptions=:0p0t0
set wrap
set textwidth=78
set complete=.,w,b,u,t
set ai
set cindent
set si
set sw=4
set ts=4
set smarttab
"set expandtab
set formatoptions=tc
set history=1000
set visualbell
set tagrelative
set term=xterm-color
set matchtime=1
set showmatch
set previewheight=15
set showcmd
set laststatus=2
set ignorecase
set smartcase
set ruler
set hlsearch
set pastetoggle=<F12>
set enc=utf-8
set fencs=utf-8,ucs-bom,euc-kr
set bg=dark
set colorcolumn=80
set cursorline

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

"execute pathogen#infect()

" SET UP Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'L9'
Plugin 'wincent/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"Plugin 'user/L9', {'name': 'newL9'}
Plugin 'The-NERD-tree'
Plugin 'cscope.vim'
Plugin 'AutoAlign'
Plugin 'taglist-plus'
Plugin 'Tagbar'
Plugin 'fatih/vim-go'
Plugin 'Valloric/YouCompleteMe'
call vundle#end()            " required
filetype plugin indent on    " required
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" END Vundle

set tags=~/workspace/agensgraph/src/tags

set path+=~/workspace/agensgraph/src/**

"set csprg=/usr/bin/cscope
"set csto=0
"set nocst
"set nocsverb
""if filereadable("~/workspace/agensgraph/src/cscope.out")
"cs add /home/ktlee/workspace/agensgraph/src/cscope.out
""cs add /home/ktlee/workspace/psqlodbc-09.05.0400/cscope.out
""endif
"set csverb
let g:cscope_silent=1

nnoremap <leader>fa :call cscope#findInteractive(expand('<cword>'))<CR>
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
"nnoremap <leader>l :call ToggleLocationList()<CR>
" s: Find this C symbol
nnoremap  <leader>fs :call cscope#find('s', expand('<cword>'))<CR>
" g: Find this definition
nnoremap  <leader>fg :call cscope#find('g', expand('<cword>'))<CR>
" d: Find functions called by this function
nnoremap  <leader>fd :call cscope#find('d', expand('<cword>'))<CR>
" c: Find functions calling this function
nnoremap  <leader>fc :call cscope#find('c', expand('<cword>'))<CR>
" t: Find this text string
nnoremap  <leader>ft :call cscope#find('t', expand('<cword>'))<CR>
" e: Find this egrep pattern
nnoremap  <leader>fe :call cscope#find('e', expand('<cword>'))<CR>
" f: Find this file
nnoremap  <leader>ff :call cscope#find('f', expand('<cword>'))<CR>
" i: Find files #including this file
nnoremap  <leader>fi :call cscope#find('i', expand('<cword>'))<CR>

au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif

autocmd BufWritePre * %s/\s\+$//e

"set autochdir
"autocmd BufEnter * silent! lcd %:p:h

