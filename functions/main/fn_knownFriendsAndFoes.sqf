/*
  Author: kenoxite

  Description:
  Looks for nearby friendlies and enemies and assigns them a tagger object.


  Parameter (s):
 

  Returns:


  Examples:

*/

params [["_unit", SQFB_player, [objNull]], ["_distance", 1000, [123]], ["_checkEnemies", true, [true]], ["_distanceFoe", 1000, [123]], ["_checkFriendlies", true, [true]], ["_distanceFriend", 1000, [123]], ["_onlyDisplayTarget", false, [true]]];

private _nearUnitsUnsorted = (_unit nearEntities [["CAManBase", "Helicopter", "Plane", "LandVehicle", "Ship"], _distance]) select { (_unit targetKnowledge _x) select 0 };
_nearUnitsUnsorted = _nearUnitsUnsorted - SQFB_units; // Exclude player units
// Only alive enemies on foot and vehicles with crew
_nearUnitsUnsorted = _nearUnitsUnsorted select { alive _x && {({ alive _x } count (crew _x)) > 0} };
// Sort by distance
private _nearUnits = [_nearUnitsUnsorted, [], { _unit distance _x }, "ASCEND"] call BIS_fnc_sortBy;

private _playerTarget = assignedTarget SQFB_player;

for "_i" from 0 to (count _nearUnits) -1 do
{
    private _IFFunit = _nearUnits select _i;
    private _sideIFFunit = side _IFFunit;

    // Skip if unit doesn't belong to a valid side
    if (_sideIFFunit == sideLogic || _sideIFFunit == sideAmbientLife || _sideIFFunit == sideEmpty) then { continue };

    private _distIFFunit = _IFFunit distance _unit;
    private _alignment1 = _sideIFFunit getFriend side _unit;
    private _alignment2 = side _unit getFriend _sideIFFunit;
    private _isEnemy = _alignment1 < 0.6 || _alignment2 < 0.6;
    private _addTagger = false;

    // Share target info with the player unit proper, otherwise might be lost when player swtiches units
    player reveal _IFFunit;
    
    // Friends
    if (_checkFriendlies && {!_isEnemy || _IFFunit == vehicle player}) then {
        // Check if unit is still below max count
        if (SQFB_opt_showFriendliesMaxUnits == -1 || {count SQFB_knownFriendlies < SQFB_opt_showFriendliesMaxUnits}) then {
            // Check if within distance
            if (_distIFFunit <= _distanceFriend) then {
                SQFB_knownFriendlies pushBackUnique _IFFunit;
                _IFFunit setVariable ["SQFB_side", [
                                                    _IFFunit call SQFB_fnc_factionSide,
                                                    _sideIFFunit
                                                    ] select (SQFB_opt_friendlySideColors == "current")
                                    ];
                private _side = [
                                    _IFFunit call SQFB_fnc_factionSide,
                                    _sideIFFunit
                                ] select (SQFB_opt_friendlySideColors == "current");
                _IFFunit setVariable ["SQFB_side", _side];
                _IFFunit setVariable ["SQFB_color",[
                                                    SQFB_opt_colorFriendly,
                                                    call {
                                                        if (_side == east) exitWith {SQFB_opt_colorFriendlyEast};
                                                        if (_side == resistance) exitWith {SQFB_opt_colorFriendlyGuer};
                                                        if (_side == civilian) exitWith {SQFB_opt_colorFriendlyCiv};
                                                        SQFB_opt_colorFriendly;
                                                    }
                                                    ] select (SQFB_opt_friendlySideColors != "never")
                                                ]; 
                _IFFunit setVariable ["SQFB_isEnemy", false];
                _addTagger = true;
            };
        };
    };

    // Foes
    if (_checkEnemies && {_isEnemy}) then {
        // Check if unit is still below max count or is the target
        if ((_onlyDisplayTarget && _IFFunit == _playerTarget) || (!_onlyDisplayTarget && {SQFB_opt_showEnemiesMaxUnits == -1 || {count SQFB_knownEnemies < SQFB_opt_showEnemiesMaxUnits}})) then {
            // Check if within distance
            if (_distIFFunit <= _distanceFoe) then {
                SQFB_knownEnemies pushBackUnique _IFFunit;
                private _side = [
                                    _IFFunit call SQFB_fnc_factionSide,
                                    _sideIFFunit
                                ] select (SQFB_opt_enemySideColors == "current");
                _IFFunit setVariable ["SQFB_side", _side];
                _IFFunit setVariable ["SQFB_color",[
                                                    SQFB_opt_colorEnemy,
                                                    call {
                                                        if (_side == west) exitWith {SQFB_opt_colorEnemyWest};
                                                        if (_side == resistance) exitWith {SQFB_opt_colorEnemyGuer};
                                                        if (_side == civilian) exitWith {SQFB_opt_colorEnemyCiv};
                                                        SQFB_opt_colorEnemy;
                                                    }
                                                    ] select (SQFB_opt_enemySideColors != "never")
                                                ]; 
                _IFFunit setVariable ["SQFB_isEnemy", true]; 
                _addTagger = true;
            };
        };
    };

    if (_addTagger) then {
        private _taggerFound = SQFB_tagObjArr select { (_x select 1) == _IFFunit };
        private _taggerObj = [
                                objNull,
                                (_taggerFound select 0) select 0
                             ] select (count _taggerFound == 1);
        if (isNull _taggerObj) then {
            if (SQFB_debug) then { diag_log format ["SQFB: nearFriendAndFoes - tagger not found for unit: %1. Creating a new one...", _IFFunit] };
            _tagger = "camera" camCreate [0,0,0];
            if (count _taggerFound == 0) then {
                SQFB_tagObjArr pushBack [_tagger, _IFFunit];
            } else {
                private _index = SQFB_tagObjArr find [objNull, _IFFunit];
                if (_index > -1) then { SQFB_tagObjArr set [_index, [_tagger, _IFFunit]] };
            };
        };
    };
};

SQFB_knownIFF = SQFB_knownFriendlies + SQFB_knownEnemies;
