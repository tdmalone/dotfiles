
" @see http://www.guckes.net/vim/setup.htm

" Turns syntax highlighting on.
syntax on

" Enables lots of features, according to the above link.
set nocp

" Line numbers. Type :set nonumber to remove on a case-by-case basis.
set number

" Turn tabs into width of 2 and type 2 spaces when pressing tab.
" @see https://stackoverflow.com/a/1878983/1982136
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

" See tabs and trailing spaces.
set list listchars=trail:+

" Create a "ruler" at the 100th column.
set colorcolumn=100
