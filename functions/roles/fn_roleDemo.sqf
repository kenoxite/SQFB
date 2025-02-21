params ["_hasMines", "_isDemo", "_items"];

if (_hasMines) exitWith {true};
if (!_isDemo) exitWith {false};
"MineDetector" in _items || "Toolkit" in _items || {"vn_b_item_trapkit" in _items || "vn_b_item_toolkit" in _items}
