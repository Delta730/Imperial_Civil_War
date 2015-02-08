--//////////////////////////////////////////////////////////////////////////////////////
-- Add Units to the reinforcement pool// This script is part of the Survival Mode
-- © Pox
--//////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGSpawnUnits")



function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- possible units to spawn
	unit_table = {"ASDONI",
"NURUODO",
"KARIEK_SHIELDSHIP",
"AURIETTE_CARRIER",
"WARLORD",
"DECIMATOR",
"VIGILANCE_GUNSHIP",
"BUDIRECH",
"CHAF_DESTROYER",
"PHALANX_DESTROYER",
"SYNDIC_DESTROYER",
"CHISS_STAR_DESTROYER"}

	Define_State("State_Init", State_Init);


end


function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Space" then
			ScriptExit()
		end
		underworld = Find_Player("Underworld")
		my_name = Object.Get_Type().Get_Name()

		

		for i, obj in pairs(unit_table) do
			contain_check = string.find(my_name, obj)			
	 			if contain_check ~= nil then
					Add_Reinforcement(obj, underworld)
				end
			
		end
		ScriptExit()
		
	end
end