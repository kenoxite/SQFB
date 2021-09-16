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

if (SQFB_opt_showEnemies && (SQFB_opt_AlwaysShowEnemies || SQFB_showEnemyHUD)) then {
    private _veh = vehicle player;
    private _range = if ((getPosASL _veh select 2) > 5 && _veh != player) then { SQFB_opt_showEnemiesMaxRangeAir } else { SQFB_opt_showEnemiesMaxRange };
    SQFB_knownEnemies = [player, _range] call SQFB_fnc_enemyTargets;
    // Remove vehicles with no crew
    // SQFB_knownEnemies = SQFB_knownEnemies select { ({ alive _x } count (crew _x)) > 0 };
    // Create enemy taggers
    for "_i" from 0 to (count SQFB_knownEnemies) -1 do
    {
        private _enemy = SQFB_knownEnemies select _i;
        private _enemyTaggerFound = SQFB_enemyTagObjArr select { (_x select 1) == _enemy };
        if (count _enemyTaggerFound == 0) then {
            if (SQFB_debug) then { diag_log format ["SQFB: updateHUD - enemyTagger not found for unit: %1. Creating a new one...", _enemy] };
            // private _enemyTagger = createVehicle ["FlagPole_F", [0,0,0], [], 0, "CAN_COLLIDE"];
            private _enemyTagger = createSimpleObject ["RoadCone_F", [0,0,0]];
            _enemyTagger hideObject true;
            SQFB_enemyTagObjArr pushBack [_enemyTagger, _enemy, true];
        };
    };

    // Clean enemy taggers
    private _taggersToDelete = [];
    private _SQFB_enemyTagObjArr = +SQFB_enemyTagObjArr;
    private _enemyTagObjArrTemp = SQFB_enemyTagObjArr;
    private _delete = false;
    for "_i" from 0 to (count _SQFB_enemyTagObjArr) -1 do
    {
        private _x = _SQFB_enemyTagObjArr select _i;
        if !((_x select 1) in SQFB_knownEnemies) then {
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