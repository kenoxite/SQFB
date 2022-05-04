/*
  Author: kenoxite

  Description:
  Returns the real side of the unit's faction, regardless of the current unit's side


  Parameter (s):
  _this select 0: _unit
 

  Returns:


  Examples:

*/

params ["_unit"];

// Exit with current side if player only wants that
if (SQFB_opt_enemySideColors == "current") exitWith { side _unit };

// Otherwise check for the faction's real side
private _side = sideUnknown;
private _factionClass = faction _unit;

if (_factionClass in SQFB_factionsWest) exitWith { west };
if (_factionClass in SQFB_factionsEast) exitWith { east };
if (_factionClass in SQFB_factionsGuer) exitWith { resistance };
if (_factionClass in SQFB_factionsCiv) exitWith { civilian };

// If not in the default arrays then check for the faction config data
private _factionData = [];
{
    private _thisSideNum = getNumber (_x >> "side");
    call {
        if (_thisSideNum == 1) exitWith {
            _side = west;
            SQFB_factionsWest pushBackUnique _factionClass;
        };
        if (_thisSideNum == 0) exitWith {
            _side = east;
            SQFB_factionsEast pushBackUnique _factionClass;
        };
        if (_thisSideNum == 2) exitWith {
            _side = resistance;
            SQFB_factionsGuer pushBackUnique _factionClass;
        };
        if (_thisSideNum == 3) exitWith {
            _side = civilian;
            SQFB_factionsCiv pushBackUnique _factionClass;
        };
        // Default to east
        if (_side == sideUnknown) exitWith {
            _side = east;
            SQFB_factionsEast pushBackUnique _factionClass;
        };
    };
} forEach ("((configName _x) == _factionClass)" configClasses (configFile >> "CfgFactionClasses"));

_side