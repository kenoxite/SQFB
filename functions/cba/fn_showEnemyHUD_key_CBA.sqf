/*
	Author: kenoxite

	Description:
	Actions to perform when the show enemy HUD key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

if (!SQFB_showEnemyHUD && !(SQFB_opt_showEnemiesIfTrackingGear && call SQFB_fnc_trackingGearCheck)) then 
{
	["enemy"] call SQFB_fnc_showHUD_init;
};