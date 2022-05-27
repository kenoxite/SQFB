/*
	Author: kenoxite

	Description:
	Actions to perform when the show enemy HUD key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

if (!SQFB_showIFFHUD) then 
{
    SQFB_showIFFHUD = true;
    call SQFB_fnc_IFFactivateDevice;
	call SQFB_fnc_HUDupdate;
    ["iff"] call SQFB_fnc_HUDshow;
};
