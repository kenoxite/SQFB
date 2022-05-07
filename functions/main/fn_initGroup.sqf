/*
  Author: kenoxite

  Description:
  Initialize group 


  Parameter (s):
  _this select 0: _grp
 

  Returns:


  Examples:

*/

params [["_grp", SQFB_group]];

if (SQFB_debug) then { diag_log format ["SQFB: initGroup - Initializing new group: %1 (old group: %2)", _grp, SQFB_group] };

private _units = units _grp;
// _grp setVariable ["SQFB_group_static", [_grp, _units]];
_grp setVariable ["SQFB_wounded", false];

// Initialize the units group index
{ _x setVariable ["SQFB_grpIndex", _x call SQFB_fnc_getUnitPositionId]; _x setVariable ["SQFB_lastGroup", group _x] } forEach _units;

// Update global vars
SQFB_group = _grp;
SQFB_units = _units;
SQFB_unitCount = count _units;

// Add dead units, which might not being tracked if player changed groups already
{
    if ((_x getVariable "SQFB_lastGroup") == SQFB_group) then { SQFB_units pushBackUnique _x };   
} forEach SQFB_deadUnits;

// Update all
[_units] call SQFB_fnc_addUnits;
call SQFB_fnc_updateAllUnits;

// Reset enemy vars
SQFB_showEnemies = false;
SQFB_knownEnemies = [];
// Clean enemy taggers
[true] call SQFB_fnc_cleanTaggers;
SQFB_enemyTagObjArr = [];

// Reset friendly vars
SQFB_showFriendlies = false;
SQFB_knownFriendlies = [];
// Clean friendly taggers
[false] call SQFB_fnc_cleanTaggers;
SQFB_friendlyTagObjArr = [];

// Player traits
private _unitTraits = getAllUnitTraits SQFB_player;
SQFB_player setVariable ["SQFB_medic",(_unitTraits select { (_x select 0) == "Medic" } apply { _x select 1 }) select 0];
