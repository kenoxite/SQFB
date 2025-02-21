params ["_AA", "_secWepType"];

if (_AA) exitWith {false};
_secWepType in ["Launcher", "MissileLauncher", "RocketLauncher"]
