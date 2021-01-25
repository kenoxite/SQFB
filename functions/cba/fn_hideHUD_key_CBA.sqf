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
	[] call SQFB_fnc_hideHUD;
	SQFB_showHUD = false;
};