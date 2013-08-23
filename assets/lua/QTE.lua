local Tweenlite = as3.class.com.greensock.TweenLite;
local FlxControl = as3.class.org.flixel.plugin.photonstorm.FlxControl;

local LEFT_CLICK  = "Left_Click";
local LEFT_PRESS = "Left_Press";
local RIGHT_CLICK = "Right_Click";
local RIGHT_PRESS = "Right_Press";
local MOUSE_MOVE  = "Mouse_Move";


local table1 =
{
    [1] =
    {
        action = RIGHT_PRESS,
        times = "0",
        counting = "2",
        playerDialog = "I hate skull!!",
        enemyDialog = ""
    },
    [2] =
    {
        action = MOUSE_MOVE,
        times = "10",
        counting = "5",
        playerDialog = "No!",
        enemyDialog = ""
	},
    [3] = 
    {
        action = RIGHT_CLICK, 
        times = "5",
        counting = "5",
        playerDialog = "",
        enemyDialog = ""
    },
    [4] = 
    {   
        action = RIGHT_PRESS, 
        times = "0",
        counting = "2",
        playerDialog = "",
        enemyDialog = ""
    },
    [5] = 
    {
        action = LEFT_CLICK, 
        times = "5",
        counting = "5",
        playerDialog = "",
        enemyDialog = ""
    },
    [6] = 
    {
        action = MOUSE_MOVE, 
        times = "10",
        counting = "5",
        playerDialog = "",
        enemyDialog = ""
    }
}

math.randomseed(os.time())

--rnd 1~4
function playerEnemyRandomQte1()
    iMax = math.random(4)

    tableLength = table.getn(table1)

    arrResult = {}
    for i = 1, iMax do
        index = math.random(tableLength)
        arrResult[i] = as3.toobject(table1[index])
    end

    return as3.toarray(arrResult)   
end

function playerEnemyQte3Times()
    tableLength = table.getn(table1)

    arrResult = {}
    for i = 1, 3 do
        index = math.random(tableLength)
        arrResult[i] = as3.toobject(table1[index])
    end

    return as3.toarray(arrResult)   
end

function playerQTEOK()
    player.play("attack")
    if (enemy ~= nil) then
        enemy.iHP = as3.tolua(enemy.iHP) - 1;
    end
    --print("enemy minus hp: "..as3.tolua(enemy.iHP))
end

function playerQTEFail()
    enemy.play("attack")
    player.play("hurt")
    sceneMgr.iPlayerHP = as3.tolua(sceneMgr.iPlayerHP) - 3;
    --print("player minus hp: "..as3.tolua(player.iHP))
end

--THE FINAL GET KEY QTE
local tableFinal =
{
    [1] =
    {
        action = RIGHT_PRESS,
        times = "0",
        counting = "1.5",
        playerDialog = "I...",
        enemyDialog = ""
    },
    [2] =
    {
        action = MOUSE_MOVE,
        times = "5",
        counting = "3",
        playerDialog = "I didn't kill the kid...",
        enemyDialog = ""
    },
    [3] = 
    {
        action = RIGHT_CLICK, 
        times = "15",
        counting = "5",
        playerDialog = "...",
        enemyDialog = ""
    },
    [4] = 
    {   
        action = RIGHT_PRESS, 
        times = "0",
        counting = "1",
        playerDialog = "My head is hurt...",
        enemyDialog = ""
    },
    [5] = 
    {
        action = LEFT_CLICK, 
        times = "5",
        counting = "2",
        playerDialog = "Who are you?! you can't ...",
        enemyDialog = ""
    },
    [6] = 
    {
        action = MOUSE_MOVE, 
        times = "5",
        counting = "2.5",
        playerDialog = "Gonna control my mind...",
        enemyDialog = ""
    }
}

function finalGetKeyQTE()
    local tableLength = table.getn(tableFinal)

    arrResult = {}
    for i = 1, tableLength do
        arrResult[i] = as3.toobject(tableFinal[i])
    end

    return as3.toarray(arrResult)
end

function finalGetKeyPlayerQTEOK()
end

function finalGetKeyPlayerQTEFail()
    sceneMgr.iPlayerHP = as3.tolua(sceneMgr.iPlayerHP) - 3;
end
--return as3.toobject(table1);              fail
--return as3.toobject(table1[1]);           ok

--local array = {}
--array[1] = as3.toobject(table1[1]);
--array[2] = as3.toobject(table1[3]);
--return as3.toarray(array)                 ok
