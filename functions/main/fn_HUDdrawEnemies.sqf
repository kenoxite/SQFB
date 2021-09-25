/*
  Author: kenoxite

  Description:
  Draws the squad HUD


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

private _SQFB_knownEnemies = SQFB_knownEnemies;
private _SQFB_enemyTagObjArr = SQFB_enemyTagObjArr;
private _SQFB_opt_colorEnemy = SQFB_opt_colorEnemy;
private _SQFB_opt_showEnemiesMinRange = SQFB_opt_showEnemiesMinRange;
private _SQFB_opt_showEnemiesMinRangeAir = SQFB_opt_showEnemiesMinRangeAir;
private _SQFB_opt_showEnemiesMaxRange = SQFB_opt_showEnemiesMaxRange;
private _SQFB_opt_showEnemiesMaxRangeAir = SQFB_opt_showEnemiesMaxRangeAir;
private _SQFB_opt_showDistEnemy = SQFB_opt_showDistEnemy;
private _SQFB_opt_enemyPreciseVisCheck = SQFB_opt_enemyPreciseVisCheck;
for "_i" from 0 to (count _SQFB_knownEnemies) -1 do
{
    if ((typeName (_SQFB_knownEnemies select _i))!="STRING") then {
        private _unit = _SQFB_knownEnemies select _i;
        private _enemyData = _unit getVariable "SQFB_enemyData";

        private ["_dataRealPos", "_dataDist", "_dataEnemyTagger", "_dataLastKnownPos", "_dataIconSize", "_dataTexture", "_dataText", "_dataTextSize", "_dataPosition", "_dataColor", "_dataIsVisible", "_dataTooClose", "_dataStance", "_dataZoom", "_dataCamDir"];
        private _noEnemyData = [false, true] select (isNil "_enemyData");
        if (!_noEnemyData) then {
            _dataRealPos = _enemyData select 0;
            _dataEnemyTagger = _enemyData select 1;
            _dataLastKnownPos = _enemyData select 2;
            _dataIconSize = _enemyData select 3;
            _dataTexture = _enemyData select 4;
            _dataText = _enemyData select 5;
            _dataTextSize = _enemyData select 6;
            _dataPosition = _enemyData select 7;
            _dataColor = _enemyData select 8;
            _dataIsVisible = _enemyData select 9;
            _dataTooClose = _enemyData select 10;
            _dataStance = _enemyData select 11;
            _dataZoom = _enemyData select 12;
            _dataCamDir = _enemyData select 13;
        };
        private _veh = vehicle _unit;
        private _vehPlayer = vehicle SQFB_player;
        private _isPlayerAir = ((getPosASL _vehPlayer select 2) > 5 && !(isNull objectParent SQFB_player));

        // Skip units outside the max range
        private _dist = _vehPlayer distance _unit;
        private _maxRange = [_SQFB_opt_showEnemiesMaxRange, _SQFB_opt_showEnemiesMaxRangeAir] select _isPlayerAir;
        if (_dist > _maxRange) then { continue };

        // Retrieve tagger object
        private _sameEnemyPos = [false, true] select (!_noEnemyData && {(_dataRealPos distance getPosWorld _veh) <= 0});
        private _realPos = [_dataRealPos, getPosWorld _veh] select (_noEnemyData || !_sameEnemyPos);
        private _enemyTagger = [_dataEnemyTagger, objNull] select _noEnemyData;
        if (_noEnemyData) then {
            private _enemyTaggerIndex = [_SQFB_enemyTagObjArr, _unit] call BIS_fnc_findNestedElement;
            private _enemyTaggerArr = [];
            if (count _enemyTaggerIndex > 0) then {
                _enemyTaggerArr = _SQFB_enemyTagObjArr select (_enemyTaggerIndex select 0);
                _enemyTagger = _enemyTaggerArr select 0;
                _enemyTagger setPosWorld _realPos;
            };
        };

        // Skip calculations if positions of both enemy and player haven't changed and player and enemy still have the same key attributes since last check
        private _camDir = [0,0,0] getdir getCameraViewDirection SQFB_player;
        private _sameCamDir = [_dataCamDir == _camDir, false] select _noEnemyData;
        private _sameEnemyStance = [stance _unit == _dataStance, false] select _noEnemyData;
        private _zoom = call SQFB_fnc_trueZoom;
        private _sameZoom = [_zoom == _dataZoom, false] select _noEnemyData;
        private ["_iconSize", "_textSize", "_position", "_color", "_text", "_texture"];
        if ((_playerPos distance (player getVariable "SQFB_pos")) <= 0 && _sameEnemyPos && _sameEnemyStance && _sameZoom && _sameCamDir) then {
            // Skip if enemy not in FOV of the player
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
            private _unitVisibility = [
                                            [
                                                [objNull, "VIEW"] checkVisibility [eyePos SQFB_player, AtlToAsl(_unit modeltoworld [0,0,0])],
                                                [_unit, SQFB_player, true] call SQFB_fnc_checkVisibility
                                            ] select _SQFB_opt_enemyPreciseVisCheck,
                                            [objNull, "VIEW"] checkVisibility [eyePos SQFB_player, eyePos _unit]
                                        ] select (_isOnFoot);
            private _visThreshold = [0.2, 0.1] select _isPlayerAir;
            private _enemyOccluded = _unitVisibility < _visThreshold;

            // Move enemy tagger to last known position
            private _lastKnownPos = [_dataLastKnownPos, _realPos] select _noEnemyData;
            if (!_enemyOccluded) then {
                _enemyTagger setPosWorld _realPos;
                _lastKnownPos = _realPos;
            };
            private _enemy = [
                                _unit,
                                [_unit, _enemyTagger] select (!isNull _enemyTagger)
                            ] select _enemyOccluded;

            private _isRealPos = _enemy == _unit;
            private _perceivedPos = [_lastKnownPos, _realPos] select _isRealPos;
            private _enemyVisible = [ _playerPos, _camDir, ceil((call CBA_fnc_getFov select 0)*100), _perceivedPos] call BIS_fnc_inAngleSector;

            // Skip if enemy not in FOV of the player
            if (!_enemyVisible) then { continue };

            // Skip if too close
            private _distPerceived = _playerPos distance _perceivedPos;
            private _minRange = [_SQFB_opt_showEnemiesMinRange, _SQFB_opt_showEnemiesMinRangeAir] select _isPlayerAir;
            private _tooClose = _minRange > 0 && {_distPerceived <= _minRange};
            if (_tooClose) then { continue };

            // Adjust sizes to distance
            private _adjSize = 2; // TBH no idea why this is needed, but it's needed

            _iconSize = [
                            [
                                ((linearConversion[ 0, _maxRange min 100, _distPerceived, (1 * _adjSize) * _zoom, 0.5, true ])) min 1,
                                ((linearConversion[ 0, _maxRange min 100, _distPerceived, (0.6 * _adjSize) * _zoom, 0.3, true ])) min 0.6
                            ] select (_isOnFoot),

                            [
                                ((linearConversion[ 0, _maxRange min 100, _distPerceived, (1 * _adjSize) * _zoom, 0.5, true ])) min 1,
                                ((linearConversion[ 0, _maxRange min 100, _distPerceived, (1 * _adjSize) * _zoom, 0.5, true ])) min 1
                            ] select (_isOnFoot)
                        ] select (_isPlayerAir);

            _textSize = [
                            ((linearConversion[ 0, _maxRange min 200, _distPerceived, (0.04 * _adjSize) * _zoom, 0.03, true ])) min 0.04,
                            ((linearConversion[ 0, _maxRange min 200, _distPerceived, (0.04 * _adjSize) * _zoom, 0.03, true ])) min 0.04
                        ] select (_isPlayerAir);

            _iconSize = (_iconSize * _SQFB_opt_iconSize) max 0.01;
            _textSize = (_textSize * _SQFB_opt_textSize) max 0.02;

            _color = [_SQFB_opt_colorEnemy select 0,_SQFB_opt_colorEnemy select 1,_SQFB_opt_colorEnemy select 2, ([_enemy] call SQFB_fnc_HUDAlpha) max 0.7];

            _text = [
                        "",
                        [
                            "",
                            format ["%1m", round _distPerceived]
                        ] select (_SQFB_opt_showDistEnemy)
                    ] select (!_isPlayerAir && _SQFB_opt_showText && _textSize > 0.02);


            private _enemyType = [typeOf _unit] call SQFB_fnc_classType;
            _texture = [
                            "a3\ui_f\data\map\markers\military\unknown_ca.paa", 
                            format ["a3\ui_f\data\map\markers\nato\o_%1.paa", _enemyType]
                        ] select _isRealPos;

            private _iconHeightMod = [
                                        [1.7, 0.8] select (_text == ""),
                                        [0.8, 0.5] select (_text == "")
                                    ] select (_isOnFoot);
            private _selectionPos = [getPosVisual _enemy, _enemy selectionPosition ["head", "HitPoints"]] select _isRealPos;
            // private _selectionPos = [getPosVisual _enemy, selectionPosition [_enemy, "head", 12, true]] select _isRealPos;
            _position = [
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
                            ] select _isRealPos,

                            [
                                _enemy modelToWorldVisual [
                                    _SQFB_opt_iconHor,
                                    0,
                                    1.3
                                ],
                                _enemy modelToWorldVisual [
                                    (_selectionPos select 0) + _SQFB_opt_iconHor,
                                    _selectionPos select 1,
                                    (_selectionPos select 2) + _iconHeightMod + _SQFB_opt_iconHeight
                                ]
                            ] select _isRealPos
                        ] select _isOnFoot;
                        
            // Create ememy vars
            _unit setVariable ["SQFB_enemyData", [_realPos, _enemyTagger, _lastKnownPos, _iconSize, _texture, _text, _textSize, _position, _color, _enemyVisible, _tooClose, stance _unit, _zoom, _camDir]]; 
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
