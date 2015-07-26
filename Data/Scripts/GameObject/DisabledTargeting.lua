--//////////////////////////////////////////////////////////////////////////////////////
-- Find Attack Targets in Survival Mode
--  Pox
--//////////////////////////////////////////////////////////////////////////////////////


require("PGBase")
require("PGStateMachine")
require("PGCommands")
require("PGSpawnUnits")
require("PGMoveUnits")
require("LayerTeleport")

function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init);
end



function State_Init(message)
	if message == OnEnter then
    if Get_Game_Mode() ~= "Space" then
			ScriptExit()
		end
    TeleportToLayer(Object)
		has_target = false
		if GlobalValue.Get("Survival_Mode") ~= 1 or Object.Get_Owner().Is_Human() then
			ScriptExit()
		end

		base_list = { "Skirmish_Rebel_Star_Base_5", "Skirmish_Empire_Star_Base_5", "Skirmish_Underworld_Star_Base_5"}
		
		for i, obj in pairs(base_list) do
			if TestValid(Find_First_Object(obj)) then
				--Game_Message("TEXT_FACTION_REBELS")
				base = Find_First_Object(obj)
				break
			end
		end
	elseif message == OnUpdate then
		
		if not has_target then
			new_target = FindDeadlyEnemy(Object)
			
			if TestValid(new_target) then
					      
				if new_target.Is_Category("Fighter") or new_target.Is_Category("Bomber") then
					new_target = base 
				end
				Object.Attack_Move(new_target)
				has_target = true
			else
				new_target = base
				Object.Attack_Move(new_target) 
				
				has_target = true
				
			end
			--new_target.Highlight(true)
		else
			if not TestValid(new_target) then
				has_target = false
			end
			Register_Attacked_Event(Object, Is_Attacked)

		end

		
	end
end

function Is_Attacked()
	
	has_target = false
	Cancel_Attacked_Event(Object)
	

end