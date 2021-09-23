/*
  Author: kenoxite

  Description:
  Controls the update of the HUD's data 


  Parameter (s):


  Returns:


  Examples:

*/

if (SQFB_opt_showSquad) then {
    private _grp = group player;
    private _count = count units player;
    if (_count != SQFB_unitCount || SQFB_showHUD) then {
    	[] call SQFB_fnc_HUDshow;
    };
    if (!SQFB_showHUD) then {
    	// Check for wounded units
    	_grp setVariable ["SQFB_wounded", (units _grp) findIf {lifeState _x != "HEALTHY"} != -1];
    };
};

if (SQFB_opt_showEnemies != "never") then {
    private _trackingDeviceEnabled = SQFB_opt_showEnemiesIfTrackingGear && call SQFB_fnc_trackingGearCheck;
    private _grpCount = count (units group player);
    private _showSolo = SQFB_opt_enemyCheckSolo || (!SQFB_opt_enemyCheckSolo && _grpCount > 1);
    SQFB_showEnemies = [false, true] select (SQFB_opt_showEnemies != "never" && (SQFB_opt_showEnemies == "always" || (SQFB_showEnemyHUD && _showSolo) ||  _trackingDeviceEnabled));

    if (SQFB_showEnemies) then {
        private _range = if (((getPosASL vehicle player) select 2) > 5 && !(isNull objectParent player)) then { SQFB_opt_showEnemiesMaxRangeAir } else { SQFB_opt_showEnemiesMaxRange };
        // Only alive enemies on foot and vehicles with crew
        SQFB_knownEnemies = ([player, _range] call SQFB_fnc_enemyTargets) select { alive _x && {({ alive _x } count (crew _x)) > 0} };
        // Clean enemy taggers
        call SQFB_fnc_cleanEnemyTaggers;
        // Create enemy taggers, used to display last known position of enemy units
        for "_i" from 0 to (count SQFB_knownEnemies) -1 do
        {
            private _enemy = SQFB_knownEnemies select _i;
            private _enemyTaggerFound = SQFB_enemyTagObjArr select { (_x select 1) == _enemy };
            if (count _enemyTaggerFound == 0) then {
                if (SQFB_debug) then { diag_log format ["SQFB: updateHUD - enemyTagger not found for unit: %1. Creating a new one...", _enemy] };
                private _enemyTagger = createSimpleObject ["RoadCone_F", [0,0,0]];
                _enemyTagger hideObject true;
                SQFB_enemyTagObjArr pushBack [_enemyTagger, _enemy];
            };
        };
    };
} else {    
    SQFB_showEnemyHUD = false;
    SQFB_showEnemies = false;
    // Clean enemy taggers
    call SQFB_fnc_cleanEnemyTaggers;
    SQFB_knownEnemies = [];
};