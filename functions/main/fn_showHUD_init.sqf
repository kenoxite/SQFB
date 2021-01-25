/*
  Author: kenoxite

  Description:
  Starts the process required to show the HUD 


  Parameter (s):
  _this select 0: _grp
 

  Returns:


  Examples:

*/

if (!SQFB_opt_on) exitWith {true};

private _grp = group player;
// Rebuild units array
private _units = _grp call SQFB_fnc_checkGroupChange;
[_units] call SQFB_fnc_addUnits;
