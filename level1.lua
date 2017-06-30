-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------
math.randomseed( os.time() )
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

local spawnTimer
local spawnedObjects = {}

local spawnParams = {
    xMin = display.contentWidth*0.8,
    xMax = display.contentWidth*0.9,
    yMin = display.contentCenterY+110,
    yMax = display.contentCenterY+110,
    spawnTime = 1000,
    spawnOnTimer = 12,
    spawnInitial = 4
}


-- Spawn an item
function spawnItem( bounds )
		--[[barricade=display.newImageRect( "barricade.png", 100, 100 )
		barricade.x=display.contentCenterX
		barricade.y=display.contentCenterY+110
		barricade.id="BR"
		local shape = {-40,-40,40,20,-40,20,40,-40}
		physics.addBody( barricade, "kinematic",{friction=1,shape=shape})
		barricade.isSensor=true]]
    -- create sample item
    local item = display.newImageRect( "barricade.png", 100, 100 )
		item.speed=4
		item.enterFrame = scrollCity
		item.id="BR"
		Runtime:addEventListener("enterFrame", item)
		--sceneGroup:insert(item)
    -- position item randomly within set bounds
    item.x = math.random( bounds.xMin, bounds.xMax )
    item.y = math.random( bounds.yMin, bounds.yMax )
    -- add item to spawnedObjects table for tracking purposes
		local shape = {-40,-40,40,20,-40,20,40,-40}
		physics.addBody( item, "kinematic",{friction=1,shape=shape})
		item.isSensor=true

		jumpBtn:toFront()
		rightBtn:toFront()
		leftBtn:toFront()

    spawnedObjects[#spawnedObjects+1] = item
end

function spawnController( action, params )
	-- cancel timer on "start" or "stop", if it exists
     if ( spawnTimer and ( action == "start" or action == "stop" ) ) then
         timer.cancel( spawnTimer )
     end
		 -- Start spawning
	if ( action == "start" ) then
			-- gather/set spawning bounds
			local spawnBounds = {}
			spawnBounds.xMin = params.xMin or 0
			spawnBounds.xMax = params.xMax or display.contentWidth
			spawnBounds.yMin = params.yMin or 0
			spawnBounds.yMax = params.yMax or display.contentHeight
			-- gather/set other spawning params
			local spawnTime = params.spawnTime or 1000
			local spawnOnTimer = params.spawnOnTimer or 50
			local spawnInitial = params.spawnInitial or 0
		spawnTimer = timer.performWithDelay( math.random(3000, 5000),
				function() spawnItem( spawnBounds ); end,
		-1 )elseif ( action == "pause" ) then
				timer.pause( spawnTimer )
		-- Resume spawning
		elseif ( action == "resume" ) then
				timer.resume( spawnTimer )
		end
end

function removeAllListeners(obj)
  obj._functionListeners = nil
  obj._tableListeners = nil
	print("K")
end

--Todo fix barricade loops
function scrollCity(self,event)
	if self ~= nil then
	if self ~= nil and self.id=="BR" and self.x < -1* display.actualContentWidth + 200 then
		Runtime:removeEventListener("enterFrame",self)
		--self:removeSelf()
		--print("logging")
	end
end
	if self.x < -1* display.actualContentWidth + 200 then
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
		--audio.resume( 1 )
		--print("dasdas")
		panel:hide()
		spawnController("resume")
end

function Pause()
		city1.speed=0
		city2.speed=0
		city3.speed=0
		city4.speed=0
		player:pause()
		for k,v in pairs(spawnedObjects) do
				print("da")
		end
		--audio.pause( 1 )
		panel:show()
		spawnController("pause")
end

function exittomenu(event)
		panel:hide()
		composer.gotoScene( "menu","fade",800 )
		--audio.resume(1)
end

function jump (event)
	if event.phase~="moved" and event.phase=="began" and canjump==1 then
		--print("jump"..canjump)
		canjump=0
		player:applyForce(0,-23,player.x,player.y)
	end

end


local holding = false
local function enterFrameListener()
    if holding then
        -- Holding button
				player.xScale=0.1
				--print("right")
				if player.x+3<=display.contentWidth then
					player.x=player.x+3
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
					--print("dank")

				end
				if(event.phase ~= "moved") then
					holding = false
					Runtime:removeEventListener( "enterFrame", enterFrameListener )
					display.getCurrentStage():setFocus( nil )
					event.target.isFocus = false
				end
        if event.phase == "ended" then
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
				--print("LEFT")
				player.xScale=-0.1
				if player.x-3>=0 then
					player.x=player.x-3
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
				end
				if(event.phase ~= "moved") then
					holding2 = false
					Runtime:removeEventListener( "enterFrame", enterFrameListener2 )
					display.getCurrentStage():setFocus( nil )
					event.target.isFocus = false
				end
        if event.phase == "ended" then
            holding2 = false
            Runtime:removeEventListener( "enterFrame", enterFrameListener2 )
            display.getCurrentStage():setFocus( nil )
            event.target.isFocus = false
        end
    end
    return true
end

function Settings(event)
		--print("()")
		panel:hide()
		panel2:show()
end

function Back(event)
		panel2:hide()
		panel:show()
end

function onplayercollison(self,event)
	if(event.other.id=="FL") then
		--print("llsad")
		canjump=1
	end
	if(event.other.id=="BR") then
		--print("llsad")
		--physics.removeBody( event.other )
		local myClosure = function()
			timer.cancel( game )

		local saveData = meters

		-- Path for the file to write
		local path = system.pathForFile( "record.txt", system.DocumentsDirectory )

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

			rightBtn.isVisible=false
			leftBtn.isVisible=false
			jumpBtn.isVisible=false
			--player.x=display.contentCenterX
			--player.y=display.contentCenterY
			for i=1,#spawnedObjects do
				--print(i)
				Runtime:removeEventListener("enterFrame",spawnedObjects[i])
				if spawnedObjects[i]~=nil then
						print("deleted")
						spawnedObjects[i]:removeSelf()
						spawnedObjects[i]=nil
				end
			end
			spawnController( "stop" )
			composer.gotoScene( "over" ,"flipFadeOutIn",500 )
		end
		timer.performWithDelay( 500, myClosure, 1 )
	end
	--print( event.target.id )        --the first object in the collision
	--print( event.other.id )         --the second object in the collision
end

function sliderListener( event )
	local value = event.value

	audioVolume = value / 100
	audioVolume = string.format('%.02f', audioVolume )

	panel2.volumeLabel.text = "Music Volume: " .. audioVolume

		audio.setVolume( audioVolume, { channel = 1 } )
end

function increaselenght()
		meters=meters+1
		print(meters)
end

function scene:create( event )

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
		canjump=0
		meters=0

		game=timer.performWithDelay( 1000, increaselenght , -1 )


		local sceneGroup = self.view

		physics.start()

		local background = display.newImageRect("bg.png",display.actualContentWidth,display.actualContentHeight)
		background.x=display.contentCenterX
		background.y=display.contentCenterY

		local ceiling =display.newImageRect("invTile.png",display.actualContentWidth,display.contentHeight*0.1)
    ceiling.x = display.contentCenterX
    ceiling.y = -1*display.actualContentHeight-50
    physics.addBody(ceiling, "static", {density=.1, bounce=0.1, friction=.2})
		ceiling.id="CL"

    local Floor = display.newImageRect("invTile.png",display.actualContentWidth,display.contentHeight*0.1)
    Floor.x = display.contentCenterX
    Floor.y = display.actualContentHeight-10
    physics.addBody(Floor, "static", {density=.1, bounce=0.1, friction=.2})
		Floor.id="FL"

		local ground = display.newImageRect("BT.png",display.actualContentWidth,display.contentHeight*0.3)
		ground.x=display.contentCenterX
		ground.y=display.contentHeight


		city1 = display.newImage("city1.png")
    city1.x = 0
    city1.y =	display.contentCenterY
    city1.speed = 3


    city2 = display.newImage("city1.png")
    city2.x = display.actualContentWidth-100
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
		player.id="PL"
		local playershape = {-40,-60,40,50,-40,50,40,-60}
		physics.addBody(player,{friction=1,shape=playershape})
		player.collision = onplayercollison
		player:addEventListener( "collision" )

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
			height = display.contentHeight * 0.7,
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
		panel.resumeBTN.y=-60
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
			panel.exitBTN.y=60
			panel:insert(panel.exitBTN)

			panel.SettingsBTN = widget.newButton
			{
			label = "Settings",
			onEvent = Settings,
			emboss = false,
			shape = "roundedRect",
			width = 200,
			height = 40,
			cornerRadius = 2,
			fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
			strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
			strokeWidth = 4
			}

	 	panel.SettingsBTN.x=0
	 	panel.SettingsBTN.y=0

	 	panel:insert(panel.SettingsBTN)

	 	panel2 = widget.newPanel
	 	{
		 location = "top",
		 onComplete = panelTransDone2,
		 width = display.contentWidth * 0.5,
		 height = display.contentHeight * 0.45,
		 speed = 250,
		 inEasing = easing.outBack,
		 outEasing = easing.outCubic
	 	}

	 	panel2.background = display.newRect( 0, 0, panel2.width, panel2.height )
	 	panel2.background:setFillColor( 100/255,60/255,0/255 )
	 	panel2:insert( panel2.background )


		panel2.exitBTN = widget.newButton
    {
        label = "Back",
        onEvent = Back,
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

		panel2.exitBTN.x=0
		panel2.exitBTN.y=30
		panel2:insert(panel2.exitBTN)

		audioVolume = 0.5

	 	panel2.volumeSlider = widget.newSlider
		{
			width = display.contentWidth*0.35,
			orientation = "horizontal",
			listener = sliderListener
		}
		panel2.volumeSlider.x=-80
		panel2.volumeSlider.y=-30
		panel2:insert(panel2.volumeSlider)

		panel2.volumeLabel = display.newText( "Music Volume: " .. audioVolume, 0 , panel2.volumeSlider.y-25,
		 native.systemFont, 18 )

		panel2:insert(panel2.volumeLabel)

		spawnController("start",spawnParams)

		sceneGroup:insert(background)
		sceneGroup:insert(ceiling)
		sceneGroup:insert(Floor)
		sceneGroup:insert(city1)
		sceneGroup:insert(city2)
		sceneGroup:insert(city3)
		sceneGroup:insert(city4)
		sceneGroup:insert(ground)
		--sceneGroup:insert(barricade)
		sceneGroup:insert(player)
		sceneGroup:insert(PauseBtn)
		sceneGroup:insert(jumpBtn)
		sceneGroup:insert(rightBtn)
		sceneGroup:insert(leftBtn)
		sceneGroup:insert(panel)
		sceneGroup:insert(panel2)
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

			--barricade.enterFrame = scrollCity
			--Runtime:addEventListener("enterFrame", barricade)
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
