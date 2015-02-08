--//////////////////////////////////////////////////////////////////////////////////////
-- Despawn Items in survival mode
-- © Pox
--//////////////////////////////////////////////////////////////////////////////////////


require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")

function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init);
end



function State_Init(message)
	if message == OnEnter then
		
		if Object.Get_Type().Get_Name() == "ITEM_DUMMY" then
			Object.Highlight(true)
			Register_Timer(Despawn_Item, 100)
		else
			Register_Timer(Despawn_Item, 300)
		end
	end
end


function Despawn_Item()
	
	if Object.Get_Type().Get_Name() == "ITEM_DUMMY" then
		Object.Despawn()
	else
		Game_Message("TEXT_ATTACK_BONUS_GONE")
	end
	ScriptExit()

end