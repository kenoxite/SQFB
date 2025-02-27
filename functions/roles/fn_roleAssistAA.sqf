params ["_backpackStr", "_unitIsVanilla"];

if ("aaa" in _backpackStr) exitWith {true};

if (_unitIsVanilla) exitWith {false};

if ("_aa" in _backpackStr || 
"_redeye" in _backpackStr || 
"_stinger" in _backpackStr || 
"_igla" in _backpackStr || 
"_strela" in _backpackStr) exitWith {true};

false
