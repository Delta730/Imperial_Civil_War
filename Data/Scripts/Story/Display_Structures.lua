--//////////////////////////////////////////////////////////////////////////////////////
-- Displays a screen text containing all orbital structures when zooming into a planet
-- © SmallPox
--//////////////////////////////////////////////////////////////////////////////////////

require("PGDebug")
require("PGStateMachine")
require("PGStoryMode")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents = { Zoom_Zoom = Begin_GC }

	--ServiceRate = 2


end



function Begin_GC(message)
	if message == OnEnter then

		zoomed_in = false
		player_table = {Find_Player("Empire"), Find_Player("Rebel"), Find_Player("Underworld"), Find_Player("Pentastar")}
		player_string_table = {"Empire", "Rebel", "Underworld", "Pentastar"}
		player = nil
		player_index = nil
		

		for i, obj in pairs(player_table) do
			if obj.Is_Human() then
				
				player = obj
				player_index = i
				break
			end
		end

		-- put all planets as strings in this table
		-- planet_list = {"Abregado_Rae", "Adumar", "Amrac", "AnxMinor", "Balmorra", "Bastion", "Bonadan", "Borosk", "Belsavis", "Belsmuth", "Bespin", "Bilbringi", "Borleais", "Bimmisaari", "Bpfassh", "Brentaal", "Bothawui", "Byss", "Bilbringi", "Bothawui", "Carida", "Cejansij", "Champala", "Chandrila", "Chardaan", "Charubah", "Chorax", "Chrondre", "Ciutric", "Comkin", "Commenor", "Corellia", "Corulag", "Coruscant", "Crustai", "Da_SoochaV", "Dagobah", "Dantooine", "Dathomir", "Doornik", "Dolomar", "Druckenwell", "Dubrillion", "Duro", "Fondor", "Jaemus", "Kuat", "MonCalimari", "Nirauan", "Odik"}
	
		planet_list = {"Balmorra", "Bastion", "Bimmisaari", "Bonadan", "Bothawui", "Byss", "Carida", "Chandrila", "Chardaan", "Charubah", "Chrondre", "Ciutric", "Commenor", "Corellia", "Corulag", "Coruscant", "Dathomir", "Denon", "Doornik", "Dubrillion", "Ession", "Etti_IV", "Farrfin", "Filve", "Garqi", "Gyndine", "Hapes", "Honoghr", "Jaemus", "Jomark", "Kauron", "Kessel", "Khomm", "Kothlis", "Kuat", "Mantell", "Metellos", "MonCalimari", "Morishim", "Muunilinst", "Myrkr", "Nkllon", "Nzoth", "ObroaSkai", "Pakrik_Minor", "Pantolomin", "Pardron", "Pesitiin", "Phindar", "Poderis", "QatChrystac", "Rishi", "Rodia", "Sarvchi", "Sluis_Van", "Talfaglio", "Tangrene", "Telos", "The Maw", "Trasi", "Ukio", "Wayland", "Woostri", "Yaga_Minor", "YagDhul", "Yavin", "Adumar", "Bakura", "Belsavis", "Belsmuth", "Bespin", "Bpfassh", "Brentaal", "Champala", "Chorax", "Comkin", "Da_SoochaV", "Dagobah", "Dantooine", "Dolomar", "Endor", "Eriadu", "Exocron", "Galantos", "Generis", "Gravan", "Graveyard", "Grho", "Hakassi", "Helska_IV", "Ilum", "Kalist", "Ketaris", "Mrisst", "NewAlderaan", "Onderon", "Orinda", "PorusVida", "Sernpidal", "Sullust", "Svivren", "Thanos", "Tsoss", "Wistril", "Zfell", "Odik", "Amrac", "Rhigar", "Riette", "Oristrom", "Crustai", "Syca", "Quethold", "Nirauan", "Borosk", "Morishim", "Ithor", "Noquivzor", "Gravlex_Med", "ILC905", "Polneye", "NewCov", "Fondor", "Duro", "NalHutta", "Kashyyyk", "Ylesia", "Thyferra", "Cejansij", "Bilbringi", "Borleais", "Terephon", "Garos_IV", "NespisVIII", "Jtptan", "Levian", "Champala", "Talasea", "Kariek", "Selaggis", "Druckenwell", "Ossus"}
		
		-- put all special structures as strings in this table
		special_structures = {
					{"Empire_Golan_One", "Empire_Golan_Two", "Empire_Golan_Three"}, --empire structures
					{"Rebel_Golan_One", "Rebel_Golan_Two", "Rebel_Golan_Three"},						--Rebel structures
					{"Brask", "Visvia"},						--Underworld structures
					{"Pentastar_Golan_One", "Pentastar_Golan_Two", "Pentastar_Golan_Three"}
					}



		-- put the text entries of the special structures as strings in this table(Yeah, I know these aren't the right ones :P)
		-- IMPORTANT: the order of the entries has to be the same as in the special_structures table!!!
		

		text_table = {
				{"TEXT_DISPLAY_GOLAN_ONE_STATION", "TEXT_DISPLAY_GOLAN_TWO_STATION", "TEXT_DISPLAY_GOLAN_THREE_STATION"}, --empire text entries
				{"TEXT_DISPLAY_GOLAN_ONE_STATION", "TEXT_DISPLAY_GOLAN_TWO_STATION", "TEXT_DISPLAY_GOLAN_THREE_STATION"},								-- rebel text entries
				{"TEXT_DISPLAY_BRASK", "TEXT_DISPLAY_VISVIA"},								-- underworld text entries
				{"TEXT_DISPLAY_GOLAN_ONE_STATION", "TEXT_DISPLAY_GOLAN_TWO_STATION", "TEXT_DISPLAY_GOLAN_THREE_STATION"}
				}

		special_structures = special_structures[player_index]
		text_table = text_table[player_index]


		-- put the name of your story file in here. IMPORTANT: the command is case sensitive!

		plot = Get_Story_Plot("Display_Structures.xml")


		event = plot.Get_Event("Zoom_out")
		event.Set_Reward_Parameter(1, player_string_table[player_index])
		for i, string in pairs(planet_list) do
			event = plot.Get_Event("Zoom_Into_"..string)
			event.Set_Reward_Parameter(1, player_string_table[player_index])
		end


		
		dialog = "Dialog_Structure_Display"
		struct_dialog = plot.Get_Event("Set_Structures")
		struct_dialog.Set_Dialog(dialog)
		struct_dialog.Clear_Dialog_Text()

		

		show_text = plot.Get_Event("SCREEN_TEXT_Special_Structure")
		--remove_text = plot.Get_Event("REMOVE_ALL_TEXT")
		
		
	
		
		


		

		
	elseif message == OnUpdate then
		
			
		
				-- concatenate strings by using string1..string2
		for i, planetstring in pairs(planet_list) do
			if Check_Story_Flag(player , "ZOOMED_INTO_"..planetstring, nil, true) then
			if FindPlanet(planetstring).Get_Owner() == player then
					--Game_Message("TEXT_UNIT_VENGEANCE_FRIGATE")
				for j, structure in pairs(special_structures) do
					temp_structure_list = Find_All_Objects_Of_Type(structure)
					for k, obj in pairs(temp_structure_list) do
						if obj.Get_Planet_Location() == FindPlanet(planetstring) then
							show_text.Set_Reward_Parameter(0, text_table[j])
							Story_Event("SHOW_STRUCTURES")
							--Story_Event("RESET_TEXT_BRANCH")
							struct_dialog.Add_Dialog_Text("TEXT_DISPLAY_STRUCTURE", text_table[j])
						end
					end

				end
				Story_Event("SET_STRUCTURES")
				zoomed_in = true
			end
			end
		end

		
		if Check_Story_Flag(player, "ZOOMED_OUT", nil, true) then
			Remove_All_Text()
			struct_dialog.Clear_Dialog_Text()
		zoomed_in = false
		end		

	end
end





