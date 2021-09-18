/*
  Author: kenoxite

  Description:
  Starts the process required to show the HUD 


  Parameter (s):
  _this select 0: _grp
 

  Returns:


  Examples:

*/

params [["_type", "friendly"]];

if (!SQFB_opt_on) exitWith {true};

if (_type == "friendly") then {
    SQFB_showHUD = true;
    if (SQFB_showDeadMinTime == 0) then {
        SQFB_showDeadMinTime = time + SQFB_opt_showDeadMinTime;
    };

    private _grp = group player;
    // Rebuild units array
    private _units = _grp call SQFB_fnc_checkGroupChange;
    [_units] call SQFB_fnc_addUnits;
} else {
    SQFB_showEnemyHUD = true;
    if (SQFB_showEnemiesMinTime == 0) then {
        SQFB_showEnemiesMinTime = time + SQFB_opt_showEnemiesMinTime;
    };
};
