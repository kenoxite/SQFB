/*
  Author: kenoxite

  Description:
  Sets a callsign for each unit in the player's squad


  Parameter (s):


  Returns:


  Examples:

*/

params [["_unit", objNull], ["_forcedType", ""]];
if (isNull _unit) exitWith {true};

// Skip units with already set callsigns
private _originalNameSound = _unit getVariable "SQFB_originalNameSound";
private _nameSound = nameSound _unit;
if (isNil "_originalNameSound") then { _unit setVariable ["SQFB_originalNameSound", _nameSound]; _originalNameSound = _nameSound; };
if (_originalNameSound != "") exitWith { _nameSound };

// Check if callsign has changed by the mission since mission init
private _newNameSound = _unit getVariable ["SQFB_newNameSound", _originalNameSound];
if (_unit != SQFB_player && {tolower _newNameSound != tolower _nameSound && _nameSound != ""}) exitWith { _nameSound };

// Player
if (_unit == SQFB_player) exitWith {
    if (SQFB_opt_playerCallsign > 0) then {
        _nameSound = SQFB_validCodeNames #(SQFB_opt_playerCallsign - 1);
        SQFB_player setNameSound _nameSound;
    };
    _nameSound
};

private _mode = [SQFB_opt_nameSoundType, _forcedType] select (_forcedType != "");

private _lastName = "";
private _nameIsValid = false;
_nameSound = call {
    // None
    if (_mode == "none") exitWith {
        _originalNameSound
    };
    // Name
    if (_mode == "name") exitWith {
        private _nameArr = [name _unit, " "] call BIS_fnc_splitString;
        _lastName = [
                                _nameArr #0,
                                _nameArr #1
                            ] select (count _nameArr > 1);
        _nameIsValid = toLower _lastName in SQFB_validNames;
        if (_nameIsValid) exitWith { _lastName };
        ""
    };
    // Role
    if (_mode == "role") exitWith {
        if (_unit getVariable "SQFB_medic") exitWith { "veh_infantry_medic_s" };
        if (_unit getVariable "SQFB_AA") exitWith { "veh_infantry_AA_s" };
        if (_unit getVariable "SQFB_AT") exitWith { "veh_infantry_AT_s" };
        if (_unit getVariable "SQFB_MG") exitWith { "veh_infantry_MG_s" };
        if (_unit getVariable "SQFB_sniper") exitWith { "veh_infantry_Sniper_s" };
        if (_unit getVariable "SQFB_hacker") exitWith { "veh_infantry_SF_s" };
        "veh_infantry_s"
    };
    ""
};

// Default to role if no valid last name is found
if (_mode == "name" && {!_nameIsValid}) exitWith { [_unit, "role"] call SQFB_fnc_setNameSound };

_unit setNameSound _nameSound;
_unit setVariable ["SQFB_newNameSound", _nameSound];

_nameSound
