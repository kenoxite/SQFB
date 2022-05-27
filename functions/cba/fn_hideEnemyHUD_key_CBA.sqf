/*
	Author: kenoxite

	Description:
	Actions to perform when the hide enemy HUD key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

if (SQFB_showIFFHUD) then
{
    SQFB_showIFFHUD = false;
	["iff"] call SQFB_fnc_HUDhide;
};
