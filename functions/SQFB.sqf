// -----------------------------------------------
// SQUAD FEEDBACK - Init
// by kenoxite
// -----------------------------------------------

// Init
SQFB_debug = if (is3DENPreview) then { true } else { false };
SQFB_units = [];
SQFB_knownEnemies = [];
SQFB_showHUD = false;
SQFB_showDeadMinTime = 0;
SQFB_squadTimeLastCheck = time;
SQFB_opt_profile_old = SQFB_opt_profile;

SQFB_showEnemies = false;
SQFB_showEnemyHUD = false;
SQFB_showEnemiesMinTime = 0;
SQFB_enemyTagObjArr = [];
SQFB_enemiesTimeLastCheck = time;

SQFB_enemyTrackingGoggles_default = [
    "G_Balaclava_combat",
    "G_Combat",
    "G_Combat_Goggles_tna_F",
    "G_Balaclava_TI_G_blk_F",
    "G_Balaclava_TI_G_tna_F",
    "G_Tactical_Clear",
    "G_Tactical_Black",
    "G_Goggles_VR"
];
SQFB_enemyTrackingGoggles = +SQFB_enemyTrackingGoggles_default;

SQFB_enemyTrackingHeadgear_default = [
    "H_HelmetSpecoO_blk",
    "H_HelmetSpecoO_ghex_F",
    "H_HelmetSpecoO_ocamo",
    "H_HelmetLeaderO_ghex_F",
    "H_HelmetLeaderO_ocamo",
    "H_HelmetLeaderO_oucamo",
    "H_PilotHelmetFighter_I",
    "H_PilotHelmetFighter_O",
    "H_PilotHelmetFighter_I_E",
    "H_PilotHelmetFighter_B",
    "H_HelmetO_ViperSP_ghex_F",
    "H_HelmetO_ViperSP_hex_F"

    // "H_Hat_Tinfoil_F"
];
SQFB_enemyTrackingHeadgear = +SQFB_enemyTrackingHeadgear_default;

SQFB_enemyTrackingHMD_default = [
    // "O_NVGoggles_ghex_F",
    // "O_NVGoggles_grn_F",
    // "O_NVGoggles_hex_F",
    // "O_NVGoggles_urb_F",
    // "O_NVGogglesB_blk_F",
    // "O_NVGogglesB_grn_F",
    // "O_NVGogglesB_gry_F"
];
SQFB_enemyTrackingHMD = +SQFB_enemyTrackingHMD_default;

SQFB_oneShotLaunchers_default = [
    // RHS
    "rhs_weap_m72a7",
    "rhs_weap_M136",
    "rhs_weap_M136_hedp",
    "rhs_weap_M136_hp",
    "rhs_weap_rpg26",
    "rhs_weap_rpg18",
    "rhs_weap_rshg2",

    // CUP
    "CUP_launch_M136",
    "CUP_launch_M72A6",
    "CUP_launch_M72A6_Special",
    "CUP_launch_RPG26",
    "CUP_launch_RPG18",
    "CUP_launch_RShG2",

    // CWR3
    "cwr3_launch_at4",
    "cwr3_launch_m72a3",
    "cwr3_launch_rpg75",
    "cwr3_launch_rpg75"
];
SQFB_oneShotLaunchers = +SQFB_oneShotLaunchers_default;

waitUntil { !isNull player };

SQFB_player = call SQFB_fnc_playerUnit;

// Init player group
private _grp = group SQFB_player;
private _units = units _grp;
SQFB_unitCount = count _units;
[_grp] call SQFB_fnc_initGroup;
// Add units to the global array
[_units] call SQFB_fnc_addUnits;

// Set player position
player setVariable ["SQFB_pos", getPosWorld vehicle SQFB_player];

// Keep track of group status
SQFB_EH_update = [{ if (SQFB_opt_on) then { [] call SQFB_fnc_HUDupdate }; }, SQFB_opt_updateDelay, []] call CBA_fnc_addPerFrameHandler;

// HUD display
SQFB_draw3D_EH = addMissionEventHandler [
"Draw3D",
{
    private _offset = [0,0,0];
    if (SQFB_opt_on) then {
        private _screenPosition = worldToScreen (_x modelToWorldVisual _offset);
        if (_screenPosition isEqualTo []) exitWith {};

        if (count SQFB_units > 0) then {
            private _playerPos = getPosWorld vehicle SQFB_player;
            // Squad
            if (time > SQFB_squadTimeLastCheck + SQFB_opt_HUDrefresh) then {
                if (SQFB_opt_showSquad) then {
                    [_playerPos] call SQFB_fnc_HUDdrawSquad;
                };
                SQFB_squadTimeLastCheck = time;
            };

            // Enemies
            if (time > SQFB_enemiesTimeLastCheck + SQFB_opt_HUDrefresh) then {
                if (SQFB_showEnemies || {time >= SQFB_showEnemiesMinTime && SQFB_showEnemyHUD}) then {
                    [_playerPos] call SQFB_fnc_HUDdrawEnemies;
                };
                SQFB_enemiesTimeLastCheck = time;
            };
            // Update player position
            player setVariable ["SQFB_pos", _playerPos];
        };
    };
}];
