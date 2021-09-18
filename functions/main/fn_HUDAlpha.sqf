/*
  Author: kenoxite

  Description:
  Set alpha


  Parameter (s):
  _this select 0: _unit
 

  Returns:


  Examples:

*/

params ["_unit", ["_type", "friendly"]];
private _vehPlayer = vehicle player;
private _distance = (vehicle _unit) distance _vehPlayer;
private _alpha = SQFB_opt_maxAlpha;
private _maxDist = if ((getPosASL _vehPlayer select 2) > 5 && !(isNull objectParent player)) then {
                        if (_type == "friendly") then { SQFB_opt_maxRangeAir } else { SQFB_opt_showEnemiesMaxRangeAir };
                    } else {
                        if (_type == "friendly") then { SQFB_opt_maxRange } else { SQFB_opt_showEnemiesMaxRange };
                    };
if (_distance > _maxDist/8 && _distance <= _maxDist/6) then {_alpha = _alpha - 0.2};
if (_distance > _maxDist/6 && _distance <= _maxDist/4) then {_alpha = _alpha - 0.4};
if (_distance > _maxDist/4 && _distance <= _maxDist/2) then {_alpha = _alpha - 0.6};
if (_distance > _maxDist/2 && _distance <= _maxDist) then {_alpha = _alpha - 0.8};

if (_distance > _maxDist) then {_alpha = 0};

_alpha