/*
	Author: kenoxite

	Description:
	Actions to perform when the show enemy HUD key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

private _trackingDeviceEnabled = (SQFB_opt_showEnemiesIfTrackingGear && SQFB_trackingGearCheck) || SQFB_opt_showEnemies == "device";
if (!SQFB_showEnemyHUD && !_trackingDeviceEnabled) then 
{
    SQFB_showEnemyHUD = true;
	call SQFB_fnc_HUDupdate;
    ["iff"] call SQFB_fnc_HUDshow;
};
