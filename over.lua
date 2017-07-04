-----------------------------------------------------------------------------------------
--
-- over.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------
-- forward declarations and other locals
local playBtn,data,contents,myText,myText2

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()

	-- go to level1.lua scene
	composer.gotoScene( "menu", "fade", 500 )

	return true	-- indicates successful touch
end

function doesFileExist( fname, path )

    local results = false

    -- Path for the file
    local filePath = system.pathForFile( fname, path )

    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" )

        if not file then
            -- Error occurred; output the cause
          --  print( "File error: " .. errorString )
        else
            -- File exists!
            --print( "File found: " .. fname )
            results = true
            -- Close the file handle
            file:close()
        end
    end

    return results
end
function updatestatus()
	-- body...
if doesFileExist("record.txt",system.DocumentsDirectory) then
	-- Path for the file to read
local path = system.pathForFile( "record.txt", system.DocumentsDirectory )

-- Open the file handle
local file, errorString = io.open( path, "r" )

if not file then
    -- Error occurred; output the cause
    print( "File error: " .. errorString )
else
    -- Read data from file
    data = file:read( "*n" )
	--	myText.text=data
    -- Output the file contents
    print( "data: " .. data )
    -- Close the file handle
    io.close( file )
end

file = nil
end

if doesFileExist("records.txt",system.DocumentsDirectory) then
	local path = system.pathForFile( "records.txt", system.DocumentsDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "r" )

	if not file then
	    -- Error occurred; output the cause
	    print( "File error: " .. errorString )
	else
	    -- Read data from file
	    contents = file:read( "*n" )

		--	myText2.text=contents
	    -- Output the file contents
			--print("data2:"..data)
			 print( "contents".. contents )
			 
			 if data>contents then
			 	print("logging")
			 	contents=data
			 	local saveData = data
			 	contents=data
			 	--myText2.text=data
			 	-- Path for the file to write
			 	local path = system.pathForFile( "records.txt", system.DocumentsDirectory )

			 	-- Open the file handle
			 	local file, errorString = io.open( path, "w" )

			 	if not file then
			 			-- Error occurred; output the cause
			 			print( "File error: " .. errorString )
			 	else
			 			-- Write data to file
			 			file:write( saveData )
			 			-- Close the file handle
			 			io.close( file )
			 	end

			 	file = nil
			 	print("data:"..data.." contents:"..contents)
			 end
			 -- Close the file handle
			 io.close( file )
			 end

	file = nil
else
	-- Data (string) to write
	contents=data
local saveData = data
--myText2.text=data
-- Path for the file to write
local path = system.pathForFile( "records.txt", system.DocumentsDirectory )

-- Open the file handle
local file, errorString = io.open( path, "w" )

if not file then
    -- Error occurred; output the cause
    print( "File error: " .. errorString )
else
    -- Write data to file
    file:write( saveData )
    -- Close the file handle
    io.close( file )
end

file = nil
end
end
function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "bg.png",
	 display.actualContentWidth, display.actualContentHeight )

	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX
	background.y = 0 + display.screenOriginY

	local Text = display.newText( "You Lose",
	 display.contentCenterX, display.contentCenterY, native.systemFont, 24 )

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton
	{
			label = "Back to Menu",
			onEvent = onPlayBtnRelease,
			emboss = false,
			-- Properties for a rounded rectangle button
			shape = "roundedRect",
			width = 200,
			height = 40,
			cornerRadius = 2,
			fillColor = { default={0/255,180/255,255/255,1}, over={1,0.1,0.7,0.4} },
			strokeColor = { default={0,0,1,1}, over={0.8,0.8,1,1} },
			strokeWidth = 4
	}

	playBtn.x = display.contentCenterX
	playBtn.y = display.contentHeight - 70

	updatestatus()

	myText = display.newText( "Score:"..data, display.contentCenterX, display.contentCenterY-100,
	native.systemFont, 16 )

	myText2 = display.newText( "High Score:"..contents, display.contentCenterX, display.contentCenterY-50,
	native.systemFont, 16 )

	--background_music=audio.loadStream("CombatReady.mp3")
	--audio.play(background_music ,{ channel=1, loops=-1, fadein=5000})
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( Text )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( myText)
	sceneGroup:insert( myText2)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on scree
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		local currScene = composer.getSceneName( "current" )
		local previusScene = composer.getSceneName( "previous" )
		print(currScene .. previusScene)
		-- Recycle the scene (its view is removed but its scene object remains in memory)
		Runtime:removeEventListener("enterFrame",city1)
		Runtime:removeEventListener("enterFrame",city2)
		Runtime:removeEventListener("enterFrame",city3)
		Runtime:removeEventListener("enterFrame",city4)
		--Runtime:removeEventListener("enterFrame",barricade)
		composer.removeScene( "level1", true )
		--print("logging")

	elseif phase == "did" then
		-- Called when the scene is now off screen

	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.

	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
