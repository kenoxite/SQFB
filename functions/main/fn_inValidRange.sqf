params ["_unit", "_vehPlayer", "_isPlayerAir"];
private _veh = vehicle _unit;
private _dist = _vehPlayer distance _veh;
private _isEnemy = _unit getVariable "SQFB_isEnemy";

private _maxRange = [
                    [SQFB_opt_showFriendliesMaxRange, SQFB_opt_showFriendliesMaxRangeAir] select _isPlayerAir,
                    [SQFB_opt_showEnemiesMaxRange, SQFB_opt_showEnemiesMaxRangeAir] select _isPlayerAir
                ] select _isEnemy;

(_dist <= _maxRange)
