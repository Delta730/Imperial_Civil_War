local TRLib = require("TRTypeLibrary")
local AI = require("TRAILibrary")

local Diplomat = {}
Diplomat.__index = Diplomat

local mt = {__call = function(t,owner, objType, parent)
                      return Diplomat.New(owner, objType, parent)
                     end}
setmetatable(Diplomat, mt)

function Diplomat.New(owner, objType, parent)
  local self = setmetatable({}, Diplomat)
  
  self.Location = nil
  self.Owner = Find_Player(owner)
  self.OwnerName = owner
  self.ObjectType = objType
  self.GameObject = nil
  self.OnMission = false
  self.Alive = false
  if parent then
    self.Parent = parent
  else
    self.Parent = nil
  end
  
  return self
end


function Diplomat:TestAlive()
  if not TestValid(self.GameObject) then
    if self.Owner.Is_Human() then
      if self.OnMission then
        return true
      elseif self.Alive then --in this case diplomat is not valid AND not OnMission BUT Alive => diplomat died, need to call DeathHandler()
        self:DeathHandler()
      end
    else --for the AI TestValid MUST always return true if diplomat is alive
      if self.Alive then --only run this if diplomat SHOULD be alive
        if self.OnMission then --if diplomat was on a mission return planet values back to default
          
          local planetObject = self.Parent.GetPlanetByGameObject(self.Location)
          if planetObject then
            planetObject.DiplomacyFlag = false
            planetObject.DiplomatObject = nil
          end
        end
        self:DeathHandler()
      end
    end
  else
    return true
  end
  return false
end


function Diplomat:usedAbility()
  if Check_Story_Flag(Find_Player(self.Parent.HumanPlayer), "DEPLOYED_ABILITY", nil , true) then
    if TestValid(self.GameObject) and self.Alive and not self.OnMission then -- changed "not TestValid" to TestValid since Despawn happens manually
      if self.Location.Get_Owner() == Find_Player("Neutral") then -- prevent diplomacy on neutral planets
        Game_Message("TEXT_DIPLOMACY_DENIED") --diplomacy not allowed!
        return
      elseif self.Location.Get_Owner().Is_Human() then --seperate check for human planet; don't need a message here
        return
      end
      for _, planet in pairs(self.Parent.planets) do
        if planet.GameObject == self.Location then 
          --test if diplomacy is allowed
          local planetList = self.Parent.getPlanetsByOwner(self.Owner, planet.Sector)
          if table.getn(planetList) > 0 then
            planet.DiplomatObject = self
            planet.DiplomacyFlag = true
            self.OnMission = true
            self.GameObject.Despawn()
            Game_Message("TEXT_DIPLOMACY_START")
          else
            Game_Message("TEXT_DIPLOMACY_DENIED") --diplomacy not allowed!
          end
        end
      end
    end
  end
end

function Diplomat:ConstructionHandler()  
  if Check_Story_Flag(Find_Player(self.Parent.HumanPlayer), "CONSTRUCT_DIPLOMAT", nil, true) then
    self.Alive = true
    self.OnMission = false
    self.GameObject = Find_First_Object(TRLib.DiplomatTypes[self.OwnerName])
    self.Location = self.GameObject.Get_Planet_Location()
    
    --Story_Event("LOCK_DIPLOMAT") <-- doing this with story events
  end
end


function Diplomat:LocationHandler()
  if TestValid(self.GameObject) then
    if self.GameObject.Get_Planet_Location() then
      self.Location = self.GameObject.Get_Planet_Location()
    end
  end
end

--gets called when a diplomat is killed
--the human diplomat is not actually there even before that; its location is just stored in the planet object
function Diplomat:DeathHandler()
    self.Alive = false
    self.OnMission = false
    self.GameObject = nil
    if self.Owner.Is_Human() then
      Story_Event("ENABLE_DIPLOMAT")
    else
      AI.SleepTime[self.Owner.Get_Faction_Name()] = GameRandom(3,10)
    end
end



return Diplomat