vim9script

# shift+K, to display manual for API in linux OS
def ChhShiftkOpen()
    var word = expand("<cword>")
    # let [line_dot, column_dot] = getpos(".")[1:2]
    # new
    var csfBufNr = bufnr("chhshiftk", 1)
    var csfBufWnr = bufwinnr(csfBufNr)

    if csfBufWnr == -1
        new
        b chhshiftk
    else
        execute ":" .. csfBufWnr .. "wincmd W" 
    endif

    set noreadonly
    normal ggdG
    execute "r !man -P cat "  .. word
    normal gg
    set buftype=nofile
    set readonly
    # wincmd p
enddef

def ChhShiftkClose()
    var csfBufNr = bufnr("chhshiftk", 1)
    var csfBufWnr = bufwinnr(csfBufNr)

    if csfBufWnr != -1
        execute ":" .. csfBufWnr .. "wincmd c" 
    endif
enddef

command ChhShiftkOpen call <SID>ChhShiftkOpen()
if !hasmapto('<Plug>ChhShiftkOpen;')
    map <unique> KK <Plug>ChhShiftkOpen;
endif
noremap <unique> <script> <Plug>ChhShiftkOpen; : call <SID>ChhShiftkOpen() <cr>

command ChhShiftkClose call <SID>ChhShiftkClose()
if !hasmapto('<Plug>ChhShiftkClose;')
    map <unique> KC <Plug>ChhShiftkClose;
endif
noremap <unique> <script> <Plug>ChhShiftkClose; : call <SID>ChhShiftkClose() <cr>

