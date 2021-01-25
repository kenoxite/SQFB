/*
  Author: kenoxite

  Description:
  Get unit index in the group


  Parameter (s):
  _this select 0: _grp
 

  Returns:


  Examples:

*/

private ["_vvn", "_str"];
_vvn = vehicleVarName _this;
_this setVehicleVarName "";
_str = str _this;
_this setVehicleVarName _vvn;
parseNumber (_str select [(_str find ":") + 1])
