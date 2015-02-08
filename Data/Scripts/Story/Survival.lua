--////////////////////////////////////////////////////////////////////////////////////
-- Survival Mode
-- ©Pox
--////////////////////////////////////////////////////////////////////////////////////


require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")


------------------------------------------------------------------------------------------------
-- SURVIVAL MODE RULES
-- General Rules:
	--Boss fight every 5 waves
	--Item Spawn probability at 20% during waves > 3 (not used until I can actually think of some useful collectable items)
-- Ship Number Calculation and ship type leves:
	-- Waves 1 - 4:
		-- ship_number = wave + 4
		-- Level 1 units only
	-- Waves 5 - 8:
		-- ship_number = wave * 2
		-- Level 1 and 2 units
		-- level 2 ships = ((wave-1)/8) * ship_number
	-- Waves 9 - 12:
		-- ship_number = wave * 2
		-- Level 2 and 3 units
		-- level 3 ships = ((wave-2)/12) * ship_number
	-- Waves 13 - 16:
		-- ship_number = wave * 2
		-- Level 3 and 4 units
		-- level 4 ships = ((wave-3)/16) * ship_number
	-- Waves > 16:
		-- ship_number = 32
		-- Level 4 and 5 units
		-- level 5 ships = ((wave-4)/32) * ship_number
	-- Waves > 20
		-- ship_number = 32
		-- every wave is a boss battle
		-- level 5 ships = 32



------------------------------------------------------------------------------------------------



function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents = { Battle_Start = Begin_GC }

	pirates = Find_Player("Hutts")	
	



end


function Begin_GC(message)
	if message == OnEnter then

		my_type = 0
		my_item = nil
		item_base_marker = Find_First_Object("STORY_TRIGGER_ZONE_05")
		player_items = {"Attack_Damage_Dummy", "Credits_2000", "Credits_5000", "Reinf_CALAMARI_CRUISER"} -- credits, reinforcements(,upgrades?)

		

		item_spawn_pos = {"STORY_TRIGGER_ZONE_04"}

	enemy_spawn_pos = {"STORY_TRIGGER_ZONE_00","STORY_TRIGGER_ZONE_01","STORY_TRIGGER_ZONE_02","STORY_TRIGGER_ZONE_03"}
		
		enemy_types = {
			{"Lancer_Frigate", "Carrack_Cruiser"}, --Level1
			{"Escort_Carrier", "Strike_Cruiser"}, --Level2
			{"Acclamator_Daala", "Venator"}, --Level3
			{"Star_Destroyer", "Victory_Destroyer_Mark_2"}, --Level4
			{"Imperial_Star_Destroyer_Two", "Tector_Star_Destroyer"}  --Level5
			}


		boss_types = {
			{"Implacable_Star_Destroyer", "Gorgon"},
{"Chimera_Pellaeon_Grand"},
{"Praetor_Empire", "Thalassa"},
{"Praetor_Empire", "Praetor_Empire"},
{"Praetor_Empire", "Praetor_Empire"}
			}

		rebel = Find_Player("Rebel")
		empire = Find_Player("Empire")
		
		start_list = {"Alliance_Assault_Frigate", "Quaser", "MC40a"}
		SpawnList(start_list, item_base_marker, rebel, false, false)
		
		wave = 1
		diff_level = 1 -- not sure if I'll use that yet
		GlobalValue.Set("WaveCount", wave)
		current_wave_alive = false
		Create_Thread("Wave_Alive")
		Create_Wave(1)
		
		

	end
end




function Wave_Alive()
	while true do
		
		if current_wave_alive then
		    	--Game_Message("TEXT_FACTION_REBELS")
			units_alive= 0
			for i, unit in pairs(current_wave) do
				if TestValid(unit) then
					units_alive = units_alive + 1
				end
			end			


			if units_alive == 0 then
				current_wave_alive = false
				--Game_Message("TEXT_WAVE_DEFEATED")
				new_money = 400+(wave*50)
				rebel.Give_Money(new_money)
				Story_Event("ENABLE_REINFORCEMENTS")
				wave = wave + 1
				GlobalValue.Set("WaveCount", wave)
				remaining_units = Find_All_Objects_Of_Type(pirates)
				if table.getn(remaining_units) > 0 then
					for i, unit in pairs(remaining_units) do
						if TestValid(unit) and (unit.Is_Category("Fighter") or unit.Is_Category("Bomber")) then
							unit.Take_Damage(9999999)
						end
					end		
				end

				if not TestValid(my_item) then
					if wave > 6 then
						Spawn_Items()
					end
				end
				
				Sleep(20)
				Create_Wave(wave)
			end
	
		end
		Sleep(1)
	end
	--Sleep(1)
end


function Create_Wave(wave)

	boss_fight = false
	ship_number = wave * 2
	spawn = nil
	if wave <= 4 then
		--Level 1 units only!
		pos_count = 2
		ship_number = wave + 4	
		spawn = Find_First_Object("STORY_TRIGGER_ZONE_00")	
		max_level = 1
		high_ship_number = ship_number
		lower_ship_number = 0

	elseif wave <= 8 then
		--Level 1,2
		pos_count = 3
		upper_limit = 8
		percent_higher_level = (wave-1)/upper_limit
		high_ship_number = Dirty_Floor(ship_number*percent_higher_level)
		lower_ship_number = ship_number - high_ship_number
		spawn = Find_First_Object(enemy_spawn_pos[GameRandom(1,2)])
		max_level = 2

	elseif wave <= 12 then
		--Level 2,3
		pos_count = 3
		upper_limit = 12
		percent_higher_level = (wave-2)/upper_limit
		high_ship_number = Dirty_Floor(ship_number*percent_higher_level)
		lower_ship_number = ship_number - high_ship_number
		spawn = Find_First_Object(enemy_spawn_pos[GameRandom(1,3)])
		max_level = 3


	elseif wave <= 16 then
		--Level 3,4
		pos_count = 4
		upper_limit = 16
		percent_higher_level = (wave-3)/upper_limit
		high_ship_number = Dirty_Floor(ship_number*percent_higher_level)
		lower_ship_number = ship_number - high_ship_number
		max_level = 4
		spawn = Find_First_Object(enemy_spawn_pos[GameRandom(1,4)])

	elseif wave > 16 then
		--Level 4,5
		pos_count = 4
		upper_limit = 20
		max_level = 5
		spawn = Find_First_Object(enemy_spawn_pos[GameRandom(1,4)])
		ship_number = 32
		if wave <= 20 then
			if (wave-4) < upper_limit then
				percent_higher_level = (wave-4)/upper_limit
				high_ship_number = Dirty_Floor(ship_number*percent_higher_level)
				lower_ship_number = ship_number - high_ship_number
			else
				high_ship_number = ship_number
				lower_ship_number = 0

			end
			
		else
			high_ship_number = 32 -- 32 should be enough lag
			lower_ship_number = 0
	        	boss_fight = true --every wave is a boss fight now! HARDCORE MODE

		end		


	end

	if Simple_Mod(wave, 5) == 0 then
		boss_fight = true

	end
	
	Spawn_Wave(lower_ship_number, high_ship_number, max_level, pos_count, boss_fight)

end



function Spawn_Wave(low_ships, high_ships, level, position, boss)
	spawn_table = {}
	my_type = 0

	for j = 1,high_ships,1 do
		my_type = GameRandom(1,table.getn(enemy_types[level]))
		table.insert(spawn_table, enemy_types[level][my_type])
	end

	if low_ships > 0 then
		for j = 1, low_ships,1 do
			my_type = GameRandom(1,table.getn(enemy_types[level-1]))
			table.insert(spawn_table, enemy_types[level-1][my_type])

		end
	end
	if boss then
        	my_type = GameRandom(1,table.getn(boss_types[level]))
		table.insert(spawn_table, boss_types[level][my_type])
	
	end
	
	current_wave = MultiPosSpawnList(spawn_table, {"STORY_TRIGGER_ZONE_00","STORY_TRIGGER_ZONE_01","STORY_TRIGGER_ZONE_02","STORY_TRIGGER_ZONE_03"}, position, pirates, true, true)
	--current_wave = Find_All_Objects_Of_Type("Skirmish_Rebel_Star_Base_5")
	current_wave_alive = true
	Story_Event("NO_REINFORCEMENTS")
	
end




--WIP----
--******************************************************************************************************************************
--					MultiPosSpawnList								       *
--		Rules:													       *
--			1. Do we want to split => 60% chance								       *
--			2. If we want to split make sure there are at least unit_count/pos_number units on each spawn point    *
--															       *
--******************************************************************************************************************************
function MultiPosSpawnList(unit_list, pos_list, pos_number, faction, allow_ai_usage, remove_after_battle)
	complete_list = {}
	if pos_number > 1 then
		want_to_split = GameRandom(0,100)
	else
		want_to_split = 0
	end
	temp_pos_list = pos_list
	
	if want_to_split > 40 then
		ships_per_spawnpoint = Dirty_Floor(table.getn(unit_list)/pos_number)

		while table.getn(temp_pos_list) > pos_number do
			
			table.remove(temp_pos_list, GameRandom(1, table.getn(temp_pos_list)))
		end
				


		for i, pos in pairs(temp_pos_list) do
			ships_on_spawnpoint = 0
			temp_list = {}
			
			 
			for k = 1, ships_per_spawnpoint do
					index = GameRandom(1,table.getn(unit_list))
					table.insert(temp_list, unit_list[index])
					table.remove(unit_list, index)

			end
			
	
			spawn_unit_list = SpawnList(temp_list, Find_First_Object(pos), pirates, allow_ai_usage, remove_after_battle)
			for j, unit in pairs(spawn_unit_list) do
				table.insert(complete_list, unit)

			end

		end

		if table.getn(unit_list) > 0 then
			for i, unit in pairs(unit_list) do
				new_unit_list = Spawn_Unit(Find_Object_Type(unit), Find_First_Object(temp_pos_list[GameRandom(1, table.getn(temp_pos_list))]), faction)
				new_unit = new_unit_list[1]
				table.insert(complete_list, new_unit)
			end

		end

	else
		complete_list = SpawnList(unit_list, Find_First_Object(pos_list[GameRandom(1, table.getn(pos_list))]), pirates, true, true)		

	end


	return complete_list
end



function Spawn_Items()
	item_spawn_chance = GameRandom(1,100)
	if item_spawn_chance >= 75 then
		spawn_loc = Find_First_Object(item_spawn_pos[GameRandom(1, table.getn(item_spawn_pos))])
		Spawn_Unit(Find_Object_Type("Item_Dummy"), spawn_loc, Find_Player("Neutral"))
		my_item = Find_First_Object("Item_Dummy")
		Register_Prox(my_item, Item_Effect, 200, Find_Player("Rebel"))
		--Game_Message("TEXT_FACTION_REBELS")

	end
end


function Item_Effect(self_obj, trigger_obj)
	
	self_obj.Cancel_Event_Object_In_Range(Item_Effect)
	
	chosen_item = player_items[GameRandom(1, table.getn(player_items))]
	if string.find(chosen_item, "Reinf_") then
		unit_string = string.sub(chosen_item, 7)
		Add_Reinforcement(unit_string, Find_Player("Rebel"))
		Game_Message("TEXT_REINFORCEMENT_BONUS")
	elseif chosen_item == "Credits_2000" then
		Game_Message("TEXT_CREDITS_2000")
		rebel.Give_Money(2000)
	elseif chosen_item == "Credits_5000" then
		Game_Message("TEXT_CREDITS_5000")
		rebel.Give_Money(5000)
	else	
		Spawn_Unit(Find_Object_Type(chosen_item), item_base_marker, Find_Player("Rebel"))
		
		if chosen_item == "Attack_Damage_Dummy" then
			Game_Message("TEXT_ATTACK_BONUS")
		else
			Game_Message("TEXT_FREE_UNIT")
		end
	end

	self_obj.Despawn()

end








-- Nasty hack of a floor function to be replaced if a math library floor funciton is exposed
function Dirty_Floor(val)
	return string.format("%d", val) -- works on implicit string to int conversion
end

-- Machine independent modulus function 
function Simple_Mod(a,b)
	--return a-b*math.floor(a/b)
	return a-b*Dirty_Floor(a/b)
end
