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

def ChhShiftkShow()
    var csfBufNr = bufnr("chhshiftk")
    if csfBufNr == -1
        return
    endif
    var csfBufWnr = bufwinnr(csfBufNr)
    if csfBufWnr == -1
        new
        b chhshiftk
    endif
    wincmd p
enddef

def ChhShiftkDown()
    var csfBufNr = bufnr("chhshiftk")
    if csfBufNr == -1
        return
    endif
    var csfBufWnr = bufwinnr(csfBufNr)
    if csfBufWnr == -1
        new
        b chhshiftk
    else
        execute ":" .. csfBufWnr .. "wincmd W" 
    endif
    execute "normal 4\<c-e>"
    wincmd p
enddef

def ChhShiftkUp()
    var csfBufNr = bufnr("chhshiftk")
    if csfBufNr == -1
        return
    endif
    var csfBufWnr = bufwinnr(csfBufNr)
    if csfBufWnr == -1
        new
        b chhshiftk
    else
        execute ":" .. csfBufWnr .. "wincmd W" 
    endif
    execute "normal 4\<c-y>"
    wincmd p
enddef

command ChhShiftkOpen call <SID>ChhShiftkOpen()
if !hasmapto('<Plug>ChhShiftkOpen;')
    map <unique> KF <Plug>ChhShiftkOpen;
    map <unique> KO <Plug>ChhShiftkOpen;
endif
noremap <unique> <script> <Plug>ChhShiftkOpen; : call <SID>ChhShiftkOpen() <cr>

command ChhShiftkClose call <SID>ChhShiftkClose()
if !hasmapto('<Plug>ChhShiftkClose;')
    map <unique> KC <Plug>ChhShiftkClose;
endif
noremap <unique> <script> <Plug>ChhShiftkClose; : call <SID>ChhShiftkClose() <cr>

command ChhShiftkShow call <SID>ChhShiftkShow()
if !hasmapto('<Plug>ChhShiftkShow;')
    map <unique> KS <Plug>ChhShiftkShow;
endif
noremap <unique> <script> <Plug>ChhShiftkShow; : call <SID>ChhShiftkShow() <cr>

command ChhShiftkDown call <SID>ChhShiftkDown()
if !hasmapto('<Plug>ChhShiftkDown;')
    map <unique> KJ <Plug>ChhShiftkDown;
endif
noremap <unique> <script> <Plug>ChhShiftkDown; : call <SID>ChhShiftkDown() <cr>

command ChhShiftkUp call <SID>ChhShiftkUp()
if !hasmapto('<Plug>ChhShiftkUp;')
    map <unique> KK <Plug>ChhShiftkUp;
endif
noremap <unique> <script> <Plug>ChhShiftkUp; : call <SID>ChhShiftkUp() <cr>

