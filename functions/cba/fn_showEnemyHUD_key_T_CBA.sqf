/*
	Author: kenoxite

	Description:
	Actions to perform when the show enemy HUD (toggle) key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

if (!SQFB_showIFFHUD) then 
{
    SQFB_showIFFHUD = true;
    call SQFB_fnc_HUDupdate;
    ["iff"] call SQFB_fnc_HUDshow;

    ["iff", "on"] call SQFB_fnc_playSound;
} else {
    SQFB_showIFFHUD = false;
	["iff"] call SQFB_fnc_HUDhide;

    ["iff", "off"] call SQFB_fnc_playSound;
};
