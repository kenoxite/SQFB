/*
  Author: kenoxite

  Description:
  Display the text under the icon for the unit


  Parameter (s):
  _this select 0: _unit
 

  Returns:


  Examples:

*/

params [["_unit", objNull], ["_unitVisible", true], ["_showIndex", true], ["_alwaysShowCritical", true], ["_showClass", true], ["_showRoles", true], ["_showDist", false], ["_outFOVindex", true], ["_profile", "default"]];

private _return = "";

// Exclude players
if (_unit == SQFB_player) exitWith {_return};

private _alive = alive _unit;
private _index = -1;
private _vehPlayer = vehicle SQFB_player;
private _veh = vehicle _unit;
if (_alive && _showIndex) then { _index = _unit getVariable "SQFB_grpIndex"; };
private _grpLeader = leader (group _unit);

private _playerIsLeader = _grpLeader == SQFB_player;
private _playerIsMedic = SQFB_player getVariable "SQFB_medic";
private _informCritical = _playerIsMedic || _playerIsLeader;

private _isGrpLeader = _grpLeader == _unit;
private _isFormLeader = formationLeader _vehPlayer == _unit;
private _isFormFollower = (formationLeader _unit == _vehPlayer) && !_playerIsLeader;

private _showCritical = [false, true] select (_alwaysShowCritical == "always" || _alwaysShowCritical == "infantry");

// Always show leader index
if (_profile != "crit" && _alive && _showIndex && _index >= 0 && (_isGrpLeader || _isFormLeader || _isFormFollower)) then { _return = format ["%1%2%3%4%5%6%7 ", _return, if (_isGrpLeader) then {"<"} else {""}, _index, if (_isGrpLeader) then {">"} else {""}, if (_isFormLeader) then {"^"} else {""}, if (_isFormFollower) then {""""} else {""}] };

// Default text when requested by player
if (SQFB_showHUD) then {
	if (_alive || (!_alive && (_veh == _unit) && time >= SQFB_showDeadMinTime)) then {
        if (_profile != "crit" && _alive && _showIndex && _index >= 0 && !_isGrpLeader && !_isFormLeader && !_isFormFollower) then { _return = format ["%1%2 ", _return, _index] };
		if (_alive) then {
			private _lifeState = lifeState _unit;
			if (_lifeState != "HEALTHY") then {
                _return = [
                                format ["%1[%2] ",_return, _lifeState],
                                format ["%1[%2] ",_return, localize "STR_SQFB_HUD_bleeding"]
                            ] select (isBleeding _unit && _lifeState != "INCAPACITATED");
			};
		};
		if (_unit getVariable "SQFB_noAmmo") then {
            _return = [
                            [
                                format ["%1[%2] ",_return, localize "STR_SQFB_HUD_noAmmoSec"],
                                format ["%1[%2] ",_return, localize "STR_SQFB_HUD_noAmmoPrim"]
                            ] select (_unit getVariable "SQFB_noAmmoPrim"),
                            format ["%1[%2] ",_return, localize "STR_SQFB_HUD_noAmmo"]
                        ] select (_unit getVariable "SQFB_noAmmoPrim" && _unit getVariable "SQFB_noAmmoSec");
		};
		if (_showClass) then {
			_return = format ["%1%2 ",_return, _unit getVariable "SQFB_displayName"];
		};
		if (_profile != "crit" && {(_showRoles && (_unit getVariable "SQFB_roles") != "") || {!_showRoles && _showCritical && !_unitVisible && {_unit getVariable "SQFB_medic" && (group _unit) getVariable "SQFB_wounded"}}}) then {
			_return = format ["%1[%2] ",_return, _unit getVariable "SQFB_roles"];
		};
		if (_profile != "crit" && _showDist && _veh != _vehPlayer) then {
			_return = format ["%1(%2m)",_return, round (_veh distance _vehPlayer)];
		};
	};
} else {
    // Text shown when not requested by player
    if (!_unitVisible && _alive && {_outFOVindex || {_showCritical && _informCritical}}) then {
        private _critical = false;
        if (_informCritical) then {
    		private _lifeState = lifeState _unit;
    		if (_lifeState != "HEALTHY") then {
                _critical = true;
                _return = [
                                format ["%1[%2] ", _return, _lifeState],
                                format ["%1[%2] ", _return, localize "STR_SQFB_HUD_bleeding"]
                            ] select (isBleeding _unit && _lifeState != "INCAPACITATED");
    		} else {
    			if (_playerIsLeader && _unit getVariable "SQFB_noAmmo") then {
                    _critical = true;
                    _return = [
                                    [
                                        format ["%1[%2] ", _return, localize "STR_SQFB_HUD_noAmmoSec"],
                                        format ["%1[%2] ", _return, localize "STR_SQFB_HUD_noAmmoPrim"]
                                    ] select (_unit getVariable "SQFB_noAmmoPrim"),
                                    format ["%1[NO AMMO] ", _return, localize "STR_SQFB_HUD_noAmmo"]
                                ] select (_unit getVariable "SQFB_noAmmoPrim" && _unit getVariable "SQFB_noAmmoSec");
    			};
    		};
    		if (_unit getVariable "SQFB_medic" && (group _unit) getVariable "SQFB_wounded") then {
    			_return = format ["%1[%2] ", _return, localize "STR_SQFB_HUD_medic"];
                _critical = true;
    		};
        };
		if ((_outFOVindex || _critical) && _showIndex && _index >= 0 && !_isGrpLeader && !_isFormLeader && !_isFormFollower) then {
            _return = format ["%1%2 %3 ", _index, if (_return != "") then { ":" } else { "" }, _return];
        };
	};
};
_return
