vim9script noclear

# Vim global plugin for peroidic notes such as daily or weekly
# Last change: 2023-02-26 
# Maintainer: Chh.wang <chh.wang@hotmail.com>
# License: This file is placed in the public domain
#

if exists("g:loaded_periodic_notes_chh")
    finish
endif
g:loaded_periodic_notes_chh = 1

if !exists("g:periodic_home_dir")
    g:periodic_home_dir = "~/.periodic"
endif

if !exists("g:periodic_monthly_dir")
    g:periodic_monthly_dir = "monthly"
endif

if !exists("g:periodic_weekly_dir")
    g:periodic_weekly_dir = "weekly"
endif

if !exists("g:periodic_daily_dir")
    g:periodic_daily_dir = "daily"
endif

def PeriodicOpenThisMonth()
    var year = system("date +%Y")
    var month = system("date +%m")
    var fileName = substitute(year .. "-m" .. month .. ".md", "\n", "", "g")
    exe "e " .. g:periodic_home_dir .. "/" .. g:periodic_monthly_dir .. "/" .. fileName
enddef

def PeriodicGetPreviousMonth(year: string, month: string): list<string>
    var theYear: string
    var lastMonth: string
    if str2nr(month) == 1
        theYear = system("date -d \"" .. year .. "0101 -1 day\" +%Y")
        lastMonth = system("date -d \"" .. year .. "0101 -1 day\" +%m")
    else
        var tmpMonth = str2nr(month) - 2
        theYear = year
        lastMonth = system("date -d \"" .. year .. "0101 +" .. tmpMonth .. " month\" +%m")
    endif
    theYear = substitute(theYear, "\n", "", "g")
    lastMonth = substitute(lastMonth, "\n", "", "g")
    return [theYear, lastMonth]
enddef

def PeriodicGetNextMonth(year: string, month: string): list<string>
    var nextYear = str2nr(year) + 1
    var maxMonthOfYear = system("date -d \"" .. nextYear .. "0101 -1 day\" +%m")
    var theYear: string
    var nextMonth: string
    if str2nr(month) == str2nr(maxMonthOfYear)
        theYear = system("date -d \"" .. nextYear .. "0101\" +%Y")
        nextMonth = system("date -d \"" .. nextYear .. "0101\" +%m")
    else
        var tmpMonth = str2nr(month)
        theYear = year
        nextMonth = system("date -d \"" .. year .. "0101 +" .. tmpMonth .. " month\" +%m")
    endif
    theYear = substitute(theYear, "\n", "", "g")
    nextMonth = substitute(nextMonth, "\n", "", "g")
    return [theYear, nextMonth]
enddef

def PeriodicOpenThisWeek()
    var year = system("date +%Y")
    var week = system("date +%W")
    var isoWeek = system("date +%V")
    if str2nr(week) == 0 && str2nr(isoWeek) != 1
        year = system("date \"-1 year\" +%Y")
    endif
    var fileName = substitute(year .. "-W" .. isoWeek .. ".md", "\n", "", "g")
    exe "e " .. g:periodic_home_dir .. "/" .. g:periodic_weekly_dir .. "/" .. fileName
enddef

def PeriodicGetPreviousWeek(year: string, week: string): list<string>
    var theYear: string
    var lastWeek: string
    if str2nr(week) == 1
        theYear = system("date -d \"" .. year .. "0101 -1 day\" +%Y")
        lastWeek = system("date -d \"" .. year .. "0101 -4 day\" +%V")
    else
        theYear = year
        lastWeek = printf("%02d", str2nr(week) - 1)
    endif
    theYear = substitute(theYear, "\n", "", "g")
    lastWeek = substitute(lastWeek, "\n", "", "g")
    return [theYear, lastWeek]
enddef

def PeriodicGetNextWeek(year: string, week: string): list<string>
    var nextYear = str2nr(year) + 1
    var maxWeekOfYear = system("date -d \"" .. nextYear .. "0101 -4 day\" +%V")
    var theYear: string
    var nextWeek: string
    if str2nr(week) == str2nr(maxWeekOfYear)
        theYear = printf("%04d", str2nr(year) + 1)
        nextWeek = "01"
    else
        theYear = year
        nextWeek = printf("%02d", str2nr(week) + 1)
    endif
    theYear = substitute(theYear, "\n", "", "g")
    nextWeek = substitute(nextWeek, "\n", "", "g")
    return [theYear, nextWeek]
enddef

def PeriodicOpenToday()
    var fileName = system("date +%Y-%m-%d.md")
    fileName = substitute(fileName, "\n", "", "g")
    exe "e " .. g:periodic_home_dir .. "/" .. g:periodic_daily_dir .. "/" .. fileName
enddef

def PeriodicCheckAndGetDateOfCurrentFileName(): list<string>
    var curFileName = expand("%:t")
    if curFileName =~ '^\d\d\d\d-m\d\d.md$'
        var fileYear = curFileName[0 : 3]
        var fileMonth = curFileName[6 : 7]
        return ["monthly", fileYear, fileMonth]
    elseif curFileName =~ '^\d\d\d\d-W\d\d.md$'
        var fileYear = curFileName[0 : 3]
        var fileWeek = curFileName[6 : 7]
        return ["weekly", fileYear, fileWeek]
    elseif curFileName =~ '^\d\d\d\d-\d\d-\d\d.md$'
        var fileYear = curFileName[0 : 3]
        var fileMonth = curFileName[5 : 6]
        var fileDay = curFileName[8 : 9]
        return ["daily", fileYear, fileMonth, fileDay]
    endif
    return []
enddef

def PeriodicOpenNext()
    var curDate = PeriodicCheckAndGetDateOfCurrentFileName()
    if !empty(curDate)
        if curDate[0] == "monthly"
            var nextMonthDate = PeriodicGetNextMonth(curDate[1], curDate[2])
            exe "e " .. expand("%:h") .. "/" .. nextMonthDate[0] .. "-m" .. nextMonthDate[1] .. ".md"
        elseif curDate[0] == "weekly"
            var nextWeekDate = PeriodicGetNextWeek(curDate[1], curDate[2])
            exe "e " .. expand("%:h") .. "/" .. nextWeekDate[0] .. "-W" .. nextWeekDate[1] .. ".md"
        elseif curDate[0] == "daily"
            var fileName = system("date -d \"" .. curDate[1] .. "-" .. curDate[2] .. "-" .. curDate[3] .. " +1 day\" +%Y-%m-%d.md")
            fileName = substitute(fileName, "\n", "", "g")
            exe "e " .. g:periodic_home_dir .. "/" .. g:periodic_daily_dir .. "/" .. fileName
        endif
    endif
enddef

def PeriodicOpenPrevious()
    var curDate = PeriodicCheckAndGetDateOfCurrentFileName()
    if !empty(curDate)
        if curDate[0] == "monthly"
            var previousMonthDate = PeriodicGetPreviousMonth(curDate[1], curDate[2])
            exe "e " .. expand("%:h") .. "/" .. previousMonthDate[0] .. "-m" .. previousMonthDate[1] .. ".md"
        elseif curDate[0] == "weekly"
            var previousWeekDate = PeriodicGetPreviousWeek(curDate[1], curDate[2])
            exe "e " .. expand("%:h") .. "/" .. previousWeekDate[0] .. "-W" .. previousWeekDate[1] .. ".md"
        elseif curDate[0] == "daily"
            var fileName = system("date -d \"" .. curDate[1] .. "-" .. curDate[2] .. "-" .. curDate[3] .. " -1 day\" +%Y-%m-%d.md")
            fileName = substitute(fileName, "\n", "", "g")
            exe "e " .. g:periodic_home_dir .. "/" .. g:periodic_daily_dir .. "/" .. fileName
        endif
    endif
enddef

if !hasmapto('<Plug>VimperiodicnotePeriodicOpenThisMonth;')
    map <unique> <leader>pnm <Plug>VimperiodicnotePeriodicOpenThisMonth;
endif
noremap <unique> <script> <Plug>VimperiodicnotePeriodicOpenThisMonth; <SID>PeriodicOpenThisMonth
noremap <SID>PeriodicOpenThisMonth :call <SID>PeriodicOpenThisMonth()<cr>

if !hasmapto('<Plug>VimperiodicnotePeriodicOpenThisWeek;')
    map <unique> <leader>pnw <Plug>VimperiodicnotePeriodicOpenThisWeek;
endif
noremap <unique> <script> <Plug>VimperiodicnotePeriodicOpenThisWeek; <SID>PeriodicOpenThisWeek
noremap <SID>PeriodicOpenThisWeek :call <SID>PeriodicOpenThisWeek()<cr>

if !hasmapto('<Plug>VimperiodicnotePeriodicOpenToday;')
    map <unique> <leader>pnt <Plug>VimperiodicnotePeriodicOpenToday;
endif
noremap <unique> <script> <Plug>VimperiodicnotePeriodicOpenToday; <SID>PeriodicOpenToday
noremap <SID>PeriodicOpenToday :call <SID>PeriodicOpenToday()<cr>

if !hasmapto('<Plug>VimperiodicnotePeriodicOpenNext;')
    map <unique> <leader>pnn <Plug>VimperiodicnotePeriodicOpenNext;
endif
noremap <unique> <script> <Plug>VimperiodicnotePeriodicOpenNext; <SID>PeriodicOpenNext
noremap <SID>PeriodicOpenNext @=':call <SID>PeriodicOpenNext()\|'<cr><cr>

if !hasmapto('<Plug>VimperiodicnotePeriodicOpenPrevious;')
    map <unique> <leader>pnp <Plug>VimperiodicnotePeriodicOpenPrevious;
endif
noremap <unique> <script> <Plug>VimperiodicnotePeriodicOpenPrevious; <SID>PeriodicOpenPrevious
noremap <SID>PeriodicOpenPrevious @=':call <SID>PeriodicOpenPrevious()\|'<cr><cr>

