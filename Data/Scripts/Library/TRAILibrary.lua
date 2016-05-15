local TRLib = require("TRTypeLibrary")
local AI = {}

function AI.Init(GCtable)
  setmetatable(AI, {__index = GCtable})
  AI.maxPlanetDesire = {
                      ["EMPIRE"] = {planet = nil, desire = 0},
                      ["REBEL"] = {planet = nil, desire = 0},
                      ["UNDERWORLD"] = {planet = nil, desire = 0}
                    }
  AI.SleepTime = {
                  ["EMPIRE"] = 0,
                  ["REBEL"] = 0,
                  ["UNDERWORLD"] = 0
                 }
end


--determines planet with max desire
--if two factions desire the same planet one will not use a diplomat
function AI.DiplomacyDesire(planet)
  for _, faction in pairs(AI.factions) do
    local player = Find_Player(faction)
    if AI.SleepTime[faction] == 0 then --AI shouldn't spam diplomats
    if not player.Is_Human() and planet.GameObject.Get_Owner() ~= Find_Player("Neutral") and not planet.DiplomacyFlag then
      if planet.GameObject.Get_Owner().Is_Human() then

        if table.getn(AI.getPlanetsByOwner(player, planet.Sector)) >= 1 then
          local desire = 0
          if EvaluatePerception("Is_Connected_To_Me", player, planet.GameObject) == 1 then
            desire = desire + 20
          end          
          desire = desire + ((100 - planet.Influence)/3) -- max 33
          --versuchen stark besetzte planeten ohne kampf zu übernehmen
          desire = desire + (1 - EvaluatePerception("Low_Space_Defense_Score", planet.GameObject.Get_Owner(), planet.GameObject))*50 -- max 50 
          desire = desire + (1 - EvaluatePerception("Low_Ground_Defense_Score", planet.GameObject.Get_Owner(), planet.GameObject))*50 -- max 50
          desire = desire + EvaluatePerception("GenericPlanetValue", planet.GameObject.Get_Owner(), planet.GameObject)*100 --max 100
          if desire < AI.maxPlanetDesire[player.Get_Faction_Name()].desire then
            desire = desire + GameRandom(0,40) --zufallsfaktor damit nicht immer gleiche planeten gewählt werden
          end
          if desire > AI.maxPlanetDesire[player.Get_Faction_Name()].desire then
            AI.maxPlanetDesire[player.Get_Faction_Name()].desire = desire
            AI.maxPlanetDesire[player.Get_Faction_Name()].planet = planet
          end
        end
      end
    end
    end
  end
end


function AI.SpawnDiplomat()
  for _, diplomat in pairs(AI.diplomats) do --using diplomat list from GC
    if not diplomat.Owner.Is_Human() and not diplomat.OnMission then
     
      local diplomacyTarget = AI.maxPlanetDesire[diplomat.Owner.Get_Faction_Name()].planet
      if diplomacyTarget then
      
        if not diplomacyTarget.DiplomacyFlag then
          --spawn diplomat
          diplomacyTarget.DiplomacyFlag = true
          local diplomatType = Find_Object_Type(TRLib.DiplomatTypes[diplomat.Owner.Get_Faction_Name()])
          local diplomatGameObjectList = Spawn_Unit(diplomatType, diplomacyTarget.GameObject, diplomat.Owner)
          diplomat.Alive = true
          diplomat.GameObject = diplomatGameObjectList[1]
          diplomat.Location = diplomacyTarget.GameObject
          diplomat.OnMission = true
          diplomacyTarget.DiplomatObject = diplomat
        end
      end
      AI.maxPlanetDesire[diplomat.Owner.Get_Faction_Name()].planet = nil
      AI.maxPlanetDesire[diplomat.Owner.Get_Faction_Name()].desire = 0
    end
  end
end


function AI.SleepTimeHandler()
  for _, faction in pairs(GC.factions) do
      if AI.SleepTime[faction] > 0 then
        AI.SleepTime[faction] = AI.SleepTime[faction] - 1
      end
    end
end


function AI.KillDiplomatChance()
  if AI.HumanDiplomat.OnMission then
    local PlanetObject = AI.GetPlanetByGameObject(AI.HumanDiplomat.Location)
    local kill_chance = 0
    if PlanetObject then
      kill_chance = kill_chance + EvaluatePerception("GenericPlanetValue", PlanetObject.GameObject.Get_Owner(), PlanetObject.GameObject)*40
      

      kill_chance = kill_chance + (100-PlanetObject.Influence* 0.8)/2.5
      if PlanetObject:hasFriendlyHero() then
		    kill_chance = kill_chance + 10
      end
      
      
      kill_chance = kill_chance + GameRandom(0,25) -- zufallsfaktor
      if kill_chance >= 60 then
          PlanetObject.DiplomacyFlag = false
          PlanetObject.DiplomatObject = nil
          AI.HumanDiplomat:DeathHandler()
          Game_Message("TEXT_DIPLOMAT_KILLED")
      end
    end
  end
end


return AI
