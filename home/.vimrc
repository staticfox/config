set number
set expandtab
set tabstop=4
set shiftwidth=4
set hlsearch
set hlsearch!
syntax on

map <C-x> :wq<CR>
nnoremap <F3> :set hlsearch!<CR>
autocmd Filetype javascript setlocal et ts=2 sw=2 sts=2
autocmd Filetype ruby setlocal et ts=2 sw=2 sts=2

" My usual screwups
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev W w
cnoreabbrev Q q
