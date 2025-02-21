params ["_primWepType", "_primWepDes", "_primWep"];

if (_primWepType == "SubmachineGun") exitWith {true};
if ("submachine" in _primWepDes) exitWith {true};
if ("smg" in _primWepDes) exitWith {true};
if ("smg" in _primWep) exitWith {true};
false
