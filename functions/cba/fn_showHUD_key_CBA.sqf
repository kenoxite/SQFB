/*
	Author: kenoxite

	Description:
	Actions to perform when the show HUD key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

if (SQFB_opt_SquadHUDkey_Toggle) exitWith { _this call SQFB_fnc_showHUD_key_T_CBA };

if (!SQFB_showHUD) then 
{
    SQFB_showHUD = true;
    
	call SQFB_fnc_HUDupdate;
    [] call SQFB_fnc_HUDshow;

    ["squad", "on"] call SQFB_fnc_playSound;
};
