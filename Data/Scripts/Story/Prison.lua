-- $Id: //Imperial_Civil_War/Data/Scripts/GameObject/Prison.lua#7 $
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
-- (C) Smallpox
--
-- _______ __                                    
--|_     _|  |--.----.---.-.--.--.--.-----.-----. 
--  |   | |     |   _|  _  |  |  |  |     |__ --|
--  |___| |__|__|__| |___._|________|__|__|_____|
-- ______                                      
--|   __ \.-----.--.--.-----.-----.-----.-----.
--|      <|  -__|  |  |  -__|     |  _  |  -__|
--|___|__||_____|\___/|_____|__|__|___  |_____|             
--                                |_____| 
--
--/////////////////////////////////////////////////////////////////////////////////////////////////
-- C O N F I D E N T I A L   S O U R C E   C O D E -- D O   N O T   D I S T R I B U T E
--/////////////////////////////////////////////////////////////////////////////////////////////////


require("PGStoryMode")
require("PGStateMachine")

function Definitions()

  DebugMessage("%s -- In Definitions", tostring(Script))


  --ServiceRate = 1

  StoryModeEvents = {

    Battle_Start = Begin_Battle

  }

  prison_count = 0
  setup_complete = false

end

function Begin_Battle(message)
  if message == OnEnter then

    rebel = Find_Player("Rebel")

    --In case you have different prison structures...

    prisons = Find_All_Objects_Of_Type("Prison")
    prisons2 = Find_All_Objects_Of_Type("Secondary_Prison_E")

    for j, obj in pairs(prisons2) do
      table.insert(prisons, obj)
    end



    -- all possible spawn structures in this table
    spawn_structures = {"Wookiee_Spawn_House", "Ewok_Spawn_House", "MonCalamari_Spawn_House", "Sullust_Cave_Complex_Entry", "Bothan_Spawn_House", "Sullust_Cave_Complex_Entry", "Duros_Spawn_House"}

    for j, spawner in pairs(spawn_structures) do
      list = Find_All_Objects_Of_Type(spawner)
      for h, obj in pairs(list) do
        obj.Set_Garrison_Spawn(true)	
      end			

    end

    if table.getn(prisons) > 0 then

      for i, obj in pairs(prisons) do
        if TestValid(obj) then	
          if obj.Get_Hull() > 0 then

            prison_count = prison_count + 1

          end
        end

      end



      if prison_count > 0 then
        for k, spawner in pairs(spawn_structures) do
          list = Find_All_Objects_Of_Type(spawner)
          for h, obj in pairs(list) do
            obj.Set_Garrison_Spawn(false)	
          end			
        end
      end

    end



  elseif message == OnUpdate then


    if Check_Story_Flag(rebel, "PRISON_DESTROYED", nil, true) then

      prison_count = prison_count - 1
    end

    if prison_count == 0 then
      for k, spawner in pairs(spawn_structures) do
        list = Find_All_Objects_Of_Type(spawner)
        for h, obj in pairs(list) do
          obj.Set_Garrison_Spawn(true)	
        end			
      end


      ScriptExit()
    end


  end
end


