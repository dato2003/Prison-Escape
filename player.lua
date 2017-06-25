
--

-- Create our player sprite sheet
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
        name = "walk-left",
        --start = 1 + selOffset,
        --count = 4,
        frames = {1,2,3,4,5,6},
        time = 600,
        loopCount = 0,
    },
}

-- And, create the player that it belongs to
local character = display.newSprite( sheet_character, sequences_character )
character:setSequence( "run" )
character:setFrame( 1 )

return character

--[[
local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {

        {
            -- 3_terrorist_3_Run_000
            x=2,
            y=2,
            width=687,
            height=1276,

        },
        {
            -- 3_terrorist_3_Run_001
            x=691,
            y=2,
            width=687,
            height=1276,

        },
        {
            -- 3_terrorist_3_Run_002
            x=2,
            y=1280,
            width=687,
            height=1276,

        },
        {
            -- 3_terrorist_3_Run_003
            x=691,
            y=1280,
            width=687,
            height=1276,

        },
        {
            -- 3_terrorist_3_Run_004
            x=2,
            y=2558,
            width=687,
            height=1276,

        },
        {
            -- 3_terrorist_3_Run_005
            x=691,
            y=2558,
            width=687,
            height=1276,

        },
    },

    sheetContentWidth = 1380,
    sheetContentHeight = 3836
}

SheetInfo.frameIndex =
{

    ["3_terrorist_3_Run_000"] = 1,
    ["3_terrorist_3_Run_001"] = 2,
    ["3_terrorist_3_Run_002"] = 3,
    ["3_terrorist_3_Run_003"] = 4,
    ["3_terrorist_3_Run_004"] = 5,
    ["3_terrorist_3_Run_005"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
]]
