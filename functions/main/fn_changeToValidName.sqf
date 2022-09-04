/*
  Author: kenoxite

  Description:
  Changes the unit's last name to one with recorded voice lines


  Parameter (s):


  Returns:


  Examples:

*/

params [["_unit", objNull]];
if (isNull _unit) exitWith {true};

// Check if current name is valid
private _currentName = name _unit;
private _nameArr = [_currentName, " "] call BIS_fnc_splitString;
private _firstName = [
                        "",
                        _nameArr #0
                    ] select (count _nameArr > 1);
private _lastName = [
                        _nameArr #0,
                        _nameArr #1
                    ] select (count _nameArr > 1);
private _nameIsValid = toLower _lastName in SQFB_validNames;
if (_nameIsValid) exitWith {
    SQFB_trackNames pushBack toLower _lastName;
    _currentName
};

// Choose last name based on the player's side and faction
private _faction = faction player;
private _factionsEnglish = [
    "BLU_F",
    "BLU_T_F",
    "BLU_CTRG_F",
    "BLU_W_F"
];
private _factionsPersian = [
    "OPF_F"
];
private _factionsGreek = [
    "BLU_G_F",
    "OPF_G_F",
    "IND_F",
    "IND_G_F"
];
private _factionsPolish = [
    "IND_E_F",
    "IND_L_F"
];
private _factionsRussian = [
    "OPF_R_F"
];
private _namesArray = call {
    if (_faction in _factionsEnglish) exitWith {
        +SQFB_validNames_English
    };
    if (_faction in _factionsPersian) exitWith {
        +SQFB_validNames_Persian
    };
    if (_faction in _factionsGreek) exitWith {
        +SQFB_validNames_Greek
    };
    if (_faction in _factionsPolish) exitWith {
        +SQFB_validNames_Polish
    };
    if (_faction in _factionsRussian) exitWith {
        +SQFB_validNames_Russian
    };
    []
};

// Don't change if faction isn't recognized as valid
if (count _namesArray == 0) exitWith { "" };

// Try not to repeat names
{
    _namesArray = _namesArray - [_x];
} forEach SQFB_trackNames;
if (count _namesArray == 0) then {
    _namesArray = +SQFB_trackNames;
    SQFB_trackNames = [];
};

// Pick the name
_lastName = selectRandom _namesArray;
SQFB_trackNames pushBack _lastName;

// Capitalize the name
private _unicodeName = toArray _lastName;
private _firstLetter = toUpper (toString [_unicodeName #0]);
_unicodeName deleteat 0;
_lastName = [_firstLetter, toString _unicodeName] joinString "";

// Set the name
_nameArr set [(count _nameArr)-1, _lastName];
private _fullName = trim(_nameArr joinString " ");
_unit setName [_fullName, _firstName, _lastName];

_fullName
