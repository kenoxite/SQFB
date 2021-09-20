/*
  Author: kenoxite

  Description:
  Draws the known enemies HUD


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
        private _unitPos = getPosWorld _veh;
        private _unitVisibility = [
                                        1,
                                        [
                                            [objNull, "VIEW"] checkVisibility [eyePos player, eyePos _unit],
                                            [objNull, "VIEW"] checkVisibility [eyePos player, AtlToAsl(_veh modeltoworld [0,0,0])]
                                        ] select (_isOnFoot)
                                    ] select (_SQFB_opt_checkVisibility);
        private _unitOccluded = _unitVisibility < 0.2;
        private _unitVisible = [ getPosWorld _vehPlayer, [0,0,0] getdir getCameraViewDirection player, (getObjectFOV _vehPlayer) * 120, _unitPos ] call BIS_fnc_inAngleSector;
        if (_unitVisible && !_unitOccluded && (_SQFB_showHUD || (!_SQFB_showHUD && _SQFB_opt_AlwaysShowCritical)) || (!_unitVisible && SQFB_opt_outFOVindex)) then {
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

                // Check wether info should be displayed as a vehicle or as separate units
                private _isFirstCrew = false;
                private _isInVeh = _SQFB_opt_GroupCrew && !_isOnFoot && (_veh != _vehPlayer || cameraView != "INTERNAL");
                if (_isInVeh) then {
                    // Check if unit is the first from this group in the vehicle's crew
                    private _crew = crew _veh;
                    private _ownCrewFirstIdx = _crew findIf { _x in units group _unit && _x == _unit };
                    if (_ownCrewFirstIdx > -1 && !_isFirstCrew) then { _isFirstCrew = (_crew select _ownCrewFirstIdx) == _unit };  
                };
                private _displayAsVehicle = _isInVeh && _isFirstCrew;

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
                                    ] select _displayAsVehicle;

                private _angle = 0;
                private _shadow = true;
                private _font = _SQFB_opt_textFont;
                private _text_align = "center";
                private _arrows = _SQFB_opt_Arrows;

                private _texture = [
                                        [
                                            "",
                                            _unit call SQFB_fnc_HUDIcon
                                        ] select (!_unitOccluded && (_SQFB_opt_showIcon || _text_size <= 0.02)),

                                        [
                                            "",
                                            [_veh, _grp] call SQFB_fnc_HUDIconVeh
                                        ] select (!_unitOccluded && (_SQFB_opt_showIcon || _text_size <= 0.02))
                                    ] select _displayAsVehicle;

                private _text = [
                                    [
                                        "",
                                        [_unit] call SQFB_fnc_HUDtext
                                    ] select (_SQFB_opt_showText && _text_size > 0.02),
                                    
                                    [
                                        "",
                                        [_veh, _SQFB_opt_showIndex, _SQFB_opt_showClass, _SQFB_opt_showRoles, _SQFB_opt_ShowCrew, _SQFB_opt_showDist] call SQFB_fnc_HUDtextVeh
                                    ] select (_SQFB_opt_showText && _text_size > 0.02)
                                ] select _displayAsVehicle;

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
