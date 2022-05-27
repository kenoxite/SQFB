/*
  Author: kenoxite

  Description:
  Deletes all tagger objects of units not in the SQFB_knownEnemies or SQFB_knownFriendlies array


  Parameter (s):
 

  Returns:


  Examples:

*/

SQFB_deletingTaggers = true;
if (count SQFB_tagObjArr > 0) then {
    if (SQFB_debug) then { diag_log format ["SQFB: cleanTaggers - Current values: %1", count SQFB_tagObjArr] };
    private _tagObjArrTemp = +SQFB_tagObjArr;
    private _delete = false;
    for "_i" from 0 to (count SQFB_tagObjArr) -1 do
    {
        private _tagArr = SQFB_tagObjArr select _i;
        private _tagger = _tagArr select 0;
        private _unit = _tagArr select 1;
        if (!(_unit in SQFB_knownIFF)) then {
            // Remove unit vars
            _unit setVariable ["SQFB_unitData", nil];
            _unit setVariable ["SQFB_HUDdata", nil];
            _unit setVariable ["SQFB_side", nil];
            _unit setVariable ["SQFB_color", nil];
            _unit setVariable ["SQFB_isEnemy", nil];
            // if (SQFB_debug) then { diag_log format ["SQFB: cleanTaggers - About to delete entries from SQFB_tagObjArr with units no longer detected. _i: %1. Current values: %2", _i, count _tagObjArrTemp] };
            deleteVehicle _tagger;
            _tagObjArrTemp deleteAt _i;
            _delete = true;
        };
    };
    if (_delete) then {
        if (SQFB_debug) then { diag_log format ["SQFB: cleanTaggers - %1 ENTRIES DELETED. Current values: %2", (count SQFB_tagObjArr) - (count _tagObjArrTemp), count _tagObjArrTemp] };
        SQFB_tagObjArr = +_tagObjArrTemp;
    };
};

SQFB_deletingTaggers = false;
