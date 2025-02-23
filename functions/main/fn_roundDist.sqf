// Round distance to the closest passed increment

params ["_distance", ["_increment", 50, [0]]];

_increment = _increment max 1;
_distance = _distance max 50;

ceil(_distance / _increment) * _increment
