/*
	Author: kenoxite

	Description:
	Actions to perform when the hide HUD (toggle) key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

if (!SQFB_showHUD) then 
{
	[] call SQFB_fnc_showHUD_init;
	SQFB_showHUD = true;
} else {
	[] call SQFB_fnc_hideHUD;
	SQFB_showHUD = false;
};