/*
  Author: kenoxite

  Description:
  Draws the enemies and friendlies HUD


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

private _SQFB_known = +SQFB_knownEnemies;
private _SQFB_enemyTagObjArr = +SQFB_enemyTagObjArr;
private _SQFB_opt_colorEnemy = SQFB_opt_colorEnemy;
private _SQFB_opt_colorEnemyTarget = SQFB_opt_colorEnemyTarget;
private _SQFB_opt_showEnemiesMinRange = SQFB_opt_showEnemiesMinRange;
private _SQFB_opt_showEnemiesMinRangeAir = SQFB_opt_showEnemiesMinRangeAir;
private _SQFB_opt_showEnemiesMaxRange = SQFB_opt_showEnemiesMaxRange;
private _SQFB_opt_showEnemiesMaxRangeAir = SQFB_opt_showEnemiesMaxRangeAir;
private _SQFB_opt_showDistEnemy = SQFB_opt_showDistEnemy;
private _SQFB_opt_enemyPreciseVisCheck = SQFB_opt_enemyPreciseVisCheck;
private _SQFB_opt_checkVisibilityEnemies = SQFB_opt_checkVisibilityEnemies;
private _SQFB_opt_lastKnownEnemyPositionOnly = SQFB_opt_lastKnownEnemyPositionOnly;
private _SQFB_opt_changeIconsToBlufor = SQFB_opt_changeIconsToBlufor;
private _SQFB_opt_enemySideColors = SQFB_opt_enemySideColors;
private _SQFB_opt_colorEnemyWest = SQFB_opt_colorEnemyWest;
private _SQFB_opt_colorEnemyGuer = SQFB_opt_colorEnemyGuer;
private _SQFB_opt_colorEnemyCiv = SQFB_opt_colorEnemyCiv;

private _SQFB_knownFriendlies = +SQFB_knownFriendlies;
private _SQFB_friendlyTagObjArr = +SQFB_friendlyTagObjArr;
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

private _SQFB_opt_alternateOcclusionCheck = SQFB_opt_alternateOcclusionCheck;

_SQFB_known append _SQFB_knownFriendlies;

for "_i" from 0 to (count _SQFB_known) -1 do
{
    if ((typeName (_SQFB_known select _i))!="STRING") then {
        private _unit = _SQFB_known select _i;
        // Skip if dead
        if !(alive _unit) then { continue };

        private _side = _unit call SQFB_fnc_factionSide;
        private _isEnemy = [false, true] select ((side _unit getFriend side SQFB_player) < 0.6);
        private _unitData = _unit getVariable "SQFB_unitData";

        private ["_dataRealPos", "_dataDist", "_dataTagger", "_dataLastKnownPos", "_dataIconSize", "_dataTexture", "_dataText", "_dataTextSize", "_dataPosition", "_dataColor", "_dataIsVisible", "_dataTooClose", "_dataStance", "_dataZoom", "_dataCamDir"];
        private _noUnitData = [false, true] select (isNil "_unitData");
        if (!_noUnitData) then {
            _dataRealPos = _unitData select 0;
            _dataTagger = _unitData select 1;
            _dataLastKnownPos = _unitData select 2;
            _dataIconSize = _unitData select 3;
            _dataTexture = _unitData select 4;
            _dataText = _unitData select 5;
            _dataTextSize = _unitData select 6;
            _dataPosition = _unitData select 7;
            _dataColor = _unitData select 8;
            _dataIsVisible = _unitData select 9;
            _dataTooClose = _unitData select 10;
            _dataStance = _unitData select 11;
            _dataZoom = _unitData select 12;
            _dataCamDir = _unitData select 13;
        };
        private _veh = vehicle _unit;
        private _vehPlayer = vehicle SQFB_player;
        private _isPlayerAir = ((getPosASL _vehPlayer select 2) > 5 && !(isNull objectParent SQFB_player));

        // Skip units outside the max range
        private _dist = _vehPlayer distance _unit;
        private _maxRange = [
                                [_SQFB_opt_showFriendliesMaxRange, _SQFB_opt_showFriendliesMaxRangeAir] select _isPlayerAir,
                                [_SQFB_opt_showEnemiesMaxRange, _SQFB_opt_showEnemiesMaxRangeAir] select _isPlayerAir
                            ] select _isEnemy;
        if (_dist > _maxRange) then { continue };

        // Retrieve tagger object
        private _pos = getPosWorld _veh;
        private _sameUnitPos = [false, true] select (!_noUnitData && {(_dataRealPos distance _pos) <= 0});
        private _realPos = [_dataRealPos, _pos] select (_noUnitData || !_sameUnitPos);
        private _tagger = [_dataTagger, objNull] select _noUnitData;
        private _SQFB_taggerArr = [_SQFB_friendlyTagObjArr, _SQFB_enemyTagObjArr] select _isEnemy;
        if (_noUnitData) then {
            private _taggerIndex = [_SQFB_taggerArr, _unit] call BIS_fnc_findNestedElement;
            private _taggerArr = [];
            if (count _taggerIndex > 0) then {
                _taggerArr = _SQFB_taggerArr select (_taggerIndex select 0);
                _tagger = _taggerArr select 0;
                _tagger setPosWorld _realPos;
            };
        };

        // Skip calculations if positions of both unit and player haven't changed and player and unit still have the same key attributes since last check
        private _camDir = [0,0,0] getdir getCameraViewDirection SQFB_player;
        private _sameCamDir = [_dataCamDir == _camDir, false] select _noUnitData;
        private _sameUnitStance = [stance _unit == _dataStance, false] select _noUnitData;
        private _zoom = call SQFB_fnc_trueZoom;
        private _sameZoom = [_zoom == _dataZoom, false] select _noUnitData;
        private _isTarget = _unit == assignedTarget SQFB_player;

        private ["_iconSize", "_textSize", "_position", "_color", "_text", "_texture"];

        if ((_playerPos distance (SQFB_player getVariable "SQFB_pos")) <= 0 && _sameUnitPos && _sameUnitStance && _sameZoom && _sameCamDir && !_isTarget) then {
            // Skip if unit not in FOV of the player
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
            // Check unit occlusion
            private _SQFB_opt_checkVisibility = [_SQFB_opt_checkVisibilityFriendlies, _SQFB_opt_checkVisibilityEnemies] select _isEnemy;
            private _unitOccluded = [false, true] select _SQFB_opt_checkVisibility;
            if (_SQFB_opt_checkVisibility) then {
                private _SQFB_opt_preciseVisCheck = [_SQFB_opt_friendlyPreciseVisCheck, _SQFB_opt_enemyPreciseVisCheck] select _isEnemy;
                _unitOccluded = [_unit, SQFB_player, _isTarget, _SQFB_opt_preciseVisCheck, _isOnFoot, _SQFB_opt_alternateOcclusionCheck] call SQFB_fnc_checkOcclusion;
            };

            // Move unit tagger to last known position
            private _lastKnownPos = [_dataLastKnownPos, _realPos] select _noUnitData;
            if (!_unitOccluded) then {
                _tagger setPosWorld _lastKnownPos;
                _lastKnownPos = _realPos;
            };

            // Skip if only unkonwn positions should be shown
            if (!_unitOccluded && ((_SQFB_opt_lastKnownEnemyPositionOnly && _isEnemy) || (_SQFB_opt_lastKnownFriendlyPositionOnly && !_isEnemy))) then { continue };

            private _IFF = [
                                _unit,
                                [_unit, _tagger] select (!isNull _tagger)
                            ] select _unitOccluded;

            private _isRealPos = _IFF == _unit;
            private _perceivedPos = [_lastKnownPos, _realPos] select _isRealPos;

            // Skip if unit not in FOV of the player
            private _unitVisible = [ _playerPos, _camDir, ceil((call CBA_fnc_getFov select 0)*100), _perceivedPos] call BIS_fnc_inAngleSector;
            if (!_unitVisible) then { continue };

            // Skip if too close
            private _distPerceived = _playerPos distance2D _perceivedPos;
            private _minRange = [
                                    [_SQFB_opt_showFriendliesMinRange, _SQFB_opt_showFriendliesMinRangeAir] select _isPlayerAir,
                                    [_SQFB_opt_showEnemiesMinRange, _SQFB_opt_showEnemiesMinRangeAir] select _isPlayerAir
                                ] select _isEnemy;
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
            _iconSize = [
                            (_iconSize * _SQFB_opt_iconSize) max 0.01,
                            ((_iconSize * _SQFB_opt_iconSize) + 0.1) max 0.01
                        ] select _isTarget;
            _textSize = (_textSize * _SQFB_opt_textSize) max 0.02;

            private _colorUnit = [
                                    [
                                        _SQFB_opt_colorFriendly,
                                        call {
                                            if (_side == east) exitWith {_SQFB_opt_colorFriendlyEast};
                                            if (_side == resistance) exitWith {_SQFB_opt_colorFriendlyGuer};
                                            if (_side == civilian) exitWith {_SQFB_opt_colorFriendlyCiv};
                                        }
                                    ] select (_SQFB_opt_friendlySideColors != "never" && (_side == east || _side == resistance || _side == civilian)),
                                    
                                    [
                                        _SQFB_opt_colorEnemy,
                                        call {
                                            if (_side == west) exitWith {_SQFB_opt_colorEnemyWest};
                                            if (_side == resistance) exitWith {_SQFB_opt_colorEnemyGuer};
                                            if (_side == civilian) exitWith {_SQFB_opt_colorEnemyCiv};
                                        }
                                    ] select (_SQFB_opt_enemySideColors != "never" && (_side == west || _side == resistance || _side == civilian))
                                ] select _isEnemy;
            _color = [
                        [_colorUnit select 0,_colorUnit select 1,_colorUnit select 2, ([_IFF] call SQFB_fnc_HUDAlpha) max 0.7],
                        [_SQFB_opt_colorEnemyTarget select 0,_SQFB_opt_colorEnemyTarget select 1,_SQFB_opt_colorEnemyTarget select 2, ([_IFF] call SQFB_fnc_HUDAlpha) max 0.7]
                    ] select _isTarget;

            _text = [
                        "",
                        [
                            "",
                            format ["%1m", round _distPerceived]
                        ] select ((_SQFB_opt_showDistEnemy && _isEnemy) || (_SQFB_opt_showDistFriendly && !_isEnemy))
                    ] select (!_isPlayerAir && _SQFB_opt_showText && _textSize > 0.02);


            private _unitType = [typeOf _unit] call SQFB_fnc_classType;
            _texture = [
                            "a3\ui_f\data\map\markers\military\unknown_ca.paa", 
                            format ["a3\ui_f\data\map\markers\nato\%1_%2.paa", ["o","n"] select (_side == west && _SQFB_opt_changeIconsToBlufor), _unitType]
                        ] select _isRealPos;

            private _iconHeightMod = [
                                        [0.8, 0.5] select (_text == ""),
                                        [0.4, 0.2] select (_text == "")
                                    ] select _isOnFoot;
            private _selectionPos = [getPosVisual _IFF, _IFF selectionPosition ["head", "HitPoints"]] select _isRealPos;
            _position = [
                            [
                                _IFF modelToWorldVisual [
                                    _SQFB_opt_iconHorVeh,
                                    0,
                                    0
                                ],
                                _IFF modelToWorldVisual [
                                    _SQFB_opt_iconHorVeh,
                                    0,
                                    _iconHeightMod + _SQFB_opt_iconHeightVeh
                                    ]
                            ] select _isRealPos,

                            [
                                _IFF modelToWorldVisual [
                                    _SQFB_opt_iconHor,
                                    0,
                                    [
                                        0.5,
                                        1.5
                                    ] select _SQFB_opt_alternateOcclusionCheck
                                ],
                                _IFF modelToWorldVisual [
                                    (_selectionPos select 0) + _SQFB_opt_iconHor,
                                    _selectionPos select 1,
                                    (_selectionPos select 2) + _iconHeightMod + _SQFB_opt_iconHeight
                                ]
                            ] select _isRealPos
                        ] select _isOnFoot;

            if (_isRealPos) then { _position set [2, (_position select 2) + ((_dist * 0.01) min 1.5)] }; // Hack to keep the icons more or less at the same height no matter the distance
                        
            // Create ememy vars
            _unit setVariable ["SQFB_unitData", [_realPos, _tagger, _lastKnownPos, _iconSize, _texture, _text, _textSize, _position, _color, _unitVisible, _tooClose, stance _unit, _zoom, _camDir]]; 
        };

        if (_text != "" || _texture != "") then {
            drawIcon3D 
            [
                _texture,
                _color,
                _position,
                _iconSize,
                _iconSize,
                0, // angle
                _text,
                false, // (shadow, optional)
                _textSize, // (optional)
                _SQFB_opt_textFont, // (font, optional)
                "center", // (_text align, optional)
                false // (arrows, optional)
            ]; 
        };
    };
};