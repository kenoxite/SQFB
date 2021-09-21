/*
  Author: kenoxite

  Description:
  Deletes all enemy tagger objects of units not in the SQFB_knownEnemies array


  Parameter (s):
 

  Returns:


  Examples:

*/

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
            // Remove unit vars
            _unit setVariable ["SQFB_enemyData", nil];
            if (SQFB_debug) then { diag_log format ["SQFB: updateHUD - About to delete entries with enemies no longer detected from SQFB_enemyTagObjArr. _i: %1. Current values: %2", _i, count SQFB_enemyTagObjArr] };
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
