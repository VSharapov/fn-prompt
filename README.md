# fn-prompt
A custom shortcut tool

## Usage
- Requires `inotifywait` (from `inotify-tools`) and `xterm`
- Save `fn-prompt.sh` somewhere (like `~/bin/`)
- Open `GNOME settings` > `Keyboard` > `Keyboard Shortcuts` > `View and Customize Shortcuts` > `Custom Shortcuts` > `+`
    - ![gnome settings screenshot][2]
    - `Name` : `FnFn` or anything really
    - `Command` : `/home/wherever/you/put/it` - on current (2023-10) GNOME shell expansion fails, so don't try anything like `~/bin/fn-prompt.sh`
    - `Shortcut` > `Set Shortcut` > hit your `Fn` key
        - Something like "Wake up" or "XF86WakeUp" should appear
- Hit `Fn`, `Fn` in quick succession, followed by `e` when xTerm appears
    - Scroll down to "Commands" and make it your own!

My timeouts are `0.3` and `0.5`, and I cut out a bunch of shortcuts that just
open some google doc or a webpage that I want to peek at for a second.

Don't forget about number keys and CAPS.

## Inspiration
I think messing aound with [X-Keys][1] when I was working at RedHat gave me
the idea. I wanted something like that, but frictionless enough that I could
easily experiment - adding and removing shortcuts without too much difficulty.

[1]: https://www.google.com/search?q=xkeys&tbm=isch
[2]: https://raw.githubusercontent.com/VSharapov/fn-prompt/master/gnome-settings-screenshot.png

## Troubleshooting
- Uncomment `set -x` on line 3
- `watch -n 0.1 cat ~/.fnp_*`
