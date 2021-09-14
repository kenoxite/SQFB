/*
  Author: kenoxite

  Description:
  Returns array with enemies at a given range.


  Parameter (s):
 

  Returns:


  Examples:

*/

params [["_unit", player, [objNull]], ["_distance", 1000, [123]]];
private _targets = if (_distance == -1) then
{
    ((_unit targetsQuery [objNull, sideUnknown, "", [], 0]) select {(_x select 3) > 0}) apply {_x select 1};
    //0.687758 ms
} else {
    // (_unit nearTargets _distance) select { (_x select 3) > 0  && count (crew (_x select 4) select { alive _x }) > 0 } apply {_x select 4};
    (_unit nearTargets _distance) select { (_x select 3) > 0 } apply {_x select 4};
    // 0.0599 ms
};

_targets