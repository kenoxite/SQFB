/*
  Author: Larrow, kenoxite

  Description:



  Parameter (s):
 

  Returns:


  Examples:

*/

private _player = player;

// Check for controlled drones
{private _UAVrole = (UAVControl _x) select 1; if ((player in UAVControl _x) && (_UAVrole != "")) then {_player = [_x, gunner _x] select (_UAVrole == "GUNNER")}} foreach allUnitsUAV;

// Check for Zeus controlled units
private _curatorModule = allCurators select 0;
if (isNil "_curatorModule") exitWith { _player };

private _curatorUnit = getAssignedCuratorUnit _curatorModule;
private _curatorObjects = curatorEditableObjects _curatorModule select { typeOf _x isKindOf "CAManBase" };
//Zeus remoteControlled Unit [ unit ] OR []
private _curatorControlledUnit = _curatorObjects select { _x getVariable "bis_fnc_moduleremotecontrol_owner" isEqualTo _curatorUnit };

[
    [player, _curatorControlledUnit select 0] select (count _curatorControlledUnit > 0),
    player
] select (isNil "_curatorControlledUnit");
