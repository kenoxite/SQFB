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

private _playerOnFoot = isNull objectParent SQFB_player;
private _vehPlayer = vehicle SQFB_player;
private _playerInDrone = call SQFB_fnc_playerInDrone;
private _isPlayerAir = (!_playerOnFoot && {(getPosASL _vehPlayer select 2) > 5});

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
private _SQFB_opt_maxAlpha = SQFB_opt_maxAlpha;

private _SQFB_units = SQFB_units;
private _SQFB_opt_GroupCrew = SQFB_opt_GroupCrew;
private _SQFB_opt_checkOcclusion = SQFB_opt_checkOcclusion;
private _SQFB_showHUD = SQFB_showHUD;
private _SQFB_opt_AlwaysShowCritical = SQFB_opt_AlwaysShowCritical;
private _SQFB_opt_showDead = SQFB_opt_showDead;
private _SQFB_opt_showName = SQFB_opt_showName;
private _SQFB_opt_showClass = SQFB_opt_showClass;
private _SQFB_opt_showRoles = SQFB_opt_showRoles;
private _SQFB_opt_ShowCrew = SQFB_opt_ShowCrew;
private _SQFB_opt_showDist = SQFB_opt_showDist;
private _SQFB_opt_profile = SQFB_opt_profile;
private _SQFB_opt_outFOVindex = SQFB_opt_outFOVindex;
private _SQFB_opt_preciseDist = SQFB_opt_preciseDist;

private _SQFB_showDeadMinTime = SQFB_showDeadMinTime;

private _cameraView = cameraView;

private _vehData = [];
for "_i" from 0 to (count _SQFB_units) -1 do
{
    if ((typeName (_SQFB_units select _i))!="STRING") then {
        private _unit = _SQFB_units select _i; 
        private _grp = group _unit; 
        private _alive = alive _unit;
        private _veh = vehicle _unit;
        private _dist = _vehPlayer distance _veh;
        private _maxRange = [SQFB_opt_maxRange, SQFB_opt_maxRangeAir] select (_isPlayerAir);

        // Skip units outside the max
        if (_dist > _maxRange) then { continue };

        private _isFormLeader = formationLeader _vehPlayer == _unit;
        
        private _isOnFoot = isNull objectParent _unit;
        private _unitPos = getPosWorld _veh;
        private _unitVisibility = [
                                        1,
                                        [
                                            [objNull, "VIEW"] checkVisibility [eyePos SQFB_player, eyePos _unit],
                                            [objNull, "VIEW"] checkVisibility [eyePos SQFB_player, AtlToAsl(_veh modeltoworld [0,0,0])]
                                        ] select _isOnFoot
                                    ] select _SQFB_opt_checkOcclusion;
        private _unitOccluded = _unitVisibility < 0.2;
        private _unitVisible = [_playerPos, _camDir, ceil((call CBA_fnc_getFov select 0)*100), _unitPos] call BIS_fnc_inAngleSector;
        
        if (!_unitOccluded) then {
            if (_alive || (!_alive && _SQFB_opt_showDead && (_unit getVariable "SQFB_veh") == _unit)) then {
                private _zoom = call SQFB_fnc_trueZoom;
                private _adjSize = 2; // TBH no idea why this is needed, but it's needed

                private _iconSizeBase = [
                                        [
                                            ((linearConversion[ 0, _maxRange min 200, _dist, (1.5 * _adjSize) * _zoom, 0.3, true ])) min 1.5,
                                            ((linearConversion[ 0, _maxRange min 200, _dist, (1.8 * _adjSize) * _zoom, 0.1, true ])) min 1.8
                                        ] select _isOnFoot,

                                        [
                                            ((linearConversion[ 0, _maxRange min 100, _dist, (2 * _adjSize) * _zoom, 0.3, true ])) min 2,
                                            ((linearConversion[ 0, _maxRange min 100, _dist, (1.8 * _adjSize) * _zoom, 0.1, true ])) min 1.8
                                        ] select _isOnFoot
                                    ] select _isPlayerAir;

                private _textSizeBase = [
                                        0.03,
                                        [
                                            [
                                                ((linearConversion[ 0, _maxRange min 200, _dist, (0.052 * _adjSize) * _zoom, 0.02, true ])) min 0.052,
                                                ((linearConversion[ 0, _maxRange min 200, _dist, (0.04 * _adjSize) * _zoom, 0.02, true ])) min 0.04
                                            ] select _isOnFoot,

                                            ((linearConversion[ 0, _maxRange min 200, _dist, (0.04 * _adjSize) * _zoom, 0.02, true ])) min 0.04
                                        ] select _isPlayerAir
                                    ] select (_SQFB_opt_scaleText || (!_SQFB_opt_scaleText && _cameraView == "GUNNER" && !_playerInDrone));

                private _iconSize = _iconSizeBase * _SQFB_opt_iconSize;
                private _textSize = (_textSizeBase * _SQFB_opt_textSize) max 0.02;

                private _color = [_unit, _dist, _maxRange, _SQFB_opt_maxAlpha] call SQFB_fnc_HUDColor;

                // Check whether crew info should be displayed as a vehicle or as separate units
                private _displayIndividualCrew = _SQFB_opt_GroupCrew && !_isOnFoot && (_veh != _vehPlayer || (_veh == _vehPlayer && cameraView != "INTERNAL"));
                private _isFirstCrew = false;
                if (_displayIndividualCrew) then {
                    // Check if unit is the first from this group in the vehicle's crew
                    private _inVehData = [_vehData, _veh] call BIS_fnc_findNestedElement;
                    if (count _inVehData > 0) then {
                        _isFirstCrew = ((_vehData select (_inVehData select 0)) select 1) == _unit;
                    } else {
                        _vehData pushBackUnique [_veh, _unit];
                        _isFirstCrew = true;
                    };
                };
                private _displayAsVehicle = (_displayIndividualCrew && _isFirstCrew) || (!_isOnFoot && _veh != _vehPlayer);

                private _texture = [
                                        [
                                            "",
                                            [_unit, _SQFB_opt_profile, _SQFB_opt_showDead, _SQFB_showDeadMinTime, _SQFB_opt_AlwaysShowCritical, _SQFB_opt_showText] call SQFB_fnc_HUDIcon
                                        ] select (!_unitOccluded && (_SQFB_opt_showIcon || "icon" in _SQFB_opt_AlwaysShowCritical || _textSize <= 0.02) && (_isOnFoot || (!_isOnFoot && _veh == _vehPlayer && cameraView == "INTERNAL"))),

                                        [
                                            "",
                                            [_veh, _grp, _SQFB_opt_AlwaysShowCritical, _SQFB_opt_showText] call SQFB_fnc_HUDIconVeh
                                        ] select (!_unitOccluded && (_SQFB_opt_showIcon || "icon" in _SQFB_opt_AlwaysShowCritical || _textSize <= 0.02))
                                    ] select _displayAsVehicle;

                private _text = [
                                    [
                                        "",
                                        [_unit, _unitVisible, _SQFB_opt_showIndex, _SQFB_opt_AlwaysShowCritical, _SQFB_opt_showName, _SQFB_opt_showClass, _SQFB_opt_showRoles, _SQFB_opt_showDist, _SQFB_opt_outFOVindex, _SQFB_opt_profile, true] call SQFB_fnc_HUDtext
                                    ] select (_SQFB_opt_showText && _textSize > 0.02 && (_isOnFoot || (!_isOnFoot && (_veh == _vehPlayer && cameraView == "INTERNAL")))),
                                    
                                    [
                                        "",
                                        [_veh, _unitVisible, _SQFB_opt_showIndex, _SQFB_opt_showClass, _SQFB_opt_showRoles, _SQFB_opt_ShowCrew, _SQFB_opt_showDist, _SQFB_opt_profile, _SQFB_opt_AlwaysShowCritical, _SQFB_opt_outFOVindex, true] call SQFB_fnc_HUDtextVeh
                                    ] select (_SQFB_opt_showText && _textSize > 0.02)
                                ] select _displayAsVehicle;

                private _iconHeightMod = [
                                            [0.1, 0] select (_text == ""),
                                            [0.3, 0.2] select (_text == "")
                                        ] select (_isOnFoot);
                private _selectionPos = _unit selectionPosition ["head", "HitPoints"];
                // private _selectionPos = selectionPosition [_unit, "head", 12, true];
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
                                    ] select _displayAsVehicle;

                _position set [2, (_position select 2) + ((_dist * ([0.02, 0.03] select _SQFB_opt_scaleText)) min 2)]; // Hack to keep the icons more or less at the same height no matter the distance

                private _angle = 0;
                private _shadow = true;
                private _font = _SQFB_opt_textFont;
                private _textAlign = "center";
                private _arrows = _SQFB_opt_Arrows;

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
    };
};
