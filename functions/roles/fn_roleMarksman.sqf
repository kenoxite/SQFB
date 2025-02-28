params ["_primWepDes", "_primWepType", "_primWep", "_unitIsVanilla"];

if ("sniper" in _primWepDes && _primWepType == "SniperRifle") exitWith {false};
if ("dms" in _primWep || "mxm" in _primWep || "srifle" in _primWep || "mark" in _primWep) exitWith {true};
if (_unitIsVanilla) exitWith {false};
"sr25" in _primWep || "m76" in _primWep || "svd" in _primWep || "scope" in _primWep || "_leupoldmk4mrt" in _primWep || "pso" in _primWep || "marksman" in _primWep || "khs" in _primWep
