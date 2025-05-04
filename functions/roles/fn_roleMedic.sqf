params ["_isMedic", "_items"];

if (!_isMedic) exitWith {false};
if ("Medikit" in _items) exitWith {true};
if ("vn_b_item_medikit_01" in _items) exitWith {true};
if ("gm_ge_army_medkit_80" in _items) exitWith {true};
if ("gm_gc_army_medbox" in _items) exitWith {true};
if ("US85_MediKit" in _items) exitWith {true};
if ("CSLA_MediKit_Z80" in _items) exitWith {true};
false
