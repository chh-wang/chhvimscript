vim9script
def g:InsertToday()
    var today = system("date +%Y-%m-%d")
    exe "normal " .. "i" .. today
enddef

noremap <leader>it :call g:InsertToday()<cr>

def ChhGlobalAddToLocalList()
    var expression = "call setloclist(0, [ ], 'a', {'efm': '%f %l %m', 'lines': ['" .. expand("%") 
                \ .. " " .. line('.') .. " | " 
        \   .. substitute(getline('.'), "'", "''", 'g') .. "']})"
    # echo expression
    execute expression
enddef

# Search file and put it in location list
# [range]Gqf[!] /pat/
def ChhGlobalQf(bang: string, line1: number, line2: number, thearg: string)
    call setloclist(0, [], ' ')
    if empty(bang) 
        exe ":" .. line1 .. "," .. line2 .. "global" .. thearg .. "call ChhGlobalAddToLocalList()"
    else
        exe ":" .. line1 .. "," .. line2 .. "vglobal" .. thearg .. "call ChhGlobalAddToLocalList()"
    endif
enddef
command -nargs=* -range=% -bang Gqf call <SID>ChhGlobalQf("<bang>", <line1>, <line2>, <q-args>)

