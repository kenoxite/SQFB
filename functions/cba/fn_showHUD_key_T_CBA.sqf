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
	call SQFB_fnc_HUDupdate;
    [] call SQFB_fnc_HUDshow;

    ["squad", "on"] call SQFB_fnc_playSound;
} else {
    SQFB_showHUD = false;
	[] call SQFB_fnc_HUDhide;

    ["squad", "off"] call SQFB_fnc_playSound;
};
