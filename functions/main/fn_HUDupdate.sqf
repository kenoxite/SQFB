/*
  Author: kenoxite

  Description:
  Controls the update of the HUD's data 


  Parameter (s):


  Returns:


  Examples:

*/

if (!SQFB_opt_on) exitWith { true };

// Check for player and player group consistency
SQFB_player = call SQFB_fnc_playerUnit;
private _grp = group SQFB_player;
private _units = units _grp;
private _unitCount = count _units;
if (SQFB_group != _grp || !(SQFB_player in SQFB_units)) then {
    // Rebuild units array
    [_grp] call SQFB_fnc_initGroup;
};

// Squad
if (SQFB_opt_showSquad) then {
	// Check for wounded units
	_grp setVariable ["SQFB_wounded", _units findIf {lifeState _x != "HEALTHY"} != -1];
};

// private _rangeFriendly = 0;
// private _rangeEnemy = 0;

// // Friendlies
// if (SQFB_showFriendlyHUD || SQFB_opt_showFriendlies == "always") then {
//     SQFB_showFriendlies = true;
//     _rangeFriendly = if (((getPosASL vehicle SQFB_player) select 2) > 5 && !(isNull objectParent SQFB_player)) then { SQFB_opt_showFriendliesMaxRangeAir } else { SQFB_opt_showFriendliesMaxRange };
// };
// if (SQFB_opt_showFriendlies == "never") then {   
//     SQFB_showFriendlyHUD = false;
//     SQFB_showFriendlies = false;
//     // Clean taggers
//     SQFB_knownFriendlies = [];
//     [false] call SQFB_fnc_cleanTaggers;
// };

// Enemies
SQFB_trackingGearCheck = call SQFB_fnc_trackingGearCheck;
if (SQFB_opt_showEnemies != "never") then {
    private _trackingDeviceEnabled = (SQFB_opt_showEnemiesIfTrackingGear || SQFB_opt_showEnemies == "device") && SQFB_trackingGearCheck;
    private _showSolo = SQFB_opt_enemyCheckSolo || (!SQFB_opt_enemyCheckSolo && _unitCount > 1);
    private _assignedTarget = assignedTarget SQFB_player;
    private _displayTarget = SQFB_opt_alwaysDisplayTarget && !isNull _assignedTarget;
    private _showEnemies = SQFB_opt_showEnemies == "always" || (SQFB_showEnemyHUD && _showSolo && SQFB_opt_showEnemies != "device") ||  _trackingDeviceEnabled;
    SQFB_showEnemies = [false, true] select (_showEnemies || _displayTarget);

    // if (SQFB_showEnemies) then {
    //     _rangeEnemy = if (((getPosASL vehicle SQFB_player) select 2) > 5 && !(isNull objectParent SQFB_player)) then { SQFB_opt_showEnemiesMaxRangeAir } else { SQFB_opt_showEnemiesMaxRange };
    // };

    if (SQFB_showEnemies) then {
        //Disable manual toggling variable if not set as such
        if (SQFB_showEnemyHUD && _trackingDeviceEnabled) then { SQFB_showEnemyHUD = false };
        // Choose which max range to check for: normal or air
        private _range = if (((getPosASL vehicle SQFB_player) select 2) > 5 && !(isNull objectParent SQFB_player)) then { SQFB_opt_showEnemiesMaxRangeAir } else { SQFB_opt_showEnemiesMaxRange };
        // Check for known enemies
        private _targets = [[SQFB_player, _range] call SQFB_fnc_enemyTargets, [_assignedTarget]] select (_displayTarget && !_showEnemies); // Only display the assigned target if enemy HUD is not requested
        // Only alive enemies on foot and vehicles with crew
        private _knownEnemies = _targets select { alive _x && {({ alive _x } count (crew _x)) > 0} };
        // Sort by distance
        SQFB_knownEnemies = [_knownEnemies, [], { SQFB_player distance _x }, "ASCEND"] call BIS_fnc_sortBy;
        // Resize to chosen max
        if (SQFB_opt_showEnemiesMaxUnits > -1) then { SQFB_knownEnemies resize SQFB_opt_showEnemiesMaxUnits };
        // Clean enemy taggers
        [true] call SQFB_fnc_cleanTaggers;
        // Create enemy taggers, used to display last known position of enemy units
        private _knownEnemiesAmount = count SQFB_knownEnemies;
        if (_knownEnemiesAmount > 0) then {
            for "_i" from 0 to _knownEnemiesAmount -1 do
            {
                private _enemy = SQFB_knownEnemies select _i;
                private _side = [
                                    _enemy call SQFB_fnc_factionSide,
                                    side _enemy
                                ] select (SQFB_opt_enemySideColors == "current");
                _enemy setVariable ["SQFB_side", _side];
                _enemy setVariable ["SQFB_color",[
                                                    SQFB_opt_colorEnemy,
                                                    call {
                                                        if (_side == west) exitWith {SQFB_opt_colorEnemyWest};
                                                        if (_side == resistance) exitWith {SQFB_opt_colorEnemyGuer};
                                                        if (_side == civilian) exitWith {SQFB_opt_colorEnemyCiv};
                                                        SQFB_opt_colorEnemy;
                                                    }
                                                    ] select (SQFB_opt_enemySideColors != "never")
                                                ]; 
                private _enemyTaggerFound = SQFB_enemyTagObjArr select { (_x select 1) == _enemy };
                if (count _enemyTaggerFound == 0) then {
                    if (SQFB_debug) then { diag_log format ["SQFB: updateHUD - enemyTagger not found for unit: %1. Creating a new one...", _enemy] };
                    private _enemyTagger = createSimpleObject ["RoadCone_F", [0,0,0], false];
                    _enemyTagger hideObject true;
                    SQFB_enemyTagObjArr pushBack [_enemyTagger, _enemy];
                };
            };
        };
    };
} else {   
    SQFB_showEnemyHUD = false;
    SQFB_showEnemies = false;
    // Clean taggers
    SQFB_knownEnemies = [];
    [true] call SQFB_fnc_cleanTaggers;
};

// if (_rangeFriendly == 0 && _rangeEnemy == 0) exitWith { true };

// // Assign tagger objects
// if ((SQFB_showFriendlies || SQFB_showEnemies) && !SQFB_deletingEnemyTaggers && !SQFB_deletingFriendlyTaggers) then {
//     private _range = selectMax [_rangeFriendly, _rangeEnemy];
//     if (SQFB_showFriendlies) then {
//         _range = [_rangeFriendly, _range] select SQFB_showEnemies;
//         [false] call SQFB_fnc_cleanTaggers;
//         SQFB_knownFriendlies = [];
//     };
//     if (SQFB_showEnemies) then {
//         _range = [_rangeEnemy, _range] select SQFB_showFriendlies;
//         [true] call SQFB_fnc_cleanTaggers;
//         SQFB_knownEnemies = [];
//     };

//     SQFB_knownIFF = [];

//     [SQFB_player, _range, SQFB_showEnemies, _rangeEnemy, SQFB_showFriendlies, _rangeFriendly] call SQFB_fnc_knownFriendsAndFoes;
// };
