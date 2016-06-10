if has("syntax")
	syntax on
endif

let unuse_newfold=1
set nocsverb

if filereadable($TB_HOME . "/dev-util/vimrc") 
    so $TB_HOME/dev-util/vimrc
    autocmd BufReadPost *.[ch] call RemoveTab()

    if filereadable($TB_HOME . "/dev-util/vimrc.db1team") 
        so $TB_HOME/dev-util/vimrc.db1team
    endif
endif

so ~/.vim/plugin/svncommand.vim

" erase Å° unmap
"iu 
"cu 

" window ÀÌµ¿
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l
nmap <C-k> <C-w>k
nmap <C-j> <C-w>j

" syntax color ÀçÁ¤ÀÇ
hi tbAssert ctermfg=DarkGray
hi tbType ctermfg=DarkGreen
hi comment ctermfg=DarkCyan
hi macro ctermfg=yellow
autocmd BufEnter *.[chly] 
    \ syntax match listIter /list[c]\=_for_[a-z0-9_]\+/
hi listIter ctermfg=Darkyellow
hi StatusLine ctermbg=Darkblue
"hi StatusLineNC ctermfg=White ctermbg=Black
hi Search ctermfg=Black ctermbg=Yellow
hi Folded ctermfg=Darkcyan ctermbg=Black

" box¸¦ »ç¿ëÇÑ ÀÚµ¿ comment ÀÔ·Â
vmap ,mb !boxes -d c<CR>
nmap ,mb !!boxes -d c<CR>
vmap ,xb !boxes -d c -r<CR>
nmap ,xb !!boxes -d c -r<CR>

vmap ,mc !boxes -d c-cmt<CR>
nmap ,mc !!boxes -d c-cmt<CR>
vmap ,xc !boxes -d c-cmt -r<CR>
nmap ,xc !!boxes -d c-cmt -r<CR>

vmap ,ml !boxes -d c-cmt2<CR>
nmap ,ml !!boxes -d c-cmt2<CR>
vmap ,xl !boxes -d c-cmt2 -r<CR>
nmap ,xl !!boxes -d c-cmt2 -r<CR>

" 2ÁÙ ÀÌ»óÀÇ ºóÁÙÀ» 1ÁÙ·Î
nmap _B GoZ<Esc>:g/^[ <Tab>]*$/,/[^ <Tab>]/-j<CR>Gdd:noh<CR>

" jam ÀÔ·Â Çò°¥¸®´Ï±ñ...
cmap jam make

" blank line¿¡ typenameÀ» Ä¡°í ',td'¸¦ Ä¡¸é ´ÙÀ½°ú °°Àº ÇüÅÂ¸¦ ¸¸µé¾î ÁØ´Ù.
" typedef struct typename_s typename_t;
" struct typename_s {
" };
autocmd BufEnter *.[chly] imap <buffer> ,td :let structName=expand("<cword>")<CR>0Ditypedef struct <C-R>=structName<CR>_s <C-R>=structName<CR>_t;<CR>struct <C-R>=structName<CR>_s {<CR>};O

" blank line¿¡ typenameÀ» Ä¡°í ',fd'¸¦ Ä¡¸é ´ÙÀ½°ú °°Àº ÇüÅÂ¸¦ ¸¸µé¾î ÁØ´Ù.
" #ifndef _TYPENAME_T
" #define _TYPENAME_T
" typedef struct typename_s typename_t;
" #endif
autocmd BufEnter *.[chly] imap <buffer> ,fd :let structName=expand("<cword>")<CR>0:let upper=toupper(structName)<CR>:let lower=expand(structName)<CR>Di#ifndef _<C-R>=upper<CR>_T<CR>#define _<C-R>=upper<CR>_T<CR>typedef struct <C-R>=lower<CR>_s <C-R>=lower<CR>_t;<CR>#endif<CR>

autocmd BufEnter * map <buffer> ;w :call GenWiki(expand("%"))<CR>
function! GenWiki(filename)
    exe "!wiki.pl ".a:filename." \| w3m -T text/html"
endfunction 

"autocmd BufEnter *.[chly] imap <buffer> ( ()i
"autocmd BufEnter *.[chly] imap <buffer> { {<CR>}O

set nu
set cinoptions=:0p0t0
set wrap
set textwidth=78
set complete=.,w,b,u,t
set ai
set cindent
set si
"set sw=4
set ts=4
"set smarttab
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
set enc=euc-kr
set fencs=ucs-bom,euc-kr,utf-8
set bg=dark
set colorcolumn=80

"branche Ä¿¹Ô ¸Þ½ÃÁö¿¡ ±âÁ¸ ·Î±×¸¦ »ðÀÔÇÏ±â À§ÇØ¼­ ÅÛÇÃ¸´ ¹®Àå Á¦°ÅÇÏ±â
nmap ,xl gg<S-V>/^--<CR>kx:set paste<CR><S-O>

exe "so $TB_HOME/dev-util/vim_lib/svnblame.vim"

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

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
Plugin 'user/L9', {'name': 'newL9'}

Plugin 'The-NERD-tree'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

