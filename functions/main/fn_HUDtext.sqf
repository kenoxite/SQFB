/*
  Author: kenoxite

  Description:
  Display the text under the icon for the unit


  Parameter (s):
  _this select 0: _unit
 

  Returns:


  Examples:

*/

params ["_unit", "_unitVisible"];

private _return = "";

if (!SQFB_opt_showText) exitwith { _return };

// Exclude players
if (isPlayer _unit) exitWith {_return};

private _alive = alive _unit;
private _index = -1;
private _vehPlayer = vehicle player;
private _veh = vehicle _unit;
if (_alive && SQFB_opt_showIndex) then { _index = _unit getVariable "SQFB_grpIndex"; };
private _grpLeader = leader (group _unit);
private _formLeader = formationLeader _vehPlayer;

// Default text when requested by player
if (SQFB_showHUD) then {
	if (_alive || (!_alive && (_veh == _unit) && time >= SQFB_showDeadMinTime)) then {
		if (SQFB_opt_profile != "crit" && _alive && SQFB_opt_showIndex && _index >= 0) then { _return = format ["%1%2%3%4%5: ", _return, if (_grpLeader == _unit) then {"<"} else {""}, _index, if (_grpLeader == _unit) then {">"} else {""}, if (_formLeader == _unit) then {"^"} else {""}] };
		if (_alive) then {
			private _lifeState = lifeState _unit;
			if (_lifeState != "HEALTHY") then {
                _return = [
                            format ["%1[%2] ",_return, _lifeState],
                            format ["%1[BLEEDING] ",_return]
                            ] select (isBleeding _unit && _lifeState != "INCAPACITATED");
			};
		};
		if (_unit getVariable "SQFB_noAmmo") then {
            _return = [
                            [
                                format ["%1[NO AMMO SEC] ",_return],
                                format ["%1[NO AMMO PRIM] ",_return]
                            ] select (_unit getVariable "SQFB_noAmmoPrim"),
                            format ["%1[NO AMMO] ",_return]
                        ] select (_unit getVariable "SQFB_noAmmoPrim" && _unit getVariable "SQFB_noAmmoSec");
		};
		if (SQFB_opt_showClass) then {
			_return = format ["%1%2 ",_return, _unit getVariable "SQFB_displayName"];
		};
		if (SQFB_opt_profile != "crit" && SQFB_opt_showRoles) then {
			if ((_unit getVariable "SQFB_roles") != "") then {
				_return = format ["%1[%2] ",_return, _unit getVariable "SQFB_roles"];
			};
		};
		if (SQFB_opt_profile != "crit" && SQFB_opt_showDist && _veh != _vehPlayer) then {
			_return = format ["%1(%2m)",_return, round (_veh distance _vehPlayer)];
		};
	};
} else {
    // Text shown when not requested by player
    if (SQFB_opt_outFOVindex || {SQFB_opt_AlwaysShowCritical && (player getVariable "SQFB_medic" || (_grpLeader == player))}) then {
		if (!_unitVisible) then {
            private _critical = false;
			if (_alive) then { 
				private _lifeState = lifeState _unit;
				if (_lifeState != "HEALTHY") then {
                    _critical = true;
					if (isBleeding _unit && _lifeState != "INCAPACITATED") then {
						_return = format ["%1[BLEEDING] ", _return];
					} else {
						_return = format ["%1[%2] ", _return, _lifeState];
					};
				} else {
					if (_unit getVariable "SQFB_noAmmo") then {
                        _critical = true;
						if (_unit getVariable "SQFB_noAmmoPrim" && _unit getVariable "SQFB_noAmmoSec") then {
							_return = format ["%1[NO AMMO] ", _return];
						} else {
							if (_unit getVariable "SQFB_noAmmoPrim") then {
								_return = format ["%1[NO AMMO PRIM] ", _return];
							} else {
								_return = format ["%1[NO AMMO SEC] ", _return];
							};
						};
					};
				};
				if ((_unit getVariable "SQFB_medic") && ((group _unit) getVariable "SQFB_wounded")) then {
					_return = format ["%1[MEDIC] ", _return];
                    _critical = true;
				};
			};
			if ((SQFB_opt_outFOVindex || _critical) && SQFB_opt_showIndex && _index >= 0) then {
                _return = format ["%1%2%3%4%5 %6 ", if (_grpLeader == _unit) then { "<" } else { "" }, _index, if (_grpLeader == _unit) then { ">" } else { "" }, if (_return != "") then { ":" } else { "" }, if (_formLeader == _unit) then {"^"} else {""}, _return];
            };
		};
	};
};
_return