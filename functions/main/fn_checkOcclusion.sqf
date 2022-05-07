/*
  Author: kenoxite

  Description:
  Returns wether the unit is occluded from the observer POV


  Parameter (s):


  Returns:


  Examples:

*/

params [["_unit", objNull], ["_observer", SQFB_player], ["_isTarget", false] , ["_SQFB_opt_preciseVisCheck", false], ["_isOnFoot", true], ["_SQFB_opt_alternateOcclusionCheck", false]];

private _unitOccluded = true;

if (_isTarget) then {
    private _playerUnits = units group _observer;
    for "_i" from 0 to (count _playerUnits) -1 do
    {
        private _groupUnit = _playerUnits select _i;
        if (_groupUnit != effectiveCommander (vehicle _groupUnit)) then { continue };
        if ((_isOnFoot || !_SQFB_opt_preciseVisCheck) && _SQFB_opt_alternateOcclusionCheck) then {
            private _targetKnowledge = _groupUnit targetKnowledge _unit;
            private _isOccludedforUnit = (time - (_targetKnowledge select 2)) > 0.1;
            if (!_isOccludedforUnit) exitWith { _unitOccluded = false };
        } else {
            private _preciseVisCheck = call {
                            if (_isOnFoot || !_SQFB_opt_preciseVisCheck) exitWith {false};
                            if (!_isOnFoot && _SQFB_opt_preciseVisCheck) exitWith {true};
                        };
            private _unitVisibility = [_unit, _groupUnit, _preciseVisCheck] call SQFB_fnc_checkVisibility;
            if (_unitVisibility >= 0.2) exitWith { _unitOccluded = false };
        };
    };
} else {
    if ((_isOnFoot || !_SQFB_opt_preciseVisCheck) && _SQFB_opt_alternateOcclusionCheck) then {
        private _targetKnowledge = _observer targetKnowledge _unit;
       _unitOccluded = (time - (_targetKnowledge select 2)) > 0.1;
    } else {
        private _preciseVisCheck = call {
                        if (_isOnFoot || !_SQFB_opt_preciseVisCheck) exitWith {false};
                        if (!_isOnFoot && _SQFB_opt_preciseVisCheck) exitWith {true};
                    };
        private _unitVisibility = [_unit, _observer, _preciseVisCheck] call SQFB_fnc_checkVisibility;
        private _visThreshold = [0.2, 0.1] select _isPlayerAir;
        _unitOccluded = _unitVisibility < _visThreshold;
    };
};

_unitOccluded
