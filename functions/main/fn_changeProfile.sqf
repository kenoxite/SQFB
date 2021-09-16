/*
Author: kenoxite

Description:
Change settings based on chosen profile 


Parameter (s):


Returns:


Examples:

*/

diag_log format ["SQFB: changeProfile - 1 - Profile to change to: %1", SQFB_opt_profile];

// "custom", "default", "all", "min", "crit", "vanillalike", onlyenemies"
switch (SQFB_opt_profile) do {

    case "custom": {
        // Nothing is changed
    };

    case "all": {
        SQFB_opt_showSquad = true;
        SQFB_opt_showEnemies = true;

        SQFB_opt_showIcon = true;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = true;
        SQFB_opt_showClass = true;
        SQFB_opt_showRoles = true;
        SQFB_opt_showDist = true;
        SQFB_opt_showDistEnemy = true;

        SQFB_opt_Arrows = true;
        SQFB_opt_outFOVindex = true;
        SQFB_opt_showCrew = true;
        SQFB_opt_showDead = true;
        SQFB_opt_AlwaysShowCritical = true;
        SQFB_opt_AlwaysShowEnemies = false;
    };

    case "min": {
        SQFB_opt_showSquad = true;
        SQFB_opt_showEnemies = true;
        
        SQFB_opt_showIcon = true;
        SQFB_opt_showText = false;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = true;
        SQFB_opt_showClass = false;
        SQFB_opt_showRoles = true;
        SQFB_opt_showDist = false;
        SQFB_opt_showDistEnemy = false;

        SQFB_opt_Arrows = true;
        SQFB_opt_outFOVindex = true;
        SQFB_opt_showCrew = true;
        SQFB_opt_showDead = true;
        SQFB_opt_AlwaysShowCritical = true;
        SQFB_opt_AlwaysShowEnemies = false;
    };

    case "crit": {
        SQFB_opt_showSquad = true;
        SQFB_opt_showEnemies = true;
        
        SQFB_opt_showIcon = true;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = false;
        SQFB_opt_showClass = false;
        SQFB_opt_showRoles = false;
        SQFB_opt_showDist = false;
        SQFB_opt_showDistEnemy = false;

        SQFB_opt_Arrows = true;
        SQFB_opt_outFOVindex = false;
        SQFB_opt_showCrew = false;
        SQFB_opt_showDead = true;
        SQFB_opt_AlwaysShowCritical = true;
        SQFB_opt_AlwaysShowEnemies = false;
    };

    case "vanillalike": {
        SQFB_opt_showSquad = true;
        SQFB_opt_showEnemies = true;
        
        SQFB_opt_showIcon = false;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = true;
        SQFB_opt_showClass = true;
        SQFB_opt_showRoles = false;
        SQFB_opt_showDist = false;
        SQFB_opt_showDistEnemy = false;

        SQFB_opt_Arrows = false;
        SQFB_opt_outFOVindex = false;
        SQFB_opt_showCrew = true;
        SQFB_opt_showDead = false;
        SQFB_opt_AlwaysShowCritical = true;
        SQFB_opt_AlwaysShowEnemies = false;
    };

    case "onlyalwaysenemies": {
        SQFB_opt_showSquad = false;
        SQFB_opt_showEnemies = true;
        
        SQFB_opt_showIcon = true;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = false;
        SQFB_opt_showClass = false;
        SQFB_opt_showRoles = false;
        SQFB_opt_showDist = true;
        SQFB_opt_showDistEnemy = true;

        SQFB_opt_Arrows = false;
        SQFB_opt_outFOVindex = false;
        SQFB_opt_showCrew = false;
        SQFB_opt_showDead = false;
        SQFB_opt_AlwaysShowCritical = false;
        SQFB_opt_AlwaysShowEnemies = true;
    };

    default {
        SQFB_opt_showSquad = true;
        SQFB_opt_showEnemies = true;
        
        SQFB_opt_showIcon = true;
        SQFB_opt_showText = true;
        SQFB_opt_showColor = true;
        SQFB_opt_showIndex = true;
        SQFB_opt_showClass = false;
        SQFB_opt_showRoles = true;
        SQFB_opt_showDist = true;
        SQFB_opt_showDistEnemy = false;

        SQFB_opt_Arrows = true;
        SQFB_opt_outFOVindex = true;
        SQFB_opt_showCrew = true;
        SQFB_opt_showDead = true;
        SQFB_opt_AlwaysShowCritical = true;
        SQFB_opt_AlwaysShowEnemies = false;
    };   
};

// Save CBA settings
// if (SQFB_opt_profile != "custom") then {
    ["SQFB_opt_showSquad", SQFB_opt_showSquad, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_showEnemies", SQFB_opt_showEnemies, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_showIcon", SQFB_opt_showIcon, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_showText", SQFB_opt_showText, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_showColor", SQFB_opt_showColor, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_showIndex", SQFB_opt_showIndex, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_showClass", SQFB_opt_showClass, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_showRoles", SQFB_opt_showRoles, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_showDist", SQFB_opt_showDist, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_showDistEnemy", SQFB_opt_showDistEnemy, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_Arrows", SQFB_opt_Arrows, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_outFOVindex", SQFB_opt_outFOVindex, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_showCrew", SQFB_opt_showCrew, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_showDead", SQFB_opt_showDead, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_AlwaysShowCritical", SQFB_opt_AlwaysShowCritical, 0, "server", true] call CBA_settings_fnc_set;
    ["SQFB_opt_AlwaysShowEnemies", SQFB_opt_AlwaysShowEnemies, 0, "server", true] call CBA_settings_fnc_set;
// };


SQFB_opt_profile_old = SQFB_opt_profile;

diag_log format ["SQFB: changeProfile - 2 - Profile changed: %1", SQFB_opt_profile];
