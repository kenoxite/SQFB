params ["_backpackStr", "_LMG", "_anyAmmoBearer", "_unitIsVanilla"];

if (_backpackStr == "") exitWith {false};
if (_LMG) exitWith {false};
if (_anyAmmoBearer) exitWith {false};

if ("aar" in _backpackStr) exitWith {true};

if (_unitIsVanilla) exitWith {false};

"_autorfle" in _backpackStr || 
"_ar" in _backpackStr || 
"_m16_lsw" in _backpackStr || 
"_m249" in _backpackStr || 
"_rpk" in _backpackStr || 
"ammosaw" in _backpackStr
