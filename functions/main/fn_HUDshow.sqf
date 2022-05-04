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
    if (SQFB_showDeadMinTime == 0) then {
        SQFB_showDeadMinTime = time + SQFB_opt_showDeadMinTime;
    };

    SQFB_player = call SQFB_fnc_playerUnit;
    private _grp = group SQFB_player;
    // Rebuild units array
    private _units = _grp call SQFB_fnc_checkGroupChange;
    [_units] call SQFB_fnc_addUnits;
    
    if (SQFB_showFriendliesMinTime == 0) then {
        SQFB_showFriendliesMinTime = time + SQFB_opt_showFriendliesMinTime;
    };
} else {
    if (SQFB_showEnemiesMinTime == 0) then {
        SQFB_showEnemiesMinTime = time + SQFB_opt_showEnemiesMinTime;
    };
    // Immediate update of enemy positions
    SQFB_enemiesTimeLastCheck = time;
    [] call SQFB_fnc_HUDupdate;
};
