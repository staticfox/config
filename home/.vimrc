set expandtab
set tabstop=4
set shiftwidth=4
set number
set hlsearch
set hlsearch!
syntax on

map <C-x> :wq<CR>
nnoremap <F3> :set hlsearch!<CR>

autocmd Filetype javascript setlocal et ts=2 sw=2 sts=2

