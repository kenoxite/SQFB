params ["_backpackStr", "_AT", "_anyAmmoBearer", "_unitIsVanilla"];

if (_backpackStr == "") exitWith {false};
if (_AT) exitWith {false};
if (_anyAmmoBearer) exitWith {false};

if ("aat" in _backpackStr || "ahat" in _backpackStr) exitWith {true};

if (_unitIsVanilla) exitWith {false};

"_at" in _backpackStr || 
"_rpg" in _backpackStr || 
"_hat" in _backpackStr || 
"_hj12" in _backpackStr || 
"_m47" in _backpackStr || 
"_m67" in _backpackStr || 
"_smaw" in _backpackStr || 
"_at4" in _backpackStr
