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

// Exit early if unit is dead
if (SQFB_showHUD && {!alive _unit && _showDead && time >= _showDeadMinTime}) exitWith {
    "a3\ui_f\data\igui\cfg\revive\overlayicons\f100_ca.paa";
};
if(!alive _unit) exitWith {_return};

// Health check
if (!SQFB_showHUD || !SQFB_opt_showRolesIcon) then {
    private _playerIsLeader = leader _unit == SQFB_player;
    private _playerIsMedic = SQFB_player getVariable "SQFB_medic";
    private _showCritical = _alwaysShowCritical == "always" || _alwaysShowCritical == "infantry" || _alwaysShowCritical == "infantryIcon";
    private _lifeState = lifeState _unit;
    private _bleeding = isBleeding _unit;
    if (_showCritical && {(_playerIsMedic || _playerIsLeader) || {!_showText}}) then {
        //  - These have preference over the role icons

        // Show medics when there's wounded units in the group
        if (_playerIsLeader && {((_unit getVariable "SQFB_medic") && (group _unit) getVariable "SQFB_wounded")}) then {
            _return = "a3\ui_f\data\igui\cfg\cursors\unithealer_ca.paa";
        };

        // Health status
        _return = call {
            if (_lifeState == "INJURED" && !_bleeding && damage _unit > 0.25 && !SQFB_aceMedical) exitWith {
                // Unit injured and not healed
                "a3\ui_f\data\igui\cfg\revive\overlayicons\r100_ca.paa"
            };
            if (_lifeState == "INJURED" && _bleeding && !SQFB_aceMedical) exitWith {
                "a3\ui_f\data\igui\cfg\cursors\unitbleeding_ca.paa"
            };
            _return
        };
        // Ammo amount
        if (_return != "" && {_playerIsLeader && {(vehicle _unit) == _unit}}) then {
            if (_unit getVariable "SQFB_noAmmo") then {
                // _return = "a3\ui_f\data\igui\cfg\actions\gear_ca.paa";
                _return = "a3\ui_f\data\igui\cfg\actions\reammo_ca.paa";
            };
        };
    };

    // Show unconscious even if not leader or medic
    if ((_showCritical || !_showText) && {_lifeState == "INCAPACITATED" || _unit getVariable ["AIS_unconscious", false]}) then {
        _return = call {
            //  - Added support for A3 Wounding System
            if (_unit getVariable ["AIS_unconscious", false]) exitWith {
                // ""
                "a3\ui_f\data\igui\cfg\revive\overlayicons\u100_ca.paa"
            };
            if (_lifeState == "INCAPACITATED") exitWith {
                "a3\ui_f\data\igui\cfg\revive\overlayicons\u100_ca.paa"
            };
            _return
        };
    };
};
// Exit early if unit is not healthy
if (_return != "") exitWith {_return};

// Icon displayed when HUD is requested
if (SQFB_showHUD && {SQFB_opt_showRolesIcon}) then {
    // Role - sorted by precedence (high to low)
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
        if (_unit getVariable "SQFB_ammoBearer") exitWith { "SQFB\images\backpack.paa"; };
        if (_unit getVariable "SQFB_radioOperator") exitWith { "a3\ui_f\data\igui\cfg\holdactions\holdaction_connect_ca.paa"; };
        if (_unit getVariable "SQFB_handgun") exitWith { "SQFB\images\handgun.paa"; };
        if (_unit getVariable "SQFB_smg") exitWith { "SQFB\images\smg.paa"; };
        if (_unit getVariable "SQFB_shotgun") exitWith { "SQFB\images\shotgun.paa"; };
        if (_unit getVariable "SQFB_rifle") exitWith { "SQFB\images\rifle.paa"; };
        if (_unit getVariable "SQFB_unarmed") exitWith { "SQFB\images\none.paa"; };
        _return
    };
};

_return
