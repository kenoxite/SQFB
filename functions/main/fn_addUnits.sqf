/*
  Author: kenoxite

  Description:
  Initialize the units and add them to the global array


  Parameter (s):
  _this select 0: _grp
 

  Returns:


  Examples:

*/

params [["_units", []]];
if (count _units == 0) exitWith { false };

// Add units to array and assign EH
for "_i" from 0 to (count _units) -1 do
{
    private _x = _units select _i;
    if !(_x isEqualType "") then {
		if !(_x in SQFB_unitsWithEH) then {
			// Add EH
			_x addEventHandler ["Take", {(_this select 0) spawn SQFB_fnc_updateUnit; if ((_this select 0) == SQFB_player) then { call SQFB_fnc_IFFactivateDevice; call SQFB_fnc_HUDupdate };}];
			_x addEventHandler ["Put", {(_this select 0) spawn SQFB_fnc_updateUnit}];
			_x addEventHandler ["InventoryClosed", {(_this select 0) spawn SQFB_fnc_updateUnit; if ((_this select 0) == SQFB_player) then { call SQFB_fnc_IFFactivateDevice; call SQFB_fnc_HUDupdate }; }];
			_x addEventHandler ["InventoryOpened", {(_this select 0) spawn SQFB_fnc_updateUnit}];
			_x addEventHandler ["Killed", {(_this select 0) spawn SQFB_fnc_updateUnit; SQFB_deadUnits pushBack (_this select 0)}];
			_x addEventHandler ["Deleted", {SQFB_units = SQFB_units - [_this select 0]; SQFB_unitsWithEH = SQFB_unitsWithEH - [_this select 0]; SQFB_deadUnits = SQFB_deadUnits - [_this select 0];}];

            // Add unit to global array for EH tracking
            SQFB_unitsWithEH pushBackUnique _x;
		};
	};
};
