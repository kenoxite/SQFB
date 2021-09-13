/*
  Author: kenoxite

  Description:
  Update the displayed feedback for a single unit


  Parameter (s):
  _this select 0: _unit
 

  Returns:


  Examples:

*/

params ["_unit",["_event",""]];

if (!SQFB_opt_on) exitWith {true};

// Invalid unit
if ((typeName _unit) == "STRING") then { _unit = objNull; }; 

// Reset unit variables
_unit call SQFB_fnc_resetUnit;

// Exclude players
if (isPlayer _unit) exitWith {true};

private _alive = alive _unit;
private _grp = group _unit;
private _roles = [];
private _displayName = "";
private _rolesStr = "";
private _grpIndex = "";
private _medic = false;
private _engi = false;
private _hacker = false;
private _AT = false;
private _sniper = false;
private _anySniper = false;
private _MG = false;
private _demo = false;
private _anyMG = false;
private _AA = false;
private _GL = false;

private _primWep = primaryWeapon _unit;
private _secWep = secondaryWeapon _unit;
private _primWepType = (_primWep call BIS_fnc_itemType) select 1;
private _secWepType = if (_secWep != "") then { (_secWep call BIS_fnc_itemType) select 1 } else {""}; 
private _primWepMags = primaryWeaponMagazine _unit;
private _secWepMags = if (_secWep != "") then { secondaryWeaponMagazine _unit } else {""}; 
private _secWepMagName = if (_secWep != "") then { if (count _secWepMags > 0) then { _secWepMags select 0 } else {""} } else {""};  
private _mags = (magazines _unit);
_mags append [currentMagazine _unit];
private _mag = "";
private _compatPrimMags = [_primWep] call BIS_fnc_compatibleMagazines;
private _primMagCount = { _mag = _x; _compatPrimMags findIf { _x == _mag } != -1} count _mags;
private _compatSecMags = if (_secWep != "") then { [_secWep] call BIS_fnc_compatibleMagazines } else {[]};
private _secMagCount = if (_secWep != "") then { { _mag = _x; _compatSecMags findIf { _x == _mag } != -1} count _mags } else {0};
private _items = items _unit;
private _hasMines = if (_mags findIf { ((_x call BIS_fnc_itemType) select 0) == "Mine"} != -1) then { true } else { false };
private _noAmmo = false;
private _noAmmoPrim = false;
private _noAmmoSec = false;

// Ammo check - primary
if (_primWep != "") then {
	if (count _primWepMags > 0) then {
		if (_primMagCount > 0) then {
			_noAmmoPrim = false;
		} else {
			_noAmmoPrim = true;
		};
	} else {
		_noAmmoPrim = true;
	};
} else {
	_noAmmoPrim = false;
};
_unit setVariable ["SQFB_noAmmoPrim",_noAmmoPrim];

// Ammo check - secondary
if (_secWep != "") then {
	if (count _secWepMags > 0) then {
		if (_secMagCount > 0 || (_unit ammo _secWep) > 0) then {
			_noAmmoSec = false;
		} else {
			_noAmmoSec = true;
		};
	} else {
		_noAmmoSec = true;
	};
} else {
	_noAmmoSec = false;
};
_unit setVariable ["SQFB_noAmmoSec",_noAmmoSec];

// Ammo check - global
if (_noAmmoPrim || _noAmmoSec) then { _noAmmo = true } else {_noAmmo = false  };
_unit setVariable ["SQFB_noAmmo",_noAmmo];

// Group index
_grpIndex = _unit call SQFB_fnc_getUnitPositionId;
_unit setVariable ["SQFB_grpIndex",_grpIndex];

// Editor class name
_displayName = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName");
_unit setVariable ["SQFB_displayName",_displayName];


private _unitTraits = getAllUnitTraits _unit;   
private _indexes = [_unitTraits, "Medic"] call BIS_fnc_findNestedElement;
private  _isMedic = if (alive _unit) then { _unitTraits select (_indexes select 0) select 1 } else { false };  

_indexes = [_unitTraits, "Engineer"] call BIS_fnc_findNestedElement;   
private _isEngi = if (alive _unit) then {_unitTraits select (_indexes select 0) select 1 } else { false }; 

_indexes = [_unitTraits, "ExplosiveSpecialist"] call BIS_fnc_findNestedElement;   
private _isDemo = if (alive _unit) then {_unitTraits select (_indexes select 0) select 1 } else { false }; 

_indexes = [_unitTraits, "UavHacker"] call BIS_fnc_findNestedElement;   
private _isHacker = if (alive _unit) then {_unitTraits select (_indexes select 0) select 1 } else { false }; 

// Medic
if (_isMedic && {"Medikit" in _items}) then {_medic = true;  _roles pushBack "Medic"} else { _medic = false; };
_unit setVariable ["SQFB_medic",_medic];

// Demolition specialist
if (_isDemo && {(_hasMines || "MineDetector" in _items || "ToolKit" in _items)}) then { _demo = true;  _roles pushBack "Demo" } else { _demo = false; };
_unit setVariable ["SQFB_demo",_demo];

// Engineer
if (_isEngi && {"ToolKit" in _items}) then { _engi = true;  _roles pushBack "Engi" } else { _engi = false; };
_unit setVariable ["SQFB_engi",_engi];

// Hacker
if (_isHacker) then { _hacker = true;  _roles pushBack "Hacker" } else { _hacker = false; };
_unit setVariable ["SQFB_hacker",_hacker];

// AntiAir
if (("_AA" in _secWepMagName)) then { _AA = true; _roles pushBack "AA" } else { _AA = false; };
_unit setVariable ["SQFB_AA",_AA];

// AntiTank
if ((_secWepType == "Launcher" || _secWepType == "MissileLauncher" || _secWepType == "RocketLauncher") && !_AA) then { _AT = true; _roles pushBack "AT" } else { _AT = false; };
_unit setVariable ["SQFB_AT",_AT];

// Grenade Launcher
if (_primWepType == "GrenadeLauncher" || "GL_" in _primWep) then { _GL = true; _roles pushBack "GL" } else { _GL = false; };
_unit setVariable ["SQFB_GL",_GL];

// Machine Gun
if (!_anyMG && {"Light Machine Gun" in (getText (configFile >> "CfgWeapons" >> _primWep >> "descriptionShort"))}) then { _anyMG = true; _roles pushBack "LMG" };
if (!_anyMG && {_primWepType == "MachineGun" || "RPK" in _primWep}) then { _anyMG = true; _roles pushBack "MG" };
if (_anyMG) then { _MG = true; } else { _MG = false; };
_unit setVariable ["SQFB_MG",_MG];

// Sniper
if (!_anySniper && {_primWepType == "SniperRifle"}) then { _anySniper = true; _roles pushBack "Sniper" };
if (!_anySniper && {("DMS_" in _primWep || "MXM_" in _primWep)}) then { _anySniper = true; _roles pushBack "Marksman" };
if (_anySniper) then { _sniper = true; } else { _sniper = false; };
_unit setVariable ["SQFB_sniper",_sniper];

// SMG
if (_primWepType == "SubmachineGun") then { _roles pushBack "SMG" };

// Rifle
if (count _roles == 0 && _alive && _primWepType == "AssaultRifle") then { _roles pushBack "Rifle" };

// Other
if (count _roles == 0 && _alive) then { _roles pushBack _primWepType };

// Crew type
private _veh = vehicle _unit;
if (_alive) then { _unit setVariable ["SQFB_veh", _veh] };
if (_veh != _unit) then {
	private _crewPos = "";
	private _crew = fullCrew [_veh,"",true];
	private _crewIndx = _crew findIf { (_x select 0) == _unit; };
	if (_crewIndx != -1) then {
		_crewPos = (_crew select _crewIndx) select 1;
		if (_crewPos == "cargo") then {_crewPos = ""};
	};
	_roles pushBack _crewPos;
};

_rolesStr = _roles joinString " ";
_unit setVariable ["SQFB_roles",_rolesStr];