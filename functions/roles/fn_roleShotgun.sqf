params ["_primWepType", "_handgunWep"];

if (_primWepType == "Handgun") exitWith {true};
_primWepType == "" && _handgunWep != ""
