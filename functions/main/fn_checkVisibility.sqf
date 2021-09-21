/*
  Author: kenoxite

  Description:
  Realizes visibility checks for the passed observed and observer, which can be coordinates or objects.
  If precise check is passed and observed is an object then all the corners of the bounding box of the object will be checked and the median of all checks will be returned.


  Parameter (s):
  _this select 0: observer
  _this select 1: observed
  _this select 2: precise
 

  Returns:


  Examples:

*/

params ["_observer", "_observed", "_precise"];

private _isObject = typeName _observed == "OBJECT";
private _observerPos = [_observer, eyepos _observer] select _isObject;
private _vis = 0;

private _bboxCoords = [];
if (_isObject) then {
    if (_precise) then {
        private _bbr = boundingBox _observed;
        // private _bbr = boundingBoxReal _observed;
        // private _bbr = 0 boundingBoxReal _observed;
        // [
        //     [-3.53909,-6.02507,-2.62616], // [xmin, ymin, zmin]
        //     [3.53909,6.02507,2.62616], // [xmax, ymax, zmax]
        //     9.76007 // boundingSphereDiameter
        // ] 
        private _p1 = _bbr select 0;
        private _p2 = _bbr select 1;

        private _x1 = _p1 select 0;
        private _y1 = _p1 select 1;
        private _z1 = _p1 select 2;
        private _x2 = _p2 select 0;
        private _y2 = _p2 select 1;
        private _z2 = _p2 select 2;

        private _dx = _x2 - _x1;
        private _dy = _y2 - _y1;
        private _dz = _z2 - _z1;

        private _adj = 0.75;
        private _topLeftFront = _observed modelToWorldVisualWorld [_x1 * _adj, 0, 0];
        private _topRightFront = _observed modelToWorldVisualWorld [_x1 + _dx * _adj, 0, 0];
        private _bottomLeftFront = _observed modelToWorldVisualWorld [_x1 * _adj, _y1 + _dy * _adj, 0];
        private _bottomRightFront = _observed modelToWorldVisualWorld [_x1 + _dx * _adj, _y1 + _dy * _adj, 0];
        private _topLeftBack = _observed modelToWorldVisualWorld [_x1 * _adj, 0, _z1 + _dz * _adj];
        private _topRightBack = _observed modelToWorldVisualWorld [_x1 + _dx, 0, _z1 + _dz * _adj];
        private _bottomLeftBack = _observed modelToWorldVisualWorld [_x1 * _adj, _y1 + _dy * _adj, _z1 + _dz * _adj];
        private _bottomRightBack = _observed modelToWorldVisualWorld [_x1 + _dx * _adj, _y1 + _dy * _adj, _z1 + _dz * _adj];

        _bbrCoords = [_topLeftFront, _topRightFront, _bottomLeftFront, _bottomRightFront, _topLeftBack, _topRightBack, _topRightBack, _bottomRightBack];
        // {
        //     diag_log format ["SQFB: checkVisibility - _bbrCoords: %1: %2", _forEachIndex, _x];
        // } forEach _bbrCoords;

        private _visArr = [];
        {
            private _visCheck = [objNull, "VIEW"] checkVisibility [_observerPos, _bbrCoords select _forEachIndex];
            _visArr pushBack _visCheck;
        } forEach _bbrCoords;
        _vis = _visArr call BIS_fnc_arithmeticMean;
        // diag_log format ["SQFB: checkVisibility - _vis: %1, objPos: %2, _visArr: %3", _vis, getPosASL _observed, _visArr];

    } else {
        _vis = [
                [objNull, "VIEW"] checkVisibility [_observerPos, AtlToAsl (_unit modeltoworld [0,0,0])],
                [objNull, "VIEW"] checkVisibility [_observerPos, eyepos _observed]
                ] select (_observed isKindOf "Man");
    };
} else {
    _vis = [objNull, "VIEW"] checkVisibility [_observerPos, _observed]
};

_vis