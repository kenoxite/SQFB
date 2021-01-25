class CfgPatches
{
	class Squad_Feedback
	{
        name = "Squad Feedback";
        author = "kenoxite";
        authors[] = {"kenoxite"};
        version = "1.0";
        //url = "";

        requiredVersion = 1.60; 
        requiredAddons[] = { "A3_Functions_F", "CBA_Main", "cba_settings", "Extended_Eventhandlers" };
        units[] = {};
        weapons[] = {};
	};
};

class Extended_PreInit_EventHandlers {
    class SQFB_settings {
        init = "call compile preprocessFileLineNumbers 'SQFB\functions\XEH_preInit.sqf'";
    };
};

class CfgFunctions
{
	class SQFB
	{
		class Init
		{
			class SQFBinit
			{
				postInit = 1;
				file = "SQFB\functions\init.sqf";
			};
		};

		class Main
		{
			file = "SQFB\functions\main";

			class initGroup {};
			class showHUD_init {};
			// class hideHUD {};
			class updateHUD {};
			class checkGroupChange {};
			class getUnitPositionId {};
			class addUnits {};
			class updateAllUnits {};
			class trueZoom {};

			// Infantry
			class resetUnit {};
			class updateUnit {};
			class HUDtext {};
			class statusIcon {};
			class setAlpha {};
			class teamColor {};

			// Vehicles
			// class updateVehicle {};
			class HUDtextVeh {};
			class statusIconVeh {};
		};

		class CBA
		{
			file = "SQFB\functions\cba";

			// CBA keys
			class showHUD_key_CBA {};
			class hideHUD_key_CBA {};
			class showHUD_key_T_CBA {};
		};
	};
};