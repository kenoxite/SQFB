params ["_hasMines", "_isDemo", "_items"];

if (_hasMines) exitWith {true};
if (!_isDemo) exitWith {false};
"MineDetector" in _items || "ToolKit" in _items || {"vn_b_item_trapkit" in _items || "vn_b_item_toolkit" in _items || {"CSLA_toolkit" in _items || "US85_toolkit_B" in _items || "CSLA_toolkit_KOMZE" in _items || "US85_toolkit_S" in _items}}
