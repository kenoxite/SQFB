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
    SQFB_showHUD = true;
	[] call SQFB_fnc_showHUD_init;
} else {
    SQFB_showHUD = false;
	[] call SQFB_fnc_hideHUD;
};