/*
  Author: kenoxite

  Description:
  Draws the friendlies HUD


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

params ["_playerPos"];

private _SQFB_opt_scaleText = SQFB_opt_scaleText;
private _SQFB_opt_textSize = SQFB_opt_textSize;
private _SQFB_opt_iconSize = SQFB_opt_iconSize;
private _SQFB_opt_iconHor = SQFB_opt_iconHor;
private _SQFB_opt_iconHeight = SQFB_opt_iconHeight;
private _SQFB_opt_textFont = SQFB_opt_textFont;
private _SQFB_opt_Arrows = SQFB_opt_Arrows;
private _SQFB_opt_iconHorVeh = SQFB_opt_iconHorVeh;
private _SQFB_opt_iconHeightVeh = SQFB_opt_iconHeightVeh;
private _SQFB_opt_showIcon = SQFB_opt_showIcon;
private _SQFB_opt_showText = SQFB_opt_showText;
private _SQFB_opt_showIndex = SQFB_opt_showIndex;
private _SQFB_opt_scaleText = SQFB_opt_scaleText;

private _SQFB_knownFriendlies = SQFB_knownFriendlies;
private _SQFB_friendlyTagObjArr = SQFB_friendlyTagObjArr;
private _SQFB_opt_colorFriendly = SQFB_opt_colorFriendly;
private _SQFB_opt_showFriendliesMinRange = SQFB_opt_showFriendliesMinRange;
private _SQFB_opt_showFriendliesMinRangeAir = SQFB_opt_showFriendliesMinRangeAir;
private _SQFB_opt_showFriendliesMaxRange = SQFB_opt_showFriendliesMaxRange;
private _SQFB_opt_showFriendliesMaxRangeAir = SQFB_opt_showFriendliesMaxRangeAir;
private _SQFB_opt_showDistFriendly = SQFB_opt_showDistFriendly;
private _SQFB_opt_friendlyPreciseVisCheck = SQFB_opt_friendlyPreciseVisCheck;
private _SQFB_opt_checkVisibilityFriendlies = SQFB_opt_checkVisibilityFriendlies;
private _SQFB_opt_lastKnownFriendlyPositionOnly = SQFB_opt_lastKnownFriendlyPositionOnly;
private _SQFB_opt_friendlySideColors = SQFB_opt_friendlySideColors;
private _SQFB_opt_colorFriendlyEast = SQFB_opt_colorFriendlyEast;
private _SQFB_opt_colorFriendlyGuer = SQFB_opt_colorFriendlyGuer;
private _SQFB_opt_colorFriendlyCiv = SQFB_opt_colorFriendlyCiv;
private _SQFB_opt_HUDrefresh = SQFB_opt_HUDrefresh;
private _SQFB_opt_alternateOcclusionCheck = SQFB_opt_alternateOcclusionCheck;
for "_i" from 0 to (count _SQFB_knownFriendlies) -1 do
{
    if ((typeName (_SQFB_knownFriendlies select _i))!="STRING") then {
        private _unit = _SQFB_knownFriendlies select _i;
        private _side = _unit call SQFB_fnc_factionSide;
        private _friendlyData = _unit getVariable "SQFB_friendlyData";

        private ["_dataRealPos", "_dataDist", "_dataFriendlyTagger", "_dataLastKnownPos", "_dataIconSize", "_dataTexture", "_dataText", "_dataTextSize", "_dataPosition", "_dataColor", "_dataIsVisible", "_dataTooClose", "_dataStance", "_dataZoom", "_dataCamDir"];
        private _noFriendlyData = [false, true] select (isNil "_friendlyData");
        if (!_noFriendlyData) then {
            _dataRealPos = _friendlyData select 0;
            _dataFriendlyTagger = _friendlyData select 1;
            _dataLastKnownPos = _friendlyData select 2;
            _dataIconSize = _friendlyData select 3;
            _dataTexture = _friendlyData select 4;
            _dataText = _friendlyData select 5;
            _dataTextSize = _friendlyData select 6;
            _dataPosition = _friendlyData select 7;
            _dataColor = _friendlyData select 8;
            _dataIsVisible = _friendlyData select 9;
            _dataTooClose = _friendlyData select 10;
            _dataStance = _friendlyData select 11;
            _dataZoom = _friendlyData select 12;
            _dataCamDir = _friendlyData select 13;
        };
        private _veh = vehicle _unit;
        private _vehPlayer = vehicle SQFB_player;
        private _isPlayerAir = ((getPosASL _vehPlayer select 2) > 5 && !(isNull objectParent SQFB_player));

        // Skip units outside the max range
        private _dist = _vehPlayer distance _unit;
        private _maxRange = [_SQFB_opt_showFriendliesMaxRange, _SQFB_opt_showFriendliesMaxRangeAir] select _isPlayerAir;
        if (_dist > _maxRange) then { continue };

        // Retrieve tagger object
        private _pos = [
                            getPosWorld _veh,
                            AtlToAsl (SQFB_player getHideFrom _unit)
                        ] select _SQFB_opt_alternateOcclusionCheck;
        private _sameFriendlyPos = [false, true] select (!_noFriendlyData && {(_dataRealPos distance _pos) <= 0});
        private _realPos = [_dataRealPos, _pos] select (_noFriendlyData || !_sameFriendlyPos);
        private _friendlyTagger = [_dataFriendlyTagger, objNull] select _noFriendlyData;
        if (_noFriendlyData) then {
            private _friendlyTaggerIndex = [_SQFB_friendlyTagObjArr, _unit] call BIS_fnc_findNestedElement;
            private _friendlyTaggerArr = [];
            if (count _friendlyTaggerIndex > 0) then {
                _friendlyTaggerArr = _SQFB_friendlyTagObjArr select (_friendlyTaggerIndex select 0);
                _friendlyTagger = _friendlyTaggerArr select 0;
                _friendlyTagger setPosWorld _realPos;
            };
        };

        // Skip calculations if positions of both friendly and player haven't changed and player and friendly still have the same key attributes since last check
        private _camDir = [0,0,0] getdir getCameraViewDirection SQFB_player;
        private _sameCamDir = [_dataCamDir == _camDir, false] select _noFriendlyData;
        private _sameFriendlyStance = [stance _unit == _dataStance, false] select _noFriendlyData;
        private _zoom = call SQFB_fnc_trueZoom;
        private _sameZoom = [_zoom == _dataZoom, false] select _noFriendlyData;
        private ["_iconSize", "_textSize", "_position", "_color", "_text", "_texture"];
        if ((_playerPos distance (player getVariable "SQFB_pos")) <= 0 && _sameFriendlyPos && _sameFriendlyStance && _sameZoom && _sameCamDir) then {
            // Skip if friendly not in FOV of the player
            if (!_dataIsVisible) then { continue };

            // Skip if too close
            if (_dataTooClose) then { continue };

            _iconSize = _dataIconSize;
            _textSize = _dataTextSize;
            _position = _dataPosition;
            _color = _dataColor;
            _text = _dataText;
            _texture = _dataTexture;
        } else {
            private _isOnFoot = (typeOf _veh isKindOf "Man");
            // Check friendly occlusion
            private _friendlyOccluded = [false, true] select _SQFB_opt_checkVisibilityFriendlies;
            if (_SQFB_opt_checkVisibilityFriendlies) then {
                if ((_isOnFoot || !_SQFB_opt_friendlyPreciseVisCheck) && _SQFB_opt_alternateOcclusionCheck) then {
                    private _targetKnowledge = SQFB_player targetKnowledge _unit;
                   _friendlyOccluded = (time - (_targetKnowledge select 2)) > (_SQFB_opt_HUDrefresh + 0.1);
                } else {
                    private _preciseVisCheck = call {
                                    if (_isOnFoot || !_SQFB_opt_friendlyPreciseVisCheck) exitWith {false};
                                    if (!_isOnFoot && _SQFB_opt_friendlyPreciseVisCheck) exitWith {true};
                                };
                    private _unitVisibility = [_unit, SQFB_player, _preciseVisCheck] call SQFB_fnc_checkVisibility;
                    private _visThreshold = [0.2, 0.1] select _isPlayerAir;
                    _friendlyOccluded = _unitVisibility < _visThreshold;
                };
            };

            // Move friendly tagger to last known position
            private _lastKnownPos = [_dataLastKnownPos, _realPos] select _noFriendlyData;
            if (!_friendlyOccluded) then {
                _friendlyTagger setPosWorld _lastKnownPos;
                _lastKnownPos = _realPos;
            };
            private _friendly = [
                                _unit,
                                [_unit, _friendlyTagger] select (!isNull _friendlyTagger)
                            ] select _friendlyOccluded;
            diag_log format ["_friendly: %1, _unit: %2", _friendly, _unit];

            private _isRealPos = _friendly == _unit;
            private _perceivedPos = [_lastKnownPos, _realPos] select _isRealPos;

            // Skip if friendly not in FOV of the player
            private _friendlyVisible = [ _playerPos, _camDir, ceil((call CBA_fnc_getFov select 0)*100), _perceivedPos] call BIS_fnc_inAngleSector;
            if (!_friendlyVisible) then { continue };

            // Skip if too close
            private _distPerceived = _playerPos distance2D _perceivedPos;
            private _minRange = [_SQFB_opt_showFriendliesMinRange, _SQFB_opt_showFriendliesMinRangeAir] select _isPlayerAir;
            private _tooClose = _minRange > 0 && {_distPerceived <= _minRange};
            if (_tooClose) then { continue };

            // Adjust sizes to distance
            private _adjSize = 2; // TBH no idea why this is needed, but it's needed

            _iconSize = [
                            [
                                ((linearConversion[ 0, _maxRange min 100, _distPerceived, (1 * _adjSize) * _zoom, 0.5, true ])) min 1,
                                ((linearConversion[ 0, _maxRange min 100, _distPerceived, (0.6 * _adjSize) * _zoom, 0.3, true ])) min 0.6
                            ] select _isOnFoot,

                            [
                                ((linearConversion[ 0, _maxRange min 100, _distPerceived, (1 * _adjSize) * _zoom, 0.5, true ])) min 1,
                                ((linearConversion[ 0, _maxRange min 100, _distPerceived, (1 * _adjSize) * _zoom, 0.5, true ])) min 1
                            ] select _isOnFoot
                        ] select _isPlayerAir;

            _textSize = [
                            ((linearConversion[ 0, _maxRange min 200, _distPerceived, (0.04 * _adjSize) * _zoom, 0.03, true ])) min 0.04,
                            ((linearConversion[ 0, _maxRange min 200, _distPerceived, (0.04 * _adjSize) * _zoom, 0.03, true ])) min 0.04
                        ] select _isPlayerAir;
            _iconSize = (_iconSize * _SQFB_opt_iconSize) max 0.01;
            _textSize = (_textSize * _SQFB_opt_textSize) max 0.02;

            private _colorFriendly = [
                                        _SQFB_opt_colorFriendly,
                                        call {
                                            if (_side == east) exitWith {_SQFB_opt_colorFriendlyEast};
                                            if (_side == resistance) exitWith {_SQFB_opt_colorFriendlyGuer};
                                            if (_side == civilian) exitWith {_SQFB_opt_colorFriendlyCiv};
                                        }
                                    ] select (_SQFB_opt_friendlySideColors != "never" && (_side == east || _side == resistance || (alive _unit && _side == civilian)));
            _color = [_colorFriendly select 0,_colorFriendly select 1,_colorFriendly select 2, ([_friendly] call SQFB_fnc_HUDAlpha) max 0.7];

            _text = [
                        "",
                        [
                            "",
                            format ["%1m", round _distPerceived]
                        ] select (_SQFB_opt_showDistFriendly
                            && (!_SQFB_opt_lastKnownFriendlyPositionOnly
                                || (_SQFB_opt_lastKnownFriendlyPositionOnly && !_isRealPos)
                                )
                            )
                    ] select (!_isPlayerAir && _SQFB_opt_showText && _textSize > 0.02);


            private _friendlyType = [typeOf _unit] call SQFB_fnc_classType;
            _texture = [
                            "a3\ui_f\data\map\markers\military\unknown_ca.paa", 
                            [   
                                format ["a3\ui_f\data\map\markers\nato\%1_%2.paa", ["o","n"] select (_side == west), _friendlyType],
                                ""
                            ] select _SQFB_opt_lastKnownFriendlyPositionOnly
                        ] select _isRealPos;

            private _iconHeightMod = [
                                        [0.8, 0.5] select (_text == ""),
                                        [0.4, 0.2] select (_text == "")
                                    ] select _isOnFoot;
            private _selectionPos = [getPosVisual _friendly, _friendly selectionPosition ["head", "HitPoints"]] select _isRealPos;
            _position = [
                            [
                                _friendly modelToWorldVisual [
                                    _SQFB_opt_iconHorVeh,
                                    0,
                                    0
                                ],
                                _friendly modelToWorldVisual [
                                    _SQFB_opt_iconHorVeh,
                                    0,
                                    _iconHeightMod + _SQFB_opt_iconHeightVeh
                                    ]
                            ] select _isRealPos,

                            [
                                _friendly modelToWorldVisual [
                                    _SQFB_opt_iconHor,
                                    0,
                                    [
                                        0.5,
                                        1.5
                                    ] select _SQFB_opt_alternateOcclusionCheck
                                ],
                                _friendly modelToWorldVisual [
                                    (_selectionPos select 0) + _SQFB_opt_iconHor,
                                    _selectionPos select 1,
                                    (_selectionPos select 2) + _iconHeightMod + _SQFB_opt_iconHeight
                                ]
                            ] select _isRealPos
                        ] select _isOnFoot;

            if (_isRealPos) then { _position set [2, (_position select 2) + ((_dist * 0.01) min 1.5)] }; // Hack to keep the icons more or less at the same height no matter the distance
                        
            // Create friendly vars
            _unit setVariable ["SQFB_friendlyData", [_realPos, _friendlyTagger, _lastKnownPos, _iconSize, _texture, _text, _textSize, _position, _color, _friendlyVisible, _tooClose, stance _unit, _zoom, _camDir]]; 
        };

        private _angle = 0;
        private _shadow = false;
        private _font = _SQFB_opt_textFont;
        private _textAlign = "center";
        private _arrows = false;

        if (_text != "" || _texture != "") then {
            drawIcon3D 
            [
                _texture,
                _color,
                _position,
                _iconSize,
                _iconSize,
                _angle,
                _text,
                _shadow, // (optional)
                _textSize, // (optional)
                _font, // (optional)
                _textAlign, // (optional)
                _arrows // (optional)
            ]; 
        };
    };
};
