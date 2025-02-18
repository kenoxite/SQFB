class CfgPatches
{
	class Squad_Feedback
	{
        name = "Squad Feedback";
        author = "kenoxite";
        authors[] = {"kenoxite"};
        version = "3.2";
        //url = "";

        requiredVersion = 2.14; 
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
            class getUnitPositionId {};
            class addUnits {};
            class updateAllUnits {};
            class resetUnit {};
            class updateUnit {};
            class playerUnit {};
            class playerInDrone {};

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
            class IFFupdate {};
            class IFFactivateDevice {};
            class playSound {};
            class inValidRange {};
            class isUnitOccluded {};

            class setNameSound {};
            class changeToValidName {};
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

class CfgSounds
{
    sounds[] = {};

    // Effects
    class SQFB_beep_On
    {
        name = "[SQFB] Beep - On";
        // filename, volume, pitch, distance (optional)
        sound[] = { "\SQFB\sounds\sfx\beep_on", db, 1, 100 };
        titles[] = {};
    };
    class SQFB_beep_Off
    {
        name = "[SQFB] Beep - Off";
        sound[] = { "\SQFB\sounds\sfx\beep_off", db, 1, 100 };
        titles[] = {};
    };

    class SQFB_focus_On
    {
        name = "[SQFB] Focus - On";
        sound[] = { "\SQFB\sounds\sfx\focus_on", db, 1, 100 };
        titles[] = {};
    };
    class SQFB_focus_Off
    {
        name = "[SQFB] Focus - Off";
        sound[] = { "\SQFB\sounds\sfx\focus_off", db, 1, 100 };
        titles[] = {};
    };

    class SQFB_radio_On
    {
        name = "[SQFB] Radio - On";
        sound[] = { "\SQFB\sounds\sfx\radiocomm_on", db, 1, 100 };
        titles[] = {};
    };
    class SQFB_radio_Off
    {
        name = "[SQFB] Radio - Off";
        sound[] = { "\SQFB\sounds\sfx\radiocomm_off", db, 1, 100 };
        titles[] = {};
    };
};
