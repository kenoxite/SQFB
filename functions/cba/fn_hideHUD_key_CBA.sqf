/*
	Author: kenoxite

	Description:
	Actions to perform when the hide HUD key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

if (SQFB_showHUD) then 
{
    SQFB_showHUD = false;
    SQFB_showFriendlyHUD = false;
	[] call SQFB_fnc_HUDhide;
};