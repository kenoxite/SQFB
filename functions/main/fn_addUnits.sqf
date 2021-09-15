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
    for "_i" from 0 to (count _units) -1 do
	{
        private _x = _units select _i;
        if !(_x isEqualType "") then {
			if !(_x in SQFB_units) then {
				// Add EH
				_x addEventHandler ["Take", {(_this select 0) spawn SQFB_fnc_updateUnit}];
				_x addEventHandler ["Put", {(_this select 0) spawn SQFB_fnc_updateUnit}];
				_x addEventHandler ["InventoryClosed", {(_this select 0) spawn SQFB_fnc_updateUnit}];
				_x addEventHandler ["InventoryOpened", {(_this select 0) spawn SQFB_fnc_updateUnit}];
				_x addEventHandler ["Killed", {(_this select 0) spawn SQFB_fnc_updateUnit}];
				_x addEventHandler ["Deleted", {SQFB_units = SQFB_units - [_this select 0]}];
                // Add unit to global array
                SQFB_units pushBackUnique _x;
			};
		};
	};
};
// Update all
[] call SQFB_fnc_updateAllUnits;
