set number
set expandtab
set tabstop=4
set shiftwidth=4
set hlsearch
set hlsearch!
syntax on

let mapleader = "/"

" For moving windows
function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf
endfunction

map <C-x> :wq<CR>
nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>
nnoremap <F3> :set hlsearch!<CR>

autocmd Filetype javascript setlocal et ts=2 sw=2 sts=2
autocmd Filetype ruby setlocal et ts=2 sw=2 sts=2

" My usual screwups
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev W w
cnoreabbrev Q q
