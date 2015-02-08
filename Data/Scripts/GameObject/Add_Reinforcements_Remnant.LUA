--//////////////////////////////////////////////////////////////////////////////////////
-- Add Units to the reinforcement pool// This script is part of the Survival Mode
-- © Pox
--//////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGSpawnUnits")



function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- possible units to spawn
	unit_table = {"LANCER_FRIGATE",
"CARRACK_CRUISER",
"IMPERIAL_STAR_DESTROYER_TWO",
"TECTOR_STAR_DESTROYER",
"STAR_DESTROYER",
"ACCLAMATOR_DAALA",
"STRIKE_CRUISER",
"VICTORY_DESTROYER_MARK_1",
"VICTORY_DESTROYER_MARK_2",
"VENATOR",
"MTC_SENSOR",
"DREADNAUGHT_EMPIRE",
"VINDICATOR_CRUISER"}

	Define_State("State_Init", State_Init);


end


function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Space" then
			ScriptExit()
		end
		empire = Find_Player("Empire")
		my_name = Object.Get_Type().Get_Name()

		

		for i, obj in pairs(unit_table) do
			contain_check = string.find(my_name, obj)			
	 			if contain_check ~= nil then
					Add_Reinforcement(obj, empire)
				end
			
		end
		ScriptExit()
		
	end
end