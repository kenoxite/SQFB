/*
  Author: kenoxite

  Description:
  Changse the color of the text and icon for the unit


  Parameter (s):
  _this select 0: _unit
 

  Returns:


  Examples:

*/

params ["_unit"];

private _return = [];

private _alpha = [_unit] call SQFB_fnc_HUDAlpha;
if (!SQFB_showHUD && _alpha > 0) then {
	_alpha = _alpha /1.5;
};

if (!SQFB_opt_showColor) exitwith { [SQFB_opt_colorDefault select 0, SQFB_opt_colorDefault select 1, SQFB_opt_colorDefault select 2, _alpha] };


if (SQFB_opt_showColor) then {
	switch (assignedTeam _unit) do {
		//[r, g, b, a] - Color format. R-red, g-green, b-blue. Values from 0 to 1.- alpha channel. (0 -valued, 1-opaque)
		case "RED": { 
			_return = [SQFB_opt_colorRed select 0,SQFB_opt_colorRed select 1,SQFB_opt_colorRed select 2,_alpha];
		};
		case "GREEN": {
			_return = [SQFB_opt_colorGreen select 0,SQFB_opt_colorGreen select 1,SQFB_opt_colorGreen select 2,_alpha];
		};
		case "BLUE": {
			_return = [SQFB_opt_colorBlue select 0,SQFB_opt_colorBlue select 1,SQFB_opt_colorBlue select 2,_alpha];
		};
		case "YELLOW": {
			_return = [SQFB_opt_colorYellow select 0,SQFB_opt_colorYellow select 1,SQFB_opt_colorYellow select 2,_alpha];
		};
		default {
			_return = [SQFB_opt_colorDefault select 0,SQFB_opt_colorDefault select 1,SQFB_opt_colorDefault select 2,_alpha];
		};
	};
} else {
	_return = [SQFB_opt_colorDefault select 0,SQFB_opt_colorDefault select 1,SQFB_opt_colorDefault select 2,_alpha];
};
_return	