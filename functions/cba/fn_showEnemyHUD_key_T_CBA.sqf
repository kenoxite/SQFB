/*
	Author: kenoxite

	Description:
	Actions to perform when the show enemy HUD (toggle) key is pressed


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/
if !(SQFB_opt_showEnemiesIfTrackingGear && call SQFB_fnc_trackingGearCheck) then {
    if (!SQFB_showEnemyHUD) then 
    {
        SQFB_showEnemyHUD = true;
        ["enemy"] call SQFB_fnc_showHUD_init;
    } else {
        SQFB_showEnemyHUD = false;
    	["enemy"] call SQFB_fnc_hideHUD;
    };
};