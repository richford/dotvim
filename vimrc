call pathogen#infect()
call pathogen#helptags()

" Use solarized color scheme
syntax enable
set background=dark
let g:solarized_visibility="high"
let g:solarized_termcolors=16
let g:solarized_contrast="high"
colorscheme solarized

" line numbers, filetypes, tabs, and highlight
set number
filetype plugin on
filetype indent on
syntax on
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
set hlsearch

" Use par for text formatting
set formatprg=par\ -re

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" Toggle linebreak setting for a visually appealing soft wrap
command! -nargs=* Wrap set wrap linebreak nolist showbreak=…
command! -nargs=* Unwrap set nolinebreak showbreak=

" Activate mouse features
set mouse=a

" Highlight the 80th column and beyond
if exists('+colorcolumn')
    set colorcolumn=80
" else
"     au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

"====================[ Highlight matches when jumping to next ]=================
"
" Remap the n and N keys to do the highlighting
highlight WhiteOnRed ctermbg=red ctermfg=white
nnoremap <silent> n   n:call HLNext(0.3)<cr>
nnoremap <silent> N   N:call HLNext(0.3)<cr>

function! HLNext (blinktime)
    set invcursorline
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    set invcursorline
    redraw
endfunction


"====================[ Navigate wrapped lines ]=================================
"
" Map the wrapped line navigation commands to the mac command key ⌘
vmap <D-j> gj
vmap <D-k> gk
vmap <D-4> g$
vmap <D-6> g^
vmap <D-0> g^
nmap <D-j> gj
nmap <D-k> gk
nmap <D-4> g$
nmap <D-6> g^
nmap <D-0> g^


"====================[ Dealing with tabs ]======================================
"
" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
    let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
    if l:tabstop > 0
        let &l:sts = l:tabstop
        let &l:ts = l:tabstop
        let &l:sw = l:tabstop
    endif
    call SummarizeTabs()
endfunction

function! SummarizeTabs()
    try
        echohl ModeMsg
        echon 'tabstop='.&l:ts
        echon ' shiftwidth='.&l:sw
        echon ' softtabstop='.&l:sts
        if &l:et
            echon ' expandtab'
        else
            echon ' noexpandtab'
        endif
    finally
        echohl None
    endtry
endfunction


"=====[ Create mappings to edit files in directory of currently open file ]=====
"
" <leader> ew   edit in new window
" <leader> es   edit in new split 
" <leader> ev   edit in new vertical split
" <leader> et   edit in new tab
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%


"====================[ Language-specific formatting]============================
"
" Only do this part when compiled with support for autocommands
if has("autocmd")
    " Enable file type detection
    filetype on

    " Syntax of these languages is fussy over tabs Vs spaces
    autocmd FileType make setlocal ts=4 sts=4 sw=4 noexpandtab
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

    " Customisations based on house-style (arbitrary)
    autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab

    " Treat .rss files as XML
    autocmd BufNewFile,BufRead *.rss setfiletype xml
endif


"====================[ Latex Integration ]======================================
"
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

"====================[ C-style Macro Editing ]==================================
"
" Substitutes the whitespace and \ at the end of the line with an expression 
" which repeats a space up until column 80 and then appends a \ character. 
" It'll append 1 space if your line is > 80 characters
command! Macrofill %s/\s*\\$/\=repeat(' ', 80-col('.')).' \'

"====================[ Case sensitive searching ]===============================
"
" Use case for searching only if any caps are used in the search
:set ignorecase
:set smartcase

"====================[ Octodown build command ]=================================
"
" Use Octodown as default build command for Markdown files
autocmd FileType markdown let b:dispatch = 'octodown --live-reload %'

"====================[ Coquille keybindings ]===================================
"
" Maps Coquille commands to CoqIDE default key bindings
au FileType coq call coquille#CoqideMapping()
