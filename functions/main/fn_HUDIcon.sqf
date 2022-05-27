/*
    Author: kenoxite

    Description:
    Update the HUD icon for the unit


    Parameter (s):
    _this select 0: _unit


    Returns:


    Examples:d
*/

params ["_unit"];

private _return = "";

if (!SQFB_opt_showIcon) exitwith { _return };

// Exclude players
if (_unit == SQFB_player) exitWith {_return};

if (SQFB_showHUD) then {
    if (SQFB_opt_profile != "crit") then {
        // Role - in reverse order of preference (lower is higher priority)
        if (_unit getVariable "SQFB_unarmed") then { _return = "SQFB\images\none.paa"; };
        if (_unit getVariable "SQFB_rifle") then { _return = "SQFB\images\rifle.paa"; };
        if (_unit getVariable "SQFB_shotgun") then { _return = "SQFB\images\shotgun.paa"; };
        if (_unit getVariable "SQFB_smg") then { _return = "SQFB\images\smg.paa"; };
        if (_unit getVariable "SQFB_handgun") then { _return = "SQFB\images\handgun.paa"; };
        if (_unit getVariable "SQFB_ammoBearer" || _unit getVariable "SQFB_assistAT" || _unit getVariable "SQFB_assistAA" || _unit getVariable "SQFB_assistLMG") then { _return = "SQFB\images\backpack.paa"; };
        if (_unit getVariable "SQFB_hacker") then { _return = "a3\ui_f\data\igui\cfg\holdactions\holdaction_hack_ca.paa"; };
        if (_unit getVariable "SQFB_GL") then { _return = "a3\ui_f\data\igui\cfg\weaponicons\gl_ca.paa"; };
        if (_unit getVariable "SQFB_sniper") then { _return = "a3\ui_f\data\igui\cfg\weaponicons\srifle_ca.paa"; };
        if (_unit getVariable "SQFB_demo") then { _return = "a3\ui_f\data\igui\cfg\cursors\explosive_ca.paa"; };
        if (_unit getVariable "SQFB_engi") then { _return = "a3\ui_f\data\igui\cfg\cursors\iconrepairat_ca.paa"; };
        if (_unit getVariable "SQFB_MG") then { _return = "a3\ui_f\data\igui\cfg\weaponicons\mg_ca.paa"; };
        if (_unit getVariable "SQFB_AT") then { _return = "a3\ui_f\data\igui\cfg\weaponicons\at_ca.paa"; };
        if (_unit getVariable "SQFB_AA") then { _return = "a3\ui_f\data\igui\cfg\weaponicons\aa_ca.paa"; };
        if (_unit getVariable "SQFB_medic") then { _return = "a3\ui_f\data\igui\cfg\cursors\unithealer_ca.paa"; };
    };

    if (!alive _unit && SQFB_opt_showDead && time >= SQFB_showDeadMinTime) then { _return = "a3\ui_f\data\igui\cfg\revive\overlayicons\f100_ca.paa" };
} else {
    if (SQFB_opt_AlwaysShowCritical && {(SQFB_player getVariable "SQFB_medic" || leader _unit == SQFB_player) || {!SQFB_opt_showText}}) then {
        // Ammo amount
        if ((vehicle _unit) == _unit) then {
            if (_unit getVariable "SQFB_noAmmo") then {
                _return = "a3\ui_f\data\igui\cfg\actions\gear_ca.paa";
            };
        };

        // Show medics when there's wounded units in the group
        if (((_unit getVariable "SQFB_medic") && (group _unit) getVariable "SQFB_wounded")) then {
            _return = "a3\ui_f\data\igui\cfg\cursors\unithealer_ca.paa";
        };

        // Health
        //  - These have preference over the role icons
        switch (lifeState _unit) do {
            case "INCAPACITATED": { 
                _return = "a3\ui_f\data\igui\cfg\revive\overlayicons\u100_ca.paa";
            };
            case "INJURED": {
                _return = [
                                "a3\ui_f\data\igui\cfg\revive\overlayicons\r100_ca.paa",
                                "a3\ui_f\data\igui\cfg\cursors\unitbleeding_ca.paa"
                            ] select (isBleeding _unit);
            };
        };
    };
};

_return 