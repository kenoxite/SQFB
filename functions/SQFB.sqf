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

// ---------------------------------------
// Unit names
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
    "yousuf"
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
SQFB_validCodeNames = [
    "ghost",
    "stranger",
    "fox",
    "snake",
    "razer",
    "jester",
    // "nomad", // not available in some voices
    "viper",
    "korneedler"
];

SQFB_validNames append SQFB_validNames_English;
SQFB_validNames append SQFB_validNames_Persian;
SQFB_validNames append SQFB_validNames_Greek;
SQFB_validNames append SQFB_validNames_Polish;
SQFB_validNames append SQFB_validNames_Russian;

SQFB_EnochNames = [];
SQFB_EnochNames append SQFB_validNames_Polish;
SQFB_EnochNames append SQFB_validNames_Russian;

SQFB_voicesEnglish = [
    "male01eng",
    "male02eng",
    "male03eng",
    "male04eng",
    "male05eng",
    "male06eng",
    "male07eng",
    "male08eng",
    "male09eng",
    "male10eng",
    "male11eng",
    "male12eng",

    "male01engb",
    "male02engb",
    "male03engb",
    "male04engb",
    "male05engb",

    "male01engvr"
];
SQFB_voicesGreek = [
    "male01gre",
    "male02gre",
    "male03gre",
    "male04gre",
    "male05gre",
    "male06gre",

    "male01grevr"
];
SQFB_voicesPersian = [
    "male01per",
    "male02per",
    "male03per",

    "male01pervr"
];
SQFB_voicesFrench = [
    "male01fre",
    "male02fre",
    "male03fre"
];
SQFB_voicesFrenchEng = [
    "male01engfre",
    "male02engfre"
];
SQFB_voicesChinese = [
    "male01chi",
    "male02chi",
    "male03chi"
];
SQFB_voicesPolish = [
    "male01pol",
    "male02pol",
    "male03pol"
];
SQFB_voicesRussian = [
    "male01rus",
    "male02rus",
    "male03rus"
];
SQFB_noEnochVoices = [];
SQFB_noEnochVoices append SQFB_voicesEnglish;
SQFB_noEnochVoices append SQFB_voicesGreek;
SQFB_noEnochVoices append SQFB_voicesPersian;
SQFB_noEnochVoices append SQFB_voicesFrench;
SQFB_noEnochVoices append SQFB_voicesFrenchEng;
SQFB_noEnochVoices append SQFB_voicesChinese;


// ---------------------------------------
// Addition lists
SQFB_enemyTrackingGoggles_default = [
    "G_Balaclava_combat",
    "G_Combat",
    "G_Combat_Goggles_tna_F",
    "G_Balaclava_TI_G_blk_F",
    "G_Balaclava_TI_G_tna_F",
    "G_Tactical_Clear",
    "G_Tactical_Black",
    "G_Goggles_VR",

    // E22
    "E22_G_Combat_Goggles_base_F",
    "E22_G_Tactical_base_F"
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

// Add custom additional IFF device classes
[(SQFB_opt_EnemyTrackingGearGoggles splitString ",") apply {_x}, "goggles"] call SQFB_fnc_trackingGearAdd;
[(SQFB_opt_EnemyTrackingGearHelmets splitString ",") apply {_x}, "headgear"] call SQFB_fnc_trackingGearAdd;
[(SQFB_opt_EnemyTrackingGearHMD splitString ",") apply {_x}, "hmd"] call SQFB_fnc_trackingGearAdd;

// ---------------------------------------
// Exclusion lists
SQFB_enemyTrackingGogglesExcluded_default = [
    // RHS
    "rhsusf_shemagh_base",
    "rhsusf_shemagh2_base",
    "rhsusf_shemagh_gogg_base",
    "rhsusf_shemagh2_gogg_base",
    "rhsusf_oakley_goggles_base",
    "rhs_googles_black",
    "rhs_googles_clear",
    "rhs_googles_orange",
    "rhs_googles_yellow",
    "rhs_ess_black"
];
SQFB_enemyTrackingGogglesExcluded = +SQFB_enemyTrackingGogglesExcluded_default;

SQFB_enemyTrackingHeadgearExcluded_default = [
    //
];
SQFB_enemyTrackingHeadgearExcluded = +SQFB_enemyTrackingHeadgearExcluded_default;

SQFB_enemyTrackingHMDExcluded_default = [
    //
];
SQFB_enemyTrackingHMDExcluded = +SQFB_enemyTrackingHMDExcluded_default;

// Add custom excluded IFF device classes
[(SQFB_opt_EnemyTrackingGearGogglesExcluded splitString ",") apply {_x}, "goggles", false] call SQFB_fnc_trackingGearAdd;
[(SQFB_opt_EnemyTrackingGearHelmetsExcluded splitString ",") apply {_x}, "headgear", false] call SQFB_fnc_trackingGearAdd;
[(SQFB_opt_EnemyTrackingGearHMDExcluded splitString ",") apply {_x}, "hmd", false] call SQFB_fnc_trackingGearAdd;


// ---------------------------------------
// One shot launchers to disable NO AMMO warning on AI units
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
    "CUP_launch_NLAW",

    // CWR3
    "cwr3_launch_at4",
    "cwr3_launch_m72a3",
    "cwr3_launch_rpg75",

    // GM
    "gm_1Rnd_66mm_heat_m72a3",
    "gm_1Rnd_64mm_heat_pg18",

    // Free World Armory
    "sp_fwa_m72a1_law_loaded"
];
SQFB_oneShotLaunchers = +SQFB_oneShotLaunchers_default;


// ---------------------------------------
// Factions for icon colors
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

// ---------------------------------------
waitUntil { !isNull player };

// ---------------------------------------
// Init player group
SQFB_player = call SQFB_fnc_playerUnit;
SQFB_group = group SQFB_player;
SQFB_unitCount = count units SQFB_group;
SQFB_lastPlayerIndex = -1;
[SQFB_group] call SQFB_fnc_initGroup;
SQFB_trackingGearCheck = call SQFB_fnc_trackingGearCheck;

// ---------------------------------------
// Set names and callsigns
{
    // Change names
    if (SQFB_opt_nameSound_ChangeNames) then {
        [_x] call SQFB_fnc_changeToValidName;
    };
    // Set callsign
    [_x] call SQFB_fnc_setNameSound;
} forEach (units player - [SQFB_player]);
[SQFB_player] call SQFB_fnc_setNameSound;

// Set player position
SQFB_player setVariable ["SQFB_pos", getPosWorld vehicle SQFB_player];

// ---------------------------------------
// Keep track of group status
SQFB_EH_HUDupdate = [{ if (isNull SQFB_player) then { SQFB_player = call SQFB_fnc_playerUnit }; if (SQFB_opt_on && alive SQFB_player) then { call SQFB_fnc_HUDupdate }; }, SQFB_opt_updateDelay, []] call CBA_fnc_addPerFrameHandler;

// ---------------------------------------
// Update IFF display info
SQFB_EH_IFFupdate = [{ if (isNull SQFB_player) then { SQFB_player = call SQFB_fnc_playerUnit }; if (SQFB_opt_on && alive SQFB_player && {(SQFB_showFriendlies || SQFB_showEnemies || SQFB_showIFFHUD)}) then { [getPosWorld vehicle SQFB_player] call SQFB_fnc_IFFupdate }; }, SQFB_opt_updateDelayIFF, []] call CBA_fnc_addPerFrameHandler;

// ---------------------------------------
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
