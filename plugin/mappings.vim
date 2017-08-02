" Swap to Dockerfile array style from shell style
nnoremap <leader>a :s/ /", "/g<cr>_w3xi [<esc>A"]<esc>_
nnoremap <leader>c :s/", "/ /g<cr>_w2x$xx_

" Drop in a new UUID
inoremap <leader>u <cr><esc>:.-1read !uuidgen<cr>kgJJs
nnoremap <leader>u a<cr><esc>:.-1read !uuidgen<cr>kgJJx



" Convert an old ruby hash ( :test => 'testing' ) to new ( test: 'testing' )
nnoremap <leader>: f=xxxhi:<esc>F:x



" No dependancy fuzzy(ish) match.
" The \c makes it case-insensitive.
" nnoremap <Leader>] :find ./**/*\c
" nnoremap <Leader>] :find *\c



" Allow a quick preview on quickfix by pressing space
" nnoremap <Space> <CR>zz:execute 'match Underlined /\%' . line('.') . 'l/'<CR>:copen<CR>
" nnoremap <CR> :match<CR><CR>


" Rdoc coverage on this file.
" nnoremap <leader>r :!rdoc -C1 %<CR>
nnoremap <leader>r :!yard stats --list-undoc<CR>

" Rspec extract variable into let
function! PromoteToLet()
  " normal! dd
  " :exec '?^\s*it\>'
  " normal! P
  .s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  normal ==
endfunction
command! PromoteToLet :call PromoteToLet()
map <leader>l :PromoteToLet<cr>






" Project wide search and replace
" map <leader>g grep! searchterm -r . | cfdo S/searchterm/replacedterm/gc | up

" Swap hash comment for the one after
nmap <leader># I# <esc>_dt#$pxF#i <esc>_xx

" Copy & paste to system clipboard with <Leader>p and <Leader>y:
vmap <Leader>y "+y
vmap <Leader>d "+d
vmap <Leader>p "+p
vmap <Leader>P "+P

nmap <Leader>y "+y
nmap <Leader>Y "+Y
nmap <Leader>p "+p
nmap <Leader>P "+P
nmap <Leader>d "+d
nmap <Leader>D "+D




" Quick make current file
nmap <leader>m :make! %\:=line('.')<CR><CR>
nmap <leader>M :make! %<CR>



" Insert current line
let @l="=line('.')"



" :Explore
nnoremap - :Explore<cr>



" Pretty json
if executable('jq')
  nmap <leader>j :%!jq .
  vmap <leader>j :!jq .
else
  nmap <leader>j :%!python -m json.tool
  vmap <leader>j :!python -m json.tool
endif


" grep
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow 20|redraw!
" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>



" visual star
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
  let temp=@s
  norm! gv"sy
  let @/='\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s=temp
endfunction



" searching and replace
" vnoremap <C-r> "ry:,$S/<c-r>r//gc<left><left><left>
vnoremap <C-r> :<C-u>call <SID>VSetSearch()<CR>:,$s/<C-R>=@/<CR>//gc<left><left><left>



" remove trailing whitespace
nmap <leader>w :%s/\s\+$//g<CR>



" tidy html
nmap <leader>T :%!tidy --tidy-mark no -indent --indent-spaces 2 -quiet -xml
vmap <leader>T :'<,'>!tidy --tidy-mark no -indent --indent-spaces 2 -quiet -xml
