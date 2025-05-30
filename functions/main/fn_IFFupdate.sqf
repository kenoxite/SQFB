/*
  Author: kenoxite

  Description:
  Updates the information of the IFF units


  Parameter (s):


  Returns:


  Examples:

*/

params ["_playerPos"];

#define ADJSIZE 2

private _playerOnFoot = isNull objectParent SQFB_player;
private _vehPlayer = vehicle SQFB_player;
private _isPlayerAir = !_playerOnFoot && {(getPosATL _vehPlayer select 2) > 5};

private _allTurrets = allTurrets [_vehPlayer, false];
private _camDir = -1;
if (count _allTurrets == 0 || {_vehPlayer turretUnit [0] != SQFB_player}) then {
    _camDir = [0,0,0] getdir getCameraViewDirection _vehPlayer;
} else {
    private _weaponDir = _vehPlayer weaponDirection (currentWeapon _vehPlayer);
    private _turretDir = (_weaponDir select 0) atan2 (_weaponDir select 1);
    _camDir = [
                    _turretDir,
                    360 + _turretDir
                ] select (_turretDir < 0);
};

private _SQFB_opt_textSize = SQFB_opt_textSize;
private _SQFB_opt_iconSize = SQFB_opt_iconSize;
private _SQFB_opt_iconHor = SQFB_opt_iconHor;
private _SQFB_opt_iconHeight = SQFB_opt_iconHeight;
private _SQFB_opt_textFont = SQFB_opt_textFont;
private _SQFB_opt_iconHorVeh = SQFB_opt_iconHorVeh;
private _SQFB_opt_iconHeightVeh = SQFB_opt_iconHeightVeh;
private _SQFB_opt_showText = SQFB_opt_showText;
private _SQFB_opt_maxAlpha = SQFB_opt_maxAlpha;

private _SQFB_opt_colorEnemy = SQFB_opt_colorEnemy;
private _SQFB_opt_colorEnemyTarget = SQFB_opt_colorEnemyTarget;
private _SQFB_opt_showEnemiesMinRange = SQFB_opt_showEnemiesMinRange;
private _SQFB_opt_showEnemiesMinRangeAir = SQFB_opt_showEnemiesMinRangeAir;
private _SQFB_opt_showEnemiesMaxRange = SQFB_opt_showEnemiesMaxRange;
private _SQFB_opt_showEnemiesMaxRangeAir = SQFB_opt_showEnemiesMaxRangeAir;
private _SQFB_opt_showDistEnemy = SQFB_opt_showDistEnemy;
private _SQFB_opt_enemyPreciseVisCheck = SQFB_opt_enemyPreciseVisCheck;
private _SQFB_opt_checkOcclusionEnemies = SQFB_opt_checkOcclusionEnemies;
private _SQFB_opt_lastKnownEnemyPositionOnly = SQFB_opt_lastKnownEnemyPositionOnly;
private _SQFB_opt_changeIconsToBlufor = SQFB_opt_changeIconsToBlufor;
private _SQFB_opt_enemySideColors = SQFB_opt_enemySideColors;
private _SQFB_opt_colorEnemyWest = SQFB_opt_colorEnemyWest;
private _SQFB_opt_colorEnemyGuer = SQFB_opt_colorEnemyGuer;
private _SQFB_opt_colorEnemyCiv = SQFB_opt_colorEnemyCiv;

private _SQFB_opt_alternateOcclusionCheck = SQFB_opt_alternateOcclusionCheck;
private _SQFB_opt_displayLastKnownPos = SQFB_opt_displayLastKnownPos;
private _cameraView = cameraView;

private _playerInDrone = call SQFB_fnc_playerInDrone;
private _onlyLastPosEnemy = [
                            [
                                [   
                                    true,
                                    false
                                ] select (SQFB_trackingGearCheck || _playerInDrone),
                                true
                            ] select (_SQFB_opt_lastKnownEnemyPositionOnly == "always"),
                            false
                        ] select (_SQFB_opt_lastKnownEnemyPositionOnly == "never" || (_cameraView == "GUNNER" && SQFB_player != driver _vehPlayer) || _cameraView == "GROUP");

private _SQFB_opt_colorFriendly = SQFB_opt_colorFriendly;
private _SQFB_opt_showFriendliesMinRange = SQFB_opt_showFriendliesMinRange;
private _SQFB_opt_showFriendliesMinRangeAir = SQFB_opt_showFriendliesMinRangeAir;
private _SQFB_opt_showFriendliesMaxRange = SQFB_opt_showFriendliesMaxRange;
private _SQFB_opt_showFriendliesMaxRangeAir = SQFB_opt_showFriendliesMaxRangeAir;
private _SQFB_opt_showDistFriendly = SQFB_opt_showDistFriendly;
private _SQFB_opt_friendlyPreciseVisCheck = SQFB_opt_friendlyPreciseVisCheck;
private _SQFB_opt_checkOcclusionFriendlies = SQFB_opt_checkOcclusionFriendlies;
private _SQFB_opt_lastKnownFriendlyPositionOnly = SQFB_opt_lastKnownFriendlyPositionOnly;
private _SQFB_opt_friendlySideColors = SQFB_opt_friendlySideColors;
private _SQFB_opt_colorFriendlyEast = SQFB_opt_colorFriendlyEast;
private _SQFB_opt_colorFriendlyGuer = SQFB_opt_colorFriendlyGuer;
private _SQFB_opt_colorFriendlyCiv = SQFB_opt_colorFriendlyCiv;
private _SQFB_opt_preciseDist = SQFB_opt_preciseDist;

private _onlyLastPosFriendly = [
                            [
                                [   
                                    true,
                                    false
                                ] select (SQFB_trackingGearCheck || _playerInDrone),
                                true
                            ] select (_SQFB_opt_lastKnownFriendlyPositionOnly == "always"),
                            false
                        ] select (_SQFB_opt_lastKnownFriendlyPositionOnly == "never" || (_cameraView == "GUNNER" && SQFB_player != driver _vehPlayer) || _cameraView == "GROUP");

private _SQFB_tagObjArr = +SQFB_tagObjArr;


private _SQFB_knownIFF = SQFB_knownIFF select {
    (typeName _x) != "STRING"
    && {
        alive _x
        && vehicle _x != _vehPlayer
        && {
                [_x, _vehPlayer, _isPlayerAir] call SQFB_fnc_inValidRange
            }
    }
};

_SQFB_knownIFFdead = SQFB_knownIFF select {!alive _x || {vehicle _x == _vehPlayer}} apply {_x setVariable ["SQFB_HUDdata", nil]};
_SQFB_knownIFFdead = nil;

private [
    "_unit",
    "_side",
    "_isEnemy",
    "_unitData",
    "_noUnitData",

    "_dataRealPos",
    "_dataDist",
    "_dataTagger",
    "_dataLastKnownPos",
    "_dataIconSize",
    "_dataTexture",
    "_dataText",
    "_dataTextSize",
    "_dataPosition",
    "_dataColor",
    "_dataIsVisible",
    "_dataTooClose",
    "_dataStance",
    "_dataZoom",
    "_dataCamDir",

    "_veh",
    "_isAir",
    "_maxRange",
    "_pos",
    "_sameUnitPos",
    "_realPos",

    "_tagger",
    "_taggerIndex",
    "_taggerArr",

    "_sameCamDir",
    "_sameUnitStance",
    "_zoom",
    "_sameZoom",
    "_isTarget",

    "_iconSize",
    "_textSize",
    "_position",
    "_color",
    "_text",
    "_texture",

    "_unitOccluded",
    "_lastKnownPos",
    "_onlyLastPos",

    "_IFFunit",
    "_isRealPos",
    "_perceivedPos",
    "_unitVisible",
    "_distPerceived",
    "_minRange",

    "_iconSizeBase",
    "_textSizeBase",
    "_colorUnit",
    "_unitType",
    "_iconHeightMod",
    "_selectionPos"
];

for "_i" from 0 to (count _SQFB_knownIFF) -1 do
{
    _unit = _SQFB_knownIFF select _i;
    _side = _unit getVariable "SQFB_side";
    _isEnemy = _unit getVariable "SQFB_isEnemy";
    _unitData = _unit getVariable "SQFB_unitData";

    _noUnitData = [false, true] select (isNil "_unitData");
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
    _veh = vehicle _unit;

    _isAir = _veh isKindOf "Air" && {(getPosATL _veh select 2) > 5};

    // Retrieve tagger object
    _pos = getPosWorld _veh;
    _sameUnitPos = [false, true] select (!_noUnitData && {(_dataRealPos distance _pos) <= 0});
    _realPos = [_dataRealPos, _pos] select (_noUnitData || !_sameUnitPos);
    _tagger = [_dataTagger, objNull] select _noUnitData;
    if (_noUnitData || {isNull _tagger}) then {
        _taggerIndex = [_SQFB_tagObjArr, _unit] call BIS_fnc_findNestedElement;
        _taggerArr = [];
        if (count _taggerIndex > 0) then {
            _taggerArr = _SQFB_tagObjArr select (_taggerIndex select 0);
            _tagger = _taggerArr select 0;
            _tagger setPosWorld (if (!_noUnitData) then { _dataLastKnownPos} else {_realPos});
        };
    };

    // Skip calculations if positions of both unit and player haven't changed and player and unit still have the same key attributes since last check
    _sameCamDir = [_dataCamDir == _camDir, false] select _noUnitData;
    _sameUnitStance = [stance _unit == _dataStance, false] select _noUnitData;
    _zoom = call SQFB_fnc_trueZoom;
    _sameZoom = [_zoom == _dataZoom, false] select _noUnitData;
    _isTarget = _unit == assignedTarget SQFB_player;

    if ((_playerPos distance (SQFB_player getVariable "SQFB_pos")) <= 0 && _sameUnitPos && _sameUnitStance && _sameZoom && _sameCamDir && !_isTarget) then {
        // Skip if unit not in FOV of the player
        if (!_dataIsVisible) then { _unit setVariable ["SQFB_HUDdata", nil]; continue };

        // Skip if too close
        if (_dataTooClose) then { _unit setVariable ["SQFB_HUDdata", nil]; continue };

        _iconSize = _dataIconSize;
        _textSize = _dataTextSize;
        _position = _dataPosition;
        _color = _dataColor;
        _text = _dataText;
        _texture = _dataTexture;
    } else {
        _isOnFoot = (typeOf _veh isKindOf "Man");
        // Check unit occlusion
        _unitOccluded = [_unit] call SQFB_fnc_isUnitOccluded;

        // Move unit tagger to last known position
        _lastKnownPos = [_dataLastKnownPos, _realPos] select _noUnitData;
        if (!_unitOccluded) then {
            _tagger setPosWorld _lastKnownPos;
            _lastKnownPos = _realPos;
        };

        // Skip if only unknown positions should be shown
        _onlyLastPos = [_onlyLastPosFriendly, _onlyLastPosEnemy] select _isEnemy;
        if (!_unitOccluded && _onlyLastPos) then { _unit setVariable ["SQFB_HUDdata", nil]; continue };

        _IFFunit = [
                            _unit,
                            [_unit, _tagger] select (!isNull _tagger)
                        ] select _unitOccluded;

        _isRealPos = _IFFunit == _unit;
        _perceivedPos = [_lastKnownPos, _realPos] select _isRealPos;

        // Skip if unit not in FOV of the player
        _unitVisible = [_playerPos, _camDir, ceil((call CBA_fnc_getFov select 0)*100), _perceivedPos] call BIS_fnc_inAngleSector;
        if (!_unitVisible) then { _unit setVariable ["SQFB_HUDdata", nil]; continue };

        // Skip if too close
        _distPerceived = _playerPos distance _perceivedPos;
        _minRange = [
                                [_SQFB_opt_showFriendliesMinRange, _SQFB_opt_showFriendliesMinRangeAir] select _isPlayerAir,
                                [_SQFB_opt_showEnemiesMinRange, _SQFB_opt_showEnemiesMinRangeAir] select _isPlayerAir
                            ] select _isEnemy;
        _tooClose = _minRange > 0 && {_distPerceived <= _minRange};
        if (_tooClose) then { _unit setVariable ["SQFB_HUDdata", nil]; continue };

        // Adjust sizes to distance

        _maxRange = [
                        [_SQFB_opt_showFriendliesMaxRange, _SQFB_opt_showFriendliesMaxRangeAir] select _isPlayerAir,
                        [_SQFB_opt_showEnemiesMaxRange, _SQFB_opt_showEnemiesMaxRangeAir] select _isPlayerAir
                    ] select _isEnemy;

        _iconSizeBase = [
                        [
                            ((linearConversion[ 0, _maxRange min 100, _distPerceived, (1 * ADJSIZE) * _zoom, 0.5, true ])) min 1,
                            ((linearConversion[ 0, _maxRange min 100, _distPerceived, (0.6 * ADJSIZE) * _zoom, 0.3, true ])) min 0.6
                        ] select _isOnFoot,

                        [
                            ((linearConversion[ 0, _maxRange min 100, _distPerceived, (0.8 * ADJSIZE) * _zoom, 0.4, true ])) min 0.8,
                            ((linearConversion[ 0, _maxRange min 100, _distPerceived, (0.6 * ADJSIZE) * _zoom, 0.3, true ])) min 0.6
                        ] select _isOnFoot
                    ] select _isPlayerAir;
                    
        _iconSize = [
                        (_iconSizeBase * _SQFB_opt_iconSize) max 0.01,
                        ((_iconSizeBase * _SQFB_opt_iconSize) + 0.1) max 0.01
                    ] select _isTarget;

        _textSizeBase = [
                        ((linearConversion[ 0, _maxRange min 200, _distPerceived, (0.04 * ADJSIZE) * _zoom, 0.03, true ])) min 0.04,
                        ((linearConversion[ 0, _maxRange min 200, _distPerceived, (0.04 * ADJSIZE) * _zoom, 0.03, true ])) min 0.04
                    ] select _isPlayerAir;

        _textSize = (_textSizeBase * _SQFB_opt_textSize) max 0.02;

        _colorUnit = _unit getVariable "SQFB_color";
        _color = [
                    [_colorUnit select 0, _colorUnit select 1, _colorUnit select 2, ([_IFFunit, _distPerceived, _maxRange, _SQFB_opt_maxAlpha] call SQFB_fnc_HUDAlpha) max 0.7],
                    [_SQFB_opt_colorEnemyTarget select 0, _SQFB_opt_colorEnemyTarget select 1, _SQFB_opt_colorEnemyTarget select 2, 0.7]
                ] select _isTarget;

        _text = [
                    "",
                    [
                        "",
                        [
                            [str ([round _distPerceived] call sqfb_fnc_roundDist), "m"] joinString "",
                            [str (round _distPerceived), "m"] joinString ""
                        ] select (_SQFB_opt_preciseDist || (!_SQFB_opt_preciseDist && !_isEnemy))
                    ] select ((_SQFB_opt_showDistEnemy && _isEnemy) || (_SQFB_opt_showDistFriendly && !_isEnemy))
                ] select (!_isPlayerAir && _SQFB_opt_showText && _textSize > 0.02);


        _unitType = [typeOf _unit] call SQFB_fnc_classType;
        _texture = [
                        [
                            "",
                            "a3\ui_f\data\map\markers\military\unknown_ca.paa"
                        ] select (_SQFB_opt_displayLastKnownPos == "always"), 
                        ["a3\ui_f\data\map\markers\nato\", (["o", "n"] select ((!_isEnemy && !_SQFB_opt_changeIconsToBlufor) || {_SQFB_opt_changeIconsToBlufor && {_side == west}})), "_", _unitType, ".paa"] joinString ""
                    ] select _isRealPos;

        _iconHeightMod = [
                                    [0.8, 0.5] select (_text == ""),
                                    [0.4, 0.2] select (_text == "")
                                ] select _isOnFoot;
        _selectionPos = [getPosVisual _IFFunit, _IFFunit selectionPosition ["head", "HitPoints"]] select _isRealPos;
        _position = [
                        [
                            _IFFunit modelToWorldVisual [
                                _SQFB_opt_iconHorVeh,
                                0,
                                0
                            ],
                            _IFFunit modelToWorldVisual [
                                _SQFB_opt_iconHorVeh,
                                0,
                                _iconHeightMod + _SQFB_opt_iconHeightVeh
                                ]
                        ] select _isRealPos,

                        [
                            _IFFunit modelToWorldVisual [
                                _SQFB_opt_iconHor,
                                0,
                                [
                                    0.5,
                                    1.5
                                ] select _SQFB_opt_alternateOcclusionCheck
                            ],
                            _IFFunit modelToWorldVisual [
                                (_selectionPos select 0) + _SQFB_opt_iconHor,
                                _selectionPos select 1,
                                (_selectionPos select 2) + _iconHeightMod + _SQFB_opt_iconHeight
                            ]
                        ] select _isRealPos
                    ] select _isOnFoot;

        if (_isRealPos) then { _position set [2, (_position select 2) + ((_distPerceived * 0.01) min 1.5)] }; // Hack to keep the icons more or less at the same height no matter the distance
                    
        // Create unit vars
        _unit setVariable ["SQFB_unitData", [_realPos, _tagger, _lastKnownPos, _iconSize, _texture, _text, _textSize, _position, _color, _unitVisible, _tooClose, stance _unit, _zoom, _camDir]]; 
    };

    _unit setVariable ["SQFB_HUDdata", 
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
            ]
        ];
};
