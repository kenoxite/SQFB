params ["_backpackStr"];

if ("_mg" in _backpackStr || 
"_amg" in _backpackStr || 
"_m60" in _backpackStr || 
"_pk" in _backpackStr || 
"_ammomg" in _backpackStr) exitWith {true};

false
