-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )
-- include the Corona "composer" module
local composer = require "composer"

local AdBuddiz = require "plugin.adbuddiz"
  --AdBuddiz.setTestModeActive()
  AdBuddiz.setAndroidPublisherKey("3d9deac0-8858-4e74-a879-2e66dc1f19c5");
  AdBuddiz.cacheAds()
  AdBuddiz.showAd()
  --AdBuddiz.setIOSPublisherKey( "TEST_PUBLISHER_KEY_IOS" )
-- load menu screen
composer.gotoScene( "menu" )
