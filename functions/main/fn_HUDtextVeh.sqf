/*
	Author: kenoxite

	Description:
	Display the text under the icon for the vehicle


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

params ["_veh",["_showIndex", true],["_showClass", false],["_showRoles", false],["_showCrew", true],["_showDist", true]];
private _return = "";
private _vehName = "";
private _index = -1;
private _vehPlayer = vehicle player;
if (_showClass) then {
    _vehName = toUpperANSI (getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName"));
};
if (_showIndex) then {
	private _vehLeader = objNull;
	if (isNull _vehLeader) then {_vehLeader = effectiveCommander _veh};
	if (isNull _vehLeader) then {_vehLeader = driver _veh};
	if (isNull _vehLeader) then {_vehLeader = gunner _veh};
	if (isNull _vehLeader) then {_vehLeader = _crew select 0};
	if (!isNull _vehLeader) then {_index = _vehLeader getVariable "SQFB_grpIndex";};
};
// Default text when requested by player
if (SQFB_showHUD) then {
	if (_showIndex && _index >= 0) then { _return = format ["%1%2: ", _return,_index]; };
	if (_showClass) then {
        _return = format ["%1%2 ", _return, _vehName];
    };
	// Vehicle status
	if ((fuel _veh) == 0) then {
		_return = format ["%1[NO FUEL] ", _return];
	};
	if ((damage _veh) >= 0.5) then {
		_return = format ["%1[DAMAGED] ", _return];
	};
	if (!(canMove _veh) && (fuel _veh) > 0) then {
		_return = format ["%1[CAN'T MOVE] ", _return];
	};
	if (_showRoles) then {
        _return = format ["%1[%2: ", _return, (_veh call BIS_fnc_objectType) select 1];
    } else {
        _return = format ["%1[", _return];
    };
	// Crew
	if (_showCrew) then {
		private _crew = fullCrew [vehicle _veh,"",true];
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
				if (_unit in units player) then {
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
	if (SQFB_opt_AlwaysShowCritical && (player getVariable "SQFB_medic" || (leader _unit == player))) then {
		private _FOV = [] call CBA_fnc_getFov select 0;
		private _inView = [ position _vehPlayer, (positionCameraToWorld [0,0,0]) getdir (positionCameraToWorld [0,0,1]), ceil(_FOV*100), position _veh ] call BIS_fnc_inAngleSector;
		if (!_inView) then {
			private _critical = false;
			//if (_showClass) then {_return = format ["%1%2 ", _return,_vehName]};
			// Vehicle status
			if ((fuel _veh) == 0) then {
				_return = format ["%1[NO FUEL] ", _return];
				_critical = true;
			};
			if ((damage _veh) >= 0.5) then {
				_return = format ["%1[DAMAGED] ", _return];
				_critical = true;
			};
			if (!(canMove _veh) && (fuel _veh) > 0) then {
				_return = format ["%1[CAN'T MOVE] ", _return];
				_critical = true;
			};
			// Display if wounded units in crew
			private _crew = crew _veh;
			private _wounded = { lifeState _x != "HEALTHY" && alive _x} count _crew;
			if (_wounded > 0) then {
				_return =  format ["%1[%2 WOUNDED] ", _return, _wounded];
				_critical = true;
			};
			// Show medics in the vehicle when there's wounded units in the group
			private _medic = _crew findIf {(_x getVariable "SQFB_medic")};
			if (_medic != -1) then {
				if (_grp getVariable "SQFB_wounded") then {
					_return =  format ["%1[MEDIC IS %2] ", _return, (_crew select _medic) getVariable "SQFB_grpIndex"];
					_critical = true;
				};
			};
			if (_critical || SQFB_opt_outFOVindex) then {
				if (_showIndex && _index >= 0) then { _return = format ["%1: %2 ", _index, _return] };
			};
		};
	};
};
_return