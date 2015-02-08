--/////////////////////////////////////////////////////////////////////////////////////////////////
--Hostile by Sidious Invader.
--Goes in DATA\SCRIPTS\GAMEOBJECT\
--Use <Lua_Script>FriendlyFire</Lua_Script>
--/////////////////////////////////////////////////////////////////////////////////////////////////
require("PGStateMachine")
require("PGStoryMode")
function Definitions()
DebugMessage("%s -- In Definitions", tostring(Script))
Define_State("State_Init", State_Init);
end
function State_Init(message)
if message == OnEnter then
hostile = Find_Player("Hostile")
closest_target = Find_First_Object("Krayt_Self_Destruct_Blast")
closest_target.Change_Owner(hostile)
end
end 