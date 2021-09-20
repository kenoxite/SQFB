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
private _isPlayerAir = (getPosASL _vehPlayer select 2) > 5 && !(isNull objectParent player);
private _maxDist = [
                        [
                            SQFB_opt_showEnemiesMaxRange,
                            SQFB_opt_maxRange
                        ] select (_type == "friendly"),

                        [
                            SQFB_opt_showEnemiesMaxRangeAir,
                            SQFB_opt_maxRangeAir
                        ] select (_type == "friendly")
                    ] select (_isPlayerAir);

if (_distance > _maxDist) exitWith { 0 };

if (_distance > _maxDist/8 && _distance <= _maxDist/6) exitWith { _alpha - 0.2 };
if (_distance > _maxDist/6 && _distance <= _maxDist/4) exitWith { _alpha - 0.4 };
if (_distance > _maxDist/4 && _distance <= _maxDist/2) exitWith { _alpha - 0.6 };
if (_distance > _maxDist/2 && _distance <= _maxDist) exitWith { _alpha - 0.8 };

_alpha