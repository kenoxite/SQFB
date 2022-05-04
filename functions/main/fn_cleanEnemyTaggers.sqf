/*
  Author: kenoxite

  Description:
  Deletes all tagger objects of units not in the SQFB_knownEnemies or SQFB_knownFriendlies array


  Parameter (s):
 

  Returns:


  Examples:

*/

params [["_checkEnemies", true]];

private _tagObjArr = [
                        SQFB_friendlyTagObjArr,
                        SQFB_enemyTagObjArr
                    ] select _checkEnemies;

private _known = [
                        SQFB_knownFriendlies,
                        SQFB_knownEnemies
                    ] select _checkEnemies;

if (count _tagObjArr > 0) then {
    private _taggersToDelete = [];
    private _SQFB_tagObjArr = +_tagObjArr;
    private _tagObjArrTemp = _tagObjArr;
    private _delete = false;
    for "_i" from 0 to (count _SQFB_tagObjArr) -1 do
    {
        private _x = _SQFB_tagObjArr select _i;
        private _unit = _x select 1;
        if !(_unit in _known) then {
            // Remove unit vars
            [
                _unit setVariable ["SQFB_enemyData", nil],
                _unit setVariable ["SQFB_friendlyData", nil]
            ] select _checkEnemies;
            if (SQFB_debug) then { diag_log format ["SQFB: cleanTaggers - About to delete entries with enemies no longer detected from _tagObjArr. _i: %1. Current values: %2", _i, count _tagObjArr] };
            deleteVehicle (_x select 0);
            _tagObjArrTemp deleteAt _i;
            _delete = true;
        };
    };
    if (_delete) then {
        _tagObjArr = +_tagObjArrTemp;
        if (SQFB_debug) then { diag_log format ["SQFB: cleanTaggers - ENTRIES DELETED. Current values: %1", count _tagObjArr] };
    };
};
