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
    SQFB_knownEnemies = player call BIS_fnc_enemyTargets;

    // Create enemy taggers
    {
        private _enemyTaggerIndex = [SQFB_enemyTagObjArr, _x] call BIS_fnc_findNestedElement;
        private _enemyTagger = objNull;
        if (count _enemyTaggerIndex == 0) then {
            diag_log format ["SQFB: updateHUD - enemyTagger not found for unit: %1. Creating a new one...", _x];
            private _unitPos = position (vehicle _x);
            private _enemyTagger = createVehicle ["FlagPole_F", [0,0,0], [], 0, "CAN_COLLIDE"];
            _enemyTagger hideObject true;
            // private _enemyTagger = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", format["mrkr_enemyTagger_%1", floor(random 99999)], _unitPos, "mil_dot", "ICON", [3, 3], 0, "Solid", "ColorEAST", 0, ""] call BIS_fnc_stringToMarker;
            SQFB_enemyTagObjArr pushBack [_enemyTagger, _x];
            // _enemyTagger setMarkerPos _unitPos;
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