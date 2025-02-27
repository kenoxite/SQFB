params ["_primWepDes", "_primWep", "_unitIsVanilla", "_primMagRounds"];

if ("light machine gun" in _primWepDes) exitWith {true};
if ("rpk" in _primWep) exitWith {true};
if (_unitIsVanilla) exitWith {false};
if ("m27" in _primWep || "pkp" in _primWep || "m249" in _primWep) exitWith {true};
if (!("machine gun" in _primWepDes) && _primMagRounds > 30) exitWith {true};

false
