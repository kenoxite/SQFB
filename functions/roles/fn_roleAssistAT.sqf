params ["_backpackStr", "_unitIsVanilla"];

if ("aat" in _backpackStr || "ahat" in _backpackStr) exitWith {true};

if (_unitIsVanilla) exitWith {false};

if ("_at" in _backpackStr || 
"_rpg" in _backpackStr || 
"_hat" in _backpackStr || 
"_hj12" in _backpackStr || 
"_m47" in _backpackStr || 
"_m67" in _backpackStr || 
"_smaw" in _backpackStr || 
"_at4" in _backpackStr) exitWith {true};

false
