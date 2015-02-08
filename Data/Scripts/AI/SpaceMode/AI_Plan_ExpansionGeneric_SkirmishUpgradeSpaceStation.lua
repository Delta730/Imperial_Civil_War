-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/AI_Plan_ExpansionGeneric_SkirmishUpgradeSpaceStation.lua#1 $
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
-- (C) Petroglyph Games, Inc.
--
--
--  *****           **                          *                   *
--  *   **          *                           *                   *
--  *    *          *                           *                   *
--  *    *          *     *                 *   *          *        *
--  *   *     *** ******  * **  ****      ***   * *      * *****    * ***
--  *  **    *  *   *     **   *   **   **  *   *  *    * **   **   **   *
--  ***     *****   *     *   *     *  *    *   *  *   **  *    *   *    *
--  *       *       *     *   *     *  *    *   *   *  *   *    *   *    *
--  *       *       *     *   *     *  *    *   *   * **   *   *    *    *
--  *       **       *    *   **   *   **   *   *    **    *  *     *   *
-- **        ****     **  *    ****     *****   *    **    ***      *   *
--                                          *        *     *
--                                          *        *     *
--                                          *       *      *
--                                      *  *        *      *
--                                      ****       *       *
--
--/////////////////////////////////////////////////////////////////////////////////////////////////
-- C O N F I D E N T I A L   S O U R C E   C O D E -- D O   N O T   D I S T R I B U T E
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/AI_Plan_ExpansionGeneric_SkirmishUpgradeSpaceStation.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 54441 $
--
--          $DateTime: 2006/09/13 15:08:39 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////



require("pgevents")


function Definitions()
	
	Category = "Skirmish_Upgrade_Space_Station"
	IgnoreTarget = true
	TaskForce = {
	{
		"ReserveForce"
		,"RC_Level_Two_Tech_Upgrade | RC_Level_Three_Tech_Upgrade | RC_Level_Four_Tech_Upgrade = 0,1"
		,"EC_Level_Two_Tech_Upgrade | EC_Level_Three_Tech_Upgrade | EC_Level_Four_Tech_Upgrade = 0,1"
		,"UC_Level_Two_Tech_Upgrade | UC_Level_Three_Tech_Upgrade | uC_Level_Four_Tech_Upgrade = 0,1"
		,"PC_Level_Two_Tech_Upgrade | PC_Level_Three_Tech_Upgrade | PC_Level_Four_Tech_Upgrade = 0,1"
	}
	}
	RequiredCategories = {"Upgrade"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)
		
	ScriptExit()
end