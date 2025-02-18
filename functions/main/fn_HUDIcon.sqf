/*
    Author: kenoxite

    Description:
    Update the HUD icon for the unit


    Parameter (s):
    _this select 0: _unit


    Returns:


    Examples:d
*/

params [["_unit", objNull], ["_profile", "default"], ["_showDead", true], ["_showDeadMinTime", 3], ["_alwaysShowCritical", true], ["_showText", true]];

private _return = "";
if(isNull _unit) exitWith {_return};

// Exclude players
if (_unit == SQFB_player) exitWith {_return};

if (SQFB_showHUD && {SQFB_opt_showRolesIcon}) then {
    // Role
    _return = call {
        if (_unit getVariable "SQFB_medic") exitWith { "a3\ui_f\data\igui\cfg\cursors\unithealer_ca.paa"; };
        if (_unit getVariable "SQFB_AA") exitWith { "a3\ui_f\data\igui\cfg\weaponicons\aa_ca.paa"; };
        if (_unit getVariable "SQFB_AT") exitWith { "a3\ui_f\data\igui\cfg\weaponicons\at_ca.paa"; };
        if (_unit getVariable "SQFB_MG") exitWith { "a3\ui_f\data\igui\cfg\weaponicons\mg_ca.paa"; };
        if (_unit getVariable "SQFB_engi") exitWith { "a3\ui_f\data\igui\cfg\cursors\iconrepairat_ca.paa"; };
        if (_unit getVariable "SQFB_demo") exitWith { "a3\ui_f\data\igui\cfg\cursors\explosive_ca.paa"; };
        if (_unit getVariable "SQFB_sniper") exitWith { "a3\ui_f\data\igui\cfg\weaponicons\srifle_ca.paa"; };
        if (_unit getVariable "SQFB_GL") exitWith { "a3\ui_f\data\igui\cfg\weaponicons\gl_ca.paa"; };
        if (_unit getVariable "SQFB_hacker") exitWith { "a3\ui_f\data\igui\cfg\holdactions\holdaction_hack_ca.paa"; };
        if (_unit getVariable "SQFB_ammoBearer"
            || _unit getVariable "SQFB_assistAT"
            || _unit getVariable "SQFB_assistAA"
            || _unit getVariable "SQFB_assistLMG") exitWith { "SQFB\images\backpack.paa"; };
        if (_unit getVariable "SQFB_handgun") exitWith { "SQFB\images\handgun.paa"; };
        if (_unit getVariable "SQFB_smg") exitWith { "SQFB\images\smg.paa"; };
        if (_unit getVariable "SQFB_shotgun") exitWith { "SQFB\images\shotgun.paa"; };
        if (_unit getVariable "SQFB_rifle") exitWith { "SQFB\images\rifle.paa"; };
        if (_unit getVariable "SQFB_unarmed") exitWith { "SQFB\images\none.paa"; };
        _return
    };
};

if (SQFB_showHUD && {!alive _unit && _showDead && time >= _showDeadMinTime}) then {
    _return = "a3\ui_f\data\igui\cfg\revive\overlayicons\f100_ca.paa";
};

if (!SQFB_showHUD || !SQFB_opt_showRolesIcon) then {
    private _playerIsLeader = leader _unit == SQFB_player;
    private _playerIsMedic = SQFB_player getVariable "SQFB_medic";
    private _showCritical = _alwaysShowCritical == "always" || _alwaysShowCritical == "infantry" || _alwaysShowCritical == "infantryIcon";
    if (_showCritical && {(_playerIsMedic || _playerIsLeader) || {!_showText}}) then {
        // Ammo amount
        if (_playerIsLeader && {(vehicle _unit) == _unit}) then {
            if (_unit getVariable "SQFB_noAmmo") then {
                _return = "a3\ui_f\data\igui\cfg\actions\gear_ca.paa";
            };
        };

        // Show medics when there's wounded units in the group
        if (_playerIsLeader && {((_unit getVariable "SQFB_medic") && (group _unit) getVariable "SQFB_wounded")}) then {
            _return = "a3\ui_f\data\igui\cfg\cursors\unithealer_ca.paa";
        };

        // Health
        //  - These have preference over the role icons
        private _lifeState = lifeState _unit;
        private _bleeding = isBleeding _unit;
        _return = call {
            //  - Added support for A3 Wounding System
            if (_unit getVariable ["AIS_unconscious", false]) exitWith {
                // ""
                "a3\ui_f\data\igui\cfg\revive\overlayicons\u100_ca.paa"
            };
            if (_lifeState == "INCAPACITATED") exitWith {
                "a3\ui_f\data\igui\cfg\revive\overlayicons\u100_ca.paa"
            };
            if (_lifeState == "INJURED" && _bleeding) exitWith {
                "a3\ui_f\data\igui\cfg\cursors\unitbleeding_ca.paa"
            };
            if (_lifeState == "INJURED" && !_bleeding) exitWith {
                "a3\ui_f\data\igui\cfg\revive\overlayicons\r100_ca.paa"
            };
            _return
        };
    };
};

_return
