/*
Author: kenoxite

Description:
Change settings based on chosen profile 


Parameter (s):


Returns:


Examples:

*/

if (SQFB_debug) then { diag_log format ["SQFB: changeProfile - 1 - Profile to change to: %1", SQFB_opt_profile] };

// "custom", "default", "all", "min", "crit", "vanillalike", onlyenemies"
switch (SQFB_opt_profile) do {

    case "custom": {
        // Nothing is changed
    };

    case "all": {
        SQFB_opt_showSquad = true;
        SQFB_opt_showEnemies = "keypressed";
        SQFB_opt_showFriendlies = "keypressed";

        SQFB_opt_showIcon = true;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = true;
        SQFB_opt_showName = true;
        SQFB_opt_showClass = true;
        SQFB_opt_showRoles = true;
        SQFB_opt_showRolesIcon = true;
        SQFB_opt_showDist = true;
        SQFB_opt_showDistEnemy = true;
        SQFB_opt_showDistFriendly = true;

        SQFB_opt_Arrows = true;
        SQFB_opt_outFOVindex = true;
        SQFB_opt_showCrew = true;
        SQFB_opt_showDead = true;
        SQFB_opt_AlwaysShowCritical = "always";

        SQFB_opt_IFFCheckSolo = "always";
        SQFB_opt_lastKnownEnemyPositionOnly = "never";
        SQFB_opt_lastKnownFriendlyPositionOnly = "never";
        SQFB_opt_enemySideColors = "current";
        SQFB_opt_friendlySideColors = "current";
        SQFB_opt_changeIconsToBlufor = true;
    };

    case "min": {
        SQFB_opt_showSquad = true;
        SQFB_opt_showEnemies = "keypressed";
        SQFB_opt_showFriendlies = "keypressed";
        
        SQFB_opt_showIcon = true;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = true;
        SQFB_opt_showName = false;
        SQFB_opt_showClass = false;
        SQFB_opt_showRoles = false;
        SQFB_opt_showRolesIcon = true;
        SQFB_opt_showDist = false;
        SQFB_opt_showDistEnemy = false;
        SQFB_opt_showDistFriendly = false;

        SQFB_opt_Arrows = true;
        SQFB_opt_outFOVindex = true;
        SQFB_opt_showCrew = true;
        SQFB_opt_showDead = true;
        SQFB_opt_AlwaysShowCritical = "always";

        SQFB_opt_IFFCheckSolo = "always";
        SQFB_opt_lastKnownEnemyPositionOnly = "never";
        SQFB_opt_lastKnownFriendlyPositionOnly = "never";
        SQFB_opt_enemySideColors = "never";
        SQFB_opt_friendlySideColors = "never";
        SQFB_opt_changeIconsToBlufor = false;
    };

    case "crit": {
        SQFB_opt_showSquad = true;
        SQFB_opt_showEnemies = "keypressed";
        SQFB_opt_showFriendlies = "keypressed";
        
        SQFB_opt_showIcon = true;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = false;
        SQFB_opt_showName = false;
        SQFB_opt_showClass = false;
        SQFB_opt_showRoles = false;
        SQFB_opt_showRolesIcon = false;
        SQFB_opt_showDist = false;
        SQFB_opt_showDistEnemy = false;
        SQFB_opt_showDistFriendly = false;

        SQFB_opt_Arrows = true;
        SQFB_opt_outFOVindex = false;
        SQFB_opt_showCrew = false;
        SQFB_opt_showDead = true;
        SQFB_opt_AlwaysShowCritical = "always";

        SQFB_opt_IFFCheckSolo = "always";
        SQFB_opt_lastKnownEnemyPositionOnly = "never";
        SQFB_opt_lastKnownFriendlyPositionOnly = "never";
        SQFB_opt_enemySideColors = "never";
        SQFB_opt_friendlySideColors = "never";
        SQFB_opt_changeIconsToBlufor = false;
    };

    case "vanillalike": {
        SQFB_opt_showSquad = true;
        SQFB_opt_showEnemies = "keypressed";
        SQFB_opt_showFriendlies = "keypressed";
        
        SQFB_opt_showIcon = false;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = true;
        SQFB_opt_showName = false;
        SQFB_opt_showClass = true;
        SQFB_opt_showRoles = false;
        SQFB_opt_showRolesIcon = false;
        SQFB_opt_showDist = false;
        SQFB_opt_showDistEnemy = false;
        SQFB_opt_showDistFriendly = false;

        SQFB_opt_Arrows = false;
        SQFB_opt_outFOVindex = false;
        SQFB_opt_showCrew = true;
        SQFB_opt_showDead = false;
        SQFB_opt_AlwaysShowCritical = "always";

        SQFB_opt_IFFCheckSolo = "always";
        SQFB_opt_lastKnownEnemyPositionOnly = "never";
        SQFB_opt_lastKnownFriendlyPositionOnly = "never";
        SQFB_opt_enemySideColors = "never";
        SQFB_opt_friendlySideColors = "never";
        SQFB_opt_changeIconsToBlufor = false;
    };

    case "onlyalwaysenemies": {
        SQFB_opt_showSquad = false;
        SQFB_opt_showEnemies = "always";
        SQFB_opt_showFriendlies = "never";
        
        SQFB_opt_showIcon = true;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = false;
        SQFB_opt_showName = false;
        SQFB_opt_showClass = false;
        SQFB_opt_showRoles = false;
        SQFB_opt_showRolesIcon = false;
        SQFB_opt_showDist = false;
        SQFB_opt_showDistEnemy = true;
        SQFB_opt_showDistFriendly = false;

        SQFB_opt_Arrows = false;
        SQFB_opt_outFOVindex = false;
        SQFB_opt_showCrew = false;
        SQFB_opt_showDead = false;
        SQFB_opt_AlwaysShowCritical = "never";

        SQFB_opt_IFFCheckSolo = "always";
        SQFB_opt_lastKnownEnemyPositionOnly = "never";
        SQFB_opt_lastKnownFriendlyPositionOnly = "never";
        SQFB_opt_enemySideColors = "never";
        SQFB_opt_friendlySideColors = "never";
        SQFB_opt_changeIconsToBlufor = false;
    };

    case "hightech": {
        SQFB_opt_showSquad = true;
        SQFB_opt_showEnemies = "device";
        SQFB_opt_showFriendlies = "device";
        
        SQFB_opt_showIcon = true;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = true;
        SQFB_opt_showName = true;
        SQFB_opt_showClass = false;
        SQFB_opt_showRoles = true;
        SQFB_opt_showRolesIcon = true;
        SQFB_opt_showDist = true;
        SQFB_opt_showDistEnemy = true;
        SQFB_opt_showDistFriendly = true;

        SQFB_opt_Arrows = true;
        SQFB_opt_outFOVindex = true;
        SQFB_opt_showCrew = true;
        SQFB_opt_showDead = true;
        SQFB_opt_AlwaysShowCritical = "always";

        SQFB_opt_IFFCheckSolo = "device";
        SQFB_opt_lastKnownEnemyPositionOnly = "device";
        SQFB_opt_lastKnownFriendlyPositionOnly = "device";
        SQFB_opt_enemySideColors = "never";
        SQFB_opt_friendlySideColors = "never";
        SQFB_opt_changeIconsToBlufor = false;
    };

    case "immersion": {
        SQFB_opt_showSquad = true;
        SQFB_opt_showEnemies = "keypressed";
        SQFB_opt_showFriendlies = "keypressed";
        
        SQFB_opt_showIcon = true;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = false;
        SQFB_opt_showName = false;
        SQFB_opt_showClass = false;
        SQFB_opt_showRoles = false;
        SQFB_opt_showRolesIcon = true;
        SQFB_opt_showDist = false;
        SQFB_opt_showDistEnemy = false;
        SQFB_opt_showDistFriendly = false;

        SQFB_opt_Arrows = false;
        SQFB_opt_outFOVindex = false;
        SQFB_opt_showCrew = false;
        SQFB_opt_showDead = false;
        SQFB_opt_AlwaysShowCritical = "never";

        SQFB_opt_IFFCheckSolo = "never";
        SQFB_opt_lastKnownEnemyPositionOnly = "always";
        SQFB_opt_lastKnownFriendlyPositionOnly = "always";
        SQFB_opt_enemySideColors = "current";
        SQFB_opt_friendlySideColors = "current";
        SQFB_opt_changeIconsToBlufor = true;
    };

    case "author": {
        SQFB_opt_showSquad = true;
        SQFB_opt_showEnemies = "keypressed";
        SQFB_opt_showFriendlies = "keypressed";
        
        SQFB_opt_showIcon = true;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = true;
        SQFB_opt_showName = true;
        SQFB_opt_showClass = false;
        SQFB_opt_showRoles = false;
        SQFB_opt_showRolesIcon = true;
        SQFB_opt_showDist = false;
        SQFB_opt_showDistEnemy = false;
        SQFB_opt_showDistFriendly = false;

        SQFB_opt_Arrows = false;
        SQFB_opt_outFOVindex = false;
        SQFB_opt_showCrew = false;
        SQFB_opt_showDead = true;
        SQFB_opt_AlwaysShowCritical = "infantry";

        SQFB_opt_IFFCheckSolo = "device";
        SQFB_opt_lastKnownEnemyPositionOnly = "device";
        SQFB_opt_lastKnownFriendlyPositionOnly = "device";
        SQFB_opt_enemySideColors = "current";
        SQFB_opt_friendlySideColors = "current";
        SQFB_opt_changeIconsToBlufor = true;
    };

    default {
        SQFB_opt_showSquad = true;
        SQFB_opt_showEnemies = "keypressed";
        SQFB_opt_showFriendlies = "keypressed";
        
        SQFB_opt_showIcon = true;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = true;
        SQFB_opt_showName = true;
        SQFB_opt_showClass = false;
        SQFB_opt_showRoles = true;
        SQFB_opt_showRolesIcon = true;
        SQFB_opt_showDist = false;
        SQFB_opt_showDistEnemy = false;
        SQFB_opt_showDistFriendly = false;

        SQFB_opt_Arrows = true;
        SQFB_opt_outFOVindex = true;
        SQFB_opt_showCrew = true;
        SQFB_opt_showDead = true;
        SQFB_opt_AlwaysShowCritical = "always";

        SQFB_opt_IFFCheckSolo = "always";
        SQFB_opt_lastKnownEnemyPositionOnly = "never";
        SQFB_opt_lastKnownFriendlyPositionOnly = "never";
        SQFB_opt_enemySideColors = "never";
        SQFB_opt_friendlySideColors = "never";
        SQFB_opt_changeIconsToBlufor = false;
    };   
};

// Save CBA settings
["SQFB_opt_showSquad", SQFB_opt_showSquad, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showEnemies", SQFB_opt_showEnemies, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showFriendlies", SQFB_opt_showFriendlies, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showIcon", SQFB_opt_showIcon, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showText", SQFB_opt_showText, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showColor", SQFB_opt_showColor, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showIndex", SQFB_opt_showIndex, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showName", SQFB_opt_showName, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showClass", SQFB_opt_showClass, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showRoles", SQFB_opt_showRoles, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showRolesIcon", SQFB_opt_showRolesIcon, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showDist", SQFB_opt_showDist, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showDistEnemy", SQFB_opt_showDistEnemy, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showDistFriendly", SQFB_opt_showDistFriendly, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_Arrows", SQFB_opt_Arrows, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_outFOVindex", SQFB_opt_outFOVindex, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showCrew", SQFB_opt_showCrew, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_showDead", SQFB_opt_showDead, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_AlwaysShowCritical", SQFB_opt_AlwaysShowCritical, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_IFFCheckSolo", SQFB_opt_IFFCheckSolo, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_lastKnownEnemyPositionOnly", SQFB_opt_lastKnownEnemyPositionOnly, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_lastKnownFriendlyPositionOnly", SQFB_opt_lastKnownFriendlyPositionOnly, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_enemySideColors", SQFB_opt_enemySideColors, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_friendlySideColors", SQFB_opt_friendlySideColors, 0, "server", true] call CBA_settings_fnc_set;
["SQFB_opt_changeIconsToBlufor", SQFB_opt_changeIconsToBlufor, 0, "server", true] call CBA_settings_fnc_set;

SQFB_opt_profile_old = SQFB_opt_profile;

if (SQFB_debug) then { diag_log format ["SQFB: changeProfile - 2 - Profile changed: %1", SQFB_opt_profile] };
