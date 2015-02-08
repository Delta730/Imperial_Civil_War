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


require("PGStateMachine")

function Definitions()

  Define_State("State_Init", State_Init);

  prison_count = 0
end

function State_Init(message)

  if message == OnEnter then
                if Get_Game_Mode() ~= "Land" then
      ScriptExit()
    end


   prisons = Find_All_Objects_Of_Type("Prison")

    if table.getn(prisons) > 0 then

      for i, obj in pairs(prisons) do

        if obj.Get_Hull() > 0 then

          prison_count = prison_count + 1

        end

      end

      if prison_count > 0 then

        Object.Set_Garrison_Spawn(false)
      end

    else
      ScriptExit()

    end
  elseif message == OnUpdate then

    for k, obj in pairs(prisons) do

      if obj.Get_Hull() == 0 then

        table.remove(prisons, k)
        prison_count = prison_count - 1

      end
    end

    if prison_count == 0 then

      Object.Set_Garrison_Spawn(true)

      ScriptExit()
    end
end
end

