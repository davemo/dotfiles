" ===== Smallest Viable Configuration =====
set nocompatible                     " Behave more usefully at the expense of backwards compatibility (this line comes first b/c it alters how the others work)
set encoding=utf-8                   " Format of the text in our files (prob not necessary, but should prevent weird errors)
filetype plugin on                   " Load code that configures vim to work better with whatever we're editing
filetype indent on                   " Load code that lets vim know when to indent our cursor
syntax on                            " Turn on syntax highlighting
set backspace=indent,eol,start       " backspace through everything in insert mode
set expandtab                        " When I press tab, insert spaces instead
set shiftwidth=2                     " Specifically, insert 2 spaces
set tabstop=2                        " When displaying tabs already in the file, display them with a width of 2 spaces

" ===== Instead of backing up files, just reload the buffer when it changes. =====
" The buffer is an in-memory representation of a file, it's what you edit
set autoread                         " Auto-reload buffers when file changed on disk
set nobackup                         " Don't use backup files
set nowritebackup                    " Don't backup the file while editing
set noswapfile                       " Don't create swapfiles for new buffers
set updatecount=0                    " Don't try to write swapfiles after some number of updates
set backupskip=/tmp/*,/private/tmp/* " Let me edit crontab files

" ===== Aesthetics =====
set t_Co=256                         " Explicitly tell vim that the terminal supports 256 colors (iTerm2 does)
set background=dark                  " Tell vim to use colours that works with a dark terminal background (opposite is 'light')
set nowrap                           " Display long lines as truncated instead of wrapped onto the next line
set cursorline                       " Colour the line the cursor is on
set re=1                             " Use an older regex library that is much much quicker, otherwise it lags when I press "jkjkjkjkjkjk"...
set number                           " Show line numbers
set hlsearch                         " Highlight all search matches that are on the screen
set showcmd                          " Display info known about the command being edited (eg number of lines highlighted in visual mode)
set colorcolumn=80                   " Add a column at the 80 char mark, for visual reference

" ===== Basic behaviour =====
set scrolloff=4                      " Scroll away from the cursor when I get too close to the edge of the screen
set incsearch                        " Incremental searching

" j and k operate on logical lines when wrapped
noremap <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <expr> k (v:count == 0 ? 'gk' : 'k')

" ===== Custom Language Settings =====
autocmd Filetype c    setlocal tabstop=8
autocmd Filetype cpp  setlocal tabstop=8
autocmd Filetype yacc setlocal tabstop=8

" ===== Mappings and keybindings =====
" Note that <Leader> is the backslash by default. You can change it, though, as seen here:
" https://github.com/bling/minivimrc/blob/43d099cc351424c345da0224da83c73b75bce931/vimrc#L20-L21

" Replace %/ with directory of current file (eg `:vs %/`)
  cmap %/ <C-R>=expand("%:p:h")."/"<CR>
" Replace %% with current file (eg `:vs %%`)
  cmap %% <C-R>=expand("%")<CR>
" In visual mode, "." will, for each line, go into normal mode and execute the "."
  vnoremap . :norm.<CR>
" Paste without being stupid ("*p means to paste on next line (p) from the register (") that represents the clipboard (*))
  " note that vim8 has builtin support for bracketed paste mode (https://twitter.com/josh_cheek/status/914245535065890816)
  " but it doesn't always do the right thing, so keeping this anyway.
  nnoremap <Leader>y :set paste<CR>"*p<CR>:set nopaste<CR>
" C-c acts like <Esc> (it kind of does by default, but not thoroughly enough)
  " This is really just b/c Apple took away my escape key,
  " which has been ruining my life t.t
  imap <C-C> <Esc>

" ===== Window Navigation ======
" Move to window below me
  nnoremap <c-j> <c-w>j
" Move to window above me
  nnoremap <c-k> <c-w>k
" Move to window left of me
  nnoremap <c-h> <c-w>h
" Move to window right of me
  nnoremap <c-l> <c-w>l

" left / shift-left decreases width
  nmap <Left>    :5wincmd <<CR>
  nmap <S-Left>  :wincmd  <<CR>
" right / shift-right increases width
  nmap <Right>   :5wincmd ><CR>
  nmap <S-Right> :wincmd  ><CR>
" up / shift-up increases height
  nmap <Up>      :5wincmd +<CR>
  nmap <S-Up>    :wincmd  +<CR>
" down / shift-down decreases height
  nmap <Down>    :5wincmd -<CR>
  nmap <S-Down>  :wincmd  -<CR>


" ===== Emacs/Readline Keybindings For Commandline Mode =====
" http://tiswww.case.edu/php/chet/readline/readline.html#SEC4
" many of these taken from vimacs http://www.vim.org/scripts/script.php?script_id=300

" Navigation
  " Beginning of line
  cnoremap <C-a> <Home>
  " End of line
  cnoremap <C-e> <End>
  " Right 1 character
  cnoremap <C-f> <Right>
  " Left 1 character
  cnoremap <C-b> <Left>
  " Left 1 word
  cnoremap <M-b> <S-Left>
  " Right 1 word
  cnoremap <M-f> <S-Right>

" Editing
  " Previous command
  cnoremap <M-p> <Up>
  " Next command (after you've gone to previous)
  cnoremap <M-n> <Down>
  " Cut to end of line
  cnoremap <C-k> <C-f>d$<C-c><End>
  " Paste
  cnoremap <C-y> <C-r><C-o>"
  " Delete character to the right
  cnoremap <C-d> <Right><C-h>

"" ===== Whitespace =====
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()  " strip trailing whitespace on save

" ===== Filetypes =====
" forth comments begin with a leading backslash
au FileType forth setlocal commentstring=\\\ %s
au FileType factor setlocal commentstring=!\ %s

au BufRead,BufNewFile *.fish setfiletype bash
au BufRead,BufNewFile *.sublime-* setfiletype javascript " .sublime-{settings,keymap,menu,commands}
au BufRead,BufNewFile *.sublime-snippet setfiletype html
au BufRead,BufNewFile *.ipynb setfiletype json
au BufRead,BufNewFile *.rl setfiletype ragel
au BufRead,BufNewFile *.es6 setfiletype javascript.jsx
au BufRead,BufNewFile *.ik setfiletype ruby " it's wong (this is ioke) but better than totally unhighlighted
au BufRead,BufNewFile *.dart setfiletype java " close enough
au BufRead,BufNewFile *.dats setfiletype javascript " prob will need to change, but I just want it kinda reasonably highlighted for now
au BufRead,BufNewFile *.gyp setfiletype yaml
au BufRead,BufNewFile .eslintrc setfiletype javascript

