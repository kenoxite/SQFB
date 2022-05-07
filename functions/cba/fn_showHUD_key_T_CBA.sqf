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
    SQFB_showFriendlyHUD = true;
	call SQFB_fnc_HUDupdate;
    [] call SQFB_fnc_HUDshow;
} else {
    SQFB_showHUD = false;
    SQFB_showFriendlyHUD = false;
	[] call SQFB_fnc_HUDhide;
};
