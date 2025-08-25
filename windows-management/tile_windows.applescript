on run argv
	if argv is {} then
		error "No argument supplied, expected 'left', 'right', or 'center'"
	end if
	
	set direction to item 1 of argv
	
	-- Get main screen resolution (adjust parsing as needed)
	set cmd to "system_profiler SPDisplaysDataType | awk '/Resolution/{print $2, $4; exit}'"
	set screenRes to do shell script cmd
	set AppleScript's text item delimiters to " "
	set {screenWidth, screenHeight} to text items of screenRes
	set screenWidth to screenWidth as integer
	set screenHeight to screenHeight as integer
	
	-- Determine new bounds depending on direction
	if direction = "left" then
		set newBounds to {0, 0, screenWidth / 2, screenHeight}
	else if direction = "right" then
		set newBounds to {screenWidth / 2, 0, screenWidth, screenHeight}
	else if direction = "center" then
		set newWidth to screenWidth * (2 / 3)
		set newX to (screenWidth - newWidth) / 2
		set newBounds to {newX, 0, newX + newWidth, screenHeight}
	else
		error "Unknown argument: " & direction
	end if
	
	-- Get the frontmost application and adjust its front window
	tell application "System Events"
		set frontAppProcess to first application process whose frontmost is true
		set frontAppName to name of frontAppProcess
	end tell
	
	-- Tell the front app to resize its front window
	tell application frontAppName
		try
			set win to front window
			set bounds of win to newBounds
		on error errMsg number errNum
			-- Handle apps that don't allow window manipulation
			display dialog "Cannot resize window for " & frontAppName & ": " & errMsg buttons {"OK"} default button 1
		end try
	end tell
end run