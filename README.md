A small collection of perl extensions for the rxvt-unicode terminal emulator.

Installation
------------
Simply place the scripts you want to install in the /usr/lib/urxvt/perl/ folder
for system-wide availability. You can also put them in a folder of your
choice, but then you have to add this line to your .Xdefaults:

    URxvt.perl-lib: /your/folder/

See the following sections for information on how to enable the scripts or set
script-specific options and keyboard mappings in your .Xdefaults.


keyboard-select
---------------
Use keyboard shortcuts to select and copy text.

After installing, put the folling lines in your .Xdefaults:

    URxvt.perl-ext-common: ...,keyboard-select
    URxvt.keysym.M-Escape: perl:keyboard-select:activate

Use Meta-Escape to activate selection mode, then use the following keys:

    h/j/k/l:    move cursor left/down/up/right (also with arrow keys)
    g/G/0/^/$/H/M/L: more vi-like cursor movement keys
    Ctrl-f/b:   move cursor down/up one screen
    Ctrl-d/u:   move cursor down/up half a screen
    v/V/Ctrl-v: toggle normal/linewise/blockwise selection
    y,Return:   copy selected text to primary buffer and quit selection mode
    Escape:     cancel keyboard selection mode


url-select
----------
Use keyboard shortcuts to select URLs.

This should be used as a replacement for the default matcher extension, it also
makes URLs clickable with the middle mouse button.

After installing, put the folling lines in your .Xdefaults:

    URxvt.perl-ext-common: ...,url-select
    URxvt.keysym.M-u: perl:url-select:select_next

Use Meta-u to activate URL selection mode, then use the following keys:

    k:        Select next upward URL (also with Meta-u)
    j:        Select next downward URL
    o/Return: Open selected URL in browser, Return: deactivate afterwards
    y:        Copy (yank) selected URL and deactivate selection mode
    q/Escape: Deactivate URL selection mode

Options:

    URxvt.urlLauncher:   browser/command to open selected URL with
    URxvt.underlineURLs: if set to true, all URLs get underlined


clipboard
---------
Use keyboard shortcuts to copy the selection to the clipboard and to paste the
clipboard contents (optionally escaping all special characters).

Requires xsel to be installed!

After installing, put the folling lines in your .Xdefaults:

    URxvt.perl-ext-common: ...,clipboard
    URxvt.keysym.M-c:   perl:clipboard:copy
    URxvt.keysym.M-v:   perl:clipboard:paste
    URxvt.keysym.M-C-v: perl:clipboard:paste_escaped

The use of the functions should be self-explanatory!
