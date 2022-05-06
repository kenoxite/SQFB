/*
  Author: kenoxite

  Description:
  Controls the update of the HUD's data 


  Parameter (s):


  Returns:


  Examples:

*/

// Squad
if (SQFB_opt_showSquad) then {
    private _grp = group SQFB_player;
    private _count = count units SQFB_player;
    if (_count != SQFB_unitCount || SQFB_showHUD) then {
    	[] call SQFB_fnc_HUDshow;
    };
	// Check for wounded units
	_grp setVariable ["SQFB_wounded", (units _grp) findIf {lifeState _x != "HEALTHY"} != -1];
};


private _rangeFriendly = 0;
private _rangeEnemy = 0;

// Friendlies
if (SQFB_opt_showFriendlies != "never") then {
    private _showFriendlies = SQFB_opt_showFriendlies == "always" || SQFB_showFriendlyHUD;
    SQFB_showFriendlies = [false, true] select _showFriendlies;

    if (SQFB_showFriendlies) then {
        _rangeFriendly = if (((getPosASL vehicle SQFB_player) select 2) > 5 && !(isNull objectParent SQFB_player)) then { SQFB_opt_showFriendliesMaxRangeAir } else { SQFB_opt_showFriendliesMaxRange };
    };
} else {  
    SQFB_showFriendlyHUD = false;
    SQFB_showFriendlies = false;
    // Clean taggers
    SQFB_knownFriendlies = [];
    [false] call SQFB_fnc_cleanTaggers;
};

// Enemies
if (SQFB_opt_showEnemies != "never") then {
    private _trackingDeviceEnabled = SQFB_opt_showEnemiesIfTrackingGear && call SQFB_fnc_trackingGearCheck;
    private _grpCount = count (units group SQFB_player);
    private _showSolo = SQFB_opt_enemyCheckSolo || (!SQFB_opt_enemyCheckSolo && _grpCount > 1);
    private _assignedTarget = assignedTarget SQFB_player;
    private _displayTarget = SQFB_opt_alwaysDisplayTarget && !isNull _assignedTarget;
    private _showEnemies = SQFB_opt_showEnemies == "always" || (SQFB_showEnemyHUD && _showSolo) ||  _trackingDeviceEnabled;
    SQFB_showEnemies = [false, true] select (_showEnemies || _displayTarget);

    if (SQFB_showEnemies) then {
        _rangeEnemy = if (((getPosASL vehicle SQFB_player) select 2) > 5 && !(isNull objectParent SQFB_player)) then { SQFB_opt_showEnemiesMaxRangeAir } else { SQFB_opt_showEnemiesMaxRange };
    };
} else {    
    SQFB_showEnemyHUD = false;
    SQFB_showEnemies = false;
    // Clean taggers
    SQFB_knownEnemies = [];
    [true] call SQFB_fnc_cleanTaggers;
};

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