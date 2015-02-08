require("PGStateMachine")
require("PGStoryMode")




function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	StoryModeEvents = { 
				Universal_Story_Start = Begin_GC,
				STORY_FLAG_Battle_Over = Get_WaveCount }




end


function Begin_GC(message)
	if message == OnEnter then
		GlobalValue.Set("Survival_Mode", 1)
	end
end



function Get_WaveCount(message)
	if message == OnEnter then
		
		wave_count = GlobalValue.Get("WaveCount") - 1
		
		--wave_count = 5
		plot = Get_Story_Plot("Story_Sandbox_Survival_Rebel.xml")
		event = plot.Get_Event("Show_Wave_Dialog")
		dialog = "Dialog_Survival"


		event.Set_Dialog(dialog)
		event.Clear_Dialog_Text()
		--event.Add_Dialog_Text("TEXT_UNIT_VENGEANCE_FRIGATE")
		event.Add_Dialog_Text("TEXT_WAVES_SURVIVED", wave_count)
		Story_Event("DIALOG")


	end
end