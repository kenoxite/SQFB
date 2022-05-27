/*
	Author: kenoxite

	Description:
	Display the text under the icon for the vehicle


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

params ["_veh", "_unitVisible", ["_showIndex", true],["_showClass", false],["_showRoles", false],["_showCrew", true],["_showDist", true]];
private _return = "";
private _index = -1;
private _crew = fullCrew [vehicle _veh,"",true];
private _vehLeader = objNull;
if (_showIndex) then {
	if (isNull _vehLeader) then {_vehLeader = effectiveCommander _veh};
	if (isNull _vehLeader) then {_vehLeader = driver _veh};
	if (isNull _vehLeader) then {_vehLeader = gunner _veh};
	if (isNull _vehLeader) then {_vehLeader = _crew select 0};

	if (!isNull _vehLeader) then {_index = _vehLeader getVariable "SQFB_grpIndex";};
};
if (isNil "_vehLeader") exitWith { _return };
if (isNull _vehLeader) exitWith { _return };

private _vehName = "";
private _vehPlayer = vehicle SQFB_player;
if (_showClass) then {
    _vehName = toUpperANSI (getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName"));
};

private _grpLeader = leader (group _unit);
private _isGrpLeader = _grpLeader == _unit;
private _isFormLeader = formationLeader _vehPlayer == _unit;
private _isFormFollower = (formationLeader _unit == _vehPlayer) && _grpLeader != SQFB_player;
private _informCritical = SQFB_player getVariable "SQFB_medic" || _grpLeader == SQFB_player;

// Always show leader index
private _alive = alive _veh || damage _veh < 1;
if (SQFB_opt_outFOVindex && SQFB_opt_profile != "crit" && _alive && SQFB_opt_showIndex && _index >= 0 && (_isGrpLeader || _isFormLeader || _isFormFollower)) then { _return = format ["%1%2%3%4%5%6%7 ", _return, if (_isGrpLeader) then {"<"} else {""}, _index, if (_isGrpLeader) then {">"} else {""}, if (_isFormLeader) then {"^"} else {""}, if (_isFormFollower) then {""""} else {""}] };

// Default text when requested by player
if (SQFB_showHUD) then {
    if (SQFB_opt_outFOVindex && SQFB_opt_profile != "crit" && _alive && _showIndex && _index >= 0 && !_isGrpLeader && !_isFormLeader) then { _return = format ["%1%2: ", _return, _index] };

	if (_showClass) then {
        _return = format ["%1%2 ", _return, _vehName];
    };
	// Vehicle status
	if ((fuel _veh) == 0) then {
		_return = format ["%1[%2] ", _return, localize "STR_SQFB_HUD_noFuel"];
	};
	if ((damage _veh) >= 0.5) then {
		_return = format ["%1[%2] ", _return, localize "STR_SQFB_HUD_damaged"];
	};
	if (!(canMove _veh) && (fuel _veh) > 0) then {
		_return = format ["%1[%2] ", _return, localize "STR_SQFB_HUD_cantMove"];
	};
	if (_showRoles) then {
        _return = format ["%1[%2: ", _return, (_veh call BIS_fnc_objectType) select 1];
    } else {
        _return = format ["%1[", _return];
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
					_crewStr = format [
						"%1%2%3%4%5",
						_crewStr,
						_crewPos,
						_unit getVariable "SQFB_grpIndex",
						if(!alive _unit)then{"D"}else{if(lifeState _unit != "HEALTHY") then {"W"}else{""}},
						if (_j < _count-1) then{","} else {""}
						];
				};
				_j = _j + 1;
			};
		};
	  _return = format ["%1%2]%3 ", _return,_crewStr, if (_e > 0) then { format[" E:%1",_e] } else { "" }];
	};
	if (_showDist && _veh != _vehPlayer) then {
		_return = format ["%1(%2m) ",_return, round (_veh distance _vehPlayer)];
	};
} else {
    // Text when always show critical is enabled
	if (count _crew > 0 && {SQFB_opt_outFOVindex || {SQFB_opt_AlwaysShowCritical && _informCritical}}) then {
		if (!_unitVisible) then {
			private _critical = false;
            if (_informCritical) then {
    			//if (_showClass) then {_return = format ["%1%2 ", _return,_vehName]};
    			// Vehicle status
    			if ((fuel _veh) == 0) then {
    				_return = format ["%1[%2] ", _return, localize "STR_SQFB_HUD_noFuel"];
    				_critical = true;
    			};
    			if ((damage _veh) >= 0.5) then {
    				_return = format ["%1[%2] ", _return, localize "STR_SQFB_HUD_damaged"];
    				_critical = true;
    			};
    			if (!(canMove _veh) && (fuel _veh) > 0) then {
    				_return = format ["%1[%2] ", _return, localize "STR_SQFB_HUD_cantMove"];
    				_critical = true;
    			};
    			// Display if wounded units in crew
    			private _crew = crew _veh;
    			private _wounded = { lifeState _x != "HEALTHY" && alive _x} count _crew;
    			if (_wounded > 0) then {
    				_return =  format ["%1[%2 %3] ", _return, _wounded, localize "STR_SQFB_HUD_wounded"];
    				_critical = true;
    			};
    			// Show medics in the vehicle when there's wounded units in the group
    			private _medic = _crew findIf {(_x getVariable "SQFB_medic")};
    			if (_medic != -1) then {
    				if (_grp getVariable "SQFB_wounded") then {
    					_return =  format ["%1[%2 %3] ", _return, localize "STR_SQFB_HUD_medicIs", (_crew select _medic) getVariable "SQFB_grpIndex"];
    					_critical = true;
    				};
    			};
            };
            if (_critical || SQFB_opt_outFOVindex  && !_isGrpLeader && !_isFormLeader && !_isFormFollower) then {
                if (_showIndex && _index >= 0) then { _return = format ["%1%2 %3 ", _index, if (_return != "") then { ":" } else { "" }, _return] };
            };
		};
	};
};
_return