/*
  Author: kenoxite

  Description:
  Controls the update of the HUD's data 


  Parameter (s):


  Returns:


  Examples:

*/

private _grp = group player;
private _count = count units player;
if (_count != SQFB_unitCount || SQFB_showHUD) then {
	[] call SQFB_fnc_showHUD_init;
	SQFB_unitCount = _count;
};
if (!SQFB_showHUD) then {
	// Check for wounded units
	_grp setVariable ["SQFB_wounded", (units _grp) findIf {lifeState _x != "HEALTHY"} != -1];
};
