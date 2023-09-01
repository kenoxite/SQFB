/*
  Author: Larrow, kenoxite

  Description:



  Parameter (s):
 

  Returns:


  Examples:

*/

private _player = player;

// Check for controlled drones
{
    private _UAVrole = (UAVControl _x) select 1;
    if ((player in UAVControl _x) && (_UAVrole != "")) then {
        _player = [_x, gunner _x] select (_UAVrole == "GUNNER");
    };
} foreach allUnitsUAV;

// Check for Zeus controlled units
private _curatorModule = allCurators select 0;
if (isNil "_curatorModule") exitWith { _player };

private _curatorUnit = getAssignedCuratorUnit _curatorModule;
private _curatorObjects = curatorEditableObjects _curatorModule select { typeOf _x isKindOf "CAManBase" };
private _curatorControlledUnit = [];
if (side _player == sideLogic) then {
    // Special check if player is a zeus gamelogic (VirtualCurator)
    if (cameraOn != _player) then { _curatorControlledUnit = [cameraOn] };
} else {
    // If zeus unit is a normal inf unit just check for the owner variable
    _curatorControlledUnit = _curatorObjects select { _x getVariable "bis_fnc_moduleremotecontrol_owner" isEqualTo _curatorUnit };
};

[
    [_player, _curatorControlledUnit#0] select (count _curatorControlledUnit > 0),
    _player
] select (isNil "_curatorControlledUnit");
