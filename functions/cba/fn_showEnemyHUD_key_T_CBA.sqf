/*
	Author: kenoxite

	Description:
	Actions to perform when the show enemy HUD (toggle) key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

private _trackingDeviceEnabled = SQFB_opt_showEnemiesIfTrackingGear && call SQFB_fnc_trackingGearCheck;
if (!_trackingDeviceEnabled) then {
    if (!SQFB_showEnemyHUD) then 
    {
        SQFB_showEnemyHUD = true;
        call SQFB_fnc_HUDupdate;
        ["iff"] call SQFB_fnc_HUDshow;
    } else {
        SQFB_showEnemyHUD = false;
    	["enemy"] call SQFB_fnc_HUDhide;
    };
};
