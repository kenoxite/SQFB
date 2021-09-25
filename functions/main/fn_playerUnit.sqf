/*
  Author: Larrow, kenoxite

  Description:



  Parameter (s):
 

  Returns:


  Examples:

*/

// Check for Zeus controlled units
private _curatorModule = allCurators select 0;
if (isNil "_curatorModule") exitWith { player };

private _curatorUnit = getAssignedCuratorUnit _curatorModule;
private _curatorObjects = curatorEditableObjects _curatorModule select { typeOf _x isKindOf "CAManBase" };
//Zeus remoteControlled Unit [ unit ] OR []
private _curatorControlledUnit = _curatorObjects select { _x getVariable "bis_fnc_moduleremotecontrol_owner" isEqualTo _curatorUnit };

[
    [player, _curatorControlledUnit select 0] select (count _curatorControlledUnit > 0),
    player
] select (isNil "_curatorControlledUnit")
