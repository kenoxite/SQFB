/*
  Author: kenoxite

  Description:
  Controls the update of the HUD's data 


  Parameter (s):


  Returns:


  Examples:

*/

if (!SQFB_opt_on || (!alive SQFB_player && !alive player)) exitWith { true };

// Check for player and player group consistency
SQFB_player = call CBA_fnc_currentUnit;
private _grp = group SQFB_player;
private _units = units _grp;
private _unitCount = count _units;
private _indexData = SQFB_player getVariable "SQFB_grpIndex";
if (isNil "_indexData") then {_indexData = SQFB_lastPlayerIndex};

// Squad
if (SQFB_opt_showSquad) then {
    // Recheck player group units and roles
    [_grp] call SQFB_fnc_initGroup;

    // Name sounds
    {[_x] call SQFB_fnc_setNameSound} forEach _units;
    [SQFB_player] call SQFB_fnc_setNameSound;
        
    // Check for wounded units
    _grp setVariable ["SQFB_wounded", ({alive _x && {damage _x > 0.25}} count _units) > 0];
};

SQFB_trackingGearCheck = call SQFB_fnc_trackingGearCheck;
private _rangeFriendly = 0;
private _rangeEnemy = 0;

private _showSolo = SQFB_opt_IFFCheckSolo == "always" || _unitCount > 1 || (SQFB_opt_IFFCheckSolo == "device" && (SQFB_trackingGearCheck || call SQFB_fnc_playerInDrone));

// Friendlies
if (SQFB_opt_showFriendlies != "never") then {
    SQFB_showFriendlies = SQFB_opt_showFriendlies == "always" || (SQFB_showIFFHUD && _showSolo && SQFB_opt_showFriendlies != "device") ||  (SQFB_opt_showFriendlies == "device" && SQFB_trackingGearCheck && SQFB_showIFFHUD);
    _rangeFriendly = if (((getPosASL vehicle SQFB_player) select 2) > 5 && !(isNull objectParent SQFB_player)) then { SQFB_opt_showFriendliesMaxRangeAir } else { SQFB_opt_showFriendliesMaxRange };
} else {   
    SQFB_showFriendlies = false;
    SQFB_knownFriendlies = [];
};

// Enemies
private _displayTarget = SQFB_opt_alwaysDisplayTarget && !isNull (assignedTarget SQFB_player);
private _showEnemies = false;
private _onlyDisplayTarget = false;
if (SQFB_opt_showEnemies != "never") then {
    _showEnemies = SQFB_opt_showEnemies == "always" || (SQFB_showIFFHUD && _showSolo && SQFB_opt_showEnemies != "device") ||  (SQFB_opt_showEnemies == "device" && SQFB_trackingGearCheck && SQFB_showIFFHUD);
    _onlyDisplayTarget = _displayTarget && !_showEnemies;
    SQFB_showEnemies = [false, true] select (_showEnemies || _onlyDisplayTarget);

    if (SQFB_showEnemies) then {
        _rangeEnemy = if (((getPosASL vehicle SQFB_player) select 2) > 5 && !(isNull objectParent SQFB_player)) then { SQFB_opt_showEnemiesMaxRangeAir } else { SQFB_opt_showEnemiesMaxRange };
    };
} else {   
    SQFB_showEnemies = false;
    SQFB_knownEnemies = [];
};

if ((_rangeFriendly == 0 && _rangeEnemy == 0) || (!SQFB_showFriendlies && !SQFB_showEnemies)) exitWith {
    SQFB_showIFFHUD = false;
    SQFB_showFriendlies = false;
    SQFB_knownFriendlies = [];
    SQFB_showEnemies = false;
    SQFB_knownEnemies = [];
    
    // Clean taggers
    SQFB_knownIFF = [];
    call SQFB_fnc_cleanTaggers;
    SQFB_tagObjArr = [];
};

// Assign tagger objects
if ((SQFB_showFriendlies || SQFB_showEnemies) && !SQFB_deletingTaggers) then {
    private _range = selectMax [_rangeFriendly, _rangeEnemy];
    if (SQFB_showFriendlies) then {
        _range = [_rangeFriendly, _range] select SQFB_showEnemies;
        SQFB_knownFriendlies = [];
    };
    if (SQFB_showEnemies) then {
        _range = [_rangeEnemy, _range] select SQFB_showFriendlies;
        SQFB_knownEnemies = [];
    };
 
    // Clean taggers
    call SQFB_fnc_cleanTaggers;
    SQFB_knownIFF = [];

    // Rebuild known IFF list and create taggers
    [SQFB_player, _range, SQFB_showEnemies, _rangeEnemy, SQFB_showFriendlies, _rangeFriendly, _onlyDisplayTarget] call SQFB_fnc_knownFriendsAndFoes;
};
