/*
  Author: kenoxite

  Description:
  Initialize group 


  Parameter (s):
  _this select 0: _grp
 

  Returns:


  Examples:

*/

params [["_grp", group player]];
private _units = units _grp;
_grp setVariable ["SQFB_group_static", [_grp, _units]];
_grp setVariable ["SQFB_wounded", false];
// Initialize the units group index
for "_i" from 0 to (count _units) -1 do { private _x = _units select _i; _x setVariable ["SQFB_grpIndex", _x call SQFB_fnc_getUnitPositionId]; };
// Update global vars
SQFB_units = _units;
SQFB_unitCount = count _units;

// Clean enemy taggers
call SQFB_fnc_cleanEnemyTaggers;
// Reset enemy vars
SQFB_showEnemies = false;
SQFB_knownEnemies = [];
        
// Player traits
private _unitTraits = getAllUnitTraits player;
player setVariable ["SQFB_medic",(_unitTraits select { (_x select 0) == "Medic" } apply { _x select 1 }) select 0];