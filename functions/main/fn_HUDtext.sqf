/*
  Author: kenoxite

  Description:
  Display the text under the icon for the unit


  Parameter (s):
  _this select 0: _unit
 

  Returns:


  Examples:

*/

params ["_unit"];

private _return = "";

if (!SQFB_opt_showText) exitwith { _return };

// Exclude players
if (isPlayer _unit) exitWith {_return};

private _alive = alive _unit;
private _index = -1;
private _vehPlayer = vehicle player;
private _veh = vehicle _unit;
if (_alive && SQFB_opt_showIndex) then { _index = _unit getVariable "SQFB_grpIndex"; };
// Default text when requested by player
if (SQFB_showHUD) then {
	if (_alive || (!_alive && (_veh == _unit) && time >= SQFB_showDeadMinTime)) then {
		if (SQFB_opt_profile != "crit" && _alive && SQFB_opt_showIndex && _index >= 0) then { _return = format ["%1%2 ", _return, _index] };
		if (_alive) then {
			private _lifeState = lifeState _unit;
			if (_lifeState != "HEALTHY") then {
				if (isBleeding _unit && _lifeState != "INCAPACITATED") then {
					_return = format ["%1[BLEEDING] ",_return];
				} else {
					_return = format ["%1[%2] ",_return,_lifeState];
				};
			};
		} else {
			if (SQFB_opt_showDead && time >= SQFB_showDeadMinTime) then {
				_return = format ["%1[DEAD] ",_return];
			};
		};
		if (_unit getVariable "SQFB_noAmmo") then {
			if (_unit getVariable "SQFB_noAmmoPrim" && _unit getVariable "SQFB_noAmmoSec") then {
				_return = format ["%1[NO AMMO] ",_return];
			} else {
				if (_unit getVariable "SQFB_noAmmoPrim") then {
					_return = format ["%1[NO AMMO PRIM] ",_return];
				} else {
					_return = format ["%1[NO AMMO SEC] ",_return];
				};
			};
		};
		if ((SQFB_opt_showClass && _alive)  || (SQFB_opt_showClass && !_alive && time >= SQFB_showDeadMinTime)) then {
			_return = format ["%1%2 ",_return, _unit getVariable "SQFB_displayName"];
		};
		if (SQFB_opt_profile != "crit" && SQFB_opt_showRoles) then {
			if ((_unit getVariable "SQFB_roles") != "") then {
				_return = format ["%1[%2] ",_return, _unit getVariable "SQFB_roles"];
			};
		};
		if (SQFB_opt_profile != "crit" && SQFB_opt_showDist && _veh != _vehPlayer && (_alive || (!_alive && time >= SQFB_showDeadMinTime))) then {
			_return = format ["%1(%2m)",_return, round (_veh distance _vehPlayer)];
		};
	};
} else {
	if (SQFB_opt_showCritical) then {
		private _FOV = [] call CBA_fnc_getFov select 0;
		private _inView = [ position _vehPlayer, (positionCameraToWorld [0,0,0]) getdir (positionCameraToWorld [0,0,1]), ceil(_FOV*100), position _veh ] call BIS_fnc_inAngleSector;
		if (!_inView) then {
			// Text shown when not requested by player
			private _critical = false;
			if (_alive) then { 
				private _lifeState = lifeState _unit;
				if (_lifeState != "HEALTHY") then {
					if (isBleeding _unit && _lifeState != "INCAPACITATED") then {
						_return = format ["%1[BLEEDING] ",_return];
						_critical = true;
					} else {
						_return = format ["%1[%2] ",_return,_lifeState];
						_critical = true;
					};
				} else {
					if (_unit getVariable "SQFB_noAmmo") then {
						if (_unit getVariable "SQFB_noAmmoPrim" && _unit getVariable "SQFB_noAmmoSec") then {
							_return = format ["%1[NO AMMO] ",_return];
							_critical = true;
						} else {
							if (_unit getVariable "SQFB_noAmmoPrim") then {
								_return = format ["%1[NO AMMO PRIM] ",_return];
								_critical = true;
							} else {
								_return = format ["%1[NO AMMO SEC] ",_return];
								_critical = true;
							};
						};
					};
				};
				if ((_unit getVariable "SQFB_medic") && ((group _unit) getVariable "SQFB_wounded")) then {
					_return = format ["%1[MEDIC] ",_return];
					_critical = true;
				};
			} else {
				//if (SQFB_opt_showDead) then { _return = format ["%1[DEAD] ",_return]; };
			};
			if (_critical || SQFB_opt_outFOVindex) then {
				if (SQFB_opt_showIndex && _index >= 0) then { _return = format ["%1 %2 ", _index, _return] };
			};
		};
	};
};
_return