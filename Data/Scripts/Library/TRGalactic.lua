local Diplomat = require("TRDiplomat")
local Planet = require("TRPlanet")
local TRLib = require("TRTypeLibrary")
local AI = require("TRAILibrary")
local GC = {
  factions = {},
  planets = {},
  fleets = {},
  faction_fleets = {},
  fleet_type = Find_Object_Type("Galactic_Fleet")
}



function GC.new(factions, planets, numSectors)
  GC.factions = factions
  GC.AIDiplomats = {}
  for _, player in pairs(factions) do
    if Find_Player(player).Is_Human() then
      GC.HumanPlayer = player
    end
  end
  
  GC.planets = planets
  for _, planet in pairs(GC.planets) do
    planet.Parent = GC
  end
  GC.sectors = GC.createSectors(numSectors)
  GC.diplomats = {}
  
  for i, faction in pairs(GC.factions) do
    GC.diplomats[i] = Diplomat.New(faction, TRLib.DiplomatTypes[faction], GC) --create a lib with important unit types later
    if Find_Player(faction).Is_Human() then
      GC.HumanDiplomat = GC.diplomats[i]
    else
      table.insert(GC.AIDiplomats, GC.diplomats[i])
    end
  end
  AI.Init(GC)
  Create_Thread("GCUpdate")
  Create_Thread("GCFleetUpdate")
  Create_Thread("GCDiplomacyUpdate")
  
end



local GC_MT = { __call = function(t, factions , planets, numSectors)
                            return GC.new(factions, planets, numSectors)
                         end }
                       
setmetatable(GC, GC_MT)


--////////////////////////////////////////////////////////////////
--////////////////////    GCFleetUpdate()    /////////////////////
--////////////////////////////////////////////////////////////////
function GCUpdate()
  local spawned = false
  while true do
    if Check_Story_Flag(Find_Player(GC.HumanPlayer), "SHOW_INFLUENCE", nil, true) then
      influence_dialog_event.Clear_Dialog_Text()
      local planetWithDiplomat = nil
      for _, planet in pairs(GC.planets) do
        if planet.GameObject.Get_Owner().Is_Human() then --have to use Get_Owner here, since planet.Owner is only updated once every day
          influence_dialog_event.Add_Dialog_Text("DUMMY_TEXT", planet.Text, planet.Influence)
        end
        if GC.HumanDiplomat.OnMission and planet.DiplomatObject then    
          if planet.DiplomatObject == GC.HumanDiplomat then
            planetWithDiplomat = planet
          end
        end
      end
      if planetWithDiplomat then --giving info about diplomat location
        influence_dialog_event.Add_Dialog_Text("TEXT_SEPERATOR")
        influence_dialog_event.Add_Dialog_Text("TEXT_DIPLOMAT_LOCATION", planetWithDiplomat.Text)
      end
      Story_Event("DIALOG")
		end
    GC.HumanDiplomat:ConstructionHandler() --have this here instead of GCDiplomacyUpdate because the locking needs to happen right away
    GC.HumanDiplomat:LocationHandler() --updates location when Diplomat.Location ~= Diplomat.GameObject.Get_Planet_Location(); enables/disables diplomacy
    GC.HumanDiplomat:usedAbility() --need to call usedAbility() before TestAlive() because TestAlive() calls DeathHandler() 
    GC.HumanDiplomat:TestAlive()
    
    Sleep(0.1)
  end
end

function GCFleetUpdate()
    while true do
      GC.fleets = GC.GetAllFleets()
      GC.faction_fleets = GC.GetFactionFleets()
      Sleep(1)
    end
end



function GCDiplomacyUpdate()
  while true do
    --test if AI diplomats are still alive before doing any influence calculations
    for _, diplomat in pairs(GC.AIDiplomats) do
      diplomat:TestAlive()
    end
    AI.KillDiplomatChance()
    --//////////////influence calculations//////////////
    for i, planet in pairs(GC.planets) do
      if planet.Owner ~= Find_Player("Neutral") then
        --add +5 inf if hero is present; unrelated to diplomacy mission
        
        if planet:hasFriendlyHero() then
          planet.Influence = planet.Influence + 5
        end
        --if diplomat on planet
        if planet.DiplomacyFlag then
          planet.Influence = planet.Influence - 20
        else
          --if player owns more than one planet in sector +5 else -5
          local sectorTable = GC.getPlanetsByOwner(planet.Owner, planet.Sector)
          if table.getn(sectorTable) > 1 then
            planet.Influence = planet.Influence + 5
          else
            planet.Influence = planet.Influence - 5
          end
          if GC.IsEnemyFleetInOrbit(planet.GameObject) then
            planet.Influence = planet.Influence - 5
          end
          if planet.Influence > 0 then --if influence < 0 then planet will change affiliation this turn => no diplomacy
            AI.DiplomacyDesire(planet)
          end
        end
      end
    planet:CompareOwners() --compares planet owner with listed owner, adjusts values on mismatch; call before CheckInfluence()!
    planet:CheckInfluence() --changes owner if influence < 0 and limits max influence to 100
  end
    AI.SpawnDiplomat()
    AI.SleepTimeHandler()

    Sleep(45)
  end
end


--////////////////////////////////////////////////////////////////
--////////////////////// createSectors() /////////////////////////
--////////////////////////////////////////////////////////////////
--GC.planets = {{Sector = 1, "a"}, {Sector = 1, "a"}, {Sector = 2, "a"}, {Sector = 4, "a"}, {Sector = 4, "a"}, {Sector = 3, "a"}}

function GC.createSectors(numSectors)
  local sectors = {}
  for i = 1, numSectors do
    sectors[i] = {}
  end
  for i, planet in pairs(GC.planets) do
    table.insert(sectors[planet.Sector], planet) 
  end
  return sectors
end

function GC.getPlanetsByOwner(player, sector)
  local planetList = {}
  if sector then
    for _, planet in pairs(GC.sectors[sector]) do
        if planet.GameObject.Get_Owner() == player then
          table.insert(planetList, planet)
        end
    end
  else
    for _, planet in pairs(GC.planets) do
      if planet.GameObject.Get_Owner() == player then
          table.insert(planetList, planet)
        end
    end
  end
  return planetList
end



--////////////////////////////////////////////////////////////////
--////////////////  Fleet specific functions    //////////////////
--////////////////////////////////////////////////////////////////

function GC.FleetContainsDiplomat(fleet)
  if fleet.Contains_Object_Type(Find_Object_Type(TRLib.DiplomatTypes[fleet.Get_Owner().Get_Faction_Name()])) then
    return true
  end
  return false
end


--////////////////////////////////////////////////////////////////
--                      GetAllFleets()                          //
-- returns all fleets and sorts them into player specific tables//
--////////////////////////////////////////////////////////////////
function GC.GetAllFleets()
    local fleets = Find_All_Objects_Of_Type("Galactic_Fleet")
    return fleets
end

function GC.GetFactionFleets()
    local faction_fleets = {}
    for _, faction in pairs(GC.factions) do
      faction_fleets[faction] = {}
      for _, fleet in pairs(GC.fleets) do
        if TestValid(fleet) then
          if fleet.Get_Owner() == Find_Player(faction) then
              table.insert(faction_fleets[faction], fleet)
          end
        end
      end
    end
    return faction_fleets  
end



--////////////////////////////////////////////////////////////////
--                GetIsUnitInFleet(unit, fleet)                 //
--            unit: UnitObject fleet: Galactic_Fleet            //
-- if a fleet is specified returns if the unit is in that fleet //
--     if no fleet is specified returns if unit is in a fleet   //
--////////////////////////////////////////////////////////////////
function GC.GetIsUnitInFleet(unit, fleet)
  if fleet then
    if unit.Get_Parent_Object() == fleet then
        return true
    end
  else
    if unit.Get_Parent_Object().Get_Type() == GC.fleet_type then
      return true
    end
  end
  return false
end



--////////////////////////////////////////////////////////////////
--                     findFleetWithUnit(unit)                  //
--         Finds the fleet that contains the specified unit     //
--////////////////////////////////////////////////////////////////
function GC.FindFleetWithUnit(unit)
  if unit.Get_Parent_Object().Get_Type() == GC.fleet_type then
    return unit.Get_Parent_Object()
  end
  return nil
end

function GC.IsEnemyFleetInOrbit(planet)
    if type(planet) == "string" then
      planet = FindPlanet(planet)
    end
    if TestValid(planet) then
      for i, fleet_list in pairs(GC.faction_fleets) do
        if i ~= planet.Get_Owner().Get_Faction_Name() then
          for _, fleet in pairs(fleet_list) do
              if TestValid(fleet) then
                if fleet.Get_Parent_Object() == planet and (fleet.Get_Contained_Object_Count() > 1 or not GC.FleetContainsDiplomat(fleet)) then
                  return true, fleet
                end
              end
          end
        end
      end
    end
    return false
end

function GC.IsFriendlyFleetInOrbit(planet)
  if type(planet) == "string" then
    planet = FindPlanet(planet)
  end
  if TestValid(planet) then
      if GC.faction_fleets[planet.Get_Owner().Get_Faction_Name()] and table.getn(GC.faction_fleets[planet.Get_Owner().Get_Faction_Name()]) > 0 then
        for _, fleet in pairs(GC.faction_fleets[planet.Get_Owner().Get_Faction_Name()]) do
          if TestValid(fleet) then
            if fleet.Get_Parent_Object() == planet then
              
              return true, fleet
            end
          end
        end
      end
  end
  return false
end


function GC.GetAllUnitsInFleet(fleet) 
    local units = Find_All_Objects_Of_Type(fleet.Get_Owner())
    local fleet_units = {}
    for _, unit in pairs(units) do
      if unit.Get_Parent_Object() == fleet then
        table.insert(fleet_units, unit)
      end
    end
    return fleet_units
end


function GC.GetPlanetByGameObject(gameObject)
  for _, planet in pairs(GC.planets) do
    if planet.GameObject == gameObject then
      return planet
    end
  end
  return nil
end

function GC.AdjustSectorInfluence(planetObject, oldOwner, newOwner)
  --decreasing influence on other planets in sector for oldOwner
  local oldOwnerPlanetList = GC.getPlanetsByOwner(oldOwner, planetObject.Sector)
  for _, planet in pairs(oldOwnerPlanetList) do
    planet.Influence = planet.Influence - 10
    planet:CheckInfluence() --need to call this again, since planet may have already been checked before in the main loop
  end
  --increasing influence on other planets in sector for newOwner
  local newOwnerPlanetList = GC.getPlanetsByOwner(newOwner, planetObject.Sector)
  for _, planet in pairs(newOwnerPlanetList) do
    planet.Influence = planet.Influence + 10
    planet:CheckInfluence() --need to call this again, since planet may have already been checked before in the main loop
  end
  
end

return GC