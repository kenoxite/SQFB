/*
	Author: kenoxite

	Description:
	Actions to perform when the show HUD (toggle) key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

if (!SQFB_showHUD) then 
{
	[] call SQFB_fnc_showHUD_init;
} else {
	[] call SQFB_fnc_hideHUD;
};