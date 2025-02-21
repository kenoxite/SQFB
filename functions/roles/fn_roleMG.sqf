params ["_LMG", "_primWepType", "_primWep", "_unitIsVanilla"];

if (_LMG) exitWith {false};
if (_primWepType == "MachineGun") exitWith {true};
if (_unitIsVanilla) exitWith {false};
"mg" in _primWep
