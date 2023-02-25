vim9script

if !exists("g:period_home_dir")
    g:period_home_dir = "~/.peroid"
endif

if !exists("g:period_weekly_dir")
    g:period_weekly_dir = "weekly"
endif

if !exists("g:period_daily_dir")
    g:period_daily_dir = "daily"
endif

def g:PeriodOpenThisWeek()
    var year = system("date +%Y")
    var week = system("date +%V")
    var fileName = substitute(year .. "-W" .. week .. ".md", "\n", "", "g")
    exe "e " .. g:period_home_dir .. "/" .. g:period_weekly_dir .. "/" .. fileName
enddef

def PeriodCheckAndGetWeekDateOfCurrentFileName(): list<string>
    var curFileName = expand("%:t")
    # curFileName = "1988-W52.md"
    if curFileName =~ '^\d\d\d\d-W\d\d.md$'
        var fileYear = curFileName[0 : 3]
        var fileWeek = curFileName[6 : 7]
        return [fileYear, fileWeek]
    endif
    return []
enddef

def PeriodGetPreviousWeek(year: string, week: string): list<string>
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

def g:PeriodOpenPreviousWeek()
    var curWeekDate = PeriodCheckAndGetWeekDateOfCurrentFileName()
    if !empty(curWeekDate)
        var previousWeekDate = PeriodGetPreviousWeek(curWeekDate[0], curWeekDate[1])
        exe "e " .. expand("%:h") .. "/" .. previousWeekDate[0] .. "-W" .. previousWeekDate[1] .. ".md"
    endif
enddef

def PeriodGetNextWeek(year: string, week: string): list<string>
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

def g:PeriodOpenNextWeek()
    var curWeekDate = PeriodCheckAndGetWeekDateOfCurrentFileName()
    if !empty(curWeekDate)
        var nextWeekDate = PeriodGetNextWeek(curWeekDate[0], curWeekDate[1])
        exe "e " .. expand("%:h") .. "/" .. nextWeekDate[0] .. "-W" .. nextWeekDate[1] .. ".md"
    endif
enddef

