params ["_unit"];
private _isEnemy = _unit getVariable "SQFB_isEnemy";
private _SQFB_opt_checkOcclusion = [SQFB_opt_checkOcclusionFriendlies, SQFB_opt_checkOcclusionEnemies] select _isEnemy;
if (!_SQFB_opt_checkOcclusion) exitWith {false};

private _isTarget = _unit == assignedTarget SQFB_player;
private _isOnFoot = (typeOf (vehicle _unit) isKindOf "Man");
private _SQFB_opt_preciseVisCheck = [SQFB_opt_friendlyPreciseVisCheck, SQFB_opt_enemyPreciseVisCheck] select _isEnemy;

[_unit, SQFB_player, _isTarget, _SQFB_opt_preciseVisCheck, _isOnFoot, SQFB_opt_alternateOcclusionCheck] call SQFB_fnc_checkOcclusion
