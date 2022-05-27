/*
	Author: kenoxite

	Description:
	Actions to perform when the hide HUD key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

if (SQFB_opt_SquadHUDkey_Toggle) exitWith { false };

if (SQFB_showHUD && SQFB_opt_showEnemies != "always") then 
{
    SQFB_showHUD = false;
	[] call SQFB_fnc_HUDhide;

    ["squad", "off"] call SQFB_fnc_playSound;
};