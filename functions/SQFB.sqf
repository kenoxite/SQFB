// -----------------------------------------------
// SQUAD FEEDBACK - Init
// by kenoxite
// -----------------------------------------------

// Init
SQFB_debug = if (is3DENPreview) then { true } else { false };
SQFB_units = [];
SQFB_unitsWithEH = [];
SQFB_deadUnits = [];
SQFB_knownEnemies = [];
SQFB_knownFriendlies = [];
SQFB_knownIFF = [];
SQFB_showHUD = false;
SQFB_showDeadMinTime = 0;
SQFB_squadTimeLastCheck = time;
SQFB_opt_profile_old = SQFB_opt_profile;

SQFB_showEnemies = false;
SQFB_showFriendlies = false;

SQFB_showIFFHUD = false;
SQFB_IFFTimeLastCheck = time;

SQFB_tagObjArr = [];
SQFB_deletingTaggers = false;

SQFB_lastNameSoundCheck = time;
SQFB_trackNames = [];
SQFB_validNames = [];
SQFB_validNames_English = [
    "armstrong",
    "nichols",
    "tanny",
    "frost",
    "lacey",
    "larkin",
    "kerry",
    "jackson",
    "miller",
    "mckendrick",
    "levine",
    "reynolds",
    "adams",
    "bennett",
    "campbell",
    "dixon",
    "everett",
    "franklin",
    "givens",
    "hawkins",
    "lopez",
    "martinez",
    "oconnor",
    "ryan",
    "patterson",
    "sykes",
    "taylor",
    "walker",

    "right",
    // "stype",
    // "kesson",

    // "stolarski",
    // "nowak",
    // "kowalski",

    "costa",
    "elias",
    "gekas",
    "kouris",
    "markos",
    "nikas",
    "panas",
    "petros",
    "rosi",
    "samaras",
    "thanos",
    "vega",

    "amin",
    "masood",
    "nazari",
    "yousuf",

    // "adamovich",
    // "ivanov",
    // "petrenko",

    "fox"
];
SQFB_validNames_Persian = [
    "amin",
    "masood",
    "fahim",
    "habibi",
    "kushan",
    "jawadi",
    "nazari",
    "siddiqi",
    "takhtar",
    "wardak",
    "yousuf"
];
SQFB_validNames_Greek = [
    "anthis",
    "costa",
    "dimitirou",
    "elias",
    "gekas",
    "kouris",
    "leventis",
    "markos",
    "nikas",
    "nicolo",
    "panas",
    "petros",
    "rosi",
    "samaras",
    "stavrou",
    "thanos",
    "vega"    
];
SQFB_validNames_Polish = [
    "smolko",
    "sternik",
    "stolarski",
    "yakhin",
    "zielinski",
    "burak",
    "gorecki",
    "kowalski",
    "nowak"
];
SQFB_validNames_Russian = [
    "yakhin",
    "adamovich",
    "ivanov",
    "kruglikov",
    "krupin",
    "kushan",
    "petrenko"
];
// SQFB_validCodeNames = [
//     "ghost",
//     "stranger",
//     "fox",
//     "snake",
//     "razer",
//     "jester",
//     "nomad",
//     "viper",
//     "korneedler"
// ];

SQFB_validNames append SQFB_validNames_English;
SQFB_validNames append SQFB_validNames_Persian;
SQFB_validNames append SQFB_validNames_Greek;
SQFB_validNames append SQFB_validNames_Polish;
SQFB_validNames append SQFB_validNames_Russian;


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
    "H_HelmetSpecO_blk",
    "H_HelmetSpecO_ghex_F",
    "H_HelmetSpecO_ocamo",
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
    // "O_NVGogglesB_gry_F",

    // IVAS
    "TIOW_IVAS_Tan",
    "TIOW_IVAS_Black",
    "TIOW_IVAS_White",
    "TIOW_IVAS_Green",
    "TIOW_IVAS_TanTI",
    "TIOW_IVAS_BlackTI",
    "TIOW_IVAS_WhiteTI",
    "TIOW_IVAS_GreenTI"
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
    "rhs_weap_m80",

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

SQFB_factionsWest = [
    // Main + Official DLCs
    "BLU_F",
    "BLU_G_F",
    "BLU_T_F",
    "BLU_CTRG_F",
    "BLU_GEN_F",
    "BLU_W_F"
];

SQFB_factionsEast = [
    // Main + Official DLCs
    "OPF_F",
    "OPF_G_F",
    "OPF_T_F",
    "OPF_R_F"
];

SQFB_factionsGuer = [
    // Main + Official DLCs
    "IND_F",
    "IND_G_F",
    "IND_C_F",
    "IND_E_F",
    "IND_L_F"
];

SQFB_factionsCiv = [
    // Main + Official DLCs
    "CIV_F",
    "CIV_IDAP_F"
];

// Add custom IFF device classes
[(SQFB_opt_EnemyTrackingGearGoggles splitString ",") apply {_x}, "goggles"] call SQFB_fnc_trackingGearAdd;
[(SQFB_opt_EnemyTrackingGearHelmets splitString ",") apply {_x}, "headgear"] call SQFB_fnc_trackingGearAdd;
[(SQFB_opt_EnemyTrackingGearHMD splitString ",") apply {_x}, "hmd"] call SQFB_fnc_trackingGearAdd;

waitUntil { !isNull player };

// Init player group
SQFB_player = call SQFB_fnc_playerUnit;
SQFB_group = group SQFB_player;
SQFB_unitCount = count units SQFB_group;
SQFB_lastPlayerIndex = -1;
[SQFB_group] call SQFB_fnc_initGroup;
SQFB_trackingGearCheck = call SQFB_fnc_trackingGearCheck;

// Set names and callsigns
{
    // Change names
    if (SQFB_opt_nameSound_ChangeNames) then {
        [_x] call SQFB_fnc_changeToValidName;
    };
    // Set callsign
    [_x] call SQFB_fnc_setNameSound;
} forEach (units player - [SQFB_player]);

// Set player position
SQFB_player setVariable ["SQFB_pos", getPosWorld vehicle SQFB_player];

// Keep track of group status
SQFB_EH_HUDupdate = [{ if (SQFB_opt_on && alive SQFB_player) then { call SQFB_fnc_HUDupdate }; }, SQFB_opt_updateDelay, []] call CBA_fnc_addPerFrameHandler;

// Update IFF display info
SQFB_EH_IFFupdate = [{ if (SQFB_opt_on && alive SQFB_player && {(SQFB_showFriendlies || SQFB_showEnemies || SQFB_showIFFHUD)}) then { [getPosWorld vehicle SQFB_player] call SQFB_fnc_IFFupdate }; }, SQFB_opt_HUDrefreshIFF, []] call CBA_fnc_addPerFrameHandler;

// HUD display
SQFB_draw3D_EH = addMissionEventHandler [
"Draw3D",
{
    if (SQFB_opt_on && alive SQFB_player) then {
        private _screenPosition = worldToScreen (_x modelToWorldVisual [0,0,0]);
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

            // Friends and foes
            if (time > SQFB_IFFTimeLastCheck + SQFB_opt_HUDrefreshIFF) then {
                if (SQFB_showEnemies || SQFB_showFriendlies) then {
                    call SQFB_fnc_HUDdrawIFF;
                };
                SQFB_IFFTimeLastCheck = time;
            };

            // Update player position
            SQFB_player setVariable ["SQFB_pos", _playerPos];
        };
    };
}];
