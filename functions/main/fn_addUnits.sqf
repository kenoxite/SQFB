/*
  Author: kenoxite

  Description:
  Initialize the units and add them to the global array


  Parameter (s):
  _this select 0: _grp
 

  Returns:


  Examples:

*/

params ["_units"];
// Add units to array and assign EH
if (count _units > 0) then {
	{
		if ((typeName _x) != "STRING") then {
			if !(_x in SQFB_units) then {
				// Add EH
				_x addEventHandler ["Take", {(_this select 0) spawn SQFB_fnc_updateUnit}];
				_x addEventHandler ["Put", {(_this select 0) spawn SQFB_fnc_updateUnit}];
				_x addEventHandler ["InventoryClosed", {(_this select 0) spawn SQFB_fnc_updateUnit}];
				_x addEventHandler ["InventoryOpened", {(_this select 0) spawn SQFB_fnc_updateUnit}];
				_x addEventHandler ["Killed", {(_this select 0) spawn SQFB_fnc_updateUnit}];
				_x addEventHandler ["Deleted", {SQFB_units = SQFB_units - [_this select 0]}];
			};
		};
	} forEach _units;
	
	// Add units to global array
	{SQFB_units pushBackUnique _x} forEach _units;
};
// Update all
[] call SQFB_fnc_updateAllUnits;
