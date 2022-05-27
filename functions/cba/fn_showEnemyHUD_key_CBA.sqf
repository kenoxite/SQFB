/*
	Author: kenoxite

	Description:
	Actions to perform when the show enemy HUD key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

if (SQFB_opt_IFFHUDkey_Toggle) exitWith { _this call SQFB_fnc_showEnemyHUD_key_T_CBA };

if (!SQFB_showIFFHUD) then 
{
    SQFB_showIFFHUD = true;
    call SQFB_fnc_IFFactivateDevice;
	call SQFB_fnc_HUDupdate;
    ["iff"] call SQFB_fnc_HUDshow;

    ["iff", "on"] call SQFB_fnc_playSound;
};
