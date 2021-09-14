/*
  Author: kenoxite

  Description:
  Controls the update of the HUD's data 


  Parameter (s):


  Returns:


  Examples:

*/

private _grp = group player;
private _count = count units player;
if (_count != SQFB_unitCount || SQFB_showHUD) then {
	[] call SQFB_fnc_showHUD_init;
	SQFB_unitCount = _count;
};
if (!SQFB_showHUD) then {
	// Check for wounded units
	_grp setVariable ["SQFB_wounded", (units _grp) findIf {lifeState _x != "HEALTHY"} != -1];
};

if (SQFB_opt_showEnemies) then {
    SQFB_knownEnemies = [player, SQFB_opt_showEnemiesMaxRange] call SQFB_fnc_enemyTargets;
    // Create enemy taggers
    {
        private _enemy = _x;
        private _enemyTaggerFound = SQFB_enemyTagObjArr select { (_x select 1) == _enemy };
        if (count _enemyTaggerFound == 0) then {
            diag_log format ["SQFB: updateHUD - enemyTagger not found for unit: %1. Creating a new one...", _enemy];
            private _unitPos = position _enemy;
            private _enemyTagger = createVehicle ["FlagPole_F", [0,0,0], [], 0, "CAN_COLLIDE"];
            _enemyTagger hideObject true;
            SQFB_enemyTagObjArr pushBack [_enemyTagger, _enemy, true];
        };
    } forEach SQFB_knownEnemies;

    // Clean enemy taggers
    private _taggersToDelete = [];
    {
        private _unit = _x select 1;
        if (isNull _unit || !alive _unit) then {
            deleteVehicle (_x select 0);
            _taggersToDelete pushBack _unit;
        };
    } forEach SQFB_enemyTagObjArr;
    SQFB_enemyTagObjArr = SQFB_enemyTagObjArr - _taggersToDelete;
};