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
if (_unit == SQFB_player) exitWith {false};

// Exclude units no longer in group
if !(_unit in SQFB_units) exitWith {false};

// Reset unit variables
_unit call SQFB_fnc_resetUnit;

// Name
private _currentName = name _unit;
private _nameArr = [_currentName, " "] call BIS_fnc_splitString;
private _lastName = [
                        _nameArr #0,
                        _nameArr #1
                    ] select (count _nameArr > 1);
_unit setVariable ["SQFB_name", _lastName];

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

private _primWep = toLowerAnsi (primaryWeapon _unit);
private _hasPrimWep = _primWep != "";
private _secWep = secondaryWeapon _unit;
private _hasSecWep = _secWep != "";
private _primWepType = (_primWep call BIS_fnc_itemType) select 1;
private _secWepType = ["", (_secWep call BIS_fnc_itemType) select 1] select _hasSecWep;
private _primWepMags = primaryWeaponMagazine _unit;
private _secWepMags = ["", secondaryWeaponMagazine _unit] select _hasSecWep;
private _secWepMagName = if (_hasSecWep) then { ["", _secWepMags select 0] select (count _secWepMags > 0) } else { "" };
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

// Mines check
private _hasMines = [false, true] select (_items findIf { ((_x call BIS_fnc_itemType) select 0) == "Mine"} != -1);
// Second pass for mod check
if (!_unitIsVanilla) then {
    if (!_hasMines) then {
        _hasMines = [false, true] select (_items findIf { "CUP_TimeBomb_M" in ([_cfgMags >> _x , true] call BIS_fnc_returnParents) } != -1);
    };
    if (!_hasMines) then {
        _hasMines = [false, true] select (_items findIf { "rhsusf_m112_mag" in ([_cfgMags >> _x , true] call BIS_fnc_returnParents) } != -1);
    };
};

// Rifle grenades check
private _hasRG = false;
if (!_unitIsVanilla) then {
    _hasRG = [false, true] select (_items findIf {"rifle grenade" in toLowerAnsi (getText (_cfgMags >> _x >> "displayName"))}!= -1);
};

private _primWepDes = toLowerAnsi (getText (configFile >> "CfgWeapons" >> _primWep >> "descriptionShort"));
private _handgunWep = handgunWeapon _unit;
private _backpack = unitBackpack _unit;
private _backpackStr = toLowerAnsi (typeOf _backpack);

// Ammo check - primary
private _noAmmoPrim = [
                        false,
                        [
                            true,
                            [true, false] select (_primMagCount > 0)
                        ] select (count _primWepMags > 0)
                    ] select _hasPrimWep;
_unit setVariable ["SQFB_noAmmoPrim", _noAmmoPrim];

// Ammo check - secondary    
private _noAmmoSec = [
                        false,
                        [
                            [true, false] select (_secWep in SQFB_oneShotLaunchers),
                            [true, false] select (_secMagCount > 0 || (_unit ammo _secWep) > 0)
                        ] select (count _secWepMags > 0)
                    ] select _hasSecWep;
_unit setVariable ["SQFB_noAmmoSec", _noAmmoSec];

// Ammo check - global
private _noAmmo = [false, true] select (_noAmmoPrim || _noAmmoSec);
_unit setVariable ["SQFB_noAmmo", _noAmmo];

private _roles = [];
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
private _SMG = false;
private _shotgun = false;
private _handgun = false;
private _rifle = false;
private _ammoBearer = false;
private _assistAT = false;
private _assistAA = false;
private _assistLMG = false;
private _anyAmmoBearer = false;

// Group index
_grpIndex = _unit call SQFB_fnc_getUnitPositionId;
_unit setVariable ["SQFB_grpIndex", _grpIndex];

private _unitTraits = getAllUnitTraits _unit;
private _isMedic = (_unitTraits select { (_x select 0) == "Medic" } apply { _x select 1 }) select 0;
private _isEngi = (_unitTraits select { (_x select 0) == "Engineer" } apply { _x select 1 }) select 0;
private _isDemo = (_unitTraits select { (_x select 0) == "ExplosiveSpecialist" } apply { _x select 1 }) select 0;
private _isHacker = (_unitTraits select { (_x select 0) == "UavHacker" } apply { _x select 1 }) select 0;

// Medic
if (_isMedic && ({"Medikit" in _items || {"vn_b_item_medikit_01" in _items} || {"gm_ge_army_medkit_80" in _items} || {"gm_gc_army_medbox" in _items}})) then {_medic = true; _roles pushBack localize "STR_SQFB_HUD_roles_Medic"};
_unit setVariable ["SQFB_medic", _medic];

// Demolition specialist
if (_hasMines || (_isDemo && ({("MineDetector" in _items || {"vn_b_item_trapkit" in _items}) || "Toolkit" in _items || {"vn_b_item_toolkit" in _items}}))) then { _demo = true; _roles pushBack localize "STR_SQFB_HUD_roles_Demolition" };
_unit setVariable ["SQFB_demo", _demo];

// Engineer
if (_isEngi && ({"Toolkit" in _items || {"vn_b_item_toolkit" in _items}})) then { _engi = true; _roles pushBack localize "STR_SQFB_HUD_roles_Engineer" };
_unit setVariable ["SQFB_engi", _engi];

// Hacker
if (_isHacker) then { _hacker = true; _roles pushBack localize "STR_SQFB_HUD_roles_Hacker" };
_unit setVariable ["SQFB_hacker", _hacker];

// AntiAir
if (("_aa" in _secWepMagName)) then { _AA = true; _roles pushBack localize "STR_SQFB_HUD_roles_AA" };
_unit setVariable ["SQFB_AA", _AA];

// AntiTank
if ((_secWepType == "Launcher" || {_secWepType == "MissileLauncher" || {_secWepType == "RocketLauncher"}}) && !_AA) then { _AT = true; _roles pushBack localize "STR_SQFB_HUD_roles_AT" };
_unit setVariable ["SQFB_AT", _AT];

// Grenade Launcher
if (_primWepType == "GrenadeLauncher" || {!_unitIsVanilla && ({_hasRG || {"gl" in _primWep || {"m203" in _primWep || "gp25" in _primWep || "gp30" in _primWep || "gp34" in _primWep || "m32" in _primWep || "g40" in _primWep || "m79" in _primWep || "_ag" in _primWep || "_ag" in _primWep || _primWep == "gm_hk69a1_blk" || "pallad" in _primWep}}})}) then { _GL = true; _roles pushBack localize "STR_SQFB_HUD_roles_GL" };
_unit setVariable ["SQFB_GL", _GL];

// Machine Gun/LMG
if (!_anyMG && {"light machine gun" in _primWepDes || "rpk" in _primWep || {!_unitIsVanilla && ({"m27" in _primWep || "pkp" in _primWep || "m249" in _primWep})}}) then { _anyMG = true; _roles pushBack localize "STR_SQFB_HUD_roles_LMG" };
if (!_anyMG && {_primWepType == "MachineGun" || {!_unitIsVanilla && {"mg" in _primWep}}}) then { _anyMG = true; _roles pushBack localize "STR_SQFB_HUD_roles_MG" };
if (_anyMG) then { _MG = true };
_unit setVariable ["SQFB_MG", _MG];

// Sniper/Marksman
if (!_anySniper && {("sniper" in _primWepDes && _primWepType != "SniperRifle") || {("dms" in _primWep || "mxm" in _primWep) || {!_unitIsVanilla && ({"sr25" in _primWep || "m76" in _primWep || "svd" in _primWep || "srifle" in _primWep || "hk417_20_scope" in _primWep || "mk20_leupoldmk4mrt" in _primWep || "aks74_pso" in _primWep})}}}) then { _anySniper = true; _roles pushBack localize "STR_SQFB_HUD_roles_Marksman" };
if (!_anySniper && {_primWepType == "SniperRifle"}) then { _anySniper = true; _roles pushBack localize "STR_SQFB_HUD_roles_Sniper" };
if (_anySniper) then { _sniper = true };
_unit setVariable ["SQFB_sniper", _sniper];

// SMG
if (_primWepType == "SubmachineGun" || {"submachine" in _primWepDes || {"smg" in _primWepDes}}) then { _SMG = true; _roles pushBack localize "STR_SQFB_HUD_roles_SMG" };
_unit setVariable ["SQFB_smg", _SMG];

// Shotgun
if (_primWepType == "Shotgun") then { _shotgun = true; _roles pushBack localize "STR_SQFB_HUD_roles_Shotgun" };   
_unit setVariable ["SQFB_shotgun", _shotgun];

// Handgun
if (_primWepType == "Handgun" || {_primWepType == "" && _handgunWep != ""}) then { _handgun = true; _roles pushBack localize "STR_SQFB_HUD_roles_Handgun" };
_unit setVariable ["SQFB_handgun", _handgun];

// Asistant AT
if (_backpackStr != "" && {!_AT && !_anyAmmoBearer && {"aat" in _backpackStr || "ahat" in _backpackStr || {!_unitIsVanilla && ({"_at" in _backpackStr || "_rpg" in _backpackStr || "_hat" in _backpackStr || "_hj12" in _backpackStr || "_m47" in _backpackStr || "_m67" in _backpackStr || "_smaw" in _backpackStr || "_at4" in _backpackStr})}}}) then { _assistAT = true; _anyAmmoBearer = true; _roles pushBack localize "STR_SQFB_HUD_roles_assistAT" };
_unit setVariable ["SQFB_assistAT", _assistAT];

// Asistant AA
if (_backpackStr != "" && {!_AA && !_anyAmmoBearer && {"aaa" in _backpackStr || {!_unitIsVanilla && ({"_aa" in _backpackStr || "_redeye" in _backpackStr || "_stinger" in _backpackStr || "_igla" in _backpackStr || "_strela" in _backpackStr})}}}) then { _assistAA = true; _anyAmmoBearer = true; _roles pushBack localize "STR_SQFB_HUD_roles_assistAA" };
_unit setVariable ["SQFB_assistAA", _assistAA];

// Asistant LMG/MG
if (_backpackStr != "" && {!_anyMG && !_anyAmmoBearer && {"aar" in _backpackStr || {!_unitIsVanilla && ({"_autorfle" in _backpackStr || "_ar" in _backpackStr || "_m16_lsw" in _backpackStr || "_m249" in _backpackStr || "_rpk" in _backpackStr || "ammosaw" in _backpackStr})}}}) then { _assistLMG = true; _anyAmmoBearer = true; _roles pushBack localize "STR_SQFB_HUD_roles_assistLMG" };
if (_backpackStr != "" && {!_anyMG && !_anyAmmoBearer && {!_unitIsVanilla && ({"_mg" in _backpackStr || "_amg" in _backpackStr || "_m60" in _backpackStr || "_pk" in _backpackStr || "_ammomg" in _backpackStr})}}) then { _assistLMG = true; _anyAmmoBearer = true; _roles pushBack localize "STR_SQFB_HUD_roles_assistMG" };
_unit setVariable ["SQFB_assistLMG", _assistLMG];

// Ammo bearer
if (_backpackStr != "" && {!_anyAmmoBearer && !_anyMG && !_AT && !_AA && {"ammo" in _backpackStr}}) then { _ammoBearer = true; _anyAmmoBearer = true; _roles pushBack localize "STR_SQFB_HUD_roles_ammoBearer" };
_unit setVariable ["SQFB_ammoBearer", _ammoBearer];

// Rifle
if (count _roles == 0 && _primWepType == "AssaultRifle") then { _rifle = true; _roles pushBack localize "STR_SQFB_HUD_roles_Rifle" };
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
