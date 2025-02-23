/*
  Author: kenoxite

  Description:
  Display the text under the icon for the unit


  Parameter (s):
  _this select 0: _unit
 

  Returns:


  Examples:

*/

params [["_unit", objNull], ["_unitVisible", true], ["_showIndex", true], ["_alwaysShowCritical", true], ["_showName", true], ["_showClass", true], ["_showRoles", true], ["_showDist", false], ["_outFOVindex", true], ["_profile", "default"], ["_preciseDist", false]];

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
private _informCritical = (_alwaysShowCritical == "always" || _alwaysShowCritical == "infantry" || _alwaysShowCritical == "infantryText") && (_playerIsMedic || _playerIsLeader);

private _isGrpLeader = _grpLeader == _unit;
private _isFormLeader = formationLeader _vehPlayer == _unit;
private _isFormFollower = (formationLeader _unit == _vehPlayer) && !_playerIsLeader;

private _dist = call {
    if (_showDist) exitwith {
        if (_preciseDist) exitwith {
            round (_veh distance _vehPlayer)
        };
        [round (_veh distance _vehPlayer)] call SQFB_fnc_roundDist;
    };
    0
};

// Always show leader index
if (_profile != "crit"
    && _alive
    && _showIndex
    && _index >= 0
    && (_isGrpLeader || _isFormLeader || _isFormFollower)
    ) then {
        _return = [_return,
                    if (_isGrpLeader) then {"<"} else {""},
                    _index, if (_isGrpLeader) then {">"} else {""},
                    if (_isFormLeader) then {"^"} else {""},
                    if (_isFormFollower) then {""""} else {""},
                    " "
                    ] joinString "";
    };

// Default text when requested by player
if (SQFB_showHUD) then {
	if (_alive
        || (!_alive && (_veh == _unit)
        && time >= SQFB_showDeadMinTime)
        ) then {
        if (_profile != "crit"
            && _alive
            && _showIndex
            && _index >= 0
            && !_isGrpLeader
            && !_isFormLeader
            && !_isFormFollower
            ) then {
            _return = [_return, _index, " "] joinString "";
        };
		if (_alive && _informCritical) then {
            private _lifeState = lifeState _unit;
            private _bleeding = isBleeding _unit;
            _return = call {
                //  - Added support for A3 Wounding System
                if (_unit getVariable ["AIS_unconscious", false]) exitWith {
                    [
                        [_return, "[", localize "STR_SQFB_HUD_incapacitated", "] "] joinString "",
                        [_return, "~ "] joinString ""
                    ] select SQFB_opt_abbreviatedText;
                };
                if (_lifeState == "INCAPACITATED") exitWith {
                    [
                        [_return, "[", _lifeState, "] "] joinString "",
                        [_return, "~ "] joinString ""
                    ] select SQFB_opt_abbreviatedText;
                };
                if (_lifeState == "INJURED" && !_bleeding) exitWith {
                    [
                        [_return, "[", _lifeState, "] "] joinString "",
                        [_return, "+ "] joinString ""
                    ] select SQFB_opt_abbreviatedText;
                };
                if (_lifeState == "INJURED" && _bleeding) exitWith {
                    [
                        [_return, "[", localize "STR_SQFB_HUD_bleeding", "] "] joinString "",
                        [_return, ", "] joinString ""
                    ] select SQFB_opt_abbreviatedText;
                };
                _return
            };
    		if (_playerIsLeader && {_unit getVariable "SQFB_noAmmo"}) then {
                _return = [
                            [
                                [
                                    [_return, "[", localize "STR_SQFB_HUD_noAmmoSec", "] "] joinString "",
                                    [_return, "[", localize "STR_SQFB_HUD_noAmmoPrim", "] "] joinString ""
                                ] select (_unit getVariable "SQFB_noAmmoPrim"),
                                [_return, "[", localize "STR_SQFB_HUD_noAmmo", "] "] joinString ""
                            ] select (_unit getVariable "SQFB_noAmmoPrim" && _unit getVariable "SQFB_noAmmoSec"),
                            [
                                [
                                    [_return, "|- "] joinString "",
                                    [_return, "-| "] joinString ""
                                ] select (_unit getVariable "SQFB_noAmmoPrim"),
                                [_return, "-- "] joinString ""
                            ] select (_unit getVariable "SQFB_noAmmoPrim" && _unit getVariable "SQFB_noAmmoSec")
                        ] select SQFB_opt_abbreviatedText;
    		};
        };
        if (_showName) then {
            _return = [_return, _unit getVariable "SQFB_name", " "] joinString "";
        };
		if (_showClass) then {
            _return = [_return, "(", _unit getVariable "SQFB_displayName", ")", " "] joinString "";
		};
		if (_profile != "crit"
            && {(_showRoles
                && (_unit getVariable "SQFB_roles") != "")
                || {!_showRoles && _informCritical
                && !_unitVisible
                    && {_unit getVariable "SQFB_medic"
                    && (group _unit) getVariable "SQFB_wounded"}}
                }
            ) then {
            _return = [_return, "[", _unit getVariable "SQFB_roles", "] "] joinString "";
		};
		if (_profile != "crit" && _showDist && _veh != _vehPlayer) then {
			_return = [_return, "(", str _dist, "m)"] joinString "";
		};
	};
} else {
    // Text shown when not requested by player, shown offscreen
    if (!_unitVisible
        && _alive
        && {_outFOVindex
            || {_informCritical}
            }
        ) then {
        private _critical = false;
        if (_informCritical) then {
    		private _lifeState = lifeState _unit;
    		if (_lifeState != "HEALTHY" || _unit getVariable ["AIS_unconscious", false]) then {
                _critical = true;
                private _bleeding = isBleeding _unit;
                _return = call {
                    //  - Added support for A3 Wounding System
                    if (_unit getVariable ["AIS_unconscious", false]) exitWith {
                        [
                            [_return, "[", localize "STR_SQFB_HUD_incapacitated", "] "] joinString "",
                            [_return, "~ "] joinString ""
                        ] select SQFB_opt_abbreviatedText;
                    };
                    if (_lifeState == "INCAPACITATED") exitWith {
                        [
                            [_return, "[", _lifeState, "] "] joinString "",
                            [_return, "~ "] joinString ""
                        ] select SQFB_opt_abbreviatedText;
                    };
                    if (_lifeState == "INJURED" && !_bleeding) exitWith {
                        [
                            [_return, "[", _lifeState, "] "] joinString "",
                            [_return, "+ "] joinString ""
                        ] select SQFB_opt_abbreviatedText;
                    };
                    if (_lifeState == "INJURED" && _bleeding) exitWith {
                        [
                            [_return, "[", localize "STR_SQFB_HUD_bleeding", "] "] joinString "",
                            [_return, ", "] joinString ""
                        ] select SQFB_opt_abbreviatedText;
                    };
                    _return
                };
    		} else {
    			if (_playerIsLeader
                    && {_unit getVariable "SQFB_noAmmo"}
                    ) then {
                    _critical = true;
                    _return = [
                                [
                                    [
                                        [_return, "[", localize "STR_SQFB_HUD_noAmmoSec", "] "] joinString "",
                                        [_return, "[", localize "STR_SQFB_HUD_noAmmoPrim", "] "] joinString ""
                                    ] select (_unit getVariable "SQFB_noAmmoPrim"),
                                    [_return, "[", localize "STR_SQFB_HUD_noAmmo", "] "] joinString ""
                                ] select (_unit getVariable "SQFB_noAmmoPrim" && _unit getVariable "SQFB_noAmmoSec"),
                                [
                                    [
                                        [_return, "|- "] joinString "",
                                        [_return, "-| "] joinString ""
                                    ] select (_unit getVariable "SQFB_noAmmoPrim"),
                                    [_return, "-- "] joinString ""
                                ] select (_unit getVariable "SQFB_noAmmoPrim" && _unit getVariable "SQFB_noAmmoSec")
                            ] select SQFB_opt_abbreviatedText;
    			};
    		};
    		if (_unit getVariable "SQFB_medic"
                && (group _unit) getVariable "SQFB_wounded"
                ) then {
    			_return = [_return, "[", localize "STR_SQFB_HUD_medic", "] "] joinString "";
                _critical = true;
    		};
        };
		if ((_outFOVindex || _critical)
            && _showIndex
            && _index >= 0
            && !_isGrpLeader
            && !_isFormLeader
            && !_isFormFollower
        ) then {
            _return = [_index, if (_return != "") then { ":" } else { "" }, " ", _return, " "] joinString "";
        };
	};
};
_return
