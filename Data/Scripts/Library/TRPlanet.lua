local TRLib = require("TRTypeLibrary")

local Planet = {}
Planet.__index = Planet

local mt = {__call = function(t,name, sector, text)
                      return Planet.New(name, sector, text)
                     end}
                   
setmetatable(Planet, mt)

function Planet.New(name, sector, text)
    local self = setmetatable({}, Planet)
    self.Name = name
    self.GameObject = FindPlanet(name)
    self.Owner = self.GameObject.Get_Owner()
    self.OwnerIndex = 0
    self.Text = text
    self.Influence = 35
    self.DiplomacyFlag = false
    self.DiplomatObject = nil
    self.Sector = sector
    
    self.Parent = parent --setting a GC object as parent so Planet can always know fleet locations
    return self
end


function Planet:hasFriendlyHero()
  if table.getn(TRLib.Heroes[self.Owner.Get_Faction_Name()]) > 0 then
    for _, hero in pairs(TRLib.Heroes[self.Owner.Get_Faction_Name()]) do
      local heroObj = Find_First_Object(hero)
      if TestValid(heroObj) then
        if heroObj.Get_Planet_Location() == self.GameObject then
          return true
        end
      end
    end
  end
  return false
end


function Planet:CompareOwners() --adjusts planet values whenever self.GameObject ~= self.Owner; DiplomacyFlag is removed
  if self.Owner ~= self.GameObject.Get_Owner() then
    self.Parent.AdjustSectorInfluence(self, self.Owner, self.GameObject.Get_Owner())
    self.Owner = self.GameObject.Get_Owner()
    if self.DiplomacyFlag then
      if TestValid(self.DiplomatObject.GameObject) then
        self.DiplomatObject.GameObject.Despawn()
      end
      
      self.DiplomatObject:DeathHandler()
      self.DiplomacyFlag = false
      self.DiplomatObject = nil
    end
    self.Influence = 100
  end
end


function Planet:CheckInfluence()
  if self.Influence <= 0 then
    self:ChangeOwner()
  elseif self.Influence > 100 then
    self.Influence = 100
  end
end



function Planet:ChangeOwner()
    local enemyInOrbit, fleet = self.Parent.IsEnemyFleetInOrbit(self.GameObject)
    if self.DiplomacyFlag then
      if self.Owner.Is_Human() then
        if TestValid(self.DiplomatObject.GameObject) then
          self.DiplomatObject.GameObject.Despawn() --despawns AI diplomats; don't need this for human diplomats because they're not really there
        end
      end
      if enemyInOrbit then --fleet > diplomat!
        local oldOwner = self.Owner
        local newOwner = fleet.Get_Owner()
        self.GameObject.Change_Owner(fleet.Get_Owner())
        self.Parent.AdjustSectorInfluence( self , oldOwner, newOwner)
        self.Owner = fleet.Get_Owner()
      else
        local oldOwner = self.Owner
        local newOwner = self.DiplomatObject.Owner
        self.GameObject.Change_Owner(self.DiplomatObject.Owner)
        self.Parent.AdjustSectorInfluence( self , oldOwner, newOwner)
        self.Owner = self.DiplomatObject.Owner
      end
        self.DiplomacyFlag = false 
        self.DiplomatObject:DeathHandler()
        self.DiplomatObject = nil
    else
        if enemyInOrbit then
          self.Parent.AdjustSectorInfluence(self, self.Owner, fleet.Get_Owner())
          self.GameObject.Change_Owner(fleet.Get_Owner())
          self.Owner = fleet.Get_Owner()
        else
          --weird bug with EaW:
          --When changing planet owner diplomat disappears but is still valid
          --need to check if human diplomat is parked there and despawn
          --not necessary for AI because AI diplomat location causes diplomacy flag
          if TestValid(self.Parent.HumanDiplomat.GameObject) then
            if self.Parent.HumanDiplomat.GameObject.Get_Planet_Location() == self.GameObject then
              self.Parent.HumanDiplomat.GameObject.Despawn()
              self.Parent.HumanDiplomat:DeathHandler()
            end
          end
          self.GameObject.Change_Owner(Find_Player("Neutral"))
          self.Owner = Find_Player("Neutral")
        end
    end
    
    self.Influence = 100
end

return Planet