params ["_backpackStr", "_AA", "_anyAmmoBearer", "_unitIsVanilla"];

if (_backpackStr == "") exitWith {false};
if (_AA) exitWith {false};
if (_anyAmmoBearer) exitWith {false};

if ("aaa" in _backpackStr) exitWith {true};

if (_unitIsVanilla) exitWith {false};

"_aa" in _backpackStr || 
"_redeye" in _backpackStr || 
"_stinger" in _backpackStr || 
"_igla" in _backpackStr || 
"_strela" in _backpackStr
