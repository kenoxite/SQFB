// -----------------------------------------------
// SQUAD FEEDBACK - Init
// by kenoxite
// -----------------------------------------------

// Init
SQFB_debug = if (is3DENPreview) then { true } else { false };
SQFB_units = [];
SQFB_knownEnemies = [];
SQFB_showHUD = false;
SQFB_showEnemyHUD = false;
SQFB_showDeadMinTime = 0;
SQFB_showEnemiesMinTime = 0;
SQFB_opt_profile_old = SQFB_opt_profile;
SQFB_enemyTagObjArr = [];
SQFB_squadTimeLastCheck = time;
SQFB_enemiesTimeLastCheck = time;

// Player traits
private _unitTraits = getAllUnitTraits player;
player setVariable ["SQFB_medic",(_unitTraits select { (_x select 0) == "Medic" } apply { _x select 1 }) select 0];

// 3rd party global vars
if (isNil "Vile_HUD_HIDDEN") then { Vile_HUD_HIDDEN = false };

waitUntil {!isNull player};

// Init player group
private _grp = group player;
private _units = units _grp;
SQFB_unitCount = count _units;
[_grp] call SQFB_fnc_initGroup;
// Add units to the global array
[_units] call SQFB_fnc_addUnits;

// Keep track of group status
SQFB_EH_update = [{ if (SQFB_opt_on) then { [] call SQFB_fnc_updateHUD }; }, SQFB_opt_updateDelay, []] call CBA_fnc_addPerFrameHandler;

// HUD display
SQFB_draw3D_EH = addMissionEventHandler [
"Draw3D",
{
    private _offset = [0,0,0];
    if (SQFB_opt_on && !Vile_HUD_HIDDEN) then {
        private _screenPosition = worldToScreen (_x modelToWorldVisual _offset);
        if (_screenPosition isEqualTo []) exitWith {};

        if (count SQFB_units > 0) then {
            private _SQFB_opt_GroupCrew = SQFB_opt_GroupCrew;
            private _SQFB_opt_checkVisibility = SQFB_opt_checkVisibility;
            private _SQFB_showHUD = SQFB_showHUD;
            private _SQFB_opt_AlwaysShowCritical = SQFB_opt_AlwaysShowCritical;
            private _SQFB_opt_showDead = SQFB_opt_showDead;
            private _SQFB_opt_scaleText = SQFB_opt_scaleText;
            private _SQFB_opt_textSize = SQFB_opt_textSize;
            private _SQFB_opt_iconSize = SQFB_opt_iconSize;
            private _SQFB_opt_iconHor = SQFB_opt_iconHor;
            private _SQFB_opt_iconHeight = SQFB_opt_iconHeight;
            private _SQFB_opt_textFont = SQFB_opt_textFont;
            private _SQFB_opt_Arrows = SQFB_opt_Arrows;
            private _SQFB_opt_showIcon = SQFB_opt_showIcon;
            private _SQFB_opt_showText = SQFB_opt_showText;
            private _SQFB_opt_showIndex = SQFB_opt_showIndex;
            private _SQFB_opt_showClass = SQFB_opt_showClass;
            private _SQFB_opt_showRoles = SQFB_opt_showRoles;
            private _SQFB_opt_ShowCrew = SQFB_opt_ShowCrew;
            private _SQFB_opt_showDist = SQFB_opt_showDist;
            private _SQFB_opt_iconHorVeh = SQFB_opt_iconHorVeh;
            private _SQFB_opt_iconHeightVeh = SQFB_opt_iconHeightVeh;
            private _SQFB_opt_scaleText = SQFB_opt_scaleText;
            // Squad
            if (time > SQFB_squadTimeLastCheck + SQFB_opt_HUDrefresh) then {
                if (SQFB_opt_showSquad) then {
                    private _SQFB_units = SQFB_units;
                    for "_i" from 0 to (count _SQFB_units) -1 do
                    {
                        if ((typeName (_SQFB_units select _i))!="STRING") then {
                            private _unit = _SQFB_units select _i; 
                            private _grp = group _unit; 
                            private _alive = alive _unit;
                            private _veh = vehicle _unit;
                            private _vehPlayer = vehicle player;
                            private _isOnFoot = isNull objectParent _unit;
                            private _isPlayerAir = if ((typeOf _vehPlayer) isKindOf "Air") then { true } else { false };
                            private _unitPos = position _veh;
                            private _dist2D = _vehPlayer distance2D _veh;
                            private _crew = crew _veh;
                            private _isFirstCrew = false;
                            private _inVehDif = _SQFB_opt_GroupCrew && !_isOnFoot && (_veh != _vehPlayer || cameraView != "INTERNAL");
                            private _canSee = 1;
                            if (_SQFB_opt_checkVisibility) then { _canSee = if (_inVehDif) then { [objNull, "VIEW"] checkVisibility [eyePos player, AtlToAsl(_veh modeltoworld [0,0,0])] } else { [objNull, "VIEW"] checkVisibility [eyePos player, eyePos _unit] } };

                            if ((_SQFB_showHUD || (!_SQFB_showHUD && _SQFB_opt_AlwaysShowCritical)) && _canSee >= 0.2) then {
                                if (_alive || (!_alive && _SQFB_opt_showDead && (_unit getVariable "SQFB_veh") == _unit)) then {
                                    private _iconSize = 0;
                                    private _text_size = 0;
                                    private _zoom = call SQFB_fnc_trueZoom;

                                    // Icon size
                                    if (_isPlayerAir) then {
                                        if (_isOnFoot) then {
                                            // _iconSize = (linearConversion[ 0, 100, _dist2D, 1.3, 0.5, true ]);
                                            _iconSize = ((linearConversion[ 0, SQFB_opt_maxRange_air min 100, _dist2D, (1.8 * 2) * _zoom, 0.1, true ])) min 1.8;

                                        } else {
                                            // _iconSize = (linearConversion[ 0, 100, _dist2D, 2.5, 1, true ]);
                                            _iconSize = ((linearConversion[ 0, SQFB_opt_maxRange_air min 100, _dist2D, (2 * 2) * _zoom, 0.3, true ])) min 2;
                                        };
                                    } else {
                                        if (_isOnFoot) then {
                                            // _iconSize = (linearConversion[ 0, 10, _dist2D, 1.5, 0.5, true ]);
                                            // _iconSize = ((linearConversion[ 0, 75, _dist2D, 2, 0.5, true ]) * _zoom) min 2;
                                            // _iconSize = ((linearConversion[ 0, SQFB_opt_maxRange, _dist2D, 3 * _zoom, 0.1, true ])) min 2;
                                            _iconSize = ((linearConversion[ 0, SQFB_opt_maxRange min 200, _dist2D, (1.8 * 2) * _zoom, 0.1, true ])) min 1.8;

                                        } else {
                                            // _iconSize = (linearConversion[ 0, 75, _dist2D, 2.5, 1, true ]);
                                            _iconSize = ((linearConversion[ 0, SQFB_opt_maxRange min 200, _dist2D, (1.8 * 2) * _zoom, 0.3, true ])) min 1.8;
                                        };
                                    };
                            
                                    // Text size
                                    if (_SQFB_opt_scaleText) then {
                                        if (_isPlayerAir) then {
                                            _text_size = 0.03;
                                        } else {
                                            if (_isOnFoot) then {
                                                // _text_size = 0.082 * _zoom;
                                                // _text_size = 0.03;
                                                // _text_size = (linearConversion[ 0, 75, _dist2D, 0.03, 0.02, true ]);
                                                // _text_size = ((linearConversion[ 0, 75, _dist2D, 0.04, 0.03, true ]) * _zoom) min 0.04;
                                                // _text_size = ((linearConversion[ 0, SQFB_opt_maxRange min 100, _dist2D, 0.08 * _zoom, 0, true ])) min 0.04;
                                                _text_size = ((linearConversion[ 0, SQFB_opt_maxRange min 200, _dist2D, (0.04 * 2) * _zoom, 0, true ])) min 0.04;

                                            } else {
                                                _text_size = ((linearConversion[ 0, SQFB_opt_maxRange min 200, _dist2D, (0.052 * 2) * _zoom, 0, true ])) min 0.052;
                                            };
                                        };
                                    } else {
                                        // if (_isOnFoot) then {
                                        //     _iconSize = 1;

                                        // } else {
                                        //     _iconSize = 1.5;
                                        // }; 
                                        _text_size = 0.03;
                                    };

                                    _iconSize = _iconSize * _SQFB_opt_iconSize;
                                    _text_size = (_text_size * _SQFB_opt_textSize) max 0.02;

                                    private _texture = "";
                                    private _color = _unit call SQFB_fnc_HUDColor;

                                    if (_inVehDif) then {
                                        // Check if unit is the first in the vehicle's crew
                                        private _ownCrewFirstIdx = _crew findIf { _x in units group _unit && _x == _unit };
                                        if (_ownCrewFirstIdx != -1) then { _isFirstCrew = (_crew select _ownCrewFirstIdx) == _unit };  
                                    };
                                    private _iconHeightMod = if (!_alive) then { 0.6 } else { if (_isOnFoot) then { 2 } else { 1.05 } };
                                    private _selectionPos = _unit selectionPosition "head";
                                    private _position = if ((_inVehDif && _isFirstCrew)) then {
                                                            _veh modelToWorldVisual [
                                                                _SQFB_opt_iconHorVeh,
                                                                0,
                                                                1 + _SQFB_opt_iconHeightVeh
                                                            ];
                                                        } else {
                                                            _unit modelToWorldVisual [
                                                                (_selectionPos select 0) + _SQFB_opt_iconHor,
                                                                _selectionPos select 1,
                                                                _iconHeightMod + _SQFB_opt_iconHeight
                                                            ];
                                                        };

                                    private _angle = 0;
                                    private _text = "";
                                    private _shadow = true;
                                    private _font = _SQFB_opt_textFont;
                                    private _text_align = "center";
                                    private _arrows = _SQFB_opt_Arrows;

                                    if (_inVehDif && _isFirstCrew) then {
                                        if (_SQFB_opt_showIcon || _text_size <= 0.02) then { _texture =  [_veh, _grp] call SQFB_fnc_HUDIconVeh };
                                        if (_SQFB_opt_showText && _text_size > 0.02) then { _text = [_veh, _SQFB_opt_showIndex, _SQFB_opt_showClass, _SQFB_opt_showRoles, _SQFB_opt_ShowCrew, _SQFB_opt_showDist] call SQFB_fnc_HUDtextVeh };
                                    } else {
                                        // Unit on foot or in the same vehicle as player and player in 1st person POV
                                        if (_SQFB_opt_showIcon || _text_size <= 0.02) then {
                                            _texture =  _unit call SQFB_fnc_HUDIcon;
                                        };
                                        if (_SQFB_opt_showText && _text_size > 0.02) then {
                                            _text = [_unit] call SQFB_fnc_HUDtext;
                                        };
                                    };

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
                        };
                    };
                };
                SQFB_squadTimeLastCheck = time;
            };

            private _SQFB_enemyTagObjArr = SQFB_enemyTagObjArr;
            private _SQFB_opt_colorEnemy = SQFB_opt_colorEnemy;
            private _SQFB_showHUD = SQFB_showEnemyHUD;
            // Enemies
            if (time > SQFB_enemiesTimeLastCheck + SQFB_opt_HUDrefresh) then {
                private _SQFB_knownEnemies = SQFB_knownEnemies;
                if (SQFB_opt_AlwaysShowEnemies || (SQFB_opt_showEnemies && time >= SQFB_showEnemiesMinTime)) then {
                    for "_i" from 0 to (count _SQFB_knownEnemies) -1 do
                    {
                        if ((typeName (_SQFB_knownEnemies select _i))!="STRING" && (_SQFB_showHUD || SQFB_opt_AlwaysShowEnemies)) then {
                            private _unit = _SQFB_knownEnemies select _i; 
                            private _grp = group _unit; 
                            private _alive = alive _unit;
                            private _veh = vehicle _unit;
                            private _vehPlayer = vehicle player;
                            private _crew = crew _veh;
                            private _isOnFoot = (typeOf _veh isKindOf "Man");
                            private _isPlayerAir = if ((typeOf _vehPlayer) isKindOf "Air") then { true } else { false };
                            private _canSee = 1;
                            private _visThreshold = if (_isPlayerAir) then { 0.1 } else { 0.2 };
                            private _unitClass = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");
                            private _unitPos = position _veh;
                            private _dist2D = _vehPlayer distance2D _veh;
                            private _distStr = format ["%1m", round _dist2D];
                            if (true) then { _canSee = if (!_isOnFoot) then { [objNull, "VIEW"] checkVisibility [eyePos player, AtlToAsl(_unit modeltoworld [0,0,0])] } else { [objNull, "VIEW"] checkVisibility [eyePos player, eyePos _unit] }; };

                            // private _zoom = call SQFB_fnc_trueZoom;
                            private _iconSize = 0;
                            private _text_size = 0;
                            private _zoom = call SQFB_fnc_trueZoom;
                            
                            // Adjust sizes to distance
                            if (_isPlayerAir) then {
                                if (_isOnFoot) then {
                                    _iconSize = ((linearConversion[ 0, SQFB_opt_showEnemiesMaxRangeAir min 100, _dist2D, (0.6 * 2) * _zoom, 0.1, true ])) min 0.6;

                                } else {
                                    _iconSize = ((linearConversion[ 0, SQFB_opt_showEnemiesMaxRangeAir min 100, _dist2D, (1 * 2) * _zoom, 0.1, true ])) min 1;
                                };
                                // _text_size = 0.08 * _zoom;
                                _text_size = ((0.03 * 2) * _zoom) min 0.03;
                            } else {
                                if (_isOnFoot) then {
                                    // _iconSize = (linearConversion[ 0, 50, _dist2D, 0.5, 0.1, true ]);
                                    _iconSize = ((linearConversion[ 0, SQFB_opt_showEnemiesMaxRange min 100, _dist2D, (0.6 * 2) * _zoom, 0.1, true ])) min 0.6;

                                } else {
                                    // _iconSize = (linearConversion[ 0, 50, _dist2D, 1, 0.3, true ]);
                                    _iconSize = ((linearConversion[ 0, SQFB_opt_showEnemiesMaxRange min 100, _dist2D, (1 * 2) * _zoom, 0.1, true ])) min 1;
                                };
                                // _text_size = 0.08 * _zoom;
                                // _text_size = (linearConversion[ 0, 500, _dist2D, 0.1, 0.025, true ]);
                                // _text_size = ((0.03 * 2) * _zoom);
                                _text_size = 0.03;
                            };

                            _iconSize = (_iconSize * _SQFB_opt_iconSize) max 0.01;
                            _text_size = (_text_size * _SQFB_opt_textSize) max 0.02;

                            // Retrieve tagger object or create it if it isn't found
                            private _enemyTagger = objNull;
                            private _enemyTaggerIndex = [_SQFB_enemyTagObjArr, _unit] call BIS_fnc_findNestedElement;
                            private _enemyTaggerArr = [];
                            private _enTagFirstTime = false;
                            if (count _enemyTaggerIndex > 0) then {
                                _enemyTaggerArr = _SQFB_enemyTagObjArr select (_enemyTaggerIndex select 0);
                                _enemyTagger = _enemyTaggerArr select 0;
                                _enTagFirstTime = _enemyTaggerArr select 2;
                            };
                            private _enemy = objNull;
                            if (_canSee >= _visThreshold) then {
                                _enemy = _unit;
                            } else {
                                if (!isNull _enemyTagger) then {
                                    _enemy = _enemyTagger
                                } else {
                                    _enemy = _unit;
                                };
                            };

                            // Choose texture image
                            private _texture = if (_enemy == _unit) then {
                                            "a3\ui_f\data\map\markers\nato\o_unknown.paa"
                                        } else {
                                            "a3\ui_f\data\map\markers\military\unknown_ca.paa"
                                        };

                            // Move enemy tagger to last known position
                            if (_enemy == _unit || (!isNull _enemyTagger && (_enemy == _enemyTagger && _enTagFirstTime))) then {
                                _enemyTagger setVehiclePosition [_unitPos, [], 0, "CAN_COLLIDE"];
                                if (_enTagFirstTime) then {
                                    _enTagFirstTime = false;
                                    _enemyTaggerArr set [2, false];
                                };
                            };

                            private _color = [_SQFB_opt_colorEnemy select 0,_SQFB_opt_colorEnemy select 1,_SQFB_opt_colorEnemy select 2, ([_enemy] call SQFB_fnc_HUDAlpha) max 0.5]; // Red

                            private _iconHeightMod = if (_isOnFoot) then { 0.8 } else { 1 };
                            private _enemyPos = if (_enemy == _unit) then { (_enemy selectionPosition "head") } else { _enemy selectionPosition "camo2" };
                            private _position = if (_isOnFoot) then {
                                                    if (_enemy == _unit) then {
                                                        _enemy modelToWorldVisual [
                                                            (_enemyPos select 0) + _SQFB_opt_iconHor,
                                                            _enemyPos select 1,
                                                            2.2 + _SQFB_opt_iconHeight
                                                        ];
                                                    } else {
                                                        _enemy modelToWorldVisual [
                                                            (_enemyPos select 0),
                                                            _enemyPos select 1,
                                                            -1.5
                                                        ];
                                                    };
                                                } else {
                                                    if (_enemy == _unit) then {
                                                        _enemy modelToWorldVisual [
                                                            _SQFB_opt_iconHorVeh,
                                                            0,
                                                            _iconHeightMod + _SQFB_opt_iconHeightVeh
                                                            ];
                                                    } else {
                                                        _enemy modelToWorldVisual [
                                                            _SQFB_opt_iconHorVeh,
                                                            0,
                                                            -0.5
                                                        ];
                                                    };
                                                };
                            private _angle = 0;
                            private _text = "";
                            private _shadow = true;
                            private _font = _SQFB_opt_textFont;
                            private _text_align = "center";
                            private _arrows = false;

                            if (!_isPlayerAir && _SQFB_opt_showText && _text_size > 0.02) then {
                                if (SQFB_opt_showDistEnemy) then { _text = _distStr };
                            };

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
                };
                SQFB_enemiesTimeLastCheck = time;
            };
        };
    };
}];
