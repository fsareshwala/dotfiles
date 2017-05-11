tell application "Safari"
  set windowurl to URL of current tab of window 1
end tell

set AppleScript's text item delimiters to "/"
set elements to every text item of windowurl
set lenElements to the count of elements
set pageKey to item lenElements of elements
set the clipboard to pageKey
