#include "\a3\ui_f\hpp\definedikcodes.inc";

/*
Function: CBA_fnc_addKeybind

Description:
 Adds or updates the keybind handler for a specified mod action, and associates
 a function with that keybind being pressed.

Parameters:
 _modName           Name of the registering mod [String]
 _actionId  	    Id of the key action. [String]
 _displayName       Pretty name, or an array of strings for the pretty name and a tool tip [String]
 _downCode          Code for down event, empty string for no code. [Code]
 _upCode            Code for up event, empty string for no code. [Code]

 Optional:
 _defaultKeybind    The keybinding data in the format [DIK, [shift, ctrl, alt]] [Array]
 _holdKey           Will the key fire every frame while down [Bool]
 _holdDelay         How long after keydown will the key event fire, in seconds. [Float]
 _overwrite         Overwrite any previously stored default keybind [Bool]

Returns:
 Returns the current keybind for the action [Array]
*/

[
    ["Squad Feedback", ""],
	"SQFB_opt_showHUD_key",
	[localize "STR_SQFB_Ctrl_SquadHUDkey", localize "STR_SQFB_Ctrl_SquadHUDkey_desc"],
	{ _this call SQFB_fnc_showHUD_key_CBA },
	{ _this call SQFB_fnc_hideHUD_key_CBA }
] call CBA_fnc_addKeybind;

[
    ["Squad Feedback", ""],
	"SQFB_opt_showHUD_T_key",
	[localize "STR_SQFB_Ctrl_SquadHUDkeyToggle", localize "STR_SQFB_Ctrl_SquadHUDkeyToggle_desc"],
	{ _this call SQFB_fnc_showHUD_key_T_CBA },
	{},
	[ DIK_TAB, [false, false, false] ], // [DIK, [shift, ctrl, alt]] 
	false
] call CBA_fnc_addKeybind;

[
    ["Squad Feedback", ""],
    "SQFB_opt_showEnemyHUD_key",
    [localize "STR_SQFB_Ctrl_enemyHUDkey", localize "STR_SQFB_Ctrl_enemyHUDkey_desc"],
    { _this call SQFB_fnc_showEnemyHUD_key_CBA },
    { _this call SQFB_fnc_hideEnemyHUD_key_CBA }
] call CBA_fnc_addKeybind;

[
    ["Squad Feedback", ""],
    "SQFB_opt_showEnemyHUD_T_key",
    [localize "STR_SQFB_Ctrl_enemyHUDkeyToggle", localize "STR_SQFB_Ctrl_enemyHUDkeyToggle_desc"],
    { _this call SQFB_fnc_showEnemyHUD_key_T_CBA },
    {},
    [ DIK_TAB, [false, true, false] ], // [DIK, [shift, ctrl, alt]] 
    false
] call CBA_fnc_addKeybind;

/*
Parameters:
    _setting     - Unique setting name. Matches resulting variable name <STRING>
    _settingType - Type of setting. Can be "CHECKBOX", "EDITBOX", "LIST", "SLIDER" or "COLOR" <STRING>
    _title       - Display name or display name + tooltip (optional, default: same as setting name) <STRING, ARRAY>
    _category    - Category for the settings menu + optional sub-category <STRING, ARRAY>
    _valueInfo   - Extra properties of the setting depending of _settingType. See examples below <ANY>
    _isGlobal    - 1: all clients share the same setting, 2: setting can't be overwritten (optional, default: 0) <NUMBER>
    _script      - Script to execute when setting is changed. (optional) <CODE>
    _needRestart - Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
*/

[
    "SQFB_opt_on", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_on", localize "STR_SQFB_opt_on_desc"],
    "Squad Feedback",
    [true],
    nil,
    {} 
] call CBA_fnc_addSetting;


// GENERAL
[
    "SQFB_opt_profile", 
    "LIST",
    [localize "STR_SQFB_opt_profile", localize "STR_SQFB_opt_profile_desc"],
    "Squad Feedback",
    [["custom", "default", "all", "min", "crit", "vanillalike", "onlyalwaysenemies"],[localize "STR_SQFB_opt_profile_custom", localize "STR_A3_OPTIONS_DEFAULT", localize "STR_SQFB_opt_profile_allOn", localize "STR_SQFB_opt_profile_minimalist", localize "STR_SQFB_opt_profile_onlyCritical", localize "STR_SQFB_opt_profile_vanillaLike", localize "STR_SQFB_opt_profile_onlyAlwaysEnemies"], 1],
    nil,
    { call SQFB_fnc_changeProfile; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showSquad", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_showSquad", localize "STR_SQFB_opt_showSquad_desc"],
    ["Squad Feedback", format ["00 - %1", localize "STR_SQFB_opt_general"]],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showEnemies", 
    "LIST",
    [localize "STR_SQFB_opt_showEnemies", localize "STR_SQFB_opt_showEnemies_desc"],
    ["Squad Feedback", format ["00 - %1", localize "STR_SQFB_opt_general"]],
    [["never", "keypressed", "always", "device"], [localize "STR_SQFB_opt_showEnemies_never", localize "STR_SQFB_opt_showEnemies_keyPressed", localize "STR_SQFB_opt_showEnemies_always", localize "STR_SQFB_opt_showEnemies_device"], 1],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showFriendlies", 
    "LIST",
    [localize "STR_SQFB_opt_showFriendlies", localize "STR_SQFB_opt_showFriendlies_desc"],
    ["Squad Feedback", format ["00 - %1", localize "STR_SQFB_opt_general"]],
    [["never", "keypressed", "always", "device"], [localize "STR_SQFB_opt_showEnemies_never", localize "STR_SQFB_opt_showEnemies_keyPressed", localize "STR_SQFB_opt_showEnemies_always", localize "STR_SQFB_opt_showEnemies_device"], 1],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_updateDelay", 
    "SLIDER",
    [localize "STR_SQFB_opt_updateDelay", localize "STR_SQFB_opt_updateDelay_desc"],
    ["Squad Feedback", format ["00 - %1", localize "STR_SQFB_opt_general"]],
    [0.1, 30, 5, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_HUDrefresh", 
    "SLIDER",
    [localize "STR_SQFB_opt_HUDrefresh", localize "STR_SQFB_opt_HUDrefresh_desc"], 
    ["Squad Feedback", format ["00 - %1", localize "STR_SQFB_opt_general"]],
    [0, 0.05, 0.011, 3], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_HUDrefreshIFF", 
    "SLIDER",
    [localize "STR_SQFB_opt_HUDrefreshIFF", localize "STR_SQFB_opt_HUDrefreshIFF_desc"], 
    ["Squad Feedback", format ["00 - %1", localize "STR_SQFB_opt_general"]],
    [0, 0.05, 0.011, 3], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;


// HUD DISPLAY - General
[
    "SQFB_opt_showIcon", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_showIcon", localize "STR_SQFB_opt_showIcon_desc"],
    ["Squad Feedback", format ["01 - %1", localize "STR_SQFB_opt_HUDdisplay_general"]],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showText", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_showText", localize "STR_SQFB_opt_showText_desc"],
    ["Squad Feedback", format ["01 - %1", localize "STR_SQFB_opt_HUDdisplay_general"]],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showColor", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_showColor", localize "STR_SQFB_opt_showColor_desc"],
    ["Squad Feedback", format ["01 - %1", localize "STR_SQFB_opt_HUDdisplay_general"]],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;


// HUD DISPLAY - Squad
[
    "SQFB_opt_maxRange", 
    "SLIDER",
    [localize "STR_SQFB_opt_maxRange", localize "STR_SQFB_opt_maxRange_desc"], 
    ["Squad Feedback", format ["02 - %1", localize "STR_SQFB_opt_HUDdisplay_squad"]],
    [10, 5000, 800, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_maxRangeAir", 
    "SLIDER",
    [localize "STR_SQFB_opt_maxRange_air", localize "STR_SQFB_opt_maxRange_air_desc"], 
    ["Squad Feedback", format ["02 - %1", localize "STR_SQFB_opt_HUDdisplay_squad"]],
    [10, 5000, 2000, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;


// HUD DISPLAY - Enemies
[
    "SQFB_opt_showEnemiesMinTime", 
    "SLIDER",
    [localize "STR_SQFB_opt_showEnemiesMinTime", localize "STR_SQFB_opt_showEnemiesMinTime_desc"], 
    ["Squad Feedback", format ["03 - %1", localize "STR_SQFB_opt_HUDdisplay_enemies"]],
    [0, 60, 0, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showEnemiesMaxUnits", 
    "SLIDER",
    [localize "STR_SQFB_opt_showEnemiesMaxUnits", localize "STR_SQFB_opt_showEnemiesMaxUnits_desc"], 
    ["Squad Feedback", format ["03 - %1", localize "STR_SQFB_opt_HUDdisplay_enemies"]],
    [-1, 100, -1, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showEnemiesMinRange", 
    "SLIDER",
    [localize "STR_SQFB_opt_showEnemiesMinRange", localize "STR_SQFB_opt_showEnemiesMinRange_desc"], 
    ["Squad Feedback", format ["03 - %1", localize "STR_SQFB_opt_HUDdisplay_enemies"]],
    [0, 1000, 20, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showEnemiesMinRangeAir", 
    "SLIDER",
    [localize "STR_SQFB_opt_showEnemiesMinRangeAir", localize "STR_SQFB_opt_showEnemiesMinRangeAir_desc"], 
    ["Squad Feedback", format ["03 - %1", localize "STR_SQFB_opt_HUDdisplay_enemies"]],
    [0, 5000, 100, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showEnemiesMaxRange", 
    "SLIDER",
    [localize "STR_SQFB_opt_showEnemiesMaxRange", localize "STR_SQFB_opt_showEnemiesMaxRange_desc"], 
    ["Squad Feedback", format ["03 - %1", localize "STR_SQFB_opt_HUDdisplay_enemies"]],
    [100, 5000, 800, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showEnemiesMaxRangeAir", 
    "SLIDER",
    [localize "STR_SQFB_opt_showEnemiesMaxRangeAir", localize "STR_SQFB_opt_showEnemiesMaxRangeAir_desc"], 
    ["Squad Feedback", format ["03 - %1", localize "STR_SQFB_opt_HUDdisplay_enemies"]],
    [100, 10000, 2000, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

// [
//     "SQFB_opt_showEnemiesIfTrackingGear", 
//     "CHECKBOX",
//     [localize "STR_SQFB_opt_showEnemiesIfTrackingGear", localize "STR_SQFB_opt_showEnemiesIfTrackingGear_desc"],
//     ["Squad Feedback", format ["03 - %1", localize "STR_SQFB_opt_HUDdisplay_enemies"]],
//     [true],
//     nil,
//     {} 
// ] call CBA_fnc_addSetting;


// HUD DISPLAY - Friendlies
[
    "SQFB_opt_showFriendliesMinTime", 
    "SLIDER",
    [localize "STR_SQFB_opt_showFriendliesMinTime", localize "STR_SQFB_opt_showFriendliesMinTime_desc"], 
    ["Squad Feedback", format ["04 - %1", localize "STR_SQFB_opt_HUDdisplay_friendlies"]],
    [0, 60, 0, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showFriendliesMaxUnits", 
    "SLIDER",
    [localize "STR_SQFB_opt_showFriendliesMaxUnits", localize "STR_SQFB_opt_showFriendliesMaxUnits_desc"], 
    ["Squad Feedback", format ["04 - %1", localize "STR_SQFB_opt_HUDdisplay_friendlies"]],
    [-1, 100, -1, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showFriendliesMinRange", 
    "SLIDER",
    [localize "STR_SQFB_opt_showFriendliesMinRange", localize "STR_SQFB_opt_showFriendliesMinRange_desc"], 
    ["Squad Feedback", format ["04 - %1", localize "STR_SQFB_opt_HUDdisplay_friendlies"]],
    [0, 1000, 30, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showFriendliesMinRangeAir", 
    "SLIDER",
    [localize "STR_SQFB_opt_showFriendliesMinRangeAir", localize "STR_SQFB_opt_showFriendliesMinRangeAir_desc"], 
    ["Squad Feedback", format ["04 - %1", localize "STR_SQFB_opt_HUDdisplay_friendlies"]],
    [0, 5000, 30, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showFriendliesMaxRange", 
    "SLIDER",
    [localize "STR_SQFB_opt_showFriendliesMaxRange", localize "STR_SQFB_opt_showFriendliesMaxRange_desc"], 
    ["Squad Feedback", format ["04 - %1", localize "STR_SQFB_opt_HUDdisplay_friendlies"]],
    [100, 5000, 200, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showFriendliesMaxRangeAir", 
    "SLIDER",
    [localize "STR_SQFB_opt_showFriendliesMaxRangeAir", localize "STR_SQFB_opt_showFriendliesMaxRangeAir_desc"], 
    ["Squad Feedback", format ["04 - %1", localize "STR_SQFB_opt_HUDdisplay_friendlies"]],
    [100, 10000, 1000, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;


// HUD DISPLAY - Text
[
    "SQFB_opt_showIndex", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_showIndex", localize "STR_SQFB_opt_showIndex_desc"],
    ["Squad Feedback", format ["05 - %1", localize "STR_SQFB_opt_HUDdisplay_textOptions"]],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showClass", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_showClass", localize "STR_SQFB_opt_showClass_desc"],
    ["Squad Feedback", format ["05 - %1", localize "STR_SQFB_opt_HUDdisplay_textOptions"]],
    [false],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showRoles", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_showRoles", localize "STR_SQFB_opt_showRoles_desc"],
    ["Squad Feedback", format ["05 - %1", localize "STR_SQFB_opt_HUDdisplay_textOptions"]],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showRolesIcon", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_showRolesIcon", localize "STR_SQFB_opt_showRolesIcon_desc"],
    ["Squad Feedback", format ["05 - %1", localize "STR_SQFB_opt_HUDdisplay_textOptions"]],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showDist", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_showDist", localize "STR_SQFB_opt_showDist_desc"],
    ["Squad Feedback", format ["05 - %1", localize "STR_SQFB_opt_HUDdisplay_textOptions"]],
    [false],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showDistEnemy", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_showDistEnemy", localize "STR_SQFB_opt_showDistEnemy_desc"],
    ["Squad Feedback", format ["05 - %1", localize "STR_SQFB_opt_HUDdisplay_textOptions"]],
    [false],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showDistFriendly", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_showDistFriendly", localize "STR_SQFB_opt_showDistFriendly_desc"],
    ["Squad Feedback", format ["05 - %1", localize "STR_SQFB_opt_HUDdisplay_textOptions"]],
    [false],
    nil,
    {} 
] call CBA_fnc_addSetting;


// HUD CUSTOMIZATION
[
    "SQFB_opt_iconSize", 
    "SLIDER",
    [localize "STR_SQFB_opt_iconSize", localize "STR_SQFB_opt_iconSize_desc"], 
    ["Squad Feedback", format ["06 - %1", localize "STR_SQFB_opt_HUDcustomization"]],
    [0.1, 2, 1, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_iconHeight", 
    "SLIDER",
    [localize "STR_SQFB_opt_iconHeight", localize "STR_SQFB_opt_iconHeight_desc"],
    ["Squad Feedback", format ["06 - %1", localize "STR_SQFB_opt_HUDcustomization"]],
    [-2, 2, 0, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_iconHor", 
    "SLIDER",
    [localize "STR_SQFB_opt_iconHor", localize "STR_SQFB_opt_iconHor_desc"],
    ["Squad Feedback", format ["06 - %1", localize "STR_SQFB_opt_HUDcustomization"]],
    [-2, 2, 0, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_iconHeightVeh", 
    "SLIDER",
    [localize "STR_SQFB_opt_iconHeightVeh", localize "STR_SQFB_opt_iconHeightVeh_desc"],
    ["Squad Feedback", format ["06 - %1", localize "STR_SQFB_opt_HUDcustomization"]],
    [-3, 3, 0, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_iconHorVeh", 
    "SLIDER",
    [localize "STR_SQFB_opt_iconHorVeh", localize "STR_SQFB_opt_iconHorVeh_desc"],
    ["Squad Feedback", format ["06 - %1", localize "STR_SQFB_opt_HUDcustomization"]],
    [-5, 5, 0, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_textSize", 
    "SLIDER",
    [localize "STR_SQFB_opt_textSize", localize "STR_SQFB_opt_textSize_desc"],
    ["Squad Feedback", format ["06 - %1", localize "STR_SQFB_opt_HUDcustomization"]],
    [0.1, 2, 1, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

/*

    0: Values this setting can take. <ARRAY>
    1: Corresponding pretty names for the ingame settings menu. Can be stringtable entries. <ARRAY>
    2: Index of the default value. Not the default value itself. <NUMBER>
    Example: [[false, true], ["STR_A3_OPTIONS_DISABLED", "STR_A3_OPTIONS_ENABLED"], 0]

*/

[
    "SQFB_opt_textFont", 
    "LIST",
    [localize "STR_SQFB_opt_textFont", localize "STR_SQFB_opt_textFont_desc"],
    ["Squad Feedback", format ["06 - %1", localize "STR_SQFB_opt_HUDcustomization"]],
    [["EtelkaMonospacePro","EtelkaMonospaceProBold","EtelkaNarrowMediumPro","LucidaConsoleB","PuristaBold","PuristaLight","PuristaMedium","PuristaSemiBold","RobotoCondensed","RobotoCondensedBold","RobotoCondensedLight","TahomaB"], ["EtelkaMonospacePro","EtelkaMonospaceProBold","EtelkaNarrowMediumPro","LucidaConsoleB","PuristaBold","PuristaLight","PuristaMedium","PuristaSemiBold","RobotoCondensed","RobotoCondensedBold","RobotoCondensedLight","TahomaB"],6],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_maxAlpha", 
    "SLIDER",
    [localize "STR_SQFB_opt_maxAlpha", localize "STR_SQFB_opt_maxAlpha_desc"],
    ["Squad Feedback", format ["06 - %1", localize "STR_SQFB_opt_HUDcustomization"]],
    [0.1, 1, 0.9, 2], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;


// ADVANCED - General
[
    "SQFB_opt_alternateOcclusionCheck", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_alternateOcclusionCheck", localize "STR_SQFB_opt_alternateOcclusionCheck_desc"],
    ["Squad Feedback", format ["07 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced"]],
    [false],
    nil,
    {} 
] call CBA_fnc_addSetting;


// ADVANCED - Squad
[
    "SQFB_opt_Arrows", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_Arrows", localize "STR_SQFB_opt_Arrows_desc"],
    ["Squad Feedback", format ["08 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_squad"]],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_outFOVindex", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_outFOVindex", localize "STR_SQFB_opt_outFOVindex_desc"],
    ["Squad Feedback", format ["08 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_squad"]],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_checkOcclusion", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_checkOcclusion", localize "STR_SQFB_opt_checkOcclusion_desc"],
    ["Squad Feedback", format ["08 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_squad"]],
    [false],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_scaleText", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_scaleText", localize "STR_SQFB_opt_scaleText_desc"],
    ["Squad Feedback", format ["08 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_squad"]],
    [true],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_ShowCrew", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_ShowCrew", localize "STR_SQFB_opt_ShowCrew_desc"],
    ["Squad Feedback", format ["08 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_squad"]],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_GroupCrew", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_GroupCrew", localize "STR_SQFB_opt_GroupCrew_desc"],
    ["Squad Feedback", format ["08 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_squad"]],
    [true],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showDead", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_showDead", localize "STR_SQFB_opt_showDead_desc"],
    ["Squad Feedback", format ["08 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_squad"]],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showDeadMinTime", 
    "SLIDER",
    [localize "STR_SQFB_opt_showDeadMinTime", localize "STR_SQFB_opt_showDeadMinTime_desc"],
    ["Squad Feedback", format ["08 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_squad"]],
    [0, 60, 3, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_AlwaysShowCritical", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_AlwaysShowCritical", localize "STR_SQFB_opt_AlwaysShowCritical_desc"],
    ["Squad Feedback", format ["08 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_squad"]],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;


// ADVANCED - Enemies
[
    "SQFB_opt_checkOcclusionEnemies", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_checkOcclusionEnemies", localize "STR_SQFB_opt_checkOcclusionEnemies_desc"],
    ["Squad Feedback", format ["09 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_enemies"]],
    [true],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_enemyCheckSolo", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_enemyCheckSolo", localize "STR_SQFB_opt_enemyCheckSolo_desc"],
    ["Squad Feedback", format ["09 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_enemies"]],
    [true],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_alwaysDisplayTarget", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_alwaysDisplayTarget", localize "STR_SQFB_opt_alwaysDisplayTarget_desc"],
    ["Squad Feedback", format ["09 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_enemies"]],
    [true],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_enemyPreciseVisCheck", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_enemyPreciseVisCheck", localize "STR_SQFB_opt_enemyPreciseVisCheck_desc"],
    ["Squad Feedback", format ["09 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_enemies"]],
    [false],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_lastKnownEnemyPositionOnly", 
    "LIST", 
    [localize "STR_SQFB_opt_lastKnownEnemyPositionOnly", localize "STR_SQFB_opt_lastKnownEnemyPositionOnly_desc"],
    ["Squad Feedback", format ["09 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_enemies"]],
    [["never", "always", "device"], [localize "STR_SQFB_opt_showEnemies_never", localize "STR_SQFB_opt_showEnemies_always", localize "STR_SQFB_opt_lastKnownEnemyPositionOnly_device"], 0],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_changeIconsToBlufor", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_changeIconsToBlufor", localize "STR_SQFB_opt_changeIconsToBlufor_desc"],
    ["Squad Feedback", format ["09 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_enemies"]],
    [false],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_enemySideColors", 
    "LIST",
    [localize "STR_SQFB_opt_enemySideColors", localize "STR_SQFB_opt_enemySideColors_desc"],
    ["Squad Feedback", format ["09 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_enemies"]],
    [["never", "current", "faction"], [localize "STR_SQFB_opt_enemySideColors_never", localize "STR_SQFB_opt_enemySideColors_current", localize "STR_SQFB_opt_enemySideColors_faction"], 0],
    nil,
    {} 
] call CBA_fnc_addSetting;


// ADVANCED - Friendlies
[
    "SQFB_opt_checkOcclusionFriendlies", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_checkOcclusionFriendlies", localize "STR_SQFB_opt_checkOcclusionFriendlies_desc"],
    ["Squad Feedback", format ["10 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_friendlies"]],
    [false],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_friendlyPreciseVisCheck", 
    "CHECKBOX",
    [localize "STR_SQFB_opt_friendlyPreciseVisCheck", localize "STR_SQFB_opt_friendlyPreciseVisCheck_desc"],
    ["Squad Feedback", format ["10 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_friendlies"]],
    [false],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_lastKnownFriendlyPositionOnly", 
    "LIST", 
    [localize "STR_SQFB_opt_lastKnownFriendlyPositionOnly", localize "STR_SQFB_opt_lastKnownFriendlyPositionOnly_desc"],
    ["Squad Feedback", format ["10 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_friendlies"]],
    [["never", "always", "device"], [localize "STR_SQFB_opt_showEnemies_never", localize "STR_SQFB_opt_showEnemies_always", localize "STR_SQFB_opt_lastKnownEnemyPositionOnly_device"], 0],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_friendlySideColors", 
    "LIST",
    [localize "STR_SQFB_opt_friendlySideColors", localize "STR_SQFB_opt_friendlySideColors_desc"],
    ["Squad Feedback", format ["10 - %1", localize "STR_SQFB_opt_HUDdisplay_advanced_friendlies"]],
    [["never", "current", "faction"], ["Never", "Current side", "Faction side"], 0],
    nil,
    {} 
] call CBA_fnc_addSetting;


// ADVANCED - Custom classnames
[
    "SQFB_opt_EnemyTrackingGearGoggles", 
    "EDITBOX",
    [localize "STR_SQFB_opt_EnemyTrackingGearGoggles", localize "STR_SQFB_opt_EnemyTrackingGearGoggles_desc"],
    ["Squad Feedback", format ["11 - %1", localize "STR_SQFB_opt_AdditionalEnemyTrackingDevices"]],
    "", // data for this setting: "defaultValue"
    nil,
    { [( _this splitString ",") apply {_x}, "goggles"] call SQFB_fnc_trackingGearAdd; }
] call CBA_fnc_addSetting;

[
    "SQFB_opt_EnemyTrackingGearHelmets", 
    "EDITBOX",
    [localize "STR_SQFB_opt_EnemyTrackingGearHelmets", localize "STR_SQFB_opt_EnemyTrackingGearHelmets_desc"],
    ["Squad Feedback", format ["11 - %1", localize "STR_SQFB_opt_AdditionalEnemyTrackingDevices"]],
    "", // data for this setting: "defaultValue"
    nil,
    { [( _this splitString ",") apply {_x}, "headgear"] call SQFB_fnc_trackingGearAdd; }
] call CBA_fnc_addSetting;

[
    "SQFB_opt_EnemyTrackingGearHMD", 
    "EDITBOX",
    [localize "STR_SQFB_opt_EnemyTrackingGearHMD", localize "STR_SQFB_opt_EnemyTrackingGearHMD_desc"],
    ["Squad Feedback", format ["11 - %1", localize "STR_SQFB_opt_AdditionalEnemyTrackingDevices"]],
    "", // data for this setting: "defaultValue"
    nil,
    { [( _this splitString ",") apply {_x}, "hmd"] call SQFB_fnc_trackingGearAdd; }
] call CBA_fnc_addSetting;


// COLORS - Squad
[
    "SQFB_opt_colorDefault", 
    "COLOR",
    [localize "STR_SQFB_opt_colorDefault", localize "STR_SQFB_opt_colorDefault_desc"],
    ["Squad Feedback", format ["12 - %1", localize "STR_SQFB_opt_Colors_squad"]],
    [0.9,0.9,0.9],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorRed", 
    "COLOR",
    [localize "STR_SQFB_opt_colorRed", localize "STR_SQFB_opt_colorRed_desc"],
    ["Squad Feedback", format ["12 - %1", localize "STR_SQFB_opt_Colors_squad"]],
    [0.95,0.33,0.5],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorGreen", 
    "COLOR",
    [localize "STR_SQFB_opt_colorGreen", localize "STR_SQFB_opt_colorGreen_desc"],
    ["Squad Feedback", format ["12 - %1", localize "STR_SQFB_opt_Colors_squad"]],
    [0.36,0.95,0.33],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorBlue", 
    "COLOR",
    [localize "STR_SQFB_opt_colorBlue", localize "STR_SQFB_opt_colorBlue_desc"],
    ["Squad Feedback", format ["12 - %1", localize "STR_SQFB_opt_Colors_squad"]],
    [0.33,0.65,0.9],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorYellow", 
    "COLOR",
    [localize "STR_SQFB_opt_colorYellow", localize "STR_SQFB_opt_colorYellow_desc"],
    ["Squad Feedback", format ["12 - %1", localize "STR_SQFB_opt_Colors_squad"]],
    [0.95,0.9,0.3],
    nil,
    {} 
] call CBA_fnc_addSetting;


// COLORS - Enemy
[
    "SQFB_opt_colorEnemyTarget", 
    "COLOR",
    [localize "STR_SQFB_opt_colorEnemyTarget", localize "STR_SQFB_opt_colorEnemyTarget_desc"],
    ["Squad Feedback", format ["13 - %1", localize "STR_SQFB_opt_Colors_enemy"]],
    [0.98,0.796,0.137],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorEnemy", 
    "COLOR",
    [localize "STR_SQFB_opt_colorEnemy", localize "STR_SQFB_opt_colorEnemy_desc"],
    ["Squad Feedback", format ["13 - %1", localize "STR_SQFB_opt_Colors_enemy"]],
    [0.9,0.21,0.3],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorEnemyWest", 
    "COLOR",
    [localize "STR_SQFB_opt_colorEnemyWest", localize "STR_SQFB_opt_colorEnemyWest_desc"],
    ["Squad Feedback", format ["13 - %1", localize "STR_SQFB_opt_Colors_enemy"]],
    [0.33,0.8,1],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorEnemyGuer", 
    "COLOR",
    [localize "STR_SQFB_opt_colorEnemyGuer", localize "STR_SQFB_opt_colorEnemyGuer_desc"],
    ["Squad Feedback", format ["13 - %1", localize "STR_SQFB_opt_Colors_enemy"]],
    [0.36,0.95,0.33],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorEnemyCiv", 
    "COLOR",
    [localize "STR_SQFB_opt_colorEnemyCiv", localize "STR_SQFB_opt_colorEnemyCiv_desc"],
    ["Squad Feedback", format ["13 - %1", localize "STR_SQFB_opt_Colors_enemy"]],
    [0.7,0.1,0.9],
    nil,
    {} 
] call CBA_fnc_addSetting;


// // COLORS - Friendly
[
    "SQFB_opt_colorFriendly", 
    "COLOR",
    [localize "STR_SQFB_opt_colorFriendly", localize "STR_SQFB_opt_colorFriendly_desc"], 
    ["Squad Feedback", format ["14 - %1", localize "STR_SQFB_opt_Colors_friendlies"]],
    [0.33,0.65,0.9],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorFriendlyEast", 
    "COLOR",
    [localize "STR_SQFB_opt_colorFriendlyEast", localize "STR_SQFB_opt_colorFriendlyEast_desc"], 
    ["Squad Feedback", format ["14 - %1", localize "STR_SQFB_opt_Colors_friendlies"]],
    [0.95,0.33,0.5],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorFriendlyGuer", 
    "COLOR",
    [localize "STR_SQFB_opt_colorFriendlyGuer", localize "STR_SQFB_opt_colorFriendlyGuer_desc"], 
    ["Squad Feedback", format ["14 - %1", localize "STR_SQFB_opt_Colors_friendlies"]],
    [0.36,0.95,0.33],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorFriendlyCiv", 
    "COLOR",
    [localize "STR_SQFB_opt_colorFriendlyCiv", localize "STR_SQFB_opt_colorFriendlyCiv_desc"], 
    ["Squad Feedback", format ["14 - %1", localize "STR_SQFB_opt_Colors_friendlies"]],
    [0.7,0.1,0.9],
    nil,
    {} 
] call CBA_fnc_addSetting;



