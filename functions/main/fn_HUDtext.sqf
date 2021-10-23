/*
  Author: kenoxite

  Description:
  Display the text under the icon for the unit


  Parameter (s):
  _this select 0: _unit
 

  Returns:


  Examples:

*/

params [["_unit", objNull], ["_unitVisible", true]];

private _return = "";

if (!SQFB_opt_showText) exitwith { _return };

// Exclude players
if (isPlayer _unit) exitWith {_return};

private _alive = alive _unit;
private _index = -1;
private _vehPlayer = vehicle SQFB_player;
private _veh = vehicle _unit;
if (_alive && SQFB_opt_showIndex) then { _index = _unit getVariable "SQFB_grpIndex"; };
private _grpLeader = leader (group _unit);
private _isGrpLeader = _grpLeader == _unit;
private _isFormLeader = formationLeader _vehPlayer == _unit;
private _isFormFollower = (formationLeader _unit == _vehPlayer) && _grpLeader != SQFB_player;
private _informCritical = player getVariable "SQFB_medic" || _grpLeader == SQFB_player;

// Always show leader index
if (SQFB_opt_outFOVindex && SQFB_opt_profile != "crit" && _alive && SQFB_opt_showIndex && _index >= 0 && (_isGrpLeader || _isFormLeader || _isFormFollower)) then { _return = format ["%1%2%3%4%5%6%7 ", _return, if (_isGrpLeader) then {"<"} else {""}, _index, if (_isGrpLeader) then {">"} else {""}, if (_isFormLeader) then {"^"} else {""}, if (_isFormFollower) then {""""} else {""}] };

// Default text when requested by player
if (SQFB_showHUD) then {
	if (_alive || (!_alive && (_veh == _unit) && time >= SQFB_showDeadMinTime)) then {
        if (SQFB_opt_profile != "crit" && _alive && SQFB_opt_showIndex && _index >= 0 && !_isGrpLeader && !_isFormLeader && !_isFormFollower) then { _return = format ["%1%2: ", _return, _index] };
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
		if (SQFB_opt_profile != "crit" && {(SQFB_opt_showRoles && (_unit getVariable "SQFB_roles") != "") || {!SQFB_opt_showRoles && SQFB_opt_AlwaysShowCritical && !_unitVisible && {_unit getVariable "SQFB_medic" && (group _unit) getVariable "SQFB_wounded"}}}) then {
			_return = format ["%1[%2] ",_return, _unit getVariable "SQFB_roles"];
		};
		if (SQFB_opt_profile != "crit" && SQFB_opt_showDist && _veh != _vehPlayer) then {
			_return = format ["%1(%2m)",_return, round (_veh distance _vehPlayer)];
		};
	};
} else {
    // Text shown when not requested by player
    if (!_unitVisible && _alive && {SQFB_opt_outFOVindex || {SQFB_opt_AlwaysShowCritical && _informCritical}}) then {
        private _critical = false;
		private _lifeState = lifeState _unit;
		if (_lifeState != "HEALTHY") then {
            _critical = true;
            _return = [
                            format ["%1[%2] ", _return, _lifeState],
                            format ["%1[BLEEDING] ", _return]
                        ] select (isBleeding _unit && _lifeState != "INCAPACITATED");
		} else {
			if (_unit getVariable "SQFB_noAmmo") then {
                _critical = true;
                _return = [
                                [
                                    format ["%1[NO AMMO SEC] ", _return],
                                    format ["%1[NO AMMO PRIM] ", _return]
                                ] select (_unit getVariable "SQFB_noAmmoPrim"),
                                format ["%1[NO AMMO] ", _return]
                            ] select (_unit getVariable "SQFB_noAmmoPrim" && _unit getVariable "SQFB_noAmmoSec");
			};
		};
		if (_unit getVariable "SQFB_medic" && (group _unit) getVariable "SQFB_wounded") then {
			_return = format ["%1[MEDIC] ", _return];
            _critical = true;
		};
		if ((SQFB_opt_outFOVindex || _critical) && SQFB_opt_showIndex && _index >= 0 && !_isGrpLeader && !_isFormLeader && !_isFormFollower) then {
            _return = format ["%1%2 %3 ", _index, if (_return != "") then { ":" } else { "" }, _return];
        };
	};
};
_return