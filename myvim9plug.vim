vim9script
def g:InsertToday()
    var today = system("date +%Y-%m-%d");
    exe "normal " .. "i" .. date
enddef

noremap <leader>it :call g:InsertToday()<cr>
