require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")


function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))


	StoryModeEvents = { Init_Diplomacy = Begin_GC }


end



function Begin_GC(message)
	if message == OnEnter then
    
    GC = require("TRGalactic")
    Planet = require("TRPlanet")
    Diplomat = require("TRDiplomat")
    GCPlanetLists = require("TRGCSetup")
    TRLib = require("TRTypeLibrary")
    
    plot = Get_Story_Plot("Diplomacy_Events.XML")
  
    campaign = GCPlanetLists["Thrawn_Campaign"]
  
    --setting up a new GC
    GC.new(campaign.factions, campaign.planets, 8, plot)
    Sleep(1)
  elseif message == OnUpdate then
    
      
    
    
  end
end
