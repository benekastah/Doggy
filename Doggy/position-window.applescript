#!/usr/bin/osascript -e

on run argv
    set x to item 1 of argv
    set y to item 2 of argv
    set width to item 3 of argv
    set height to item 4 of argv
    
    tell application "Finder"
        set _b to bounds of window of desktop
        set _w to item 3 of _b
        set _h to item 4 of _b
    end tell
    
    tell application "System Events"
        set proc to first process where it is frontmost
        set position of front window of proc to {x * _w, y * _h}
        set size of front window of proc to {width * _w, height * _h}
    end tell
end run
