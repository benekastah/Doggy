#!/usr/bin/osascript -e

on run argv
    set selectedSegment to item 1 of argv
    set selectedSize to item 2 of argv
    set numSegments to item 3 of argv
    tell application "Finder"
        set _b to bounds of window of desktop
        set _w to item 3 of _b
        set _h to item 4 of _b
    end tell
    tell application "System Events"
        set proc to first process where it is frontmost
        set segmentW to _w * (1 / numSegments)
        set position of front window of proc to {segmentW * selectedSegment, 0}
        set size of front window of proc to {segmentW * selectedSize, _h}
    end tell
end run
