class CfgPatches
{
	class Squad_Feedback
	{
        name = "Squad Feedback";
        author = "kenoxite";
        authors[] = {"kenoxite"};
        version = "1.1";
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
        class SQFBinit
        {
            class postInit
            {
                postInit = 1;
                file = "SQFB\functions\init.sqf";
            };
        };

        class Main
        {
            file = "SQFB\functions\main";

            class initGroup {};
            class checkGroupChange {};
            class getUnitPositionId {};
            class addUnits {};
            class updateAllUnits {};
            class resetUnit {};
            class updateUnit {};
            class playerUnit {};

            class HUDshow {};
            class HUDhide {};
            class HUDupdate {};
            class HUDdrawSquad {};
            class HUDdrawIFF {};
            class HUDtext {};
            class HUDIcon {};
            class HUDAlpha {};
            class HUDColor {};
            class HUDtextVeh {};
            class HUDIconVeh {};

            class changeProfile {};
            class trackingGearAdd {};
            class trackingGearCheck {};

            class trueZoom {};
            class enemyTargets {};
            class checkVisibility {};
            class cleanTaggers {};
            class classType {};
            class factionSide {};
            class knownFriendsAndFoes {};
            class checkOcclusion {};
        };

        class CBA
        {
            file = "SQFB\functions\cba";

            // CBA keys
            class showHUD_key_CBA {};
            class hideHUD_key_CBA {};
            class showHUD_key_T_CBA {};
            class showEnemyHUD_key_CBA {};
            class hideEnemyHUD_key_CBA {};
            class showEnemyHUD_key_T_CBA {};
        };
    };
};