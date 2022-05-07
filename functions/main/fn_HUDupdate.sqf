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

private _rangeFriendly = 0;
private _rangeEnemy = 0;

// Friendlies
if (SQFB_showFriendlyHUD || SQFB_opt_showFriendlies == "always") then {
    SQFB_showFriendlies = true;
    _rangeFriendly = if (((getPosASL vehicle SQFB_player) select 2) > 5 && !(isNull objectParent SQFB_player)) then { SQFB_opt_showFriendliesMaxRangeAir } else { SQFB_opt_showFriendliesMaxRange };
};
if (SQFB_opt_showFriendlies == "never") then {   
    SQFB_showFriendlyHUD = false;
    SQFB_showFriendlies = false;
    // Clean taggers
    SQFB_knownFriendlies = [];
    [false] call SQFB_fnc_cleanTaggers;
};

// Enemies
if (SQFB_showEnemyHUD || SQFB_opt_showEnemies == "always") then {
    private _trackingDeviceEnabled = SQFB_opt_showEnemiesIfTrackingGear && call SQFB_fnc_trackingGearCheck;
    private _showSolo = SQFB_opt_enemyCheckSolo || (!SQFB_opt_enemyCheckSolo && _unitCount > 1);
    private _assignedTarget = assignedTarget SQFB_player;
    private _displayTarget = SQFB_opt_alwaysDisplayTarget && !isNull _assignedTarget;
    private _showEnemies = SQFB_opt_showEnemies == "always" || (SQFB_showEnemyHUD && _showSolo) ||  _trackingDeviceEnabled;
    SQFB_showEnemies = [false, true] select (_showEnemies || _displayTarget);

    if (SQFB_showEnemies) then {
        _rangeEnemy = if (((getPosASL vehicle SQFB_player) select 2) > 5 && !(isNull objectParent SQFB_player)) then { SQFB_opt_showEnemiesMaxRangeAir } else { SQFB_opt_showEnemiesMaxRange };
    };
};
if (SQFB_opt_showEnemies == "never") then {   
    SQFB_showEnemyHUD = false;
    SQFB_showEnemies = false;
    // Clean taggers
    SQFB_knownEnemies = [];
    [true] call SQFB_fnc_cleanTaggers;
};

if (_rangeFriendly == 0 && _rangeEnemy == 0) exitWith { true };

// Assign tagger objects
if ((SQFB_showFriendlies || SQFB_showEnemies) && !SQFB_deletingEnemyTaggers && !SQFB_deletingFriendlyTaggers) then {
    private _range = selectMax [_rangeFriendly, _rangeEnemy];
    if (SQFB_showFriendlies) then {
        _range = [_rangeFriendly, _range] select SQFB_showEnemies;
        [false] call SQFB_fnc_cleanTaggers;
        SQFB_knownFriendlies = [];
    };
    if (SQFB_showEnemies) then {
        _range = [_rangeEnemy, _range] select SQFB_showFriendlies;
        [true] call SQFB_fnc_cleanTaggers;
        SQFB_knownEnemies = [];
    };

    [SQFB_player, _range, SQFB_showEnemies, _rangeEnemy, SQFB_showFriendlies, _rangeFriendly] call SQFB_fnc_knownFriendsAndFoes;
};
