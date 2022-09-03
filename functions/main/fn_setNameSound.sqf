/*
  Author: kenoxite

  Description:
  Adds custom items to the corresponding enemy tracking gear array 


  Parameter (s):


  Returns:


  Examples:

*/

params [["_unit", objNull]];
if (isNull _unit) exitWith {true};

private _originalNameSound = _unit getVariable "SQFB_originalNameSound";
private _nameSound = nameSound _unit;
if (isNil "_originalNameSound") then { _unit setVariable ["SQFB_originalNameSound", _nameSound]; _originalNameSound = _nameSound; };
if (_originalNameSound != "") exitWith { true }; // Skip units with already set callsigns

private _mode = SQFB_opt_nameSoundType;
private _validNames = [
    "Armstrong",
    "Nichols",
    "Tanny",
    "Frost",
    "Lacey",
    "Larkin",
    "Kerry",
    "Jackson",
    "Miller",
    "McKendrick",
    "Levine",
    "Reynolds",
    "Adams",
    "Bennett",
    "Campbell",
    "Dixon",
    "Everett",
    "Franklin",
    "Givens",
    "Hawkins",
    "Lopez",
    "Martinez",
    "O'Connor",
    "Ryan",
    "Patterson",
    "Sykes",
    "Taylor",
    "Walker",

    "Amin",
    "Masood",
    "Fahim",
    "Habibi",
    "Kushan",
    "Jawadi",
    "Nazari",
    "Siddiqi",
    "Takhtar",
    "Wardak",
    "Yousuf",

    "Anthis",
    "Costa",
    "Dimitirou",
    "Elias",
    "Gekas",
    "Kouris",
    "Leventis",
    "Markos",
    "Nikas",
    "Nicolo",
    "Panas",
    "Petros",
    "Rosi",
    "Samaras",
    "Stavrou",
    "Thanos",
    "Vega"
];

_nameSound = call {
    // None
    if (_mode == "none") exitWith {
        _originalNameSound
    };
    // Name
    if (_mode == "name") exitWith {
        private _nameArr = [name _unit, " "] call BIS_fnc_splitString;
        private _lastName = [
                                _nameArr #0,
                                _nameArr #1
                            ] select (count _nameArr > 1);
        if (_lastName in _validNames) exitWith { _lastName };
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

_unit setNameSound _nameSound;
