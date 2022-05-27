/*
  Author: kenoxite

  Description:
  Starts the process required to show the HUD 


  Parameter (s):
  _this select 0: _grp
 

  Returns:


  Examples:

*/

params [["_type", "squad"]];

if (_type == "squad") exitWith {
    if (SQFB_showDeadMinTime == 0) then {
        SQFB_showDeadMinTime = time + SQFB_opt_showDeadMinTime;
    };
};

// Immediate update of unit positions
SQFB_IFFTimeLastCheck = time;
