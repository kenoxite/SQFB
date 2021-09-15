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
    if (SQFB_opt_on && !Vile_HUD_HIDDEN) then {
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
                            private _crew = crew _veh;
                            private _inVehDif = _SQFB_opt_GroupCrew && _veh != _unit && (_veh != _vehPlayer || cameraView != "INTERNAL");
                            private _canSee = 1;
                            if (_SQFB_opt_checkVisibility) then { _canSee = if (_inVehDif) then { [objNull, "VIEW"] checkVisibility [eyePos player, AtlToAsl(_unit modeltoworld [0,0,0])] } else { [objNull, "VIEW"] checkVisibility [eyePos player, eyePos _unit] } };

                            if ((_SQFB_showHUD || (!_SQFB_showHUD && _SQFB_opt_AlwaysShowCritical)) && _canSee >= 0.2) then {
                                if (_alive || (!_alive && _SQFB_opt_showDead && (_unit getVariable "SQFB_veh") == _unit)) then {
                                    private _zoom = 0;
                                    private _adjIconSize = 0;
                                    private _iconWidth = 0;
                                    private _iconHeight = 0;
                                    private _adjTextSize = 0;
                                    private _text_size = 0;
                                    private _resolution = getResolution;
                                    private _resHeight = _resolution select 1; 
                                    
                                    // Adjust sizes to distance
                                    if (_SQFB_opt_scaleText) then {
                                        _zoom = call SQFB_fnc_trueZoom;
                                        _adjIconSize = (_vehPlayer distance _veh) / 1000;

                                        _iconWidth = (((_resHeight * 0.001) - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5) max 0;
                                        _iconHeight = (((_resHeight * 0.001) - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5) max 0;

                                        _adjTextSize = ((_vehPlayer distance _veh) / 10000)  max 0;
                                        _text_size = (_zoom / 1000) + ((0.03 - _adjTextSize) max 0);
                                    } else {
                                        _iconWidth = (_resHeight * 0.001) max 0;
                                        _iconHeight = (_resHeight * 0.001) max 0;
                                        _text_size = 0.03;
                                    };

                                    _text_size = (_text_size * _SQFB_opt_textSize) max 0.02;
                                    private _width = (_iconWidth * _SQFB_opt_iconSize) max 0;
                                    private _height = _iconHeight * _SQFB_opt_iconSize;

                                    private _texture = "";
                                    private _color = _unit call SQFB_fnc_HUDColor;
                                    private _pos = (_unit selectionPosition "head");
                                    private _position = _unit modelToWorldVisual [
                                        (_pos select 0) + _SQFB_opt_iconHor,
                                        _pos select 1,
                                        (((_pos select 2) + 0.5) + _SQFB_opt_iconHeight) max 0
                                        ];
                                    private _angle = 0;
                                    private _text = "";
                                    private _shadow = true;
                                    private _font = _SQFB_opt_textFont;
                                    private _text_align = "center";
                                    private _arrows = _SQFB_opt_Arrows;


                                    // Check if unit is in a vehicle different from the player's
                                    if (_inVehDif) then {
                                        // Check if unit is the first in the vehicle's crew
                                        _text_size = (0.03 * _SQFB_opt_textSize) max 0.02;
                                        private _ownCrewFirstIdx = _crew findIf { _x in units group _unit && _x == _unit };
                                        private _isFirstUnit = false;
                                        if (_ownCrewFirstIdx != -1) then { _isFirstUnit = (_crew select _ownCrewFirstIdx) == _unit };
                                        if (_isFirstUnit) then {
                                            if (_SQFB_opt_showIcon || _text_size <= 0.02) then { _texture =  [_veh, _grp] call SQFB_fnc_HUDIconVeh };
                                            if (_SQFB_opt_showText && _text_size > 0.02) then { _text = [_veh, _SQFB_opt_showIndex, _SQFB_opt_showClass, _SQFB_opt_showRoles, _SQFB_opt_ShowCrew, _SQFB_opt_showDist] call SQFB_fnc_HUDtextVeh };
                                            //private _vehHeight = (_veh call BIS_fnc_objectHeight - 3);
                                            private _vehHeight = 1;
                                            _position = _veh modelToWorldVisual [
                                                _SQFB_opt_iconHorVeh,
                                                0,
                                                _vehHeight + _SQFB_opt_iconHeightVeh
                                                ];
                                            if (_SQFB_showHUD) then {    
                                                if (_SQFB_opt_scaleText) then {
                                                    _iconWidth = (1.5 - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;
                                                    _width = (_iconWidth * _SQFB_opt_iconSize) max 0;
                                                    _iconHeight = (0.8 - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;
                                                    _height = _iconHeight * _SQFB_opt_iconSize;
                                                } else {
                                                    _width = (1.5 * _SQFB_opt_iconSize) max 0;
                                                    _height = (0.8 * _SQFB_opt_iconSize) max 0;
                                                };
                                            };
                                        };                 
                                    } else {
                                        // Unit not in vehicle or in the same vehicle as player and player in 1st person POV
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
                                            _width,
                                            _height,
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
                            private _isVeh = if ((typeOf _unit) isKindOf "Man") then { false } else { true };
                            private _canSee = 1;
                            private _unitClass = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");
                            private _unitPos = position _veh;
                            private _dist = format ["%1m",round (_veh distance _vehPlayer)];
                            if (true) then { _canSee = if (_isVeh) then { [objNull, "VIEW"] checkVisibility [eyePos player, AtlToAsl(_unit modeltoworld [0,0,0])] } else { [objNull, "VIEW"] checkVisibility [eyePos player, eyePos _unit] }; };

                            private _zoom = 0;
                            private _adjIconSize = 6;
                            private _iconWidth = 0;
                            private _iconHeight = 0;
                            private _adjTextSize = 0;
                            private _text_size = 0;
                            private _resolution = getResolution;
                            private _resHeight = _resolution select 1; 
                            private _texture = "";
                            private _textureImg = "";
                            
                            // Adjust sizes to distance
                            if (true) then {
                                _zoom = call SQFB_fnc_trueZoom;
                                _adjIconSize = ((_vehPlayer distance _veh) / 1000) max 0;

                                _iconWidth = ((_resHeight * 0.0005) - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;
                                _iconHeight = ((_resHeight * 0.0005) - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;

                                _adjTextSize = ((_vehPlayer distance _veh) / 10000) max 0;
                                _text_size = (_zoom / 1000) + ((0.03 - _adjTextSize) max 0);
                            } else {
                                _iconWidth = (_resHeight * 0.0005) min 5;
                                _iconHeight = (_resHeight * 0.0005) min 5;
                                _text_size = 0.03;
                            };

                            _text_size = (_text_size * _SQFB_opt_textSize) max 0.02;
                            private _width = (_iconWidth * _SQFB_opt_iconSize) max 0;
                            private _height = (_iconHeight * _SQFB_opt_iconSize) max 0;

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
                            if (_canSee >= 0.2) then {
                                _enemy = _unit;
                            } else {
                                if (!isNull _enemyTagger) then {
                                    _enemy = _enemyTagger
                                } else {
                                    _enemy = _unit;
                                };
                            };

                            // Choose texture image
                            _textureImg = if (_enemy == _unit) then { "a3\ui_f\data\map\markers\nato\o_unknown.paa" } else {"a3\ui_f\data\map\markers\military\unknown_ca.paa" };

                            // Move enemy tagger to last known position
                            if (_enemy == _unit || (!isNull _enemyTagger && (_enemy == _enemyTagger && _enTagFirstTime))) then {
                                _enemyTagger setPos _unitPos;
                                if (_enTagFirstTime) then {
                                    _enTagFirstTime = false;
                                    _enemyTaggerArr set [2, false];
                                    // _textureImg = "a3\ui_f\data\map\markers\military\warning_ca.paa";
                                };
                            };

                            private _color = [_SQFB_opt_colorEnemy select 0,_SQFB_opt_colorEnemy select 1,_SQFB_opt_colorEnemy select 2, ([_enemy] call SQFB_fnc_HUDAlpha) max 0.5]; // Red

                            private _enemyPos = if (_enemy == _unit) then { (_enemy selectionPosition "head") } else { _enemy selectionPosition "camo2" };
                            // private _position = if (typeName _enemy == "OBJECT") then { 
                            private _position = if (_enemy == _unit) then  {
                                        _enemy modelToWorldVisual [
                                            (_enemyPos select 0) + _SQFB_opt_iconHor,
                                            _enemyPos select 1,
                                            (((_enemyPos select 2) + 0.8) + _SQFB_opt_iconHeight) max 0
                                        ];
                                    } else {
                                        _enemy modelToWorldVisual [
                                            (_enemyPos select 0),
                                            _enemyPos select 1,
                                            -1.5
                                        ];
                                    };
                            private _angle = 0;
                            private _text = "";
                            private _shadow = true;
                            private _font = _SQFB_opt_textFont;
                            private _text_align = "center";
                            private _arrows = false;

                            if (_isVeh) then {
                                // Check if unit is the first in the vehicle's crew
                                _text_size = (0.03 * _SQFB_opt_textSize) max 0.02;
                                if (_SQFB_opt_showIcon || _text_size <= 0.02) then {
                                    _texture =  _textureImg;
                                };
                                if (_SQFB_opt_showText && _text_size > 0.02) then {
                                    if (SQFB_opt_showDistEnemy) then { _text = _dist };
                                };
                                private _vehHeight = 1;
                                _position = if (_enemy == _unit) then  {
                                    _veh modelToWorldVisual [
                                        _SQFB_opt_iconHorVeh,
                                        0,
                                        _vehHeight + _SQFB_opt_iconHeightVeh
                                        ];
                                    } else {
                                        _enemy modelToWorldVisual [
                                            _SQFB_opt_iconHorVeh,
                                            0,
                                            -0.5
                                        ];
                                    };  
                                if (true) then {
                                    _iconWidth = (0.7 - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;
                                    _width = (_iconWidth * _SQFB_opt_iconSize) max 0;
                                    _iconHeight = (0.7 - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;
                                    _height = (_iconHeight * _SQFB_opt_iconSize) max 0;
                                } else {
                                    _width = (0.7 * _SQFB_opt_iconSize) max 0;
                                    _height = (0.7 * _SQFB_opt_iconSize) max 0;
                                };                
                            } else {
                                // Unit not in vehicle or in the same vehicle as player and player in 1st person POV
                                if (_SQFB_opt_showIcon || _text_size <= 0.02) then {
                                    _texture = _textureImg;
                                };
                                if (_SQFB_opt_showText && _text_size > 0.02) then {
                                    if (SQFB_opt_showDistEnemy) then { _text = _dist };
                                };
                            };

                            if (_text != "" || _texture != "") then {
                                drawIcon3D 
                                [
                                    _texture,
                                    _color,
                                    _position,
                                    _width,
                                    _height,
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
