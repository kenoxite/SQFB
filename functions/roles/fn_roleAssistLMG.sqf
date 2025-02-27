params ["_backpackStr", "_unitIsVanilla"];

if ("aar" in _backpackStr) exitWith {true};

if (_unitIsVanilla) exitWith {false};

if ("_autorfle" in _backpackStr || 
"_ar" in _backpackStr || 
"_m16_lsw" in _backpackStr || 
"_m249" in _backpackStr || 
"_rpk" in _backpackStr || 
"ammosaw" in _backpackStr) exitWith {true};

false
