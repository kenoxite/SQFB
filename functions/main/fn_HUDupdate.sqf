/*
  Author: kenoxite

  Description:
  Controls the update of the HUD's data 


  Parameter (s):


  Returns:


  Examples:

*/

// Squad
if (SQFB_opt_showSquad) then {
    private _grp = group SQFB_player;
    private _count = count units SQFB_player;
    if (_count != SQFB_unitCount || SQFB_showHUD) then {
    	[] call SQFB_fnc_HUDshow;
    };
	// Check for wounded units
	_grp setVariable ["SQFB_wounded", (units _grp) findIf {lifeState _x != "HEALTHY"} != -1];
};

// Friendlies
if (SQFB_opt_showFriendlies != "never") then {
    private _showFriendlies = SQFB_opt_showFriendlies == "always" || SQFB_showFriendlyHUD;
    SQFB_showFriendlies = [false, true] select _showFriendlies;

    if (SQFB_showFriendlies) then {
        private _range = if (((getPosASL vehicle SQFB_player) select 2) > 5 && !(isNull objectParent SQFB_player)) then { SQFB_opt_showFriendliesMaxRangeAir } else { SQFB_opt_showFriendliesMaxRange };
        // Only alive friendlies on foot and vehicles with crew
        private _nearFriendlies = (SQFB_player nearEntities [["CAManBase", "Helicopter", "Plane", "LandVehicle", "Ship"], _range]) select { side SQFB_player getFriend side _x >= 0.6 };
        // Remove units from the current player's group
        SQFB_knownFriendlies = _nearFriendlies - (units group SQFB_player);
        // Clean friendly taggers
        [false] call SQFB_fnc_cleanEnemyTaggers;
        // Create friendly taggers, used to display last known position of friendly units
        for "_i" from 0 to (count SQFB_knownFriendlies) -1 do
        {
            private _friendly = SQFB_knownFriendlies select _i;
            private _friendlyTaggerFound = SQFB_friendlyTagObjArr select { (_x select 1) == _friendly };
            if (count _friendlyTaggerFound == 0) then {
                if (SQFB_debug) then { diag_log format ["SQFB: updateHUD - friendlyTagger not found for unit: %1. Creating a new one...", _friendly] };
                private _friendlyTagger = createSimpleObject ["RoadCone_F", [0,0,0], false];
                _friendlyTagger hideObject true;
                SQFB_friendlyTagObjArr pushBack [_friendlyTagger, _friendly];
            };
        };
    };
} else {    
    SQFB_showFriendlyHUD = false;
    SQFB_showFriendlies = false;
    // Clean friendly taggers
    [false] call SQFB_fnc_cleanEnemyTaggers;
    SQFB_knownFriendlies = [];
};

// Enemies
if (SQFB_opt_showEnemies != "never") then {
    private _trackingDeviceEnabled = SQFB_opt_showEnemiesIfTrackingGear && call SQFB_fnc_trackingGearCheck;
    private _grpCount = count (units group SQFB_player);
    private _showSolo = SQFB_opt_enemyCheckSolo || (!SQFB_opt_enemyCheckSolo && _grpCount > 1);
    private _assignedTarget = assignedTarget SQFB_player;
    private _displayTarget = SQFB_opt_alwaysDisplayTarget && !isNull _assignedTarget;
    private _showEnemies = SQFB_opt_showEnemies == "always" || (SQFB_showEnemyHUD && _showSolo) ||  _trackingDeviceEnabled;
    SQFB_showEnemies = [false, true] select (_showEnemies || _displayTarget);

    if (SQFB_showEnemies) then {
        private _range = if (((getPosASL vehicle SQFB_player) select 2) > 5 && !(isNull objectParent SQFB_player)) then { SQFB_opt_showEnemiesMaxRangeAir } else { SQFB_opt_showEnemiesMaxRange };
        // Only alive enemies on foot and vehicles with crew
        private _targets = [[SQFB_player, _range] call SQFB_fnc_enemyTargets, [_assignedTarget]] select (_displayTarget && !_showEnemies); // Only display the assigned target if enemy HUD is not requested
        SQFB_knownEnemies = _targets select { alive _x && {({ alive _x } count (crew _x)) > 0} };
        // Clean enemy taggers
        [true] call SQFB_fnc_cleanEnemyTaggers;
        // Create enemy taggers, used to display last known position of enemy units
        for "_i" from 0 to (count SQFB_knownEnemies) -1 do
        {
            private _enemy = SQFB_knownEnemies select _i;
            private _enemyTaggerFound = SQFB_enemyTagObjArr select { (_x select 1) == _enemy };
            if (count _enemyTaggerFound == 0) then {
                if (SQFB_debug) then { diag_log format ["SQFB: updateHUD - enemyTagger not found for unit: %1. Creating a new one...", _enemy] };
                private _enemyTagger = createSimpleObject ["RoadCone_F", [0,0,0], false];
                _enemyTagger hideObject true;
                SQFB_enemyTagObjArr pushBack [_enemyTagger, _enemy];
            };
        };
    };
} else {    
    SQFB_showEnemyHUD = false;
    SQFB_showEnemies = false;
    // Clean enemy taggers
    [true] call SQFB_fnc_cleanEnemyTaggers;
    SQFB_knownEnemies = [];
};