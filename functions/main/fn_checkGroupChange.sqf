/*
  Author: kenoxite

  Description:
  Check for changes in the group units. 


  Parameter (s):
  _this select 0: _grp
 

  Returns:


  Examples:

*/

params ["_grp"];
private _currentUnits = units _grp;
private _currentUnitCount = count _currentUnits;
private _currentGrp = _grp;
private _oldGrpArr = _grp getVariable "SQFB_group_static";
if (isNil "_oldGrpArr") then { _oldGrpArr = [grpNull,[]] };
private _oldGrp = _oldGrpArr select 0;
//private _oldUnits = _oldGrpArr select 1;

// Exit if there's only one unit
if (_currentUnitCount == 1) exitWith { [_grp] call SQFB_fnc_initGroup; _currentUnits };

// Exit if it's a new group
if ((_oldGrp != _currentGrp)) exitWith { 
		[_grp] call SQFB_fnc_initGroup;
		private _tmp = [];
		{
			if ((_x in _currentUnits)) then {
				_tmp pushBack _x;
			};
		} forEach SQFB_units;
		SQFB_units = _tmp;
		_currentUnits
	 };

_grp setVariable ["SQFB_group_static", [_currentGrp, _currentUnits]];

_currentUnits
