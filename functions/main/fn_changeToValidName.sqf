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
    SQFB_trackNames pushBackUnique toLower _lastName;
    _currentName
};

// Choose last name based on the unit's voice
private _voice = toLower (speaker _unit);

private _namesArray = call {
    if (_voice in SQFB_voicesEnglish) exitWith {
        +SQFB_validNames_English
    };
    if (_voice in SQFB_voicesPersian) exitWith {
        +SQFB_validNames_Persian
    };
    if (_voice in SQFB_voicesGreek) exitWith {
        +SQFB_validNames_Greek
    };
    if (_voice in SQFB_voicesPolish) exitWith {
        +SQFB_validNames_Polish
    };
    if (_voice in SQFB_voicesRussian) exitWith {
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
SQFB_trackNames pushBackUnique _lastName;

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
