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
    	[] call SQFB_fnc_showHUD_init;
    	SQFB_unitCount = _count;
    };
    if (!SQFB_showHUD) then {
    	// Check for wounded units
    	_grp setVariable ["SQFB_wounded", (units _grp) findIf {lifeState _x != "HEALTHY"} != -1];
    };
};

if (SQFB_opt_showEnemies != "never") then {
    // SQFB_showEnemies = if (SQFB_opt_showEnemies != "never" && {SQFB_opt_showEnemies == "always" || _hasTrackingGear}) then { true } else { false };
    SQFB_showEnemies = [false, true] select (SQFB_opt_showEnemies != "never" && {SQFB_opt_showEnemies == "always" || {SQFB_opt_showEnemiesIfTrackingGear && call SQFB_fnc_trackingGearCheck}});

    if (SQFB_showEnemies || SQFB_showEnemyHUD) then {
        private _vehPlayer = vehicle player;
        private _range = if ((getPosASL _vehPlayer select 2) > 5 && !(isNull objectParent player)) then { SQFB_opt_showEnemiesMaxRangeAir } else { SQFB_opt_showEnemiesMaxRange };
        // SQFB_knownEnemies = [player, _range] call SQFB_fnc_enemyTargets;
        // Only alive enemies on foot and vehicles with crew
        SQFB_knownEnemies = ([player, _range] call SQFB_fnc_enemyTargets) select { alive _x && {({ alive _x } count (crew _x)) > 0} };
        // Create enemy taggers
        for "_i" from 0 to (count SQFB_knownEnemies) -1 do
        {
            private _enemy = SQFB_knownEnemies select _i;
            private _enemyTaggerFound = SQFB_enemyTagObjArr select { (_x select 1) == _enemy };
            if (count _enemyTaggerFound == 0) then {
                if (SQFB_debug) then { diag_log format ["SQFB: updateHUD - enemyTagger not found for unit: %1. Creating a new one...", _enemy] };
                private _enemyTagger = createSimpleObject ["RoadCone_F", [0,0,0]];
                _enemyTagger hideObject true;
                SQFB_enemyTagObjArr pushBack [_enemyTagger, _enemy, true];
            };
        };
    };
} else {
    SQFB_showEnemyHUD = false;
    SQFB_showEnemies = false;
    SQFB_knownEnemies = [];
};

// Clean enemy taggers
if (count SQFB_enemyTagObjArr > 0) then {
    private _taggersToDelete = [];
    private _SQFB_enemyTagObjArr = +SQFB_enemyTagObjArr;
    private _enemyTagObjArrTemp = SQFB_enemyTagObjArr;
    private _delete = false;
    for "_i" from 0 to (count _SQFB_enemyTagObjArr) -1 do
    {
        private _x = _SQFB_enemyTagObjArr select _i;
        private _unit = _x select 1;
        // if (({ alive _x } count crew (vehicle _unit)) == 0) then { SQFB_knownEnemies deleteAt _i };
        if !(_unit in SQFB_knownEnemies) then {
            if (SQFB_debug) then { diag_log format ["SQFB: updateHUD - About to delete entries with dead units from SQFB_enemyTagObjArr. _i: %1. Current values: %2", _i, count SQFB_enemyTagObjArr] };
            deleteVehicle (_x select 0);
            _enemyTagObjArrTemp deleteAt _i;
            _delete = true;
        };
    };
    if (_delete) then {
        SQFB_enemyTagObjArr = +_enemyTagObjArrTemp;
        if (SQFB_debug) then { diag_log format ["SQFB: updateHUD - ENTRIES DELETED. Current values: %1", count SQFB_enemyTagObjArr] };
    };
};