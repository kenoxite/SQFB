params ["_isEngi", "_items"];

if (!_isEngi) exitWith {false};
"ToolKit" in _items || {"vn_b_item_toolkit" in _items}
