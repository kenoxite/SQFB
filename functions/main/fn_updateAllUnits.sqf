/*
  Author: kenoxite

  Description:
  Update all units


  Parameter (s):
  _this select 0: _grp
 

  Returns:


  Examples:

*/

// Add units to global array
for "_i" from 0 to (count SQFB_units) -1 do { (SQFB_units select _i) call SQFB_fnc_updateUnit};