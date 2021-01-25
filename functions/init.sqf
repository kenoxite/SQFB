// -----------------------------------------------
// SQUAD FEEDBACK - Init
// by kenoxite
// -----------------------------------------------

// Init
SQFB_units = [];
SQFB_showHUD = false;

waitUntil {!isNull player};

// Init player group
private _grp = group player;
private _units = units _grp;
SQFB_unitCount = count _units;
[_grp] call SQFB_fnc_initGroup;
// Add units to the global array
[_units] call SQFB_fnc_addUnits;

// Keep track of group status
SQFB_EH_refresh = [{ if (SQFB_opt_on) then { [] call SQFB_fnc_updateHUD }; }, SQFB_opt_refreshRate, []] call CBA_fnc_addPerFrameHandler;

// SQFB_EH_refresh = [{ if (SQFB_opt_on) then { [] call SQFB_fnc_updateHUD }; onTeamSwitch {(_grp (_this select 1)) call SQFB_fnc_checkGroupChange;}; }, SQFB_opt_refreshRate, []] call CBA_fnc_addPerFrameHandler;

// HUD display
SQFB_draw3D_EH = addMissionEventHandler [
"Draw3D",
{
	if (count SQFB_units > 0 && SQFB_opt_on) then {
		{
			if ((typeName _x)!="STRING") then {
				private _unit = _x;	
				private _grp = group _unit;	
				private _alive = alive _unit;
				private _veh = vehicle _unit;
				private _vehPlayer = vehicle player;
				private _crew = crew _veh;
				private _inVehDif = SQFB_opt_GroupCrew && _veh != _unit && (_veh != _vehPlayer || cameraView != "INTERNAL");
				private _canSee = 1;
				if (SQFB_opt_checkVisibility) then { _canSee = [objNull, "VIEW"] checkVisibility [eyePos player, eyePos _unit]; };

				if ((SQFB_showHUD || (!SQFB_showHUD && SQFB_opt_showCritical)) && _canSee >= 0.2) then {
					if (_alive || (!_alive && SQFB_opt_showDead && (_unit getVariable "SQFB_veh") == _unit)) then {

						private _zoom = 0;
						private _adjIconSize = 0;
						private _iconWidth = 0;
						private _iconHeight = 0;
						private _adjTextSize = 0;
						private _text_size = 0;
						private _resolution = getResolution;
						private _resHeight = _resolution select 1; 
						
						// Adjust sizes to distance
						if (SQFB_opt_scaleText) then {
							_zoom = call SQFB_fnc_trueZoom;
							_adjIconSize = (_vehPlayer distance _veh) / 1000;

							_iconWidth = ((_resHeight * 0.001) - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;
							_iconHeight = ((_resHeight * 0.001) - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;

							_adjTextSize = (_vehPlayer distance _veh) / 10000;
							_text_size = (_zoom / 1000) + ((0.03 - _adjTextSize) max 0);
						} else {
							_iconWidth = (_resHeight * 0.001);
							_iconHeight = (_resHeight * 0.001);
							_text_size = 0.03;
						};

						_text_size = (_text_size * SQFB_opt_textSize) max 0.02;
						private _width = (_iconWidth * SQFB_opt_iconSize) max 0;
						private _height = _iconHeight * SQFB_opt_iconSize;

						private _texture = "";
						private _color = _unit call SQFB_fnc_teamColor;
						private _pos = (_unit selectionPosition "head");
						private	_position = _unit modelToWorldVisual [
							(_pos select 0) + SQFB_opt_iconHor,
							_pos select 1,
							(((_pos select 2) + 0.5) + SQFB_opt_iconHeight) max 0
							];
						private _angle = 0;
						private _text = "";
						private _shadow = true;
						private _font = SQFB_opt_textFont;
						private _text_align = "center";
						private _arrows = SQFB_opt_Arrows;


						// Check if unit is in a vehicle different from the player's
						if (_inVehDif) then {
							// Check if unit is the first in the vehicle's crew
							//_text_size = ((_text_size * 1.2) * SQFB_opt_textSize) max 0.02;
							_text_size = (0.03 * SQFB_opt_textSize) max 0.02;
							private _ownCrewFirstIdx = _crew findIf { _x in units group _unit && _x == _unit };
							private _isFirstUnit = false;
							if (_ownCrewFirstIdx != -1) then { _isFirstUnit = (_crew select _ownCrewFirstIdx) == _unit };
							if (_isFirstUnit) then {
								if (SQFB_opt_showIcon || _text_size <= 0.02) then { _texture =  [_veh, _grp] call SQFB_fnc_statusIconVeh };
								if (SQFB_opt_showText && _text_size > 0.02) then { _text = [_veh, SQFB_opt_showIndex, SQFB_opt_showClass, SQFB_opt_showRoles, SQFB_opt_ShowCrew, SQFB_opt_showDist] call SQFB_fnc_HUDtextVeh };
								//private _vehHeight = (_veh call BIS_fnc_objectHeight - 3);
								private _vehHeight = 1;
								_position = _veh modelToWorldVisual [
									SQFB_opt_iconHorVeh,
									0,
									_vehHeight + SQFB_opt_iconHeightVeh
									];
								if (SQFB_showHUD) then {	
									if (SQFB_opt_scaleText) then {
										_iconWidth = (1.5 - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;
										_width = (_iconWidth * SQFB_opt_iconSize) max 0;
										_iconHeight = (0.8 - _adjIconSize) max 0.1 + (_zoom * 0.04) min 5;
										_height = _iconHeight * SQFB_opt_iconSize;
									} else {
										_width = (1.5 * SQFB_opt_iconSize) max 0;
										_height = 0.8 * SQFB_opt_iconSize;
									};
								};
							};					
						} else {
							// Unit not in vehicle or in the same vehicle as player and player in 1st person POV
							if (SQFB_opt_showIcon || _text_size <= 0.02) then {
								_texture =  _unit call SQFB_fnc_statusIcon;
							};
							if (SQFB_opt_showText && _text_size > 0.02) then {
								_text = [_unit, SQFB_opt_showIndex, SQFB_opt_showClass, SQFB_opt_showRoles, SQFB_opt_showDist] call SQFB_fnc_HUDtext;
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
		} foreach SQFB_units;
	};
}];

