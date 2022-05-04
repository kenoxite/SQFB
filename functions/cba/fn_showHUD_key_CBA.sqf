/*
	Author: kenoxite

	Description:
	Actions to perform when the show HUD key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

if (!SQFB_showHUD) then 
{
    SQFB_showHUD = true;
    SQFB_showFriendlyHUD = true;
    
	[] call SQFB_fnc_HUDshow;
};