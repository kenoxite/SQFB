/*
  Author: kenoxite

  Description:
  Returns the type of class based on what type of vehicle it is. 


  Parameter (s):
  _this select 0: _class

  Returns:


  Examples:

*/
params ["_class"];
private ["_veh", "_return"];
_return = "unknown";
if (_class isKindOf "Man") exitwith { "inf" };
if (_class isKindOf "APC_Tracked_01_base_F" || _class isKindOf "APC_Tracked_02_base_F" || _class isKindOf "APC_Tracked_03_base_F" || _class isKindOf "Wheeled_APC_F") exitwith { "mech_inf" };
if (_class isKindOf "Car" || _class isKindOf "Truck") exitwith { "motor_inf" };
if (_class isKindOf "Armor") exitwith { "armor" };
if (_class isKindOf "Air") exitwith { "air" };
if (_class isKindOf "Ship") exitwith { "naval" };
_return
