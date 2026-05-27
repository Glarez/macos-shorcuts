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