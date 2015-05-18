" my .vimrc
" by Tim Martin

" Build Notes
" =================
" I always seem to forget how to build Vim correctly, so here's the process saved:
"
" hg clone https://vim.googlecode.com/hg/ vim
" hg pull
" hg update
" ./configure --enable-multibyte --enable-pythoninterp=dynamic --enable-rubyinterp=dynamic --enable-python3interp=dynamic --with-features=huge --with-compiledby="Tim Martin" --with-x=yes --enable-gui=auto --prefix=<SOMEWHERE>
" make
" sudo make install

" Windows Install Notes
" =====================
" It's not the build of vim in windows that's tough, but it's the installation of
" this vimrc and plugins
"
" For the vimrc:
" In vim run ":version" "and note where the "user vimrc file" points to. It will
" likely contain the variable $HOME, whose path can be shown by ":echo $HOME".
" Write this file to the location "user vimrc file" specified. Note there might
" be an underscore in front of this filename. For example, at the time of this
" writing, I was told to put my vimrc in "$HOME/_vimrc".
"
" For the vim folder (containing plugins, amongst other things):
" Move the vim folder to "$HOME/vimfiles". See ":help rtp" for more info.
"
" Note that there may be issues with vim-gist, and if so, a lazy workaround is to
" just not use it by deleting it from the bundle folder


" tpope's pathogen
" Manage your 'runtimepath' with ease. In practical terms, pathogen.vim makes
"  it super easy to install plugins and runtime files in their own private
"  directories.
" Makes a directory ~/.vim/bundle and you can plugins inside it
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
" run :helptags on each directory in ~/.vim/bundle
Helptags

if has('path_extra')
  setglobal tags-=./tags tags^=./tags;
endif

" its it 21st century and im using vim. (not vi)
set nocompatible

if has('autocmd')
  " turn on file type detection, plugins, and indenting
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  " vim default syntax highlighting
  syntax enable
endif

set t_Co=256
let g:hybrid_use_Xresources = 1
colorscheme hybrid

" yank to the right registers
" unnamedplus
"   refers to the X11 CLIPBOARD register
"   in vim, yank and pasting from the + register (e.g. "+yw )
"   in other apps, pastes with Ctrl-V and Right Mouse Button's "paste" command
" unnamed
"   refers to the X11 PRIMARY register
"   in vim, yank and pasting from the * register (e.g. "*yw )
"   in other apps, pastes with Middle Mouse Button
" See :h x11-selection for more info
if has("clipboard")
  if v:version > 730
    set clipboard=unnamed,unnamedplus
  else
    set clipboard=unnamed
  endif
endif

" map F2 to paste toggle
" also acts as a way to override textwidth easily
set pastetoggle=<F2>

" order of precedence on which EOL formats to detect/use
set fileformats=unix,dos,mac

" no error bells when i do something vim doesn't like. they're annoying
set noerrorbells
" but visual bell is okay
set visualbell

" command completion menu displayed in statusline
set wildmenu
set wildmode=full
set wildignore+=tags,.*.un~,*.pyc,.git

set history=1000

" options for insert-mode completion
"   menu: popup a menu
"   preview: show more info in the preview window
set completeopt=menu,preview

" don't search includes for completion
set complete-=i

" highlight current line
set cursorline

" show searches so far as they are typed
set incsearch
" highlight searches after im done searching
set hlsearch
" use F1 to take this off (because it may be distracting at times)
" it's put back on when i do another search
map <silent> <F3> :nohlsearch<CR>

" automatically replace all occurences per line
set gdefault

" allow visual blocks to be sized intuitively
set virtualedit+=block

" number the lines in the right margin
set relativenumber
" use as few colums for numbering as we can
set numberwidth=1

" shortens messages so I don't have to press Enter to see the rest of the
" message
"
" flag description
" a    several abbreviations made
" s    dont give \"search hit bottom\" or \"search hit top\" messages during
"       searches
" t    truncate file message at start if too long, mark with < in leftest col
" T    truncate other messages in the middle if the are too long, use ...
set shortmess=astT

" try to keep 3 lines on the top or bottom of the current line when i scroll
set scrolloff=3
" if the last line of a window is multiple lines where i can only see some of
" the lines, display those lines (otherwise vim wouldnt)
set display=lastline,uhex

" show how much ive selected in visual mode
set showcmd

" breifly jump matching to matching bracket when typed eg (),[],...
set showmatch

" allows me to backspace over autoindenting (indent), line breaks (eol), and
" the entry point of insert mode (start)
set backspace=indent,eol,start

" copy indent from current line
" set autoindent
" " without cindent, python comments would be pushed to column 0...weird.
set cindent

" "Line up function arguments on new lines to the opening paren
set cino=(0

" " tabs are actually spaces
set expandtab
" " tabs are 2 spaces
set tabstop=2
" " delete these 2 space when i <BS> at the start of a line
set smarttab
" " (auto)indenting uses 2 spaces too
set shiftwidth=2
" " don't use softtabstop (by setting to 0). just indent tabstop spaces
set softtabstop=2

set shiftround

set undofile
set backup

set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//

set directory=~/.vim/tmp/swap//


" vim formats text for me
" letter  meaning
" r       insert comment leaders
" q       allow formatting of comments with \"gq\"
" c       auto-wrap comments using text width
" o       automatically insert comment leader after hitting o or O while in a
"         while in a comment
" n       recognize numbered lists (may not actually work because i use
"         cindent, not autoindent like docs say
" j       remove comment leaders when joining
set formatoptions=rqconj

" how long lines should be
set textwidth=80
" if we do encounter text > window width, wrap words at word boundaries (not
" mid-word"
set linebreak

" highlight the column after textwidth to give an idea of boundaries
set colorcolumn=+1

" TODO: figure out how showbreak and listchars=precedes:... interact
set list
" use ↳ at the start of lines that have been wrapped
" use ░ to trail the whitespace after the last non-whitespace on a line
" use →/← to indicate text that extends beyond/before the last/first column
" extends shows up when nowrap, precedes shows up when wrap
if has("dos16") || has("dos32") || has("win32") || has("win64")
  set showbreak=+
  set listchars=extends:+,precedes:+,tab:\ \ ,trail:$
else
  set showbreak=↳
  set listchars=extends:→,precedes:←,tab:\ \ ,trail:░
endif

" allow mouse in 'a'll modes
set mouse=a
" try to pop up a menu on r-clicks, but this doesn't seem to be working with gnome-terminal
set mousemodel=popup

" statusline
"   Each item like this: %-0{minwid}.{maxwid}{item}
"   where everything but {item} is optional (and % if its a substitution!)
"
"   item  meaning
"   <     where to start truncating if buffer is too narrow
"   {fugitive#statusline()}
"         vim-fugitive statusline. says what branch im in. if not in a git
"         project, says nothing
"   \     gotta escape spaces
"   f     relative file path
"   m     modified? [+] if yes
"   y     type of file, like [asm], [ruby], etc
"   r     read only? [RO] if so
"   =     separates left justified stuff from right justified
"   %40.(blarg%) group item. minimum of 40 chars wide,
"         no max width, and start and close a group with (blarg%)
"   l     line number
"   c     column number
"   V     virtual column number (if theres tabs and other whitespace chars,
"         only shows when different than %c)
"   b     byte value (decimal)
"   B     byte value (hex)
"   P     percentage through file, but also has things like Top, Bot, All
set statusline=%<%{fugitive#statusline()}%f\ %m%y%r[%{&fenc}][%{&ff}]%=%40.(B:%n\ L:%l/%L(%P)\ C:%c%V\ =[%b][0x%B]%)
" each buffer gets a statusline
set laststatus=2

" dont make my :split window on top, make it go on the bottom
set splitbelow
" make :vsplit's new window on the right
set splitright

" Only enforce case-sensitivity in searches when there's an uppercase letter
" disable with \C somewhere in search pattern
set ignorecase
set smartcase

" Make Esc work faster yadda yagg
set ttimeout
set ttimeoutlen=50

set title

" don't use ex mode, annoying
map Q gq

" if spell is on, spellcheck in English
set spelllang=en_us
" use this dictionary
if filereadable("/usr/share/dict/words")
  set dictionary+=/usr/share/dict/words
endif

" writes the buffer if its been modified on many commands (see help for them)
set autowrite

" reload the vimrc now
map _r :source $MYVIMRC<CR>

" we print on letter paper
set printoptions=paper:letter

" keep a viminfo to remember stuff from previous sessions
"   !     save and restore global vars
"   '10   remember marks of 10 previous files
"   h     don't remember highligted searches
"   s10   save registers with <= 10Kb of text
set viminfo=!,'10,h,s10

" quick empty line insertion
" functions defined in vim-unimpaired
nmap <silent> <C-K> [<Space>
nmap <silent> <C-J> ]<Space>

" automatically dont use vim's crazy regexes
nnoremap / /\v
vnoremap / /\v

" h is left, l is right...
" so this is strong H, strong L for beginning and end of line
noremap H ^
noremap L g_

" use a good encoding for future edits
set encoding=utf-8

function! TrimTrailingWhitespace()
  let _s=@/
  let l:save_cursor = getpos(".")
  %s/\s\+$//e
  call setpos('.', l:save_cursor)
  let @/=_s
endfunction

" Show out-of-place tabs when expandtab is on
" requires list
function! ShowTabsWhenExpandTab()
  if &expandtab
    setlocal listchars=extends:→,precedes:←,tab:»-,trail:░
  else
    setlocal listchars=extends:→,precedes:←,tab:\ \ ,trail:░
  endif
endfunction

" Run :TrimTrailingWhitespace to remove end of line white space.
command! -range=% TrimTrailingWhitespace call <SID>TrimTrailingWhitespace()

augroup myautocmds
  autocmd!
  autocmd BufNewFile,BufRead *.txt,README,INSTALL,NEWS,TODO if &ft == ""|set ft=text|endif
  autocmd FileType c setlocal ts=8 sw=8 tw=80 noet
  autocmd FileType help setlocal nospell
  autocmd FileType text,txt,mail setlocal ai spell
  autocmd FileType css silent! setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
  autocmd FileType gitcommit setlocal spell
  autocmd FileType ruby setlocal tw=79 noet sw=2 ts=2 sts=4
  autocmd FileType python setlocal sw=4 ts=4 sts=4 tw=79
  autocmd FileType liquid,markdown,text,txt setlocal tw=78 linebreak nolist
  autocmd FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
  autocmd FileType * if exists("+completefunc") && &completefunc == "" | setlocal completefunc=syntaxcomplete#Complete | endif
  autocmd BufWritePre * :call TrimTrailingWhitespace()
augroup END

set gfn=Inconsolata:h9:cANSI
