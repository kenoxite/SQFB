// -----------------------------------------------
// SQUAD FEEDBACK - Init
// by kenoxite
// -----------------------------------------------

// Init
SQFB_debug = if (is3DENPreview) then { true } else { false };
SQFB_units = [];
SQFB_knownEnemies = [];
SQFB_showHUD = false;
SQFB_showDeadMinTime = 0;
SQFB_squadTimeLastCheck = time;
SQFB_opt_profile_old = SQFB_opt_profile;

SQFB_showEnemies = false;
SQFB_showEnemyHUD = false;
SQFB_showEnemiesMinTime = 0;
SQFB_enemyTagObjArr = [];
SQFB_enemiesTimeLastCheck = time;

SQFB_enemyTrackingGoggles_default = [
    "G_Balaclava_combat",
    "G_Combat",
    "G_Combat_Goggles_tna_F",
    "G_Balaclava_TI_G_blk_F",
    "G_Balaclava_TI_G_tna_F",
    "G_Tactical_Clear",
    "G_Tactical_Black",
    "G_Goggles_VR"
];
SQFB_enemyTrackingGoggles = [];

SQFB_enemyTrackingHeadgear_default = [
    "H_HelmetSpecoO_blk",
    "H_HelmetSpecoO_ghex_F",
    "H_HelmetSpecoO_ocamo",
    "H_HelmetLeaderO_ghex_F",
    "H_HelmetLeaderO_ocamo",
    "H_HelmetLeaderO_oucamo",
    "H_PilotHelmetFighter_I",
    "H_PilotHelmetFighter_O",
    "H_PilotHelmetFighter_I_E",
    "H_PilotHelmetFighter_B",
    "H_HelmetO_ViperSP_ghex_F",
    "H_HelmetO_ViperSP_hex_F"

    // "H_Hat_Tinfoil_F"
];
SQFB_enemyTrackingHeadgear = [];

SQFB_enemyTrackingHMD_default = [
    // "O_NVGoggles_ghex_F",
    // "O_NVGoggles_grn_F",
    // "O_NVGoggles_hex_F",
    // "O_NVGoggles_urb_F",
    // "O_NVGogglesB_blk_F",
    // "O_NVGogglesB_grn_F",
    // "O_NVGogglesB_gry_F"
];
SQFB_enemyTrackingHMD = [];

// Player traits
private _unitTraits = getAllUnitTraits player;
player setVariable ["SQFB_medic",(_unitTraits select { (_x select 0) == "Medic" } apply { _x select 1 }) select 0];

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
    if (SQFB_opt_on) then {
        private _screenPosition = worldToScreen (_x modelToWorldVisual _offset);
        if (_screenPosition isEqualTo []) exitWith {};

        if (count SQFB_units > 0) then {
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
            // Squad
            if (time > SQFB_squadTimeLastCheck + SQFB_opt_HUDrefresh) then {
                if (SQFB_opt_showSquad) then {
                    private _SQFB_units = SQFB_units;
                    private _SQFB_opt_GroupCrew = SQFB_opt_GroupCrew;
                    private _SQFB_opt_checkVisibility = SQFB_opt_checkVisibility;
                    private _SQFB_showHUD = SQFB_showHUD;
                    private _SQFB_opt_AlwaysShowCritical = SQFB_opt_AlwaysShowCritical;
                    private _SQFB_opt_showDead = SQFB_opt_showDead;
                    private _SQFB_opt_showClass = SQFB_opt_showClass;
                    private _SQFB_opt_showRoles = SQFB_opt_showRoles;
                    private _SQFB_opt_ShowCrew = SQFB_opt_ShowCrew;
                    private _SQFB_opt_showDist = SQFB_opt_showDist;
                    for "_i" from 0 to (count _SQFB_units) -1 do
                    {
                        if ((typeName (_SQFB_units select _i))!="STRING") then {
                            private _unit = _SQFB_units select _i; 
                            private _grp = group _unit; 
                            private _alive = alive _unit;
                            private _veh = vehicle _unit;
                            private _vehPlayer = vehicle player;
                            private _isPlayerAir = ((getPosASL _vehPlayer select 2) > 5 && !(isNull objectParent player));
                            private _dist = _vehPlayer distance _veh;
                            private _maxRange = [SQFB_opt_maxRange, SQFB_opt_maxRangeAir] select (_isPlayerAir);
                            // Skip units outside the max
                            if (_dist > _maxRange) then { continue };
                            
                            private _isOnFoot = isNull objectParent _unit;
                            private _unitPos = position _veh;
                            private _crew = crew _veh;
                            private _isFirstCrew = false;
                            private _isInVeh = _SQFB_opt_GroupCrew && !_isOnFoot && (_veh != _vehPlayer || cameraView != "INTERNAL");
                            private _canSee = [
                                                    1,
                                                    [
                                                        [objNull, "VIEW"] checkVisibility [eyePos player, eyePos _unit],
                                                        [objNull, "VIEW"] checkVisibility [eyePos player, AtlToAsl(_veh modeltoworld [0,0,0])]
                                                    ] select (_isInVeh)
                                                ] select (_SQFB_opt_checkVisibility);

                            if ((_SQFB_showHUD || (!_SQFB_showHUD && _SQFB_opt_AlwaysShowCritical)) && _canSee >= 0.2) then {
                                if (_alive || (!_alive && _SQFB_opt_showDead && (_unit getVariable "SQFB_veh") == _unit)) then {
                                    private _zoom = call SQFB_fnc_trueZoom;
                                    private _adjSize = 2; // TBH no idea why this is needed, but it's needed

                                    private _iconSize = [
                                                    [
                                                    ((linearConversion[ 0, _maxRange min 200, _dist, (1.8 * _adjSize) * _zoom, 0.3, true ])) min 1.8,
                                                    ((linearConversion[ 0, _maxRange min 200, _dist, (1.8 * _adjSize) * _zoom, 0.1, true ])) min 1.8
                                                    ] select (_isOnFoot),

                                                    [
                                                    ((linearConversion[ 0, _maxRange min 100, _dist, (2 * _adjSize) * _zoom, 0.3, true ])) min 2,
                                                    ((linearConversion[ 0, _maxRange min 100, _dist, (1.8 * _adjSize) * _zoom, 0.1, true ])) min 1.8
                                                    ] select (_isOnFoot)
                                                ] select (_isPlayerAir);

                                    private _text_size = [
                                                    [
                                                    ((linearConversion[ 0, _maxRange min 200, _dist, (0.052 * _adjSize) * _zoom, 0.02, true ])) min 0.052,
                                                    ((linearConversion[ 0, _maxRange min 200, _dist, (0.04 * _adjSize) * _zoom, 0.02, true ])) min 0.04
                                                    ] select (_isOnFoot),

                                                    [
                                                    0.03,
                                                    ((linearConversion[ 0, _maxRange min 200, _dist, (0.04 * _adjSize) * _zoom, 0.02, true ])) min 0.04
                                                    ] select (_isOnFoot)
                                                ] select (_isPlayerAir);

                                    _iconSize = _iconSize * _SQFB_opt_iconSize;
                                    _text_size = (_text_size * _SQFB_opt_textSize) max 0.02;

                                    private _color = _unit call SQFB_fnc_HUDColor;

                                    if (_isInVeh) then {
                                        // Check if unit is the first in the vehicle's crew
                                        private _ownCrewFirstIdx = _crew findIf { _x in units group _unit && _x == _unit };
                                        if (_ownCrewFirstIdx != -1) then { _isFirstCrew = (_crew select _ownCrewFirstIdx) == _unit };  
                                    };

                                    private _isMan = (typeOf _unit) isKindOf "Man";
                                    private _iconHeightMod = [0.4, 0.5] select (_isOnFoot);
                                    private _selectionPos = _unit selectionPosition "head";
                                    private _position = [
                                                            _unit modelToWorldVisual [
                                                                (_selectionPos select 0) + _SQFB_opt_iconHor,
                                                                _selectionPos select 1,
                                                                (_selectionPos select 2) + _iconHeightMod + _SQFB_opt_iconHeight
                                                            ],
                                                            _veh modelToWorldVisual [
                                                                _SQFB_opt_iconHorVeh,
                                                                0,
                                                                1 + _SQFB_opt_iconHeightVeh
                                                            ]
                                                        ] select (_isInVeh && _isFirstCrew);

                                    private _angle = 0;
                                    private _shadow = true;
                                    private _font = _SQFB_opt_textFont;
                                    private _text_align = "center";
                                    private _arrows = _SQFB_opt_Arrows;

                                    private _texture = [
                                                            if (_SQFB_opt_showIcon || _text_size <= 0.02) then { _unit call SQFB_fnc_HUDIcon },
                                                            if (_SQFB_opt_showIcon || _text_size <= 0.02) then { [_veh, _grp] call SQFB_fnc_HUDIconVeh }
                                                        ] select (_isInVeh && _isFirstCrew);

                                    private _text = [
                                                        if (_SQFB_opt_showText && _text_size > 0.02) then { [_unit] call SQFB_fnc_HUDtext },
                                                        if (_SQFB_opt_showText && _text_size > 0.02) then { [_veh, _SQFB_opt_showIndex, _SQFB_opt_showClass, _SQFB_opt_showRoles, _SQFB_opt_ShowCrew, _SQFB_opt_showDist] call SQFB_fnc_HUDtextVeh }
                                                    ] select (_isInVeh && _isFirstCrew);

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

            // Enemies
            if (time > SQFB_enemiesTimeLastCheck + SQFB_opt_HUDrefresh) then {
                private _gearCheck = call SQFB_fnc_trackingGearCheck;
                if (SQFB_showEnemies && SQFB_opt_showEnemiesIfTrackingGear && _gearCheck || {SQFB_showEnemies && !SQFB_opt_showEnemiesIfTrackingGear || {time >= SQFB_showEnemiesMinTime && SQFB_showEnemyHUD}}) then {
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

                            private _isOnFoot = (typeOf _veh isKindOf "Man");
                            private _canSee = [
                                                [objNull, "VIEW"] checkVisibility [eyePos player, AtlToAsl(_unit modeltoworld [0,0,0])],
                                                [objNull, "VIEW"] checkVisibility [eyePos player, eyePos _unit]
                                                ] select (_isOnFoot);
                            private _visThreshold = [0.2, 0.1] select (_isPlayerAir);
                            private _enemyVisible = _canSee >= _visThreshold;

                            // Skip if too close
                            private _minRange = [_SQFB_opt_showEnemiesMinRange, _SQFB_opt_showEnemiesMinRangeAir] select (_isPlayerAir);
                            if (_minRange > 0 && {_dist <= _minRange && _enemyVisible}) then { continue };

                            // Retrieve tagger object
                            private _enemyTagger = objNull;
                            private _enemyTaggerIndex = [_SQFB_enemyTagObjArr, _unit] call BIS_fnc_findNestedElement;
                            private _enemyTaggerArr = [];
                            private _enTagFirstTime = false;
                            if (count _enemyTaggerIndex > 0) then {
                                _enemyTaggerArr = _SQFB_enemyTagObjArr select (_enemyTaggerIndex select 0);
                                _enemyTagger = _enemyTaggerArr select 0;
                                _enTagFirstTime = _enemyTaggerArr select 2;
                            };
                            private _enemy = [
                                                [_unit, _enemyTagger] select (!isNull _enemyTagger),
                                                _unit
                                            ] select _enemyVisible;

                            // Move enemy tagger to last known position
                            if (_enemy == _unit || (!isNull _enemyTagger && (_enemy == _enemyTagger && _enTagFirstTime))) then {
                                _enemyTagger setPosWorld (getPosWorld _veh);
                                if (_enTagFirstTime) then {
                                    _enTagFirstTime = false;
                                    _enemyTaggerArr set [2, false];
                                };
                            };

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
                                                            0
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
                };
                SQFB_enemiesTimeLastCheck = time;
            };
        };
    };
}];
