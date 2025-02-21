params ["_hasRG", "_primSecMuzzle", "_primWep", "_handgunWep"];

if (_hasRG) exitWith {true};

if (_primSecMuzzle == "") exitWith {
    "m79" in _primWep || "gl" in _primWep
};

if (_primSecMuzzle != "") exitWith {
    "gl" in _primSecMuzzle || 
    "gp" in _primSecMuzzle || 
    "pallad" in _primSecMuzzle || 
    "m79" in _primSecMuzzle
};

if (_handgunWep != "") exitWith {
    "gl" in _handgunWep
};

false
