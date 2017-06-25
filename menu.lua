-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------
local musicisrunning = 1
-- forward declarations and other locals
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()

	-- go to level1.lua scene
	composer.gotoScene( "level1", "fade", 500 )

	return true	-- indicates successful touch
end

function removeAllListeners(obj)
  obj._functionListeners = nil
  obj._tableListeners = nil
	print("K")
end

function musicchanger (event)
		local t = event.target
		if musicisrunning==1 then
				audio.pause( 1 )
				musicisrunning=0
				t.fill = image2
		else
				audio.resume( 1 )
				musicisrunning=1
				t.fill = image1
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

	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "logo.png", display.contentWidth*0.8, display.contentHeight*0.5 )
	titleLogo.x = display.contentCenterX
	titleLogo.y = display.contentCenterY-70

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton
	{
			label = "Play",
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
	playBtn.y = display.contentHeight - 125

 	image1 = { type="image", filename="note1.png" }
  image2 = { type="image", filename="note2.png" }
	local note = display.newRect(display.contentWidth*0.95,display.contentHeight*0.8,50,50)
	note.fill = image1

	note:addEventListener("tap",musicchanger)

	background_music=audio.loadStream("Extreme Music - Combat Ready (Epic Hybrid Rock Action).mp3")
	audio.play(background_music ,{ channel=1, loops=-1, fadein=5000})
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( note )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
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
