" Refer: https://newbedev.com/how-to-get-visually-selected-text-in-vimscript
function s:get_visual_selection_through_func()
	let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif


	" let option ww to null, such that press "l" won't go to next line
	let saved_ww=&ww
	let &ww=""
	" try to move right of last character
	normal `>l
	let &ww=saved_ww
    let [line_dot, column_dot] = getpos(".")[1:2]
	" for chinese character, the len is 2
	if (column_dot-column_end == 2)
		let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 0 : 1)]
	" if column_dot doesn't equal column_end, imply that such character is not the
	" last character of the line. 
	elseif (column_dot != column_end)
		let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
	endif

    let lines[0] = lines[0][column_start - 1:]

    return join(lines, "\n")
endfunction

function s:get_visual_selection_through_yank()
	let saved_reg=@@
	try
		normal gv"zy
		return @@
	finally
		let @z=saved_reg
	endtry
endfunction

" Search the visual text. Only suitable for line mode, but not block mode
function s:search_visual_selection()
	" let lines=s:get_visual_selection_through_yank()
	let lines=s:get_visual_selection_through_func()
	let lines=substitute(lines, "\\", "\\\\\\\\", "g")
	let lines=substitute(lines, "/", "\\\\/", "g")
	let lines=substitute(lines, "\n", "\\\\n", "g")
	let @/=lines
endfunction
command MypluginSearcahVisualtext call s:search_visual_selection()
vnoremap <leader>* :<c-w>MypluginSearcahVisualtext<cr>/\V<c-r>/<cr>

" input method
let s:insertModeInputMethod=1033
let s:otherModeInputMethod=1033
function! UpdateInputMethod(mode)
	let curMode = a:mode
	if curMode == "i"
		call system("im-select " . s:insertModeInputMethod)
	else
		call system("im-select " . s:otherModeInputMethod)
	endif
endfunction
function! SwitchInputMethod(mode)
	let curMode = a:mode
	if curMode == "i"
		if s:insertModeInputMethod == 1033
			let s:insertModeInputMethod=2052
		else
			let s:insertModeInputMethod=1033
		endif
	else
		if s:otherModeInputMethod == 1033
			let s:otherModeInputMethod=2052
		else
			let s:otherModeInputMethod=1033
		endif
	endif
	call UpdateInputMethod(a:mode)
endfunction
noremap <c-l> :call SwitchInputMethod("n")<cr>
noremap! <c-l> i<esc>:call SwitchInputMethod("i")<cr>"_cl

autocmd InsertEnter * call UpdateInputMethod("i")
autocmd InsertLeave * call UpdateInputMethod("n")

