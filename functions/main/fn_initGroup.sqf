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
