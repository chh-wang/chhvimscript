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

if !exists("g:periodic_weekly_dir")
    g:periodic_weekly_dir = "weekly"
endif

if !exists("g:periodic_daily_dir")
    g:periodic_daily_dir = "daily"
endif

def PeriodicOpenThisWeek()
    var year = system("date +%Y")
    var week = system("date +%V")
    var fileName = substitute(year .. "-W" .. week .. ".md", "\n", "", "g")
    exe "e " .. g:periodic_home_dir .. "/" .. g:periodic_weekly_dir .. "/" .. fileName
enddef

def PeriodicCheckAndGetWeekDateOfCurrentFileName(): list<string>
    var curFileName = expand("%:t")
    # curFileName = "1988-W52.md"
    if curFileName =~ '^\d\d\d\d-W\d\d.md$'
        var fileYear = curFileName[0 : 3]
        var fileWeek = curFileName[6 : 7]
        return [fileYear, fileWeek]
    endif
    return []
enddef

def PeriodicGetPreviousWeek(year: string, week: string): list<string>
    var theYear: string
    var lastWeek: string
    if str2nr(week) == 0
        theYear = system("date -d \"" .. year .. "0101 -1 day\" +%Y")
        lastWeek = system("date -d \"" .. year .. "0101 -1 day\" +%W")
    else
        var tmpWeek = str2nr(week) - 1
        theYear = year
        lastWeek = system("date -d \"" .. year .. "0101 +" .. tmpWeek .. " week\" +%W")
    endif
    theYear = substitute(theYear, "\n", "", "g")
    lastWeek = substitute(lastWeek, "\n", "", "g")
    return [theYear, lastWeek]
enddef

def PeriodicOpenPreviousWeek()
    var curWeekDate = PeriodicCheckAndGetWeekDateOfCurrentFileName()
    if !empty(curWeekDate)
        var previousWeekDate = PeriodicGetPreviousWeek(curWeekDate[0], curWeekDate[1])
        exe "e " .. expand("%:h") .. "/" .. previousWeekDate[0] .. "-W" .. previousWeekDate[1] .. ".md"
    endif
enddef

def PeriodicGetNextWeek(year: string, week: string): list<string>
    var nextYear = str2nr(year) + 1
    var maxWeekOfYear = system("date -d \"" .. nextYear .. "0101 -1 day\" +%W")
    var theYear: string
    var nextWeek: string
    if str2nr(week) == str2nr(maxWeekOfYear)
        theYear = system("date -d \"" .. nextYear .. "0101\" +%Y")
        nextWeek = system("date -d \"" .. nextYear .. "0101\" +%W")
    else
        var tmpWeek = str2nr(week) + 1
        theYear = year
        nextWeek = system("date -d \"" .. year .. "0101 +" .. tmpWeek .. " week\" +%W")
    endif
    theYear = substitute(theYear, "\n", "", "g")
    nextWeek = substitute(nextWeek, "\n", "", "g")
    return [theYear, nextWeek]
enddef

def PeriodicOpenNextWeek()
    var curWeekDate = PeriodicCheckAndGetWeekDateOfCurrentFileName()
    if !empty(curWeekDate)
        var nextWeekDate = PeriodicGetNextWeek(curWeekDate[0], curWeekDate[1])
        exe "e " .. expand("%:h") .. "/" .. nextWeekDate[0] .. "-W" .. nextWeekDate[1] .. ".md"
    endif
enddef

if !hasmapto('<Plug>VimperiodicnotePeriodicOpenThisWeek;')
    map <unique> <leader>pnw <Plug>VimperiodicnotePeriodicOpenThisWeek;
endif
noremap <unique> <script> <Plug>VimperiodicnotePeriodicOpenThisWeek; <SID>PeriodicOpenThisWeek
noremap <SID>PeriodicOpenThisWeek :call <SID>PeriodicOpenThisWeek()<cr>

if !hasmapto('<Plug>VimperiodicnotePeriodicOpenPreviousWeek;')
    map <unique> <leader>pnk <Plug>VimperiodicnotePeriodicOpenPreviousWeek;
endif
noremap <unique> <script> <Plug>VimperiodicnotePeriodicOpenPreviousWeek; <SID>PeriodicOpenPreviousWeek
noremap <SID>PeriodicOpenPreviousWeek :call <SID>PeriodicOpenPreviousWeek()<cr>

if !hasmapto('<Plug>VimperiodicnotePeriodicOpenNextWeek;')
    map <unique> <leader>pnj <Plug>VimperiodicnotePeriodicOpenNextWeek;
endif
noremap <unique> <script> <Plug>VimperiodicnotePeriodicOpenNextWeek; <SID>PeriodicOpenNextWeek
noremap <SID>PeriodicOpenNextWeek :call <SID>PeriodicOpenNextWeek()<cr>

