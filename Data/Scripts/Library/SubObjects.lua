--[[add your unit types in CAPITAL LETTERS(!!!) to this table as shown below. The "meshes" table contains the mesh names that have to be hidden by the script, 
    the heights table contains the possible heights for this unit type]]
local Unit_Info_Table = {
          ["CORELLIAN_CORVETTE"] = { meshes ={ "Corvette",
                                                "shadow",
                                                "PE_Corvetteengines"},
                                     heights = {"ZLayer_Medium",
                                                "ZLayer_High"}
                                   },
          ["SACHEEN"] = { meshes ={ "Sacheen",
                                    "PE_VENGEANCEENGINE_SML"
                                            },
                          heights = {"ZLayer_Medium",
                                     "ZLayer_High"}
                                   },
          ["MARAUDER_MISSILE_CRUISER"] = { meshes = {"rv_missile_ship_LOD1",
                                                     "rv_missile_ship_shadow",
                                                     "pe_rv_missile_ship"},
                                           heights = {"ZLayer_Medium",
                                                      "ZLayer_High"}
                                         },
          ["NEBULON_B-2_FRIGATE"] = { meshes = {"Nebulon_B-2",
                                                "PE_NEBULONENGINES"
                                               },
                                      heights = {"ZLayer_Medium",
                                                 "ZLayer_High"}                               
                                    },
          ["MC40A"] = { meshes = {"Body",
                                  "Lights",
                                  "Shadow",
                                  "PE_Decimator",
                                  "PE_Decimator02"},
                        heights = {"ZLayer_Medium",
                                   "ZLayer_High"}
                      },
          ["QUASAR"] = { meshes = {"Object01",
                                   "Object03",
                                   "Plane03",
                                   "Shadow",
                                   "P_blink_white",
                                   "PE_INTERDICTORENGINE_SML"
                                  },
                         heights = {"ZLayer_Medium",
                                    "ZLayer_High"}
                        },
          ["DREADNAUGHT_REBEL"] = { meshes = {"Engines00",
                                              "Engines01",
                                              "Engines02",
                                              "Engines03",
                                              "Engines04",
                                              "Engines05",
                                              "Engines06",
                                              "Engines07",
                                              "Engines08",
                                              "Engines09",
                                              "Engines10",
                                              "Engines11",
                                              "Engines12",
                                              "Engines13",
                                              "Engines14",
                                              "Engines15",
                                              "Engines16",
                                              "Engines17",
                                              "Engines18",
                                              "Engines19",
                                              "Engines20",
                                              "Engines21",
                                              "Engines22",
                                              "Engines23",
                                              "Engines24",
                                              "Engines25",
                                              "Engines26",
                                              "Engines27",
                                              "Engines28",
                                              "Engines29",
                                              "Engines30",
                                              "Engines31",
                                              "Engines32",
                                              "Engines33",
                                              "Engines34",
                                              "Engines35",
                                              "Engines36",
                                              "Engines37",
                                              "Engines38",
                                              "Engines39",
                                              "Engines40",
                                              "Engines41",
                                              "Engines42",
                                              "Engines43",
                                              "Engines44",
                                              "Engines45",
                                              "Engines46",
                                              "Engines47",
                                              "Engines48",
                                              "Engines49",
                                              "Engines50",
                                              "Engines51",
                                              "Engines52",
                                              "Engines53",
                                              "Engines54",
                                              "Engines55",
                                              "Engines56",
                                              "Engines57",
                                              "Engines58",
                                              "Engines59",
                                              "Engines60",
                                              "Engines61",
                                              "Engines62",
                                              "Engines63",
                                              "Engines64",
                                              "Engines65",
                                              "Engines66",
                                              "Engines67",
                                              "Engines68",
                                              "Engines69",
                                              "Engines70",
                                              "Engines71",
                                              "objDreadnought_sep2_default",
                                              "Dreadnought"
                                              },
                                    heights = {"ZLayer_Medium",
                                               "ZLayer_High"}
                                  },  
          ["NEBULON_B_FRIGATE"] = { meshes ={ "RV_NebulonB",
                                              "shadow",
                                              "Lighting",
                                              "pe_nebulonengines"
                                            },
                                     heights = {"ZLayer_High",
                                                "ZLayer_Medium"}
                                   },
          ["CORONA"] = { meshes = {"Corona",
                                   "Lights",
                                   "Shadow",
                                   "PE_NEBULONENGINES"
                                  },
                         heights = {"ZLayer_Medium",
                                    "ZLayer_High"}
                        },
          ["ALLIANCE_ASSAULT_FRIGATE"] = { meshes = {"Assault_Frigate",
                                                     "Lights",
                                                     "Object01",
                                                     "pe_nebulonengines"
                                                    },
                                           heights = {"ZLayer_Medium",
                                                      "ZLayer_High"}
                                                     },
          ["BAC"] = { meshes = {"BAC",
                                "pe_bac"},
                      heights = {"ZLayer_Medium",
                                 "ZLayer_High"}
                    },
          ["Endurance"] = { meshes = {"objChassis",
                                      "objEngines",
                                      "Plane02",
                                      "Plane03",
                                      "Plane04",
                                      "ShadowEngines",
                                      "BodyShadow",
                                      "LightMesh",
                                      "LightMesh01",
                                      "PE_STARDESTROYERENGINES_SML.ALO"
                                     },
                            heights = {"ZLayer_Medium",
                                       "ZLayer_Low"}
                          },
          ["NEBULA"] = { meshes = { "Box02",
                                    "Box03",
                                    "Box04",
                                    "Lightmesh",
                                    "pe_nebula"
                                  },
                         heights = {"ZLayer_Medium",
                                    "ZLayer_Low"}
                        },
          ["MAJESTIC"] = { meshes = { "objcube1_default",
                                      "Shadow",
                                      "PE_INTERDICTORENGINE_LRG.alo"
                                    },
                          heights = {"ZLayer_Medium",
                                     "ZLayer_Low"}
                          },
          ["VISCOUNT"] = { meshes = { "objpolySurface138",
                                      "objpolySurface140",
                                      "objpolySurface142",
                                      "Plane03",
                                      "Alamo Proxy02",
                                      "PE_STARDESTROYERENGINES",
                                      "PE_STARDESTROYERENGINES_SML"
                                    },
                           heights = {"ZLayer_Medium",
                                      "ZLayer_Low"}
                          },
          ["MC80B"] = { meshes = {"Box01",
                                  "Lights",
                                  "Shadow",
                                  "PE_Chaf",
                                  "PE_Chaf_Small"
                                 },
                        heights = {"ZLayer_Medium",
                                   "ZLayer_Low"}
                      },
          ["MC90"] = { meshes = { "objpolySurface555",
                                  "objpolySurface557",
                                  "objpolySurface558",
                                  "PE_StarDestroyer_Engines_SML"
                                },
                       heights = {"ZLayer_Medium",
                                  "ZLayer_Low"}
                     },
          ["CALAMARI_CRUISER"] = { meshes = { "Hull",
                                              "Lights",
                                              "Shadow"
                                            },
                                  heights = {"ZLayer_Medium",
                                              "ZLayer_Low"}
                                  }
  }
  
  
return Unit_Info_Table


--[[["NEBULON_B_FRIGATE"] = { meshes ={ "RV_NebulonB",
                                              "shadow",
                                              "Lighting",
                                              "pe_nebulonengines"
                                            },
                                     heights = {"ZLayer_Low",
                                                "ZLayer_Medium"}
                                   },
                                 
[] = { meshes = {},
       heights = {"ZLayer_Medium",
                  "ZLayer_Low"}
       }
      ]]