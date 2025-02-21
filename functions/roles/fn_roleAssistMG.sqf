params ["_backpackStr", "_MG", "_anyAmmoBearer", "_unitIsVanilla"];

if (_backpackStr == "") exitWith {false};
if (_MG) exitWith {false};
if (_anyAmmoBearer) exitWith {false};
if (_unitIsVanilla) exitWith {false};

"_mg" in _backpackStr || 
"_amg" in _backpackStr || 
"_m60" in _backpackStr || 
"_pk" in _backpackStr || 
"_ammomg" in _backpackStr
