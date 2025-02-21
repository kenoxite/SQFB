params ["_backpackStr", "_anyAmmoBearer", "_LMG", "_MG", "_AT", "_AA"];

if (_backpackStr == "") exitWith {false};
if (_anyAmmoBearer) exitWith {false};
if (_LMG) exitWith {false};
if (_MG) exitWith {false};
if (_AT) exitWith {false};
if (_AA) exitWith {false};
"ammo" in _backpackStr
