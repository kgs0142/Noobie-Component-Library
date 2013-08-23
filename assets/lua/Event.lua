local FlxG = as3.class.org.flixel.FlxG
local FlxControl = as3.class.org.flixel.plugin.photonstorm.FlxControl;
local CGamePlayModule = as3.class.com.game.module.CGamePlayModule;
local CGameOverModule = as3.class.com.game.module.CGameOverModule;
local TweenLite = as3.class.com.greensock.TweenLite;
local bitflag = sceneMgr.cTriggerFlag;

--sceneMgr.sCurScenePath = "Scene/Level_Entrance.xml";

local replayAgain = false;
function lua_e001()
	if (as3.tolua(bitflag.check(001)) == true) then
		print("I did this before")
		return;
	end

    FlxControl.stop();

    if (replayAgain == true) then
    	player.ftDialog.text = "Here AGAIN???!!!!"
    	audioMgr.PlaySnd("Dialog", 0.5);
    	TweenLite.delayedCall(2.5, lua_e001_02);
    else
    	player.play("up")
	    player.ftDialog.text = "Aw....."
	    audioMgr.PlaySnd("Dialog", 0.5);
	    TweenLite.delayedCall(1.5, lua_e001_00);
	end
end

function lua_e001_00()
    player.ftDialog.text = "What the hell happened here?!"
    audioMgr.PlaySnd("Dialog", 0.5);
    TweenLite.delayedCall(1.5, lua_e001_01);
end

function lua_e001_01()
    player.ftDialog.text = "Need find a way out of here..."
    audioMgr.PlaySnd("Dialog", 0.5);
    TweenLite.delayedCall(1.5, lua_e001_02);
end

function lua_e001_02()
	player.ftDialog.text = "";
	FlxControl.start();
    bitflag.bitOn(001)
end

--
function lua_e002()
	--it's loop trigger, so dont check, just do, but need to lock the trigger'overlap
	--if (as3.tolua(bitflag.check(002)) == true) then return;	end

	trigger.bLockOverlap = true;

    FlxControl.stop();
    player.velocity.x = 0;
    player.velocity.y = 0;
    player.acceleration.x = 0;
    player.acceleration.y = 0;
    audioMgr.PlaySnd("W", 0.5);
    player.ftDialog.text = "Here has a diary."
    TweenLite.delayedCall(1.5, lua_e002_00);
end

function lua_e002_00()
    player.ftDialog.text = "Lots of pages are destroyed."
    TweenLite.delayedCall(1.5, lua_e002_01);
end

function lua_e002_01()
    player.ftDialog.text = "2012/12/14...'Think what have you done.'"
    TweenLite.delayedCall(1.5, lua_e002_02);
end

function lua_e002_02()
    player.ftDialog.text = "What's a stupid diary"
    TweenLite.delayedCall(0.5, lua_e002_03);
end

function lua_e002_03()
    player.ftDialog.text = ""
    trigger.bLockOverlap = false;
    FlxControl.start();
    --ending flag
	bitflag.bitOn(002)
end

--
--open door to out door
function lua_e003()
	trigger.bLockOverlap = true;
	--change scene
	audioMgr.PlaySnd("HitSound", 0.5);
	sceneMgr.sCurScenePath = "Scene/Level_OutRoom.xml";
	FlxG.resetState();
end

--

--out of room---------------------------------------------------------------------------------------

function lua_e004()
	if (as3.tolua(bitflag.check(004)) == true) then
		print("I did 004 before")
		return;
	end

    FlxControl.stop();
    player.velocity.y = -100
	--shock to 9
	sceneMgr.iPlayerHP = 9;
    player.ftDialog.text = "What the ...!!!"
    TweenLite.delayedCall(1.5, lua_e004_00);
end

function lua_e004_00()
	player.ftDialog.text = "Oh MY GOSH!! the kid is dead..."
	TweenLite.delayedCall(1.5, lua_e004_01);
end

function lua_e004_01( ... )
	enemy.visible = true;
	enemy.active = true;

	enemy.ftDialog.text = "*roar*..."
	TweenLite.delayedCall(1.5, lua_e004_02);
end

function lua_e004_02()
	enemy.ftDialog.text = ""
	player.ftDialog.text = "!!!!!!!!"
	TweenLite.delayedCall(0.5, lua_e004_03);
end

function lua_e004_03()
	player.ftDialog.text = "";
	FlxControl.start();
    bitflag.bitOn(004)
end

--
function lua_e005()
	if (as3.tolua(enemy.active) == true) then
		player.ftDialog.text = "take care the ..creature first!!"
		TweenLite.delayedCall(0.5, function_clear_player_dlg);
		return;
	end

	trigger.bLockOverlap = true;

    FlxControl.stop();
    player.velocity.x = 0;
    player.velocity.y = 0;
    player.acceleration.x = 0;
    player.acceleration.y = 0;
    player.ftDialog.text = "... ..."
    TweenLite.delayedCall(1.5, lua_e005_00);
end

function lua_e005_00()
    player.ftDialog.text = "... he seem so familiar ..."
    TweenLite.delayedCall(1.5, lua_e005_01);
end

function lua_e005_01()
    player.ftDialog.text = "But I really don't remember..."
    TweenLite.delayedCall(1.5, lua_e005_02);
end

function lua_e005_02()
    
	trigger.bLockOverlap = false;

	player.ftDialog.text = "";
	FlxControl.start();
    bitflag.bitOn(005)
end

--
--open door to first place
function lua_e006()
	if (as3.tolua(enemy.active) == true) then
		player.ftDialog.text = "take care the skull first!!"
		TweenLite.delayedCall(0.5, function_clear_player_dlg);
		return;
	end

	trigger.bLockOverlap = true;
	--change scene
	audioMgr.PlaySnd("HitSound", 0.5);
	sceneMgr.sCurScenePath = "Scene/Level_First.xml";
	FlxG.resetState();
end

--open door to out of kitchen
function lua_e007()
	trigger.bLockOverlap = true;
	--change scene
	audioMgr.PlaySnd("HitSound", 0.5);
	sceneMgr.sCurScenePath = "Scene/Level_OutKitchen.xml";
	FlxG.resetState();
end

--out kitchen
function lua_e008()
	--if (as3.tolua(enemy.active) == true) then
		--player.ftDialog.text = "take care the skull first!!"
		--TweenLite.delayedCall(0.5, function_clear_player_dlg);
		--return;
	--end

	trigger.bLockOverlap = true;
	--change scene
	sceneMgr.sCurScenePath = "Scene/Level_OutRoom.xml";
	FlxG.resetState();
end

function lua_e009(  )
	if (as3.tolua(bitflag.check(009)) == true) then
		print("I did this before")
		return;
	end

	audioMgr.PlaySnd("SanityEffect", 0.5);
	trigger.cAITarget.play("dieAnim")

    bitflag.bitOn(009)
end

function lua_e010( )
	trigger.bLockOverlap = true;
	audioMgr.PlaySnd("EarthQuake", 0.5);
	player.ftDialog.text = "The door is broken";
	TweenLite.delayedCall(1.5, function_clear_player_dlg);
end

--function lua_e010_00()
	--trigger.bLockOverlap = false;
	--function_clear_player_dlg();
--end

function lua_e011()
	sceneMgr.sCurScenePath = "Scene/Level_LivingRoom.xml";
	FlxG.resetState();
end

--
--LivingRoom

function lua_e012()
	--change scene
	sceneMgr.sCurScenePath = "Scene/Level_OutKitchen.xml";
	FlxG.resetState();
end

local tvCheckTimes = 0
function lua_e013()
	local dialog =
	{
		"It's a TV, let's watch",
		"'When you stare into the abyss'",
		"...'the abyss looks into you'",
		"I dont want to watch this anymore.",
		"I dont want to watch this anymore."
	}

	trigger.bLockOverlap = true;

	tvCheckTimes = tvCheckTimes + 1
	if (tvCheckTimes > 4) then tvCheckTimes = 4 end

	
	player.ftDialog.text = dialog[tvCheckTimes]
	TweenLite.delayedCall(2.5, function_clear_player_dlg);

	audioMgr.PlaySnd("W");

	if (tvCheckTimes == 3 and
		as3.tolua(bitflag.check(13)) == false) then

		audioMgr.PlaySnd("SanityEffect2");

		FlxG.shake(0.005, 0.05)

	    FlxControl.stop();
	    player.velocity.x = 0;
	    player.velocity.y = 0;
	    player.acceleration.x = 0;
	    player.acceleration.y = 0;

		--ending condion
		bitflag.bitOn(13)
		sceneMgr.ShowTvShader();

		TweenLite.killDelayedCallsTo(function_clear_player_dlg)
		TweenLite.delayedCall(1.0, function_mad_player_001, 
							  as3.toarray({as3.tolua(sceneMgr.ShowNormalShader)}))
		--function_mad_player_001(sceneMgr.ShowNormalShader)
	end
end

local hangerCheckTimes = 0
function lua_e014( )
	trigger.bLockOverlap = true;
	player.ftDialog.text = "seems here lives a doctor and a child"
	TweenLite.delayedCall(2.0, function_clear_player_dlg);

	hangerCheckTimes = hangerCheckTimes + 1
	if (hangerCheckTimes == 2) then
		audioMgr.PlaySnd("Laugh", 0.5)
	end
end

function lua_e015()
	sceneMgr.sCurScenePath = "Scene/Level_Entrance.xml";
	FlxG.resetState();
end

--

--entrance
--go to the 2nd world
local gotTheKey = false
local hallway_Counter1 = 0
local hallway_Counter2 = 0
function lua_e016()
	if (hallway_Counter1 < 3 and hallway_Counter2 < 3) then
		sceneMgr.sCurScenePath = "Scene/Level_HallWay.xml";
	elseif (gotTheKey == true) then
        FlxControl.stop();
        player.velocity.x = 0;
        player.velocity.y = 0;
        player.acceleration.x = 0;
        player.acceleration.y = 0;
		player.ftDialog.text = "Why do you want to go back?!"
		TweenLite.delayedCall(1.5, function_clear_player_dlg);
		return;
	else
		sceneMgr.sCurScenePath = "Scene/Level_LivingRoom_2.xml";
	end

	FlxG.resetState();
end

--the final--------------------------------------------------------------------------------------------------
function lua_e017()

	trigger.bLockOverlap = true;

	if (gotTheKey == false) then
		audioMgr.PlaySnd("EarthQuake", 0.5)
		player.ftDialog.text = "Oh my... I need the key to get out of here!"
		TweenLite.delayedCall(1.5, function_clear_player_dlg)
		return;
	end

	audioMgr.PlayMusic("Music002")
	
	end_ingame000()
end

--play the final ingame*****************************************************************************
function end_ingame000()
	--play fog effect, player down
	--player
	--player.active = false;
    FlxControl.stop();
    player.velocity.x = 0;
    player.velocity.y = 0;
    player.acceleration.x = 0;
    player.acceleration.y = 0;
	player.play("down")
	player.ftDialog.text = "Ahhhhhh!"

	trigger.bLockOverlap = true;
	--player.kill();

	enemy.active = true;
	enemy.visible = true;
	enemy.bPauseUpdate = true;

	TweenLite.delayedCall(1.5, end_ingame001)
end

function end_ingame001()
	player.ftDialog.text = ""
	enemy.ftDialog.text = "That's pretty weird...his multiple personality disorder."
	TweenLite.delayedCall(3, end_ingame002)
end

function end_ingame002()
	enemy.ftDialog.text = "He is always mental instability. why does the tricks no effect"
	TweenLite.delayedCall(3, end_ingame003)
end

function end_ingame003()
	enemy.ftDialog.text = "But why...why this time he's so strong."
	TweenLite.delayedCall(3, end_ingame004)
end

function end_ingame004()
	enemy.ftDialog.text = "... ...just like god is helping him."
	TweenLite.delayedCall(3, end_ingame005)
end

function end_ingame005()
	enemy.ftDialog.text = "HE KILL MY OWN CHILD, the ex-patient."
	TweenLite.delayedCall(3, end_ingame006)
end

function end_ingame006()
	enemy.ftDialog.text = "No matter how many times do I have to try."
	TweenLite.delayedCall(3, end_ingame007)
end

function end_ingame007()
	enemy.ftDialog.text = "I will get his another personality."
	TweenLite.delayedCall(3, end_ingame008)
end

function end_ingame008()
	enemy.ftDialog.text = "And take him to court myself."
	TweenLite.delayedCall(3, end_ingame009)
end

function end_ingame009()
	enemy.ftDialog.text = "YOU VILLAIN!"

	replayAgain = true;
	
	sceneMgr.sCurScenePath = "Scene/Level_First.xml";
	
	--fade out
	camera.fade(4278190080, 2, end_ingame010);
	--ending
end

function end_ingame010()
	FlxG.switchState(CGameOverModule.new())
end

--Hallway
function lua_e018()
	hallway_Counter1 = hallway_Counter1 + 1;

	trigger.bLockOverlap = true;
	if (hallway_Counter1 > 3) then 
		sceneMgr.sCurScenePath = "Scene/Level_HallWay_2.xml";
	end
		
	FlxG.resetState();
end

function lua_e019()
	hallway_Counter1 = hallway_Counter1 + 1;

	trigger.bLockOverlap = true;
	if (hallway_Counter1 > 3) then 
		sceneMgr.sCurScenePath = "Scene/Level_HallWay_2.xml";
	end

	FlxG.resetState();
end

--HallWay2
function lua_e020()
	hallway_Counter2 = hallway_Counter2 + 1;

	trigger.bLockOverlap = true;

	if (hallway_Counter2 == 3) then
		function_mad_player_001()
		return;
	elseif (hallway_Counter2 > 3) then 
		sceneMgr.sCurScenePath = "Scene/Level_LivingRoom_2.xml";
	end
		
	FlxG.resetState();
end

function lua_e021()
	hallway_Counter2 = hallway_Counter2 + 1;

	trigger.bLockOverlap = true;
	if (hallway_Counter2 == 3) then
		function_mad_player_001()
		return;
	elseif (hallway_Counter2 > 3) then 
		sceneMgr.sCurScenePath = "Scene/Level_LivingRoom_2.xml";
	end
		
	FlxG.resetState();
end

--Living Room 2
function lua_e022()
	sceneMgr.sCurScenePath = "Scene/Level_Entrance.xml";
	FlxG.resetState();
end

function lua_e024()
	sceneMgr.sCurScenePath = "Scene/Level_OutKitchen_2.xml";
	FlxG.resetState();
end

function lua_e023()
	if (as3.tolua(bitflag.check(023)) == true) then
		print("I did this before")
		return;
	end

	trigger.cAITarget.visible = true;
	trigger.cAITarget.active = true;

	bitflag.bitOn(023)
end

--outKitchen_2
function lua_e025()
	sceneMgr.sCurScenePath = "Scene/Level_LivingRoom_2.xml";
	FlxG.resetState();
end

local  dialogIndex2 = 1
function lua_e026()
	local dialog2 = 
	{
		"I am not go in there!!!!",
		"Never!!!!",
		"What are you thinking!!!!"
	}

	if (dialogIndex2 > 3) then
		dialogIndex2 = 3
	end

    FlxControl.stop();
    player.velocity.x = 0;
    player.velocity.y = 0;
    player.acceleration.x = 0;
    player.acceleration.y = 0;
	trigger.bLockOverlap = true;

	player.ftDialog.text = dialog2[dialogIndex2]

	dialogIndex2 = dialogIndex2 + 1;

	TweenLite.delayedCall(1.5, function_clear_player_dlg)
end

function lua_e027()
	sceneMgr.sCurScenePath = "Scene/Level_OutRoom_2.xml";
	FlxG.resetState();
end

--Level_OutRoom_2
function lua_e028()
	sceneMgr.sCurScenePath = "Scene/Level_OutKitchen_2.xml";
	FlxG.resetState();
end

function lua_e030()
	sceneMgr.sCurScenePath = "Scene/Level_First_2.xml";
	FlxG.resetState();
end

function lua_e029()
	if (as3.tolua(bitflag.check(029)) == true) then
		print("I did this before")
		return;
	end

    FlxControl.stop();
    player.velocity.x = 0;
    player.velocity.y = 0;
    player.acceleration.x = 0;
    player.acceleration.y = 0;
	player.play("down")
	player.ftDialog.text = "Aw....."
	TweenLite.delayedCall(2, lua_e029_00)
	
end

function lua_e029_00()
	player.ftDialog.text = "My head....."
	TweenLite.delayedCall(2, lua_e029_01)
end

function lua_e029_01()
	player.ftDialog.text = "NO! It's not my fault! leave me alone!!"
	TweenLite.delayedCall(2, lua_e029_02)
end

local fakeAI = as3.class.com.ai.CBaseAI.new();
function lua_e029_02()
	--play QTE
	player.ftDialog.text = ""
	fakeAI.sQTEFn = "playerEnemyQte3Times"
	QTEMgr.Active(player, fakeAI, finalGetKeyPlayerQTEOK, nil, lua_e029_03);
end

function lua_e029_03()
	player.play("idle")
	bitflag.bitOn(029)
end


--first_2

function lua_e031()
	if (gotTheKey == false) then
        FlxControl.stop();
        player.velocity.x = 0;
        player.velocity.y = 0;
        player.acceleration.x = 0;
        player.acceleration.y = 0;
		player.ftDialog.text = "I need to get the key to escape."
		TweenLite.delayedCall(2, function_clear_player_dlg);
		return;
	end	

	sceneMgr.sCurScenePath = "Scene/Level_Entrance.xml";
	FlxG.resetState();
end

function lua_e032()
	if (as3.tolua(bitflag.check(032)) == true) then
		print("I did this before")
		return;
	end

    FlxControl.stop();
    player.velocity.x = 0;
    player.velocity.y = 0;
    player.acceleration.x = 0;
    player.acceleration.y = 0;
	player.play("down");
	TweenLite.delayedCall(2, lua_e032_01)
end

function lua_e032_01()
	player.play("cry")
	player.ftDialog.text = "I can't hold it for anymore..."
	TweenLite.delayedCall(4, lua_e032_02)
end


function lua_e032_02()
	player.ftDialog.text = ""
	fakeAI.sQTEFn = "finalGetKeyQTE"
	QTEMgr.Active(player, fakeAI, finalGetKeyPlayerQTEOK, finalGetKeyPlayerQTEFail, lua_e032_03);
end

function lua_e032_03()
	player.play("idle")
	player.ftDialog.text = "OK, I got the key from the corpse, let's move out."
	TweenLite.delayedCall(2, lua_e032_04)
end

function lua_e032_04()
	FlxControl.start();
	gotTheKey = true
	bitflag.bitOn(032)
end

------------------------------------------------------------------------------------------------------------
function function_clear_player_dlg()
	if (trigger ~= nil) then trigger.bLockOverlap = false; end
	FlxControl.start();
    player.ftDialog.text = ""
end

local madComplete;
function function_mad_player_001(onComplete)
	madComplete = onComplete;

    FlxControl.stop();
    player.velocity.x = 0;
    player.velocity.y = 0;
    player.acceleration.x = 0;
    player.acceleration.y = 0;
    -- play anim
    player.ftDialog.text = "This..."

    TweenLite.delayedCall(1.8, function_mad_player_001_00);
end

function function_mad_player_001_00( )
    player.ftDialog.text = "...cannot be..."

    TweenLite.delayedCall(0.8, function_mad_player_001_02);
end

function function_mad_player_001_02()
    player.ftDialog.text = "HAPPENING!!!!!!!!"

    TweenLite.delayedCall(2.5, function_mad_player_001_03);
end

function function_mad_player_001_03()
	player.ftDialog.text = ""
	FlxControl.start()

	if (madComplete ~= nil) then
		madComplete()
	end
end
