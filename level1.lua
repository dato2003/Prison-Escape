-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local physics = require ("physics")
local widget = require ("widget")
--physics.setDrawMode( "hybrid" )
--------------------------------------------

function widget.newPanel (options)
	local customOptions = options or {}
	local opt = {}
	opt.location = customOptions.location or "top"
	local default_width, default_height
	if ( opt.location == "top" or opt.location == "bottom" ) then
	default_width = display.contentWidth
	default_height = display.contentHeight * 0.33
	else
	default_width = display.contentWidth * 0.33
	default_height = display.contentHeight
	end
	opt.width = customOptions.width or default_width
	opt.height = customOptions.height or default_height
	opt.speed = customOptions.speed or 500
	opt.inEasing = customOptions.inEasing or easing.linear
	opt.outEasing = customOptions.outEasing or easing.linear
	if ( customOptions.onComplete and type(customOptions.onComplete) == "function" ) then
	opt.listener = customOptions.onComplete
	else
	opt.listener = nil
	end
	local container = display.newContainer( opt.width, opt.height )
	if ( opt.location == "left" ) then
	container.anchorX = 1.0
	container.x = display.screenOriginX
	container.anchorY = 0.5
	container.y = display.contentCenterY
	elseif ( opt.location == "right" ) then
	container.anchorX = 0.0
	container.x = display.actualContentWidth
	container.anchorY = 0.5
	container.y = display.contentCenterY
	elseif ( opt.location == "top" ) then
	container.anchorX = 0.5
	container.x = display.contentCenterX
	container.anchorY = 1.0
	container.y = display.screenOriginY
	else
	container.anchorX = 0.5
	container.x = display.contentCenterX
	container.anchorY = 0.0
	container.y = display.actualContentHeight
	end
	function container:show()
	local options = {
	time = opt.speed,
	transition = opt.inEasing
	}
	if ( opt.listener ) then
	options.onComplete = opt.listener
	self.completeState = "shown"
	end
	if ( opt.location == "top" ) then
	options.y = display.screenOriginY + opt.height
	elseif ( opt.location == "bottom" ) then
	options.y = display.actualContentHeight - opt.height
	elseif ( opt.location == "left" ) then
	options.x = display.screenOriginX + opt.width
	else
	options.x = display.actualContentWidth - opt.width
	end
	transition.to( self, options )
	end
	function container:hide()
	local options = {
	time = opt.speed,
	transition = opt.outEasing
	}
	if ( opt.listener ) then
	options.onComplete = opt.listener
	self.completeState = "hidden"
	end
	if ( opt.location == "top" ) then
	options.y = display.screenOriginY
	elseif ( opt.location == "bottom" ) then
	options.y = display.actualContentHeight
	elseif ( opt.location == "left" ) then
	options.x = display.screenOriginX
	else
	options.x = display.actualContentWidth
	end
	transition.to( self, options )
	end
	return container
end

function removeAllListeners(obj)
  obj._functionListeners = nil
  obj._tableListeners = nil
	print("K")
end


function scrollCity(self,event)
	if self.x < -1*display.actualContentWidth+200 then
		self.x = display.actualContentWidth
	else
		self.x = self.x - self.speed
	end
end

function resumegame()
		city1.speed=3
		city2.speed=3
		city3.speed=6
		city4.speed=6
		player:play()
		audio.resume( 1 )
		print("dasdas")
		panel:hide()
end

function Pause()
		city1.speed=0
		city2.speed=0
		city3.speed=0
		city4.speed=0
		player:pause()
		--audio.pause( 1 )
		panel:show()
end

function exittomenu(event)
		panel:hide()
		composer.gotoScene( "menu","fade",800 )
		--audio.resume(1)
end

function jump (event)
	if event.phase~="moved" and event.phase=="began" then
		--print("jump")
		player:applyForce(0,-20,player.x,player.y)
	end

end

local holding = false
local function enterFrameListener()
    if holding then
        -- Holding button

				print("right")
				if player.x+5<=display.contentWidth then
					player.x=player.x+5
				end
    else
        -- Not holding

    end
end

local function right( event )
    if event.phase == "began" then
        display.getCurrentStage():setFocus( event.target )
        event.target.isFocus = true
        Runtime:addEventListener( "enterFrame", enterFrameListener )
        holding = true
    elseif event.target.isFocus then
        if event.phase == "moved" then
        elseif event.phase == "ended" then
            holding = false
            Runtime:removeEventListener( "enterFrame", enterFrameListener )
            display.getCurrentStage():setFocus( nil )
            event.target.isFocus = false
        end
    end
    return true
end

local holding2 = false
local function enterFrameListener2()
    if holding2 then
        -- Holding button
				print("LEFT")
				if player.x-5>=0 then
					player.x=player.x-5
				end
    else
        -- Not holding

    end
end

local function left( event )
    if event.phase == "began" then
        display.getCurrentStage():setFocus( event.target )
        event.target.isFocus = true
        Runtime:addEventListener( "enterFrame", enterFrameListener2 )
        holding2 = true
    elseif event.target.isFocus then
        if event.phase == "moved" then
        elseif event.phase == "ended" then
            holding2 = false
            Runtime:removeEventListener( "enterFrame", enterFrameListener2 )
            display.getCurrentStage():setFocus( nil )
            event.target.isFocus = false
        end
    end
    return true
end


function scene:create( event )

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

		local sceneGroup = self.view

		physics.start()

		local background = display.newImageRect("bg.png",display.actualContentWidth,display.actualContentHeight)
		background.x=display.contentCenterX
		background.y=display.contentCenterY

		local ceiling =display.newImageRect("invTile.png",display.actualContentWidth,display.contentHeight*0.1)
    ceiling.x = display.contentCenterX
    ceiling.y = -1*display.actualContentHeight-50
    physics.addBody(ceiling, "static", {density=.1, bounce=0.1, friction=.2})


    local Floor = display.newImageRect("invTile.png",display.actualContentWidth,display.contentHeight*0.1)
    Floor.x = display.contentCenterX
    Floor.y = display.actualContentHeight-20
    physics.addBody(Floor, "static", {density=.1, bounce=0.1, friction=.2})


		local ground = display.newImageRect("BT.png",display.actualContentWidth,display.contentHeight*0.3)
		ground.x=display.contentCenterX
		ground.y=display.contentHeight


		city1 = display.newImage("city1.png")
    city1.x = 0
    city1.y =	display.contentCenterY
    city1.speed = 3


    city2 = display.newImage("city1.png")
    city2.x = display.actualContentWidth
    city2.y =	display.contentCenterY
    city2.speed = 3
		--print(city1.x..city1.y)
		--print(city2.x..city2.y)

    city3 = display.newImage("city2.png")
    city3.x = 0
    city3.y =	display.contentHeight*0.7
    city3.speed = 6


    city4 = display.newImage("city2.png")
    city4.x = display.actualContentWidth-100
    city4.y =	display.contentHeight*0.7
    city4.speed = 6


		local sheetOptions = {
		    width = 687,
		    height = 1276,
		    numFrames = 6,
		    sheetContentWidth = 1380,
		    sheetContentHeight = 3836
		}

		local sheet_character = graphics.newImageSheet( "0.png", sheetOptions )

		local sequences_character = {
		    {
		        name = "run",
		        --start = 1 + selOffset,
		        --count = 4,
		        frames = {1,2,3,4,5,6},
		        time = 600,
		        loopCount = 0,
		    },
		}

		-- And, create the player that it belongs to
	 	player = display.newSprite( sheet_character, sequences_character )
		player:setSequence( "run" )
		player:setFrame( 1 )

		player:scale(0.1,0.1)
		player:play()
		player.x=display.contentWidth*0.1
		player.y=display.contentHeight*0.9
		local playershape = {-40,-60,40,50,-40,50,40,-60}
		physics.addBody(player,{friction=1,shape=playershape})

		--print("player cords:"..player.x .. " " .. player.y)

		local PauseBtn = widget.newButton
		{
			width = 50,
			height = 50,
			defaultFile = "PauseBtn.png",
			overFile = "PauseBtn.png",
			label = "",
			onEvent = Pause
		}
		PauseBtn.x=display.contentWidth*0.1-20
		PauseBtn.y=display.contentHeight*0.1

		jumpBtn = widget.newButton
		{
			width = 50,
			height = 50,
			defaultFile = "jumpBtn.png",
			overFile = "jumpBtn-over.png",
			label = "",
			onEvent = jump
		}
		jumpBtn.x=display.contentWidth*0.8+20
		jumpBtn.y=display.contentHeight*0.7

		rightBtn = widget.newButton
		{
			width = 50,
			height = 50,
			defaultFile = "rightBtn.png",
			overFile = "rightBtn-over.png",
			label = "",
			onEvent = right
		}
		rightBtn.x=jumpBtn.x+50
		rightBtn.y=jumpBtn.y+50

		leftBtn = widget.newButton
		{
			width = 50,
			height = 50,
			defaultFile = "leftBtn.png",
			overFile = "leftBtn-over.png",
			label = "",
			onEvent = left
		}
		leftBtn.x=jumpBtn.x-50
		leftBtn.y=jumpBtn.y+50

		panel = widget.newPanel
		{
			location = "top",
			onComplete = panelTransDone,
			width = display.contentWidth * 0.5,
			height = display.contentHeight * 0.45,
			speed = 250,
			inEasing = easing.outBack,
			outEasing = easing.outCubic
		}

		panel.background = display.newRect( 0, 0, panel.width, panel.height )
		panel.background:setFillColor( 100/255,60/255,0/255 )
		panel:insert( panel.background )

		panel.resumeBTN = widget.newButton
    {
        label = "Resume",
        onEvent = resumegame,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
		panel.resumeBTN.x=0
		panel.resumeBTN.y=-30
		panel:insert(panel.resumeBTN)

		panel.exitBTN = widget.newButton
    {
        label = "Exit to Menu",
        onEvent = exittomenu,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
		panel.exitBTN.x=0
		panel.exitBTN.y=30
		panel:insert(panel.exitBTN)

		sceneGroup:insert(background)
		sceneGroup:insert(ceiling)
		sceneGroup:insert(Floor)
		sceneGroup:insert(city1)
		sceneGroup:insert(city2)
		sceneGroup:insert(city3)
		sceneGroup:insert(city4)
		sceneGroup:insert(ground)
		sceneGroup:insert(player)
		sceneGroup:insert(PauseBtn)
		sceneGroup:insert(jumpBtn)
		sceneGroup:insert(rightBtn)
		sceneGroup:insert(leftBtn)
		sceneGroup:insert(panel)
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		local currScene = composer.getSceneName( "current" )
		local previusScene = composer.getSceneName( "previous" )
		--print(currScene .. previusScene)
		if(Runtime._functionListeners.enterFrame)then
			Runtime:removeEventListener( "enterFrame", city1)
		end
		if(currScene=="level1" and previusScene == "menu" and Runtime._functionListeners.enterFrame==nil) then
			city1.enterFrame = scrollCity
			Runtime:addEventListener("enterFrame", city1)

			city2.enterFrame = scrollCity
			Runtime:addEventListener("enterFrame", city2)

			city3.enterFrame = scrollCity
			Runtime:addEventListener("enterFrame", city3)

			city4.enterFrame = scrollCity
			Runtime:addEventListener("enterFrame", city4)
			--print("LOLLOL")
		end
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
		local previusScene = composer.getSceneName( "previus" )
	elseif phase == "did" then
		-- Called when the scene is now off screen

	end

end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
