/*
  Author: kenoxite

  Description:
  Deletes all tagger objects of units not in the SQFB_knownEnemies or SQFB_knownFriendlies array


  Parameter (s):
 

  Returns:


  Examples:

*/

params [["_checkEnemies", true]];

if (_checkEnemies) then { SQFB_deletingEnemyTaggers = true };
if (!_checkEnemies) then { SQFB_deletingFriendlyTaggers = true };

private _SQFB_tagObjArr = [
                            SQFB_friendlyTagObjArr,
                            SQFB_enemyTagObjArr
                        ] select _checkEnemies;

private _known = [
                        SQFB_knownFriendlies,
                        SQFB_knownEnemies
                    ] select _checkEnemies;

if (count _SQFB_tagObjArr > 0) then {
    private _tagObjArrTemp = +_SQFB_tagObjArr;
    private _delete = false;
    for "_i" from 0 to (count _SQFB_tagObjArr) -1 do
    {
        private _x = _SQFB_tagObjArr select _i;
        private _unit = _x select 1;
        if !(_unit in _known) then {
            // Remove unit vars
            _unit setVariable ["SQFB_unitData", nil];
            if (SQFB_debug) then { diag_log format ["SQFB: cleanTaggers - About to delete entries from _tagObjArr with enemies no longer detected. _i: %1. Current values: %2", _i, count _tagObjArr] };
            deleteVehicle (_x select 0);
            _tagObjArrTemp deleteAt _i;
            _delete = true;
        };
    };
    if (_delete) then {
        if (_checkEnemies) then { SQFB_enemyTagObjArr = +_tagObjArrTemp };
        if (!_checkEnemies) then { SQFB_friendlyTagObjArr = +_tagObjArrTemp };
        if (SQFB_debug) then { diag_log format ["SQFB: cleanTaggers - ENTRIES DELETED. Current values: %1", count _tagObjArr] };
    };
};

if (_checkEnemies) then { SQFB_deletingEnemyTaggers = false };
if (!_checkEnemies) then { SQFB_deletingFriendlyTaggers = false };