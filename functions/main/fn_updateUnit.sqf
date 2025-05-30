/*
  Author: kenoxite

  Description:
  Updates the roles of a unit based on equipment, traits, and other factors.

  Parameter (s):
  _unit (Object): The unit to process.

  Returns:
  (Boolean): False if the unit is invalid, True otherwise.
*/

params [["_unit", objNull, [objNull]]];

if (!SQFB_opt_on) exitWith {false};

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
_unit setVariable ["SQFB_name", _lastName];

// Editor class name
if (isNil {_unit getVariable "SQFB_displayName"}) then {
    _unit setVariable ["SQFB_displayName", getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName")];
};

// Exit if dead
if (!alive _unit) exitWith {false};

// Vanilla and SOG Checks
private _unitIsVanilla = _unit getVariable "SQFB_isVanilla";
if (isNil {_unitIsVanilla}) then {
    private _unitMod = (unitAddons typeof _unit) select 0;
    if (isNil "_unitMod") then {_unitMod = "unknown"};
    private _vanilla = ["A3_Characters_F", "A3_Characters_F_Exp", "A3_Characters_F_Enoch"];
    _unitIsVanilla = _unitMod in _vanilla;
    _unit setVariable ["SQFB_isVanilla", _unitIsVanilla];
};

// SOG check
private _SOGunit = _unit getVariable "SQFB_SOGunit";
if (isNil {_SOGunit}) then {
    _SOGunit = !_unitIsVanilla && {(((getAssetDLCInfo _unit)#4) == "1227700")};
    _unit setVariable ["SQFB_SOGunit", _SOGunit];
};

// Group index
private _grpIndex = _unit call SQFB_fnc_getUnitPositionId;
_unit setVariable ["SQFB_grpIndex", _grpIndex];

private _roles = [];
private _rolesStr = "";
private _items = itemsWithMagazines _unit;
private _cfgMags = configfile >> "cfgMagazines";

// Mines check
private _hasMines = _items findIf {((_x call BIS_fnc_itemType) select 0) == "Mine"} != -1;
// Second pass for mod check
if (!_hasMines && !_unitIsVanilla) then {
    _hasMines = call {
        if (_items findIf {"CUP_TimeBomb_M" in ([_cfgMags >> _x, true] call BIS_fnc_returnParents)} != -1) exitWith {true};
        if (_items findIf {"rhsusf_m112_mag" in ([_cfgMags >> _x, true] call BIS_fnc_returnParents)} != -1) exitWith {true};
        false
    };
};

// Unit attributes check
// - Medic
private _medic = [_unit getUnitTrait "Medic", _items] call SQFB_fnc_roleMedic;
if (_medic) then {
    _roles pushBack localize "STR_SQFB_HUD_roles_Medic";
    _unit setVariable ["SQFB_medic", true];
};

private _noAmmoPrim = false;
private _noAmmoSec = false;
private _noAmmo = false;

// Secondary weapon check
private _secWep = secondaryWeapon _unit;
private _hasSecWep = _secWep != "";

private _AT = false;
private _AA = false;

if (_hasSecWep) then {
    private _secWepType = (_secWep call BIS_fnc_itemType) select 1;
    // Get loaded magazine
    private _secWepMags = secondaryWeaponMagazine _unit;
    private _secWepMagName = ["", toLowerAnsi (_secWepMags select 0)] select (count _secWepMags > 0);
    // Check if it carries compatible magazines
    private _compatSecMags = [_secWep] call BIS_fnc_compatibleMagazines;
    private _mag = "";
    private _secMagCount = {_mag = _x; _compatSecMags findIf {_x == _mag} != -1} count _items;

    // Ammo check - secondary
    _noAmmoSec = !(_secWep in SQFB_oneShotLaunchers) && {
        count _secWepMags == 0 && _secMagCount == 0 && (_unit ammo _secWep) == 0
    };
    _unit setVariable ["SQFB_noAmmoSec", _noAmmoSec];

    // Roles
    // - AntiAir
    _AA = [_secWepMagName] call SQFB_fnc_roleAA;
    if (_AA) then {
        _roles pushBack localize "STR_SQFB_HUD_roles_AA";
        _unit setVariable ["SQFB_AA", true];
    };

    // - AntiTank
    if (!_AA) then {
        _AT = [_secWepType] call SQFB_fnc_roleAT;
        if (_AT) then {
            _roles pushBack localize "STR_SQFB_HUD_roles_AT";
            _unit setVariable ["SQFB_AT", true];
        };
    };
};

// - Demolition specialist
private _demo = [_hasMines, _unit getUnitTrait "ExplosiveSpecialist", _items] call SQFB_fnc_roleDemo;
if (_demo) then {
    _roles pushBack localize "STR_SQFB_HUD_roles_Demolition";
    _unit setVariable ["SQFB_demo", true];
};

// - Engineer
private _engi = [_unit getUnitTrait "Engineer", _items] call SQFB_fnc_roleEngi;
if (_engi) then {
    _roles pushBack localize "STR_SQFB_HUD_roles_Engineer";
    _unit setVariable ["SQFB_engi", true];
};

// Primary weapon check
private _primWep = toLowerAnsi (primaryWeapon _unit);
private _hasPrimWep = _primWep != "";
private _primWepType = "";
private _primWepRole = false;
private _hasRG = false;
private _MG = false;
private _LMG = false;

if (_hasPrimWep) then {
    _primWepType = (_primWep call BIS_fnc_itemType) select 1;
    private _primWepDes = toLowerAnsi (getText (configFile >> "CfgWeapons" >> _primWep >> "descriptionShort"));
    // Check if it carries compatible magazines
    private _compatPrimMags = [_primWep] call BIS_fnc_compatibleMagazines;
    private _mag = "";
    private _primMagCount = {_mag = _x; _compatPrimMags findIf {_x == _mag} != -1} count _items;
    // Get amount of rounds left in the loaded magazine
    private _primMagsRounds = getNumber (_cfgMags >> (primaryWeaponMagazine _unit select 0) >> "count");
    // Check muzzles for GL check
    private _primMuzzles = [_primWep] call CBA_fnc_getMuzzles;
    private _primSecMuzzle = ["", toLowerAnsi (_primMuzzles#1)] select (count _primMuzzles > 1);

    // Rifle grenades check
    if (!_unitIsVanilla) then {
        _hasRG = _items findIf {"rifle grenade" in toLowerAnsi (getText (_cfgMags >> _x >> "displayName"))} != -1;
    };

    // Ammo check - primary
    _noAmmoPrim = (_unit ammo primaryWeapon _unit == 0 && _primMagCount == 0);
    _unit setVariable ["SQFB_noAmmoPrim", _noAmmoPrim];

    // Roles
    // - Grenade Launcher
    if (!_primWepRole) then {
        if ([_hasRG, _primSecMuzzle, _primWep] call SQFB_fnc_roleGL) then {
            _roles pushBack localize "STR_SQFB_HUD_roles_GL";
            _unit setVariable ["SQFB_GL", true];
            _primWepRole = true;
        };
    };

    // - Rifle - shotgun
    if (!_primWepRole) then {
        if ([_primSecMuzzle] call SQFB_fnc_roleRifleSG) then {
            _roles pushBack localize "STR_SQFB_HUD_roles_RifleSG";
            _unit setVariable ["SQFB_rifle", true];
            _primWepRole = true;
        };
    };

    // - Rifle - 50 cal
    if (!_primWepRole) then {
        if ([_primSecMuzzle] call SQFB_fnc_roleRifle50cal) then {
            _roles pushBack localize "STR_SQFB_HUD_roles_Rifle50cal";
            _unit setVariable ["SQFB_rifle", true];
            _primWepRole = true;
        };
    };

    // - SMG
    if (!_primWepRole) then {
        if ([_primWepType, _primWepDes, _primWep] call SQFB_fnc_roleSMG) then {
            _roles pushBack localize "STR_SQFB_HUD_roles_SMG";
            _unit setVariable ["SQFB_smg", true];
            _primWepRole = true;
        };
    };

    // - Shotgun
    if (!_primWepRole) then {
        if ([_primWepType] call SQFB_fnc_roleShotgun) then {
            _roles pushBack localize "STR_SQFB_HUD_roles_Shotgun";
            _unit setVariable ["SQFB_shotgun", true];
            _primWepRole = true;
        };
    };

    // - Machine Gun/LMG
    if (!_primWepRole) then {
        _LMG = [_primWepDes, _primWep, _unitIsVanilla, _primMagsRounds] call SQFB_fnc_roleLMG;
        if (_LMG) then {
            _roles pushBack localize "STR_SQFB_HUD_roles_LMG";
            _primWepRole = true;
        };
    };
    if (!_primWepRole) then {
        _MG = [_primWepDes, _primWepType, _primWep, _unitIsVanilla] call SQFB_fnc_roleMG;
        if (_MG) then {
            _roles pushBack localize "STR_SQFB_HUD_roles_MG";
            _primWepRole = true;
        };
    };
    _unit setVariable ["SQFB_MG", _MG || _LMG];

    // - Sniper/Marksman
    private _marksman = false;
    private _sniper = false;
    if (!_primWepRole) then {
        _marksman = [_primWepDes, _primWepType, _primWep, _unitIsVanilla] call SQFB_fnc_roleMarksman;
        if (_marksman) then {
            _roles pushBack localize "STR_SQFB_HUD_roles_Marksman";
            _primWepRole = true;
        };
    }; 
    if (!_primWepRole && !_SOGunit) then {
        _sniper = [_primWepType] call SQFB_fnc_roleSniper;
        if (_sniper) then {
            _roles pushBack localize "STR_SQFB_HUD_roles_Sniper";
            _primWepRole = true;
        };
    };
    _unit setVariable ["SQFB_sniper", _sniper || _marksman];
};

// Ammo check - global
_noAmmo = _noAmmoPrim || _noAmmoSec;
_unit setVariable ["SQFB_noAmmo", _noAmmo];

// Handgun check
private _handgunWep = handgunWeapon _unit;
private _hasHandgun = _handgunWep != "";

if (!_hasPrimWep && _hasHandgun) then {
    // Roles
    private _handgun = true;
    _roles pushBack localize "STR_SQFB_HUD_roles_Handgun";
    _unit setVariable ["SQFB_handgun", true];
};

// Assistant check
private _backpack = toLowerAnsi (backpack _unit);
private _hasBackpack = _backpack != "";
private _anyAmmoBearer = false;

if (_hasBackpack && {!_LMG && !_MG}) then {
    // - Asistant AT
    if (!_AT && !_anyAmmoBearer) then {
        if ([_backpack, _unitIsVanilla] call SQFB_fnc_roleAssistAT) then {
            _anyAmmoBearer = true;
            _roles pushBack localize "STR_SQFB_HUD_roles_assistAT";
        };
    };

    // - Asistant LMG/MG
    if (!_anyAmmoBearer) then {
        if ([_backpack, _unitIsVanilla] call SQFB_fnc_roleAssistLMG) then {
            _anyAmmoBearer = true;
            _roles pushBack localize "STR_SQFB_HUD_roles_assistLMG";
        };
    };
    if (!_anyAmmoBearer && !_unitIsVanilla) then {
        if ([_backpack] call SQFB_fnc_roleAssistMG) then {
            _anyAmmoBearer = true;
            _roles pushBack localize "STR_SQFB_HUD_roles_assistMG";
        };
    };

    // - Asistant AA
    if (!_AA && !_anyAmmoBearer) then {
        if ([_backpack, _unitIsVanilla] call SQFB_fnc_roleAssistAA) then {
            _anyAmmoBearer = true;
            _roles pushBack localize "STR_SQFB_HUD_roles_assistAA";
        };
    };

    // - Ammo bearer
    if (!_anyAmmoBearer) then {
        if ([_backpack] call SQFB_fnc_roleAmmo) then {
            _anyAmmoBearer = true;
            _roles pushBack localize "STR_SQFB_HUD_roles_ammoBearer";
        };
    };
    _unit setVariable ["SQFB_ammoBearer", _anyAmmoBearer];

    // - Radio Operator
    if (!_anyAmmoBearer) then {
        if ([_backpack] call SQFB_fnc_roleRadio) then {
            _roles pushBack localize "STR_SQFB_HUD_roles_radioOperator";
            _unit setVariable ["SQFB_radioOperator", true];
        };
    };
};

// - Rifle
if (count _roles == 0 && _hasPrimWep) then {
    //  SOG rifles are all defined as sniper rifles. Yup. That makes them almost impossible to filter other than going class by class or adding even more superfluous checks. So now all their rifles will be treated as rifles.
    if (_primWepType == "AssaultRifle" || _SOGunit) then {
        _roles pushBack localize "STR_SQFB_HUD_roles_Rifle";
        _unit setVariable ["SQFB_rifle", true];
        _primWepRole = true;
    };
};

// - Hacker
private _hacker = _unit getUnitTrait "UavHacker" && !_SOGunit; // Don't report SOG units as hackers. Because for some reason all of them are. In Nam.
if (_hacker) then {
    _roles pushBack localize "STR_SQFB_HUD_roles_Hacker";
    _unit setVariable ["SQFB_hacker", true];
};

// Other
if (count _roles == 0) then {
    _unit setVariable ["SQFB_unarmed", true];
    _roles pushBack _primWepType;
};

// Crew type
private _veh = vehicle _unit;
_unit setVariable ["SQFB_veh", _veh];
if !(isNull objectParent _unit) then {
    private _crewPos = "";
    private _crew = fullCrew [_veh,"",true];
    private _crewIndx = _crew findIf {(_x select 0) == _unit;};
    if (_crewIndx != -1) then {
        _crewPos = (_crew select _crewIndx) select 1;
        if (_crewPos == "cargo") then {_crewPos = ""};
    };
    if (_crewPos != "") then { _roles pushBack (["-", _crewPos] joinString " ") };
};

_rolesStr = _roles joinString " ";
_unit setVariable ["SQFB_roles", _rolesStr];
