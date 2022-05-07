/*
  Author: kenoxite

  Description:
  Looks for nearby friendlies and enemies and assigns them a tagger object.


  Parameter (s):
 

  Returns:


  Examples:

*/

params [["_unit", SQFB_player, [objNull]], ["_distance", 1000, [123]], ["_checkEnemies", true, [true]], ["_distanceFoe", 1000, [123]], ["_checkFriendlies", true, [true]], ["_distanceFriend", 1000, [123]]];

private _nearUnits = (_unit nearEntities [["CAManBase", "Helicopter", "Plane", "LandVehicle", "Ship"], _distance]) select { (_unit targetKnowledge _x) select 0 };
_nearUnits = _nearUnits - SQFB_units; // Exclude player units

for "_i" from 0 to (count _nearUnits) -1 do
{
    private _IFFunit = _nearUnits select _i;
    private _alignment = side _IFFunit getFriend side _unit;
    
    // Friends
    if (_checkFriendlies && {_alignment >= 0.6}) then {
        if (_IFFunit distance2D _unit <= _distanceFriend) then {
            SQFB_knownFriendlies pushBackUnique _IFFunit;
            private _friendlyTaggerFound = SQFB_friendlyTagObjArr select { (_x select 1) == _IFFunit };
            if (count _friendlyTaggerFound == 0) then {
                if (SQFB_debug) then { diag_log format ["SQFB: nearFriendAndFoes - friendlyTagger not found for unit: %1. Creating a new one...", _IFFunit] };
                private _friendlyTagger = createSimpleObject ["RoadCone_F", [0,0,0], false];
                _friendlyTagger hideObject true;
                SQFB_friendlyTagObjArr pushBack [_friendlyTagger, _IFFunit];
            };               
        };
    };

    // Foes
    if (_checkEnemies && {_alignment < 0.6}) then {
        if (_IFFunit distance2D _unit <= _distanceFoe) then {
            SQFB_knownEnemies pushBackUnique _IFFunit;
            private _enemyTaggerFound = SQFB_enemyTagObjArr select { (_x select 1) == _IFFunit };
            if (count _enemyTaggerFound == 0) then {
                if (SQFB_debug) then { diag_log format ["SQFB: nearFriendAndFoes - enemyTagger not found for unit: %1. Creating a new one...", _IFFunit] };
                private _enemyTagger = createSimpleObject ["RoadCone_F", [0,0,0], false];
                _enemyTagger hideObject true;
                SQFB_enemyTagObjArr pushBack [_enemyTagger, _IFFunit];
            };               
        };
    };
};
