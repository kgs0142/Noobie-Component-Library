local FlxG = as3.class.org.flixel.FlxG
local FlxSprite = as3.class.org.flixel.FlxSprite
local FlxObject = as3.class.org.flixel.FlxObject

local portalA = nil
local portalB = nil

local uiJumpTimes = 0
local bTrigger1 = false
local bTrigger2 = false

function PlayerAI_BeforeUpdate()

    
    if (bTrigger1 == false)
    then
        if ((as3.tolua(player.x) == 24) and (as3.tolua(player.y) == 84))
        then
            bTrigger1 = true
            player.makeGraphic(10, 12, 0xaaaaFFFF)
        end
    end
    
    if (bTrigger2 == false)
    then
        if ((as3.tolua(player.x) == 302) and (as3.tolua(player.y) == 108))
        then
            bTrigger2 = true
            FlxG.bgColor = 0xff000000
        end
    end
    
    --teat, shake
    if as3.tolua(keys.justPressed("S"))
    then
        camera.shake();
    end
    
    --teat, flash
    if as3.tolua(keys.justPressed("A"))
    then
        camera.flash();
    end
    
    if as3.tolua(keys.justPressed("Z"))
    then
        if portalA == nil
        then
            portalA = FlxSprite.new(as3.tolua(FlxG.width)/2 - 5)
            portalA.makeGraphic(10, 12, 0xff85ffff)
            portalA.maxVelocity.x = 0
            portalA.maxVelocity.y = 0
            portalA.acceleration.y = 0
            this.add(portalA);
        end
        
        portalA.x = as3.tolua(player.x) - 10
        portalA.y = as3.tolua(player.y)
        
    end
    
    if as3.tolua(keys.justPressed("X"))
    then
        if portalB == nil
        then
            portalB = FlxSprite.new(as3.tolua(FlxG.width)/2 - 5)
            portalB.makeGraphic(10, 12, 0xffffe954)
            portalB.maxVelocity.x = 0
            portalB.maxVelocity.y = 0
            portalB.acceleration.y = 0
            this.add(portalB);
        end

        portalB.x = as3.tolua(player.x) + 10
        portalB.y = as3.tolua(player.y)
        
    end
end

function PlayerAI_AfterUpdate()
    if portalB ~= nil and as3.tolua(FlxG.overlap(player, portalA))
    then
        player.x = portalB.x
        player.y = portalB.y
        this.remove(portalB)
        portalB = nil
    elseif portalA ~= nil and as3.tolua(FlxG.overlap(player, portalB))
    then
        player.x = portalA.x
        player.y = portalA.y
        this.remove(portalA)
        portalA = nil
    end
end
