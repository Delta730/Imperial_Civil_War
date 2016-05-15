Planet = require("TRPlanet")

local GCPlanetLists = {
    --[[
    Sector 1:
    Bastion, Muunilinst, Dubrillion, Yaga Minor, Borosk, Morishim, Ord Trasi, Gravlex Med
    Sector 2:
    Anx Minor, Ciutric IV, Ketaris, Myrkr, Wayland, Obroa Skai
    Sector 3:
    Ord Mantell, Bilbringi, Wistril, Mrisst, Dolomar, Farrfin, Poderis
    Sector 4:
    Coruscant, Corulag, Carida, Kuat, Pakrik Minor, Abregado-Rae
    Sector 5:
    Corellia, Duro, Commenor, Denon, Fondor
    Sector 6: 
    Endor, Qat Chrystac, Nkllon, Woostri, Eriadu, Bpfassh, Sluis Van
    Sector 7:
    Svivren, New Cov, Filve, Chrondre, Ord Pardron, Ukio, Kothlis, Bothawui
    Sector 8:
    Cejansij, Jomark, Honoghr, Mon Calamari, Bimmisaari]]
    ["Thrawn_Campaign"] = { planets = {
        --Sector 1
        Planet("Bastion", 1, "TEXT_OBJECT_STAR_SYSTEM_BASTION"),
        Planet("Muunilinst", 1, "TEXT_OBJECT_STAR_SYSTEM_MUUNILINST"),
        Planet("Dubrillion", 1, "TEXT_OBJECT_STAR_SYSTEM_DUBRILLION"),
        Planet("Yaga_Minor", 1, "TEXT_OBJECT_STAR_SYSTEM_YAGAMINOR"),
        Planet("Borosk", 1, "TEXT_OBJECT_STAR_SYSTEM_BOROSK"),
        Planet("Morishim", 1, "TEXT_OBJECT_STAR_SYSTEM_MORISHIM"),
        Planet("Trasi", 1, "TEXT_OBJECT_STAR_SYSTEM_TRASI"),
        Planet("Gravlex_Med", 1, "TEXT_OBJECT_STAR_SYSTEM_GRAVLEX"),
        --Sector 2
        Planet("AnxMinor", 2, "TEXT_OBJECT_STAR_SYSTEM_ANXMINOR"),
        Planet("Ciutric", 2, "TEXT_OBJECT_STAR_SYSTEM_CIUTRIC"),
        Planet("Ketaris", 2, "TEXT_OBJECT_STAR_SYSTEM_KETARIS"),
        Planet("Myrkr", 2, "TEXT_OBJECT_STAR_SYSTEM_MYRKR"),
        Planet("Wayland", 2, "TEXT_OBJECT_STAR_SYSTEM_WAYLAND"),
        Planet("ObroaSkai", 2, "TEXT_OBJECT_STAR_SYSTEM_OBROA"),
        --Sector 3
        Planet("Mantell", 3, "TEXT_OBJECT_STAR_SYSTEM_MANTELL"),
        Planet("Bilbringi", 3, "TEXT_OBJECT_STAR_SYSTEM_BILBRINGI"),
        Planet("Wistril", 3, "TEXT_OBJECT_STAR_SYSTEM_WISTRIL"),
        Planet("Mrisst", 3, "TEXT_OBJECT_STAR_SYSTEM_MRISST"),
        Planet("Dolomar", 3, "TEXT_OBJECT_STAR_SYSTEM_DOLOMAR"),
        Planet("Farrfin", 3, "TEXT_OBJECT_STAR_SYSTEM_FARRFIN"),
        Planet("Poderis", 3, "TEXT_OBJECT_STAR_SYSTEM_PODERIS"),
        --Sector 4
        Planet("Coruscant", 4, "TEXT_OBJECT_STAR_SYSTEM_CORUSCANT"),
        Planet("Corulag", 4, "TEXT_OBJECT_STAR_SYSTEM_CORULAG"),
        Planet("Carida", 4, "TEXT_OBJECT_STAR_SYSTEM_CARIDA"),
        Planet("Kuat", 4, "TEXT_OBJECT_STAR_SYSTEM_KUAT"),
        Planet("Pakrik_Minor", 4, "TEXT_OBJECT_STAR_SYSTEM_PAKRIK"),
        Planet("Abregado_Rae", 4, "TEXT_OBJECT_STAR_SYSTEM_ABREGADORAE"),
        --Sector 5
        Planet("Corellia", 5, "TEXT_OBJECT_STAR_SYSTEM_CORELLIA"),
        Planet("Duro", 5, "TEXT_OBJECT_STAR_SYSTEM_DURO"),
        Planet("Commenor", 5, "TEXT_OBJECT_STAR_SYSTEM_COMMENOR"),
        Planet("Denon", 5, "TEXT_OBJECT_STAR_SYSTEM_DENON"),
        Planet("Fondor", 5, "TEXT_OBJECT_STAR_SYSTEM_FONDOR"),
        --Sector 6
        Planet("Endor", 6, "TEXT_OBJECT_STAR_SYSTEM_ENDOR"),
        Planet("QatChrystac", 6, "TEXT_OBJECT_STAR_SYSTEM_QATCHRYSTAC"),
        Planet("Nkllon", 6, "TEXT_OBJECT_STAR_SYSTEM_NKLLON"),
        Planet("Woostri", 6, "TEXT_OBJECT_STAR_SYSTEM_WOOSTRI"),
        Planet("Eriadu", 6, "TEXT_OBJECT_STAR_SYSTEM_ERIADU"),
        Planet("Bpfassh", 6, "TEXT_OBJECT_STAR_SYSTEM_BPFASSH"),
        Planet("Sluis_Van", 6, "TEXT_OBJECT_STAR_SYSTEM_SLUIS_VAN"),
        --Sector 7
        Planet("Svivren", 7, "TEXT_OBJECT_STAR_SYSTEM_SVIVREN"),
        Planet("NewCov", 7, "TEXT_OBJECT_STAR_SYSTEM_NEWCOV"),
        Planet("Filve", 7, "TEXT_OBJECT_STAR_SYSTEM_FILVE"),
        Planet("Chrondre", 7, "TEXT_OBJECT_STAR_SYSTEM_CHRONDRE"),
        Planet("Pardron", 7, "TEXT_OBJECT_STAR_SYSTEM_PARDRON"),
        Planet("Ukio", 7, "TEXT_OBJECT_STAR_SYSTEM_UKIO"),
        Planet("Kothlis", 7, "TEXT_OBJECT_STAR_SYSTEM_KOTHLIS"),
        Planet("Bothawui", 7, "TEXT_OBJECT_STAR_SYSTEM_BOTHAWUI"),
        --Sector 8
        Planet("Cejansij", 8, "TEXT_OBJECT_STAR_SYSTEM_CEJANSIJ"),
        Planet("Jomark", 8, "TEXT_OBJECT_STAR_SYSTEM_JOMARK"),
        Planet("Honoghr", 8, "TEXT_OBJECT_STAR_SYSTEM_HONOGHR"),
        Planet("MonCalimari", 8, "TEXT_OBJECT_STAR_SYSTEM_MONCALAMARI"),
        Planet("Bimmisaari", 8, "TEXT_OBJECT_STAR_SYSTEM_BIMMISAARI")
      },
      
      factions = {
        "REBEL",
        "EMPIRE"
        }
}


return GCPlanetLists