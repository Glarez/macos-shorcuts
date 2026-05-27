# macos-shorcuts


# Safari DevOps Window Script Documentation

## Overview

### devops-workspace-eng.applescript and devops-workspace-esp.applescript 

This AppleScript is an Automator-style `run` handler that prepares a Safari workspace for DevOps-related browsing.

It first closes blank or Favorites-only Safari windows, then opens a new Safari window using the **DevOps** profile, and finally loads two predefined websites.

## What the script does

1. Checks whether Safari already has open windows.
2. Closes windows that contain only one tab and that tab is blank or points to Safari Favorites.
3. Brings Safari to the foreground.
4. Uses the **File** menu to open a new window named **New DevOps Window**.
5. Reuses the first tab in that new window to open Udemy.
6. Opens YouTube Music in a second tab.
7. Returns the original Automator input unchanged.

## Script flow

### 1. Clean up empty Safari windows

The script starts by telling Safari to inspect existing windows.

If a window has only one tab, and that tab has no URL, an empty URL, or a `favorites://` URL, the window is closed. This avoids leaving unused blank Safari windows around.

### 2. Open the DevOps profile window

After a short delay, Safari is activated.

Then `System Events` interacts with Safari’s menu bar and clicks:

`File > New Window > New DevOps Window`

This means the script depends on Safari having a profile or menu item with exactly that name.

### 3. Load the target websites

Once the new window is open, the script assumes it becomes `window 1`.

The current tab in that window is reused to load:

- `https://www.udemy.com/home/my-courses/learning/`

Then a new tab is created in the same window with:

- `https://music.youtube.com`

## Full script

```applescript
on run {input, parameters}
	-- Cerrar cualquier ventana en blanco preexistente de Safari
	tell application "Safari"
		if (count of windows) > 0 then
			repeat with w in windows
				if (count of tabs of w) is 1 then
					set theURL to URL of current tab of w
					if theURL is missing value or theURL is "" or theURL contains "favorites://" then
						close w
					end if
				end if
			end repeat
		end if
	end tell
	
	delay 0.3
	
	-- Abrir ventana del perfil DevOps
	tell application "Safari" to activate
	tell application "System Events"
		tell process "Safari"
			delay 0.7
			click menu item "New DevOps Window" of menu 1 of menu item "New Window" of menu "File" of menu bar 1
		end tell
	end tell
	
	delay 1
	
	-- Operar sobre la ventana recién abierta (window 1 después de activate)
	tell application "Safari"
		set targetWindow to window 1
		-- Reutilizar la pestaña en blanco para URL 1
		set URL of current tab of targetWindow to "https://www.udemy.com/home/my-courses/learning/"
		delay 0.5
		-- Abrir URL 2 en nueva pestaña
		tell targetWindow
			make new tab with properties {URL:"https://music.youtube.com"}
		end tell
	end tell
	
	return input
end run
```

## Requirements

- Safari must be installed and available.
- [Rectangle]([Rectangle](https://rectangleapp.com)) app is needed to move the windows properly.
- A Safari profile menu entry named **New DevOps Window** must exist.
- macOS Accessibility permissions may be required for `System Events` to click Safari menu items.
- The script is intended to run in Automator, Shortcuts, or another AppleScript runner that passes `input` and `parameters`.

## Notes and caveats

- The script relies on UI scripting for opening the DevOps profile window, so menu name changes will break it.
- It assumes the newly created Safari window becomes `window 1`, which is usually true but not especially elegant.
- The delays are there to give Safari time to react.
- Only windows with a single blank/Favorites tab are closed; normal browsing windows are left untouched.

## Possible improvements

- Verify that the **New DevOps Window** menu item exists before clicking it.
- Target the newly opened window more reliably instead of assuming `window 1`.
- Make the URLs configurable.
- Add error handling in case Safari or UI scripting fails.
