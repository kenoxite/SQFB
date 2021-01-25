/*
  Author: kenoxite

  Description:
  Set alpha


  Parameter (s):
  _this select 0: _unit
 

  Returns:


  Examples:

*/

params ["_unit"];
private _distance = (vehicle _unit) distance (vehicle player);
private _alpha = SQFB_opt_maxAlpha;
private _maxDist = SQFB_opt_maxDist;
private _veh = vehicle player;
if ((getPosASL _veh select 2) > 5 && _veh != player) then { _maxDist = SQFB_opt_maxDist_air };
if (_distance > _maxDist/8 && _distance <= _maxDist/6) then {_alpha = _alpha - 0.2};
if (_distance > _maxDist/6 && _distance <= _maxDist/4) then {_alpha = _alpha - 0.4};
if (_distance > _maxDist/4 && _distance <= _maxDist/2) then {_alpha = _alpha - 0.6};
if (_distance > _maxDist/2 && _distance <= _maxDist) then {_alpha = _alpha - 0.8};

if (_distance > _maxDist) then {_alpha = 0};

_alpha