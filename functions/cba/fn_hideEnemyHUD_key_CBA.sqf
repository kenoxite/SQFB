/*
	Author: kenoxite

	Description:
	Actions to perform when the hide enemy HUD key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/
private _trackingDeviceEnabled = SQFB_opt_showEnemiesIfTrackingGear && call SQFB_fnc_trackingGearCheck;
if (SQFB_showEnemyHUD && !_trackingDeviceEnabled) then
{
    SQFB_showEnemyHUD = false;
	["enemy"] call SQFB_fnc_hideHUD;
};