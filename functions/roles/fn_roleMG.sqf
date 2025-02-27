params ["_primWepDes", "_primWepType", "_primWep", "_unitIsVanilla"];

if ("light machine gun" in _primWepDes) exitWith {false};
if (_primWepType == "MachineGun") exitWith {true};
if (_unitIsVanilla) exitWith {false};
if ("machine gun" in _primWepDes) exitWith {true};
if ("mg" in _primWep) exitWith {true};

false
