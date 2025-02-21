params ["_marksman", "_primWepType", "_SOGunit"];

if (_marksman) exitWith {false};
if (_primWepType != "SniperRifle") exitWith {false};
if (_SOGunit) exitWith {false};
true
