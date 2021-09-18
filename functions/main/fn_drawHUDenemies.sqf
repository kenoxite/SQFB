/*
  Author: kenoxite

  Description:
  Draws the squad HUD


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

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

private _SQFB_knownEnemies = SQFB_knownEnemies;
private _SQFB_enemyTagObjArr = SQFB_enemyTagObjArr;
private _SQFB_opt_colorEnemy = SQFB_opt_colorEnemy;
private _SQFB_opt_showEnemiesMinRange = SQFB_opt_showEnemiesMinRange;
private _SQFB_opt_showEnemiesMinRangeAir = SQFB_opt_showEnemiesMinRangeAir;
private _SQFB_opt_showEnemiesMaxRange = SQFB_opt_showEnemiesMaxRange;
private _SQFB_opt_showEnemiesMaxRangeAir = SQFB_opt_showEnemiesMaxRangeAir;
private _SQFB_opt_showDistEnemy = SQFB_opt_showDistEnemy;
for "_i" from 0 to (count _SQFB_knownEnemies) -1 do
{
    if ((typeName (_SQFB_knownEnemies select _i))!="STRING") then {
        private _unit = _SQFB_knownEnemies select _i;
        private _veh = vehicle _unit;
        private _vehPlayer = vehicle player;
        private _isPlayerAir = ((getPosASL _vehPlayer select 2) > 5 && !(isNull objectParent player));
        private _dist = _vehPlayer distance _unit;

        // Skip units outside the max range
        private _maxRange = [_SQFB_opt_showEnemiesMaxRange, _SQFB_opt_showEnemiesMaxRangeAir] select (_isPlayerAir);
        if (_dist > _maxRange) then { continue };

        // Retrieve tagger object
        private _enemyTagger = objNull;
        private _enemyTaggerIndex = [_SQFB_enemyTagObjArr, _unit] call BIS_fnc_findNestedElement;
        private _enemyTaggerArr = [];
        if (count _enemyTaggerIndex > 0) then {
            _enemyTaggerArr = _SQFB_enemyTagObjArr select (_enemyTaggerIndex select 0);
            _enemyTagger = _enemyTaggerArr select 0;
            if (_enemyTaggerArr select 2) then {
                _enemyTagger setPosWorld (getPosWorld _veh);
                _enemyTaggerArr set [2, false];
            };
        };

        private _isOnFoot = (typeOf _veh isKindOf "Man");
        private _unitVisibility = [
                            [objNull, "VIEW"] checkVisibility [eyePos player, AtlToAsl(_unit modeltoworld [0,0,0])],
                            [objNull, "VIEW"] checkVisibility [eyePos player, eyePos _unit]
                            ] select (_isOnFoot);
        private _visThreshold = [0.2, 0.1] select (_isPlayerAir);
        private _enemyOccluded = _unitVisibility < _visThreshold;
        // Move enemy tagger to last known position
        if (!_enemyOccluded) then { _enemyTagger setPosWorld (getPosWorld _veh) };
        private _enemy = [
                            _unit,
                            [_unit, _enemyTagger] select (!isNull _enemyTagger)
                        ] select _enemyOccluded;
        private _unitPos = getPosWorld _enemy;
        private _enemyVisible = [ getPosWorld _vehPlayer, [0,0,0] getdir getCameraViewDirection player, (getObjectFOV _vehPlayer) * 120, _unitPos ] call BIS_fnc_inAngleSector;

        // Skip if enemy not in FOV of the player
        if (!_enemyVisible) then { continue };

        // Skip if too close
        private _minRange = [_SQFB_opt_showEnemiesMinRange, _SQFB_opt_showEnemiesMinRangeAir] select (_isPlayerAir);
        if (_minRange > 0 && {_dist <= _minRange}) then { continue };

        // Adjust sizes to distance
        private _zoom = call SQFB_fnc_trueZoom;
        private _adjSize = 2; // TBH no idea why this is needed, but it's needed

        private _iconSize = [
                        [
                        ((linearConversion[ 0, _maxRange min 100, _dist, (1 * _adjSize) * _zoom, 0.5, true ])) min 1,
                        ((linearConversion[ 0, _maxRange min 100, _dist, (0.6 * _adjSize) * _zoom, 0.3, true ])) min 0.6
                        ] select (_isOnFoot),

                        [
                        ((linearConversion[ 0, _maxRange min 100, _dist, (1 * _adjSize) * _zoom, 0.5, true ])) min 1,
                        ((linearConversion[ 0, _maxRange min 100, _dist, (1 * _adjSize) * _zoom, 0.5, true ])) min 1
                        ] select (_isOnFoot)
                    ] select (_isPlayerAir);

        private _text_size = [
                        ((linearConversion[ 0, _maxRange min 200, _dist, (0.04 * _adjSize) * _zoom, 0.03, true ])) min 0.04,
                        ((linearConversion[ 0, _maxRange min 200, _dist, (0.04 * _adjSize) * _zoom, 0.03, true ])) min 0.04
                    ] select (_isPlayerAir);

        _iconSize = (_iconSize * _SQFB_opt_iconSize) max 0.01;
        _text_size = (_text_size * _SQFB_opt_textSize) max 0.02;

        private _color = [_SQFB_opt_colorEnemy select 0,_SQFB_opt_colorEnemy select 1,_SQFB_opt_colorEnemy select 2, ([_enemy] call SQFB_fnc_HUDAlpha) max 0.7]; // Red

        private _iconHeightMod = [
                                    ((linearConversion[ 0, _maxRange min 200, _dist, (1 * _adjSize) * _zoom, 1, true ])) min 1,
                                    ((linearConversion[ 0, _maxRange min 200, _dist, (0.8 * _adjSize) * _zoom, 0.8, true ])) min 0.8
                                ] select (_isOnFoot);
        private _enemyPos = [getPosWorld _enemy, _enemy selectionPosition "head"] select (_enemy == _unit);
        private _position = [
                                [
                                    _enemy modelToWorldVisual [
                                        _SQFB_opt_iconHorVeh,
                                        0,
                                        0
                                    ],
                                    _enemy modelToWorldVisual [
                                        _SQFB_opt_iconHorVeh,
                                        0,
                                        _iconHeightMod + _SQFB_opt_iconHeightVeh
                                        ]
                                ] select (_enemy == _unit),

                                [
                                    _enemy modelToWorldVisual [
                                        _SQFB_opt_iconHor,
                                        0,
                                        1.3
                                    ],
                                    _enemy modelToWorldVisual [
                                        (_enemyPos select 0) + _SQFB_opt_iconHor,
                                        _enemyPos select 1,
                                        (_enemyPos select 2) + _iconHeightMod + _SQFB_opt_iconHeight
                                    ]
                                ] select (_enemy == _unit)
                            ] select (_isOnFoot);
        private _angle = 0;
        private _shadow = false;
        private _font = _SQFB_opt_textFont;
        private _text_align = "center";
        private _arrows = false;

        private _text = [
                            "",
                            [
                                "",
                                format ["%1m", round _dist]
                            ] select (_SQFB_opt_showDistEnemy)
                        ] select (!_isPlayerAir && _SQFB_opt_showText && _text_size > 0.02);

        private _texture = ["a3\ui_f\data\map\markers\military\unknown_ca.paa", "a3\ui_f\data\map\markers\nato\o_unknown.paa"] select (_enemy == _unit);

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
                _text_size, // (optional)
                _font, // (optional)
                _text_align, // (optional)
                _arrows // (optional)
            ]; 
        };
    };
};
