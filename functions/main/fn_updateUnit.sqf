/*
  Author: kenoxite

  Description:
  Update the displayed feedback for a single unit


  Parameter (s):
  _this select 0: _unit
 

  Returns:


  Examples:

*/

params [["_unit", objNull, [objNull]]];

if (!SQFB_opt_on) exitWith {false};

// Exclude players
// if (_unit == SQFB_player) exitWith {false};

// Exclude non humanoids
if !(_unit call SQFB_fnc_isHuman) exitWith {false};

// Exclude units no longer in group
if !(_unit in SQFB_units) exitWith {false};

// Reset unit variables
_unit call SQFB_fnc_resetUnit;

// Name
private _currentName = name _unit;
private _nameArr = [_currentName, " "] call BIS_fnc_splitString;
private _lastName = call {
    if (count _nameArr == 0) exitWith {
        if (_currentName != "") exitWith {_currentName};
        typeof _unit
    };
    if (count _nameArr > 1) exitWith {_nameArr#1};
    _nameArr#0  
};

// Editor class name
if (isNil {_unit getVariable "SQFB_displayName"}) then {
    _unit setVariable ["SQFB_displayName", getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName")];
};

if (!alive _unit) exitWith {false};

private _unitIsVanilla = true;
if (isNil {_unit getVariable "SQFB_isVanilla"}) then {
    private _unitMod = (unitAddons typeof _unit) select 0;
    if (isNil "_unitMod") then {_unitMod = "unknown"};
    private _vanilla = [
                        "A3_Characters_F",
                        "A3_Characters_F_Exp",
                        "A3_Characters_F_Enoch"
                        ];
    _unitIsVanilla = _vanilla findIf { _x == _unitMod } != -1;
    _unit setVariable ["SQFB_isVanilla", _unitIsVanilla];
};

// SOG check
private _SOGunit = _unit getVariable "SQFB_SOGunit";
if (isNil {_unit getVariable "SQFB_SOGunit"}) then {
    _SOGunit = call {
        if (_unitIsVanilla) exitwith {false};
        if ((getAssetDLCInfo _unit)#4 == "1227700") exitWith {true};
        false;
    };
    _unit setVariable ["SQFB_SOGunit", _SOGunit];
};

private _primWep = toLowerAnsi (primaryWeapon _unit);
private _hasPrimWep = _primWep != "";
private _secWep = secondaryWeapon _unit;
private _hasSecWep = _secWep != "";
private _primWepType = (_primWep call BIS_fnc_itemType) select 1;
private _secWepType = ["", (_secWep call BIS_fnc_itemType) select 1] select _hasSecWep;
private _secWepMags = [[], secondaryWeaponMagazine _unit] select _hasSecWep;
private _secWepMagName = if (_hasSecWep) then { ["", toLowerAnsi (_secWepMags select 0)] select (count _secWepMags > 0) } else { "" };
private _items = itemsWithMagazines _unit;
private _mag = "";
private _compatPrimMags = [_primWep] call BIS_fnc_compatibleMagazines;
private _primMagCount = { _mag = _x; _compatPrimMags findIf { _x == _mag } != -1} count _items;
private _compatSecMags = [[], [_secWep] call BIS_fnc_compatibleMagazines] select _hasSecWep;
_mag = "";
private _secMagCount = [
                            0,
                            { _mag = _x; _compatSecMags findIf { _x == _mag } != -1} count _items
                        ] select _hasSecWep;

private _cfgMags = configfile >> "cfgMagazines";
private _primMagsRounds = getNumber (_cfgMags >> (primaryWeaponMagazine _unit select 0) >> "count");

// Mines check
private _hasMines = _items findIf { ((_x call BIS_fnc_itemType) select 0) == "Mine"} != -1;
// Second pass for mod check
if (!_unitIsVanilla) then {
    if (!_hasMines) then {
        _hasMines = _items findIf { "CUP_TimeBomb_M" in ([_cfgMags >> _x , true] call BIS_fnc_returnParents) } != -1;
    };
    if (!_hasMines) then {
        _hasMines = _items findIf { "rhsusf_m112_mag" in ([_cfgMags >> _x , true] call BIS_fnc_returnParents) } != -1;
    };
};

// Rifle grenades check
private _hasRG = false;
if (!_unitIsVanilla) then {
    _hasRG = _items findIf {"rifle grenade" in toLowerAnsi (getText (_cfgMags >> _x >> "displayName"))}!= -1;
};

// Primary weapon muzzles
private _primMuzzles = call {
    if (_hasPrimWep) exitWith { [_primWep] call CBA_fnc_getMuzzles };
    []
};
private _primSecMuzzle = call {
    if (_hasPrimWep) exitWith { ["", toLowerAnsi (_primMuzzles#1)] select (count _primMuzzles > 1) };
    ""
};
private _primWepDes = toLowerAnsi (getText (configFile >> "CfgWeapons" >> _primWep >> "descriptionShort"));
private _handgunWep = handgunWeapon _unit;
private _backpack = unitBackpack _unit;
private _backpackStr = toLowerAnsi (typeOf _backpack);

// Ammo check - primary
private _noAmmoPrim = _hasPrimWep && {(_unit ammo primaryWeapon _unit == 0 && _primMagCount == 0)};
_unit setVariable ["SQFB_noAmmoPrim", _noAmmoPrim];

// Ammo check - secondary    
private _noAmmoSec = _hasSecWep && {!(_secWep in SQFB_oneShotLaunchers) && {count _secWepMags == 0 && _secMagCount == 0 && (_unit ammo _secWep) == 0}};
_unit setVariable ["SQFB_noAmmoSec", _noAmmoSec];

// Ammo check - global
private _noAmmo = _noAmmoPrim || _noAmmoSec;
_unit setVariable ["SQFB_noAmmo", _noAmmo];

private _roles = [];
private _rolesStr = "";
private _grpIndex = "";
private _medic = false;
private _engi = false;
private _hacker = false;
private _AT = false;
private _sniper = false;
private _marksman = false;
private _LMG = false;
private _MG = false;
private _demo = false;
private _AA = false;
private _GL = false;
private _SMG = false;
private _shotgun = false;
private _handgun = false;
private _rifle = false;
private _ammoBearer = false;
private _assistAT = false;
private _assistAA = false;
private _assistMG = false;
private _assistLMG = false;
private _anyAmmoBearer = false;

// Group index
_grpIndex = _unit call SQFB_fnc_getUnitPositionId;
_unit setVariable ["SQFB_grpIndex", _grpIndex];

// Medic
_medic = [_unit getUnitTrait "Medic", _items] call SQFB_fnc_roleMedic;
if (_medic) then { _roles pushBack localize "STR_SQFB_HUD_roles_Medic" };
_unit setVariable ["SQFB_medic", _medic];

// Demolition specialist
_demo = [_hasMines, _unit getUnitTrait "ExplosiveSpecialist", _items] call SQFB_fnc_roleDemo;
if (_demo) then { _roles pushBack localize "STR_SQFB_HUD_roles_Demolition" };
_unit setVariable ["SQFB_demo", _demo];

// Engineer
_engi = [_unit getUnitTrait "Engineer", _items] call SQFB_fnc_roleEngi;
if (_engi) then { _roles pushBack localize "STR_SQFB_HUD_roles_Engineer" };
_unit setVariable ["SQFB_engi", _engi];

// Hacker
_hacker = _unit getUnitTrait "UavHacker";
if (_hacker) then { _roles pushBack localize "STR_SQFB_HUD_roles_Hacker" };
_unit setVariable ["SQFB_hacker", _hacker];

// AntiAir
_AA = [_secWepMagName] call SQFB_fnc_roleAA;
if (_AA) then { _roles pushBack localize "STR_SQFB_HUD_roles_AA" };
_unit setVariable ["SQFB_AA", _AA];

// AntiTank
_AT = [_AA, _secWepType] call SQFB_fnc_roleAT;
if (_AT) then { _roles pushBack localize "STR_SQFB_HUD_roles_AT" };
_unit setVariable ["SQFB_AT", _AT];

// Grenade Launcher
_GL = [_hasRG, _primSecMuzzle, _primWep, _handgunWep] call SQFB_fnc_roleGL;
if (_GL) then { _roles pushBack localize "STR_SQFB_HUD_roles_GL" };
_unit setVariable ["SQFB_GL", _GL];

// Machine Gun/LMG
_LMG = [_primWepDes, _primWep, _unitIsVanilla, _primMagsRounds] call SQFB_fnc_roleLMG; 
if (_LMG) then { _roles pushBack localize "STR_SQFB_HUD_roles_LMG" };

_MG = [_LMG, _primWepType, _primWep, _unitIsVanilla] call SQFB_fnc_roleMG; 
if (_MG) then { _roles pushBack localize "STR_SQFB_HUD_roles_MG" };

_unit setVariable ["SQFB_MG", _LMG || _MG];

// Sniper/Marksman
_marksman = [_primWepDes, _primWepType, _primWep, _unitIsVanilla] call SQFB_fnc_roleMarksman; 
if (_marksman) then { _roles pushBack localize "STR_SQFB_HUD_roles_Marksman" };

_sniper = [_marksman, _primWepType, _SOGunit] call SQFB_fnc_roleSniper; 
if (_sniper) then { _roles pushBack localize "STR_SQFB_HUD_roles_Sniper" };

_unit setVariable ["SQFB_sniper", _marksman || _sniper];

// SMG
_SMG = [_primWepType, _primWepDes, _primWep] call SQFB_fnc_roleSMG; 
if (_SMG) then { _roles pushBack localize "STR_SQFB_HUD_roles_SMG" };
_unit setVariable ["SQFB_smg", _SMG];

// Shotgun
_shotgun = [_primWepType] call SQFB_fnc_roleShotgun; 
if (_shotgun) then { _roles pushBack localize "STR_SQFB_HUD_roles_Shotgun" };   
_unit setVariable ["SQFB_shotgun", _shotgun];

// Handgun
_handgun = [_primWepType, _handgunWep] call SQFB_fnc_roleHandgun; 
if (_handgun) then { _roles pushBack localize "STR_SQFB_HUD_roles_Handgun" };
_unit setVariable ["SQFB_handgun", _handgun];

// Asistant AT
_assistAT = [_backpackStr, _AT, _anyAmmoBearer, _unitIsVanilla] call SQFB_fnc_roleAssistAT; 
if (_assistAT) then { _anyAmmoBearer = true; _roles pushBack localize "STR_SQFB_HUD_roles_assistAT" };
_unit setVariable ["SQFB_assistAT", _assistAT];

// Asistant AA
_assistAA = [_backpackStr, _AA, _anyAmmoBearer, _unitIsVanilla] call SQFB_fnc_roleAssistAA; 
if (_assistAA) then { _anyAmmoBearer = true; _roles pushBack localize "STR_SQFB_HUD_roles_assistAA" };
_unit setVariable ["SQFB_assistAA", _assistAA];

// Asistant LMG/MG
_assistLMG = [_backpackStr, _LMG, _anyAmmoBearer, _unitIsVanilla] call SQFB_fnc_roleAssistLMG; 
if (_assistLMG) then { _anyAmmoBearer = true; _roles pushBack localize "STR_SQFB_HUD_roles_assistLMG" };

_assistMG = [_backpackStr, _MG, _anyAmmoBearer, _unitIsVanilla] call SQFB_fnc_roleAssistMG; 
if (_assistMG) then { _anyAmmoBearer = true; _roles pushBack localize "STR_SQFB_HUD_roles_assistMG" };

_unit setVariable ["SQFB_assistLMG", _assistLMG || _assistMG];

// Ammo bearer
_ammoBearer = [_backpackStr, _anyAmmoBearer] call SQFB_fnc_roleAmmo; 
if (_ammoBearer) then { _anyAmmoBearer = true; _roles pushBack localize "STR_SQFB_HUD_roles_ammoBearer" };
_unit setVariable ["SQFB_ammoBearer", _ammoBearer];

// Rifle
//  SOG rifles are all defined as sniper rifles. Yup. That makes them almost impossible to filter other than going class by class or adding even more superfluous checks. So now all their rifles will be treated as rifles.
if (count _roles == 0 && (_primWepType == "AssaultRifle" || _SOGunit)) then { _rifle = true; _roles pushBack localize "STR_SQFB_HUD_roles_Rifle" };
_unit setVariable ["SQFB_rifle", _rifle];

// Other
if (count _roles == 0) then { _unit setVariable ["SQFB_unarmed", true]; _roles pushBack _primWepType } else { _unit setVariable ["SQFB_unarmed", false] };

// Crew type
private _veh = vehicle _unit;
_unit setVariable ["SQFB_veh", _veh];
if !(isNull objectParent _unit) then {
    private _crewPos = "";
    private _crew = fullCrew [_veh,"",true];
    private _crewIndx = _crew findIf { (_x select 0) == _unit; };
    if (_crewIndx != -1) then {
        _crewPos = (_crew select _crewIndx) select 1;
        if (_crewPos == "cargo") then {_crewPos = ""};
    };
    if (_crewPos != "") then { _roles pushBack format ["- %1", _crewPos] };
};

_rolesStr = _roles joinString " ";
_unit setVariable ["SQFB_roles", _rolesStr];
