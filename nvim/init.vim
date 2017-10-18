" PaperColor ###############################################################

set background=light
colorscheme PaperColor

" Deoplete #################################################################
let g:deoplete#enable_at_startup = 1
" use tab to cycle
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" close preview when leaving insert
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" NERDTree #################################################################
let NERDTreeMouseMode=3
let NERDTreeMinimalUI=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeHighlightCursorline=1
let NERDTreeShowHidden=1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "Δ",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "☢",
    \ "Deleted"   : "-",
    \ "Dirty"     : "Δ",
    \ "Clean"     : "",
    \ "Unknown"   : ""
    \ }

map <C-n> :NERDTreeToggle<CR>
" always enter term buffer in insert mode
autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif

" vim-go ###################################################################
"
"use goimports for formatting instead of gofmt
let g:go_fmt_command = "goimports"

" neomake ##################################################################
autocmd! BufWritePost * Neomake
"let g:neomake_verbose=3
"let g:neomake_logfile='/tmp/neomake.log'

" the sidebar sign placement wasn't playing nice with gitgutter, so use the
" location list instead. But location list is kinda dumb cause it pops open
" multiple times and at weird times, sooo.... fuck it
"let g:neomake_open_list=2
let g:neomake_open_list=0
let g:neomake_place_signs=0

let g:neomake_go_enabled_makers = ['go', 'golangcilint']
let g:neomake_go_golangcilint_maker = {
    \ 'exe': 'golangci-lint',
    \ 'args': [
        \ 'run',
        \ '--no-config',
        \ '--out-format=line-number',
        \ '--print-issued-lines=false',
        \ '-E=durationcheck',
        \ '-E=errorlint',
        \ '-E=exportloopref',
        \ '-E=forbidigo',
        \ '-E=gochecknoinits',
        \ '-E=godot',
        \ '-E=goimports',
        \ '-E=misspell',
        \ '-E=revive',
        \ '-E=unconvert',
        \ '-E=unparam',
        \ '.'
    \ ],
    \ 'output_stream': 'stdout',
    \ 'append_file': 0,
    \ 'cwd': '%:h',
    \ 'errorformat':
        \ '%f:%l:%c: %m,' .
        \ '%f:%l: %m'
    \ }

let g:neomake_markdown_enabled_makers = ['misspell']
let g:neomake_markdown_misspell_maker = {
    \ 'errorformat': '%f:%l:%c:%m',
    \ }

" mine #####################################################################

"Makes current line/column highlighted, and set text width
set tw=80
set colorcolumn=+1
"autocmd bufenter * set cursorline   cursorcolumn   colorcolumn=+1
"autocmd bufleave * set nocursorline nocursorcolumn colorcolumn=0
hi ColorColumn ctermfg=none ctermbg=grey cterm=none
"hi CursorLine ctermfg=none ctermbg=lightgrey cterm=none
"hi CursorColumn ctermfg=none ctermbg=lightgrey cterm=none

"Buffers scroll a bit so cursor doens't go all the way to the bottom before
"scroll begins
set scrolloff=3

"Makes all .swp files go to /tmp instead of . CAUSE FUCK DA POLICE
set backupdir=/tmp
set directory=/tmp

"Better indenting
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4

"Show eol and tabs
set list
set listchars=trail:░,tab:►\ ,extends:>,precedes:<

"Don't highlight search matches, don't jump while mid-search
set noincsearch
set nohlsearch

"We want certain types to only have 2 space for tabs
au FileType clojure    setlocal tabstop=2 shiftwidth=2
au FileType ruby       setlocal tabstop=2 shiftwidth=2
au FileType yaml       setlocal tabstop=2 shiftwidth=2
au FileType html       setlocal tabstop=2 shiftwidth=2
au FileType proto      setlocal tabstop=2 shiftwidth=2
au FileType javascript setlocal tabstop=2 shiftwidth=2

"We want certain types to use tabs instead of spaces
au FileType go      setlocal nolist noexpandtab
au FileType make    setlocal nolist noexpandtab

"terminal shortcuts
tnoremap <leader><leader> \
tnoremap <leader> <C-\><C-n>
"tab shortcuts for terminal mode have terminal escape code preceding them
tnoremap <leader>tn <C-\><C-n>:tabe term://zsh<CR>
tnoremap <leader>tN <C-\><C-n>:tabe<CR>
tnoremap <leader>ts <C-\><C-n>:vs term://zsh<CR>
tnoremap <leader>tS <C-\><C-n>:vnew<CR>
tnoremap <leader>ti <C-\><C-n>:sp term://zsh<CR>
tnoremap <leader>tI <C-\><C-n>:new<CR>
tnoremap <leader>th <C-\><C-n>gT
tnoremap <leader>tH <C-\><C-n>:-tabmove<CR>
tnoremap <leader>tl <C-\><C-n>gt
tnoremap <leader>tL <C-\><C-n>:+tabmove<CR>
tnoremap <leader>tx <C-\><C-n>:tabclose<CR>

"tab shortcuts
noremap <leader>tn :tabe term://zsh<CR>
noremap <leader>tN :tabe<CR>
noremap <leader>ts :vs term://zsh<CR>
noremap <leader>tS :vnew<CR>
noremap <leader>ti :sp term://zsh<CR>
noremap <leader>tI :new<CR>
noremap <leader>th gT
noremap <leader>tH :-tabmove<CR>
noremap <leader>tl gt
noremap <leader>tL :+tabmove<CR>
noremap <leader>tx :tabclose<CR>

" yank/paste into/from clipboard
set clipboard+=unnamedplus

"Clojure specific mappings
" Eval outerform
au FileType clojure nmap <buffer> cpP :Eval<cr>
" Eval full page
au FileType clojure nmap <buffer> cpR :%Eval<cr>

" Disable Ex mode!
nnoremap Q <Nop>
