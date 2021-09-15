/*
	Author: kenoxite

	Description:
	Update the HUD icon for the unit


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

params ["_veh", "_grp"];
private _return = "";

if (!SQFB_opt_showIcon) exitwith { _return };
    
private _crew = crew _veh;

// Default
if (SQFB_showHUD) then {
	//_return = format["%1", getText (configfile >> "CfgVehicles" >> typeOf _veh >> "picture")];
};

if ((SQFB_opt_AlwaysShowCritical && !SQFB_showHUD) || !SQFB_opt_showText) then {
	// Vehicle status
	if ((fuel _veh) == 0) then {
		_return = "a3\ui_f\data\igui\cfg\actions\refuel_ca.paa";
	};
	if ((damage _veh) >= 0.5) then {
		_return = "a3\ui_f\data\igui\cfg\actions\repair_ca.paa";
	};
	if (!(canMove _veh) && (fuel _veh) > 0) then {
		_return = "a3\ui_f\data\igui\cfg\actions\repair_ca.paa";
	};
	
	// Display if wounded units in crew
	private _wounded = { lifeState _x != "HEALTHY" && alive _x} count _crew;
	if (_wounded > 0) then {
		_return = "a3\ui_f\data\igui\cfg\revive\overlayicons\r100_ca.paa";
	};

	// Show medics in the vehicle when there's wounded units in the group
	private _medic = _crew findIf {(_x getVariable "SQFB_medic")};
	if (_medic != -1) then {
		if (_grp getVariable "SQFB_wounded") then {
			//_return = "a3\ui_f\data\igui\cfg\cursors\unithealer_ca.paa";
			_return = "a3\ui_f\data\igui\cfg\actions\heal_ca.paa";
		};
	};
};
_return	