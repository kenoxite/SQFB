/*
  Author: kenoxite

  Description:
  Set alpha


  Parameter (s):
  _this select 0: _unit
 

  Returns:


  Examples:

*/

params [["_unit", objNull], ["_distance", 0], ["_maxDist", 800], ["_alpha", 1]];
if (isNull _unit) exitWith {1};
if (_distance > _maxDist) exitWith { 0 };

if (_distance > _maxDist/8 && _distance <= _maxDist/6) exitWith { _alpha - 0.2 };
if (_distance > _maxDist/6 && _distance <= _maxDist/4) exitWith { _alpha - 0.4 };
if (_distance > _maxDist/4 && _distance <= _maxDist/2) exitWith { _alpha - 0.6 };
if (_distance > _maxDist/2 && _distance <= _maxDist) exitWith { _alpha - 0.8 };

_alpha
