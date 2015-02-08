--////////////////////////////////////////////////
-- Katana Mission (New Republic)
--////////////////////////////////////////////////

require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")



function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	StoryModeEvents = 
	{
		Battle_Start = Begin_Battle,
		STORY_VICTORY_Player = Return_Katana_Count
	}


	
	marker_list = {}	
	mission_started = false
	
end


function Begin_Battle(message)
	if message == OnEnter then
		empire = Find_Player("Empire")
		rebels = Find_Player("Rebel")
		hutts = Find_Player("Hutts")
		pirates = Find_Player("Yevetha")
		rebels.Make_Ally(pirates)
		hutts.Make_Ally(pirates)
		empire.Make_Ally(pirates)
		pirates.Make_Ally(empire)
		pirates.Make_Ally(rebels)
		pirates.Make_Ally(hutts)
		entry_marker = Find_First_Object("Attacker Entry Position")
		reb_boarders = {"Gallofree_Transport", "Gallofree_Transport", "Gallofree_Transport"}
		imp_boarders = {"Imperial_Landing_Craft", "Imperial_Landing_Craft", "Imperial_Landing_Craft"}
		
		
		player_list = nil
		player = nil

		if rebels.Is_Human() then
			player = rebels
			player_list = reb_boarders
			plot = Get_Story_Plot("Tactical_Katana_NR.XML")
		elseif empire.Is_Human() then
			player_list = imp_boarders
			player = empire
			plot = Get_Story_Plot("Tactical_Katana_IR.XML")
		end

		boarder_list = SpawnList(player_list, entry_marker, player, false, true)

		
		
		


		for j, unit in pairs(boarder_list) do
			Register_Prox(unit, Take_Over_Katana, 200, Find_Player("Neutral"))
			
		end
		

		--spawn = Find_First_Object("STORY_TRIGGER_ZONE_00")
		
		--Spawn_Unit(Find_Object_Type("Katana_Dreadnaught"), spawn, Find_Player("Neutral"))
		list = Find_All_Objects_Of_Type("Katana_Dreadnaught")

		
		event = plot.Get_Event("INCREMENT_FLAG_Katana_Count")
		
		current_cinematic_thread = Create_Thread("Intro_Cinematic")
		mission_started = true
	end
end




function Return_Katana_Count(message)
	if message == OnEnter then
		reb_katana = {}
		katana_list = Find_All_Objects_Of_Type("Katana_Dreadnaught")
		for i, obj in pairs(katana_list) do
			if obj.Get_Owner() == player then
				table.insert(reb_katana, obj)

			end	
		end
		event.Set_Reward_Parameter(1, table.getn(reb_katana))
		Story_Event("INCREMENT_KATANA_COUNT")

		
	end
end



function Take_Over_Katana(self_obj, trigger_obj)
		
	for j, obj in pairs(list) do
		if trigger_obj == obj then
			
			table.remove(list, j)
			trigger_obj.Change_Owner(pirates)
			
			self_obj.Stop()
			self_obj.Suspend_Locomotor(true)
			if self_obj.Get_Owner().Is_Human() then
				Game_Message("BOARDING_KATANA")
			end
			unit_list = {self_obj, trigger_obj}
			Create_Thread("ChangeKatanaOwner",unit_list)
			
						
			
		end
	end
end





function ChangeKatanaOwner(unit_list)

	Sleep(15)

	if TestValid(unit_list[1]) then
				
		if unit_list[1].Get_Owner().Is_Human() then
			Game_Message("BOARDING_SUCCESSFUL")
		end
		unit_list[1].Suspend_Locomotor(false)
		unit_list[2].Change_Owner(unit_list[1].Get_Owner())

	end
end




function Intro_Cinematic()


	Fade_Screen_Out(.5)
	Suspend_AI(1)
	Lock_Controls(1)
	Letter_Box_In(0)
	
	Start_Cinematic_Camera()
	
	-- camera location	object	   x     y     z   + not so important stuff
	Set_Cinematic_Camera_Key(list[1], 1500, 120, 30, 1, 0, 0, 0)

	-- object the camera points at     x  y  z  blabla
	Set_Cinematic_Target_Key(list[1], 0, 0, 0, 0, 0, 0, 0) 
	
	Fade_Screen_In(3)
	Story_Event("START_SPEECH")

	Sleep(9)
	
	Transition_Cinematic_Target_Key(boarder_list[1], 5, 0, 0, 0, 0, 0, 1, 0)
	Transition_Cinematic_Camera_Key(boarder_list[1], 5, 600, 10, 30, 1, 0, 1, 0)
	
	Sleep(9)
	

	Transition_To_Tactical_Camera(1)
	
	Story_Event("END_SPEECH")
    	Letter_Box_Out(1)
	Sleep(1)
    	End_Cinematic_Camera()
    	Fade_Screen_In(.5)
	Lock_Controls(0)
	Suspend_AI(0)

end


function Story_Handle_Esc()
  	if current_cinematic_thread ~= nil then   
		Thread.Kill(current_cinematic_thread)   
		current_cinematic_thread = nil
   
    		Letter_Box_Out(0)
		End_Cinematic_Camera()
		Lock_Controls(0)
		Suspend_AI(0)

		
	end
end

