/*
  Author: kenoxite

  Description:
  Initialize group 


  Parameter (s):
  _this select 0: _grp
 

  Returns:


  Examples:

*/

params [["_grp", SQFB_group, [grpNull]]];

if (isNull _grp) exitWith {false};
if (isNil "_grp") exitWith {false};
if (!alive SQFB_player) exitWith {false};

if (SQFB_debug) then { diag_log format ["SQFB: initGroup - Initializing new group: %1 (old group: %2)", _grp, SQFB_group] };

private _units = units _grp;
_grp setVariable ["SQFB_wounded", false];

{
    // Initialize the units group index
    private _index = _x call SQFB_fnc_getUnitPositionId;
    _x setVariable ["SQFB_grpIndex", _index];
    _x setVariable ["SQFB_lastGroup", group _x];
    if (_x == SQFB_player) then {SQFB_lastPlayerIndex = _index };

    // Change names
    if (_x != SQFB_player && SQFB_opt_nameSound_ChangeNames) then {
        [_x] call SQFB_fnc_changeToValidName;
    };
} forEach _units;

// Update global vars
SQFB_group = _grp;
SQFB_units = _units;
SQFB_unitCount = count _units;

// Add dead units, which might not being tracked if player changed groups already
{
    if ((_x getVariable "SQFB_lastGroup") == SQFB_group) then { SQFB_units pushBackUnique _x };   
} forEach SQFB_deadUnits;

// Update all
[_units] call SQFB_fnc_addUnits;
call SQFB_fnc_updateAllUnits;

// Reset enemy vars
SQFB_showEnemies = false;

// Reset friendly vars
SQFB_showFriendlies = false;

// Clean enemy taggers
SQFB_knownIFF = if (isNull (assignedTarget SQFB_player)) then { [] } else {[assignedTarget SQFB_player]};
call SQFB_fnc_cleanTaggers;
SQFB_tagObjArr = [];

// Init HUDs
call SQFB_fnc_IFFactivateDevice;

// Init squad HUD
if (SQFB_showHUD) then {
    [] call SQFB_fnc_HUDshow;
};

// Init IFF HUD
if (SQFB_showIFFHUD) then {
    ["iff"] call SQFB_fnc_HUDshow;
};

// Player traits
// private _unitTraits = getAllUnitTraits SQFB_player;
// SQFB_player setVariable ["SQFB_medic",(_unitTraits select { (_x select 0) == "Medic" } apply { _x select 1 }) select 0];
