/*
  Author: kenoxite

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
_player != player
