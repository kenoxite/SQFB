params ["_isEngi", "_items"];

if (!_isEngi) exitWith {false};
"ToolKit" in _items || {"vn_b_item_toolkit" in _items || {"CSLA_toolkit" in _items || "US85_toolkit_B" in _items || "CSLA_toolkit_KOMZE" in _items || "US85_toolkit_S" in _items}}
