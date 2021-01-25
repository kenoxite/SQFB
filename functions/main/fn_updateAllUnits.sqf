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
{_x call SQFB_fnc_updateUnit} forEach SQFB_units;