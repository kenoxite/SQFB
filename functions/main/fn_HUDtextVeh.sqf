/*
	Author: kenoxite

	Description:
	Display the text under the icon for the vehicle


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

params ["_veh", "_unitVisible", ["_showIndex", true], ["_showClass", false], ["_showRoles", false], ["_showCrew", true], ["_showDist", true], ["_profile", "default"], ["_alwaysShowCritical", true], ["_outFOVindex", true]];

private _return = "";

// Exclude players
if (_veh == vehicle SQFB_player) exitWith {_return};

private _index = -1;
private _crew = fullCrew [vehicle _veh,"",true];
private _vehCommander = objNull;
if (isNull _vehCommander) then {_vehCommander = effectiveCommander _veh};
if (isNull _vehCommander) then {_vehCommander = driver _veh};
if (isNull _vehCommander) then {_vehCommander = gunner _veh};
if (isNull _vehCommander) then {_vehCommander = _crew select 0};

if (isNil "_vehCommander") exitWith { _return };
if (isNull _vehCommander) exitWith { _return };

_index = _vehCommander getVariable "SQFB_grpIndex";

private _vehName = call {
    if (_showClass) exitWith {
        toUpperANSI (getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName"))
    };
    ""
};
private _vehPlayer = vehicle SQFB_player;
private _grpLeader = leader (group _vehCommander);

private _playerIsLeader = _grpLeader == SQFB_player;
private _playerIsMedic = SQFB_player getVariable "SQFB_medic";
private _playerCanRepair = SQFB_player getVariable "SQFB_engi";

private _isGrpLeader = _grpLeader == _vehCommander;
private _formleader = formationLeader SQFB_player;
private _isFormLeader = formationLeader _vehPlayer == _vehCommander || (vehicle _formleader == _veh && _vehCommander == effectiveCommander vehicle _formleader);
private _isFormFollower = (formationLeader _vehCommander == effectiveCommander _vehPlayer) && !_playerIsLeader;

private _informCritical = (_alwaysShowCritical == "always" || _alwaysShowCritical == "vehicles" || _alwaysShowCritical == "vehiclesText") && (_playerIsMedic || _playerIsLeader || _playerCanRepair);
private _alive = alive _veh || damage _veh < 1;
needService _veh params ["_needRepair", "_needRefuel", "_needRearm"];

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
    if (_profile != "crit" && _alive && _showIndex && _index >= 0 && !_isGrpLeader && !_isFormLeader && !_isFormFollower) then {
        _return = [_return, _index, " "] joinString "";
    };

	if (_showClass) then {
        _return = [_return, _vehName, " "] joinString "";
    };
    // Vehicle status
    if ((fuel _veh) == 0) then {
        _return =[
                    [_return, "[", localize "STR_SQFB_HUD_noFuel", "] "] joinString "",
                    [_return, "!F "] joinString ""
                ] select SQFB_opt_abbreviatedText;
    };
    if (_playerIsLeader || _playerCanRepair) then {
        call {
            if ((damage _veh) >= 0.5) then {
                _return =[
                            [_return, "[", localize "STR_SQFB_HUD_damaged", "] "] joinString "",
                            [_return, if ((damage _veh) >= 0.7) then {"!!! "}else{"!! "}] joinString ""
                        ] select SQFB_opt_abbreviatedText;
            };
        };
        if (!(canMove _veh) && (fuel _veh) > 0) then {
            _return =[
                        [_return, "[", localize "STR_SQFB_HUD_cantMove", "] "] joinString "",
                        [_return, "!>> "] joinString ""
                    ] select SQFB_opt_abbreviatedText;
        };
    };
    if (_playerIsLeader) then {
        if (_needRearm >= 0.8) then {
            _return =[
                        [_return, "[", localize "STR_SQFB_HUD_noAmmo", "] "] joinString "",
                        [_return, "!A "] joinString ""
                    ] select SQFB_opt_abbreviatedText;
        };
    };
	if (_showRoles) then {
        _return = [_return, "[", ((_veh call BIS_fnc_objectType) select 1), "] "] joinString "";
    };
	// Crew
	if (_showCrew) then {
		private _crewStr = "";
		private _count = count crew _veh;
		private _e = 0;
		private _j = 0;
        for "_i" from 0 to (count _crew) -1 do
		{
            private _x = _crew select _i;
			private _unit = _x select 0;
			private _crewPos = _x select 1;
			if (_crewPos == "driver") then {_crewPos = "D"};
			if (_crewPos == "commander") then {_crewPos = "C"};
			if (_crewPos == "gunner") then {_crewPos = "G"};
			if (_crewPos == "turret") then {_crewPos = "T"};
			if (_crewPos == "cargo") then {_crewPos = ""};
			if (isNull _unit) then {
				_e = _e + 1;
			} else {
				if (_unit in units SQFB_player) then {
					_crewStr = [
                                _crewStr,
                                _crewPos,
                                _unit getVariable "SQFB_grpIndex",
                                if (!alive _unit) then {"D"} else {if (lifeState _unit != "HEALTHY") then {"W"} else {""}},
                                if (_j < _count-1) then {","} else {""}
                            ] joinString "";
				};
				_j = _j + 1;
			};
		};
	  _return = [
                    _return, 
                    "[", _crewStr, "]",
                    if (_e > 0) then {[" E:", str _e] joinString ""} else {""}
                ] joinString "";
	};
	if (_showDist && _veh != _vehPlayer) then {
		_return = [_return, "(", str round (_veh distance _vehPlayer), "m) "] joinString "";
	};
} else {
    // Text when off screen or always show critical is enabled
    if (count _crew > 0 && !_unitVisible && _alive && {_outFOVindex || {_informCritical}}) then {
		private _critical = _needRepair > 0.5 || _needRefuel > 0.5 || _needRearm > 0.5;
        if (_informCritical) then {
			// Vehicle status
			if ((fuel _veh) == 0) then {
                _return =[
                            [_return, "[", localize "STR_SQFB_HUD_noFuel", "] "] joinString "",
                            [_return, "!F "] joinString ""
                        ] select SQFB_opt_abbreviatedText;
			};
			if (_playerIsLeader || _playerCanRepair) then {
                call {
                if ((damage _veh) >= 0.5) then {
                    _return =[
                                [_return, "[", localize "STR_SQFB_HUD_damaged", "] "] joinString "",
                                [_return, if ((damage _veh) >= 0.7) then {"!!! "}else{"!! "}] joinString ""
                            ] select SQFB_opt_abbreviatedText;
    			};
            };
    			if (!(canMove _veh) && (fuel _veh) > 0) then {
                    _return =[
                                [_return, "[", localize "STR_SQFB_HUD_cantMove", "] "] joinString "",
                                [_return, "!>> "] joinString ""
                            ] select SQFB_opt_abbreviatedText;
    			};
            };
            if (_playerIsLeader) then {
                if (_needRearm >= 0.8) then {
                    _return =[
                                [_return, "[", localize "STR_SQFB_HUD_noAmmo", "] "] joinString "",
                                [_return, "!A "] joinString ""
                            ] select SQFB_opt_abbreviatedText;
                };
            };
			// Display if wounded units in crew
            if (_playerIsLeader || _playerIsMedic) then {
    			private _crew = crew _veh;
    			private _wounded = { lifeState _x != "HEALTHY" && alive _x} count _crew;
    			if (_wounded > 0) then {
    				_return = [_return, "[", _wounded, " ", localize "STR_SQFB_HUD_wounded", "] "] joinString "";
    				_critical = true;
    			};
            };
			// Show medics in the vehicle when there's wounded units in the group
            if (_playerIsLeader) then {
    			private _medic = _crew findIf {(_x getVariable "SQFB_medic")};
    			if (_medic != -1) then {
    				if (_grp getVariable "SQFB_wounded") then {
    					_return = [_return, "[", localize "STR_SQFB_HUD_medicIs", " ", (_crew select _medic) getVariable "SQFB_grpIndex", "] "] joinString "";
    					_critical = true;
    				};
    			};
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
