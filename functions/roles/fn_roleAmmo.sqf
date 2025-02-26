params ["_backpackStr", "_anyAmmoBearer"];

if (_backpackStr == "") exitWith {false};
if (_anyAmmoBearer) exitWith {false};
"ammo" in _backpackStr
