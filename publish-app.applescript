-- Publish Presentation.app
-- Drag one or more .html presentation files onto this app's icon to publish them
-- to presentations.kapchatfield.com. Source kept in the repo; rebuild with:
--   osacompile -o ~/Desktop/"Publish Presentation.app" publish-app.applescript

property repoRoot : "/Users/kappeschatfield/Documents/Claude/presentations-repo"

on open theItems
	repeat with anItem in theItems
		set p to POSIX path of anItem
		if p ends with ".html" then
			publishOne(p)
		else
			display dialog "Skipped — not an .html file:" & return & p buttons {"OK"} default button "OK"
		end if
	end repeat
end open

on publishOne(p)
	-- Default the title to the file name (without .html); let the user edit it.
	set defaultTitle to do shell script "basename " & quoted form of p & " .html"
	set theTitle to text returned of (display dialog "Presentation title:" default answer defaultTitle)
	set theTag to text returned of (display dialog "Tag / label (shown on the card):" default answer "Keynote")

	try
		do shell script quoted form of (repoRoot & "/drop-publish.sh") & " " & quoted form of p & " " & quoted form of theTitle & " " & quoted form of theTag
		set choice to button returned of (display dialog "✓ Published!" & return & return & theTitle & return & "Live in about a minute." buttons {"Open Site", "Done"} default button "Done")
		if choice is "Open Site" then
			do shell script "open https://presentations.kapchatfield.com"
		end if
	on error errMsg
		display dialog "Publish failed:" & return & return & errMsg buttons {"OK"} default button "OK" with icon stop
	end try
end publishOne

on run
	display dialog "Drag a presentation .html file onto this app's icon to publish it to your site." buttons {"OK"} default button "OK"
end run
