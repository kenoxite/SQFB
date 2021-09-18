/*
  Author: kenoxite

  Description:
  Adds custom items to the corresponding enemy tracking gear array 


  Parameter (s):


  Returns:


  Examples:

*/

params [["_classes", [], [[]]], ["_type", "", [""]]];

private _arr = call compile format ["SQFB_enemyTracking%1", _type];
if (isNil "_arr") exitWith {
    [{!isNil "_arr"}, SQFB_fnc_trackingGearAdd, [_classes, _type]] call CBA_fnc_waitUntilAndExecute;
};

private _arr_def = call compile format ["SQFB_enemyTracking%1_default", _type];
private _count = (count _arr)-1;
for "_i" from 0 to _count do { _arr deleteAt 0 };
_arr append _arr_def;
_arr append _classes;

if (SQFB_debug) then { diag_log format ["SQFB: addTrackingGear - %1: %2", format ["SQFB_enemyTracking%1", _type], _arr] };
