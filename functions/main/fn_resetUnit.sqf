/*
  Author: kenoxite

  Description:
  Update all units


  Parameter (s):
  _this select 0: _unit
 

  Returns:


  Examples:

*/

params ["_unit"];
_unit setVariable ["SQFB_noAmmoPrim",false];
_unit setVariable ["SQFB_noAmmoSec",false];
_unit setVariable ["SQFB_noAmmo",false];
//_unit setVariable ["SQFB_grpIndex",-1];
_unit setVariable ["SQFB_displayName",""];
_unit setVariable ["SQFB_medic",false];
_unit setVariable ["SQFB_demo",false];
_unit setVariable ["SQFB_engi",false];
_unit setVariable ["SQFB_AA",false];
_unit setVariable ["SQFB_AT",false];
_unit setVariable ["SQFB_GL",false];
_unit setVariable ["SQFB_MG",false];
_unit setVariable ["SQFB_sniper",false];
_unit setVariable ["SQFB_veh",_unit];
_unit setVariable ["SQFB_roles",""];