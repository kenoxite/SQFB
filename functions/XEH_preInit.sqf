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

// [
//     ["Squad Feedback", "2 - HUD Display - Squad"],
// 	"SQFB_opt_showHUD_key",
// 	["Display Squad HUD", "Displays the squad HUD as long as this key is pressed."],
// 	{ _this call SQFB_fnc_showHUD_key_CBA },
// 	{ _this call SQFB_fnc_hideHUD_key_CBA },
// 	[ DIK_TAB, [false, false, false] ], // [DIK, [shift, ctrl, alt]] 
// 	true
// ] call CBA_fnc_addKeybind;

[
    ["Squad Feedback", ""],
	"SQFB_opt_showHUD_T_key",
	["Display Squad HUD (Toggle)", "Toggles the display of the HUD for your squad."],
	{ _this call SQFB_fnc_showHUD_key_T_CBA },
	{},
	[ DIK_TAB, [false, false, false] ], // [DIK, [shift, ctrl, alt]] 
	false
] call CBA_fnc_addKeybind;

// [
//     ["Squad Feedback", "1- HUD Display - Enemy"],
//     "SQFB_opt_showEnemyHUD_key",
//     ["Display Known Enemy Locations", "Displays the HUD for enemies as long as this key is pressed."],
//     { _this call SQFB_fnc_showEnemyHUD_key_CBA },
//     { _this call SQFB_fnc_hideEnemyHUD_key_CBA },
//     [ DIK_TAB, [false, false, false] ], // [DIK, [shift, ctrl, alt]] 
//     true
// ] call CBA_fnc_addKeybind;

[
    ["Squad Feedback", ""],
    "SQFB_opt_showEnemyHUD_T_key",
    ["Display Known Enemies (Toggle)", "Toggles the display of the HUD for enemies."],
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
    ["Enable", "Enables or disables the whole system."],
    "Squad Feedback",
    [true],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_profile", 
    "LIST",
    ["Profile (applies after closing this window)", "Choosing a profile will change the activation status of the following settings:\n  - Display Squad HUD\n  - Display Known Enemies\n  - Display Icon\n  - Display Text\n  - Display Team Color\n  - Display Index\n  - Display Class\n  - Display Roles\n  - Display Distance\n  - Display Arrows and Text\n  - Always Display Index\n  - Display Crew\n  - Display Dead Units\n  - Always Display Critical\n  - Always Display Enemies\nIf you change the profile any further changes to those settings won't be applied after you close this window."],
    "Squad Feedback",
    [["custom", "default", "all", "min", "crit", "vanillalike", "onlyalwaysenemies"],["Custom", "Default", "All On", "Minimalist", "Only Critical", "Vanilla-like", "Only Always Enemies"], 1],
    nil,
    { call SQFB_fnc_changeProfile; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showSquad", 
    "CHECKBOX",
    ["Display Squad HUD", "Toggles the activation of your squad's feeback HUD."],
    ["Squad Feedback", "0 - General"],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showEnemies", 
    "LIST",
    ["Display Known Enemies", "Choose when to display known enemy locations."],
    ["Squad Feedback", "0 - General"],
    [["never", "keypressed", "always"], ["Never", "When key is pressed", "Always"], 1],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_HUDrefresh", 
    "SLIDER",
    ["HUD Refresh Rate", "Waiting time between HUD redraws, in seconds.\nYou can set this value higher if the game performance is badly affected, but you'll see the HUD flickering."], 
    ["Squad Feedback", "0 - General"],
    [0, 0.05, 0.011, 3], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_updateDelay", 
    "SLIDER",
    ["Data Update Delay", "Waiting time between squad status and known enemies checks, in seconds.\nSetting this value lower will keep the HUDs more up to date, but the game performance can be affected."], 
    ["Squad Feedback", "0 - General"],
    [0.1, 30, 5, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showIcon", 
    "CHECKBOX",
    ["Display Icon", "Display an icon indicating the AI unit's role and its health and ammo status, etc."],
    ["Squad Feedback", "1 - HUD Display - General"],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showText", 
    "CHECKBOX",
    ["Display Text", "Display descriptive text below the icon. The kind of text shown is controlled by the other text related options.\nNo text will be shown at all if this setting is deactivated, regardless of the other settings."],
    ["Squad Feedback", "1 - HUD Display - General"],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showColor", 
    "CHECKBOX",
    ["Display Team Color", "Automatically change the color of the icon and text to match that of the unit's assigned team."],
    ["Squad Feedback", "1 - HUD Display - General"],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

// [
//     "SQFB_opt_minRange", 
//     "SLIDER",
//     ["Minimum Range", "Distance above which a unit has to be for its HUD info to show up, in meters.\nSet to zero to always show regardless of range."], 
//     ["Squad Feedback", "2 - HUD Display - Squad"],
//     [0, 1000, 5, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
//     nil,
//     {} 
// ] call CBA_fnc_addSetting;

[
    "SQFB_opt_maxRange", 
    "SLIDER",
    ["Maximum Range", "Maximum distance a unit has to be for its HUD info to show up, in meters."], 
    ["Squad Feedback", "2 - HUD Display - Squad"],
    [10, 5000, 500, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

// [
//     "SQFB_opt_minRangeAir", 
//     "SLIDER",
//     ["Minimum Range (air)", "Distance above which a unit has to be for its HUD info to show up when the player is flying, in meters.\nSet to zero to always show regardless of range."], 
//     ["Squad Feedback", "2 - HUD Display - Squad"],
//     [0, 5000, 50, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
//     nil,
//     {} 
// ] call CBA_fnc_addSetting;

[
    "SQFB_opt_maxRangeAir", 
    "SLIDER",
    ["Maximum Range (air)", "Maximum distance a unit has to be for its HUD info to show up when the player is flying, in meters."], 
    ["Squad Feedback", "2 - HUD Display - Squad"],
    [10, 5000, 1500, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showEnemiesMinTime", 
    "SLIDER",
    ["Initial Delay", "Time that must pass while the HUD is shown to display known enemy units when the key is pressed, in seconds."], 
    ["Squad Feedback", "3 - HUD Display - Known Enemies"],
    [0, 60, 0, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showEnemiesMinRange", 
    "SLIDER",
    ["Minimum Range", "No HUD elements will be shown for enemies below this distance, in meters.\nSet to zero to always show regardless of range."], 
    ["Squad Feedback", "3 - HUD Display - Known Enemies"],
    [0, 1000, 20, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showEnemiesMaxRange", 
    "SLIDER",
    ["Maximum Range", "Maximum distance to look for enemies and display their HUD elements, in meters."], 
    ["Squad Feedback", "3 - HUD Display - Known Enemies"],
    [100, 5000, 800, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showEnemiesMinRangeAir", 
    "SLIDER",
    ["Minimum Range (Air)", "No HUD elements will be shown for enemies below this distance when the player is in an air vehicle, in meters.\nSet to zero to always show regardless of range."], 
    ["Squad Feedback", "3 - HUD Display - Known Enemies"],
    [0, 5000, 100, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showEnemiesMaxRangeAir", 
    "SLIDER",
    ["Maximum Range (Air)", "Maximum distance to look for enemies and display their HUD elements when the player is in an air vehicle, in meters."], 
    ["Squad Feedback", "3 - HUD Display - Known Enemies"],
    [100, 10000, 2000, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showEnemiesIfTrackingGear", 
    "CHECKBOX",
    ["Allow Enemy Tracking Devices", "Enemy locations will ALWAYS be displayed as long as the player has an Enemy Tracking device equipped.\nThe pre-defined devices are:
    - Combat Goggles (any version, including balaclavas)
    - Tactical Glasses (any version)
    - VR Goggles
    - Assassin Helmet (any version)
    - Defender Helmet (any version)
    - Fighter Pilot Helmet (any version)
    - Special Purpose Helmet (any version)
    \nYou can still use the corresponding key to display enemy locations even with this option active.
    "],
    ["Squad Feedback", "3 - HUD Display - Known Enemies"],
    [true],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showIndex", 
    "CHECKBOX",
    ["Display Index", "Display the index of the unit in the player's group.\n\nThis option will have no effect if Show Text is disabled."],
    ["Squad Feedback", "4 - HUD Display - Text Options"],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showClass", 
    "CHECKBOX",
    ["Display Class", "Display the unit's class name as seen in the Eden editor.\n\nThis option will have no effect if Show Text is disabled."],
    ["Squad Feedback", "4 - HUD Display - Text Options"],
    [false],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showRoles", 
    "CHECKBOX",
    ["Display Roles Text", "Display the unit's role(s) text, which might be different from its original class.\nSome of the roles shown can be:\n* Medic: The unit can heal and has a medikit.\n* AT: The unit has a launcher weapon.\n* Demo: The unit can use explosives and has some in its inventory.\nThese are just some examples. There are many more roles and each unit can have more than one role depending on its weapon, ammo, gear and attributes.\n\nThis option will have no effect if Display Text is disabled."],
    ["Squad Feedback", "4 - HUD Display - Text Options"],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showRolesIcon", 
    "CHECKBOX",
    ["Display Roles Icon", "Display the unit's role(s) icon, which might be different from its original class.\nSome of the roles shown can be:\n* Medic: The unit can heal and has a medikit.\n* AT: The unit has a launcher weapon.\n* Demo: The unit can use explosives and has some in its inventory.\nThese are just some examples. There are many more roles and each unit can have more than one role depending on its weapon, ammo, gear and attributes.\n\nThis option will have no effect if Display Text is disabled."],
    ["Squad Feedback", "4 - HUD Display - Text Options"],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showDist", 
    "CHECKBOX",
    ["Display Distance (squad)", "Display the distance of the squad unit from the player, in meters.\n\nThis option will have no effect if Show Text is disabled."],
    ["Squad Feedback", "4 - HUD Display - Text Options"],
    [false],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showDistEnemy", 
    "CHECKBOX",
    ["Display Distance (enemies)", "Display the distance of the enemy unit from the player, in meters.\n\nThis option will have no effect if Show Text is disabled."],
    ["Squad Feedback", "4 - HUD Display - Text Options"],
    [false],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_iconSize", 
    "SLIDER",
    ["Icon Size", "Relative size of the icons."], 
    ["Squad Feedback", "5 - HUD Customization"],
    [0.1, 2, 1, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_iconHeight", 
    "SLIDER",
    ["Icon Height", "Height of the icons for infantry units, relative to the default height."], 
    ["Squad Feedback", "5 - HUD Customization"],
    [-2, 2, 0, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_iconHor", 
    "SLIDER",
    ["Icon Horizontal", "Horizontal position of the icons for infantry units, relative to the default horizontal position."], 
    ["Squad Feedback", "5 - HUD Customization"],
    [-2, 2, 0, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_iconHeightVeh", 
    "SLIDER",
    ["Icon Height (vehicles)", "Height of the icons for vehicles, relative to the default height."], 
    ["Squad Feedback", "5 - HUD Customization"],
    [-3, 3, 0, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_iconHorVeh", 
    "SLIDER",
    ["Icon Horizontal (vehicles)", "Horizontal position of the icons for vehicles, relative to the default horizontal position."], 
    ["Squad Feedback", "5 - HUD Customization"],
    [-5, 5, 0, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_textSize", 
    "SLIDER",
    ["Text Size", "Relative size of the texts."], 
    ["Squad Feedback", "5 - HUD Customization"],
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
    ["Text Font", "Font used in all the texts."], 
    ["Squad Feedback", "5 - HUD Customization"],
    [["EtelkaMonospacePro","EtelkaMonospaceProBold","EtelkaNarrowMediumPro","LucidaConsoleB","PuristaBold","PuristaLight","PuristaMedium","PuristaSemiBold","RobotoCondensed","RobotoCondensedBold","RobotoCondensedLight","TahomaB"], ["EtelkaMonospacePro","EtelkaMonospaceProBold","EtelkaNarrowMediumPro","LucidaConsoleB","PuristaBold","PuristaLight","PuristaMedium","PuristaSemiBold","RobotoCondensed","RobotoCondensedBold","RobotoCondensedLight","TahomaB"],6],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_maxAlpha", 
    "SLIDER",
    ["Maximum Alpha", "Maximum opaqueness for all the elements of the HUD."], 
    ["Squad Feedback", "5 - HUD Customization"],
    [0.1, 1, 0.9, 2], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_Arrows", 
    "CHECKBOX",
    ["Display Arrows and Text", "Display arrows and text at the edge of the screen indicating the unit's relative position when it's not in view of the player."],
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_outFOVindex", 
    "CHECKBOX",
    ["Alway Show Index", "Always display the indexes of your units when not in view."],
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_checkVisibility", 
    "CHECKBOX",
    ["Check Squad for Visibility", "Only display HUD elements on units not hidden by obstacles or terrain.\nThis option only affects your squad units. Enemies are always checked for visibility."],
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    [false],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_scaleText", 
    "CHECKBOX",
    ["Scale Squad HUD Text", "The further away the unit is the smaller the text. When too far away the text won't be displayed.\nThis option only affects your squad units."],
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    [true],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_ShowCrew", 
    "CHECKBOX",
    ["Display Squad Crew", "Display the indexes of all the crew of the group vehicles and their roles as crew (D for driver, C for commander, G for gunner, T for turret)."],
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_GroupCrew", 
    "CHECKBOX",
    ["Group Squad Units in Vehicles", "If enabled, when units are inside a vehicle only a HUD element will be displayed over such vehicle (instead of over every crew member), with information about its crew and cargo.\nIf disabled, every unit inside a vehicle will display a HUD element over their heads (same behaviour as if they weren't in a vehicle)."],
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    [true],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showDead", 
    "CHECKBOX",
    ["Display Squad's Dead Units", "Display the HUD over dead units which were part of the player's group."],
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_showDeadMinTime", 
    "SLIDER",
    ["Display Dead Initial Delay", "Time that must pass while the HUD is shown to display dead units, in seconds."], 
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    [0, 60, 3, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_AlwaysShowCritical", 
    "CHECKBOX",
    ["Always Display Squad Critical Conditions", "If player is medic or the squad leader, always display information about injured, unconscious, units without ammo, etc. even when the Squad Feedback key isn't pressed."],
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    [true],
    nil,
    { if (time > 0.1 && SQFB_opt_profile_old == SQFB_opt_profile) then { ["SQFB_opt_profile", "custom", 0, "server", true] call CBA_settings_fnc_set }; } 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_enemyCheckSolo", 
    "CHECKBOX",
    ["Check for enemies when alone", "If enabled, you will always track known enemy units, even when you're not in a group.\nThe known enemies will be those that the unit you are controlling perceives.\nEven if disabled, known enemies will still be shown if you have 'Allow Enemy Tracking Devices' enabled and one of those devices equipped."],
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    [true],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_enemyPreciseVisCheck", 
    "CHECKBOX",
    ["Precise Visibilty Check for Enemies", "More precise visibility checks for enemy vehicles.\nThis will check all the corners of their bounding box instead of a single point, so it will severily affect performance."],
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    [false],
    nil,
    {} 
] call CBA_fnc_addSetting;
[
    "SQFB_opt_EnemyTrackingGearGoggles", 
    "EDITBOX",
    ["Additional Enemy Tracking Devices - Goggles", "Add here any other goggles you want to be able to use to track known enemies.\n\nThe list must be class names (without quotation marks) separated by commas."],
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    "", // data for this setting: "defaultValue"
    nil,
    { [( _this splitString ",") apply {_x}, "goggles"] call SQFB_fnc_trackingGearAdd; }
] call CBA_fnc_addSetting;

[
    "SQFB_opt_EnemyTrackingGearHelmets", 
    "EDITBOX",
    ["Additional Enemy Tracking Devices - Helmets", "Add here any other helmets you want to be able to use to track known enemies.\n\nThe list must be class names (without quotation marks) separated by commas."],
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    "", // data for this setting: "defaultValue"
    nil,
    { [( _this splitString ",") apply {_x}, "headgear"] call SQFB_fnc_trackingGearAdd; }
] call CBA_fnc_addSetting;

[
    "SQFB_opt_EnemyTrackingGearHMD", 
    "EDITBOX",
    ["Additional Enemy Tracking Devices - HMD", "Add here any other Head Mounted Displays (like NVGs) you want to be able to use to track known enemies.\n\nThe list must be class names (without quotation marks) separated by commas."],
    ["Squad Feedback", "6 - HUD Display - Advanced"],
    "", // data for this setting: "defaultValue"
    nil,
    { [( _this splitString ",") apply {_x}, "hmd"] call SQFB_fnc_trackingGearAdd; }
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorDefault", 
    "COLOR",
    ["Default color", "Default color used for all the elements of the HUD."], 
    ["Squad Feedback", "7 - Colors"],
    [0.9,0.9,0.9],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorRed", 
    "COLOR",
    ["Red Team color", "Color used for units assigned to the red player's team.\nThis option won't have any effect if colors are deactivated."], 
    ["Squad Feedback", "7 - Colors"],
    [0.95,0.33,0.5],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorGreen", 
    "COLOR",
    ["Green Team color", "Color used for units assigned to the green player's team.\nThis option won't have any effect if colors are deactivated."], 
    ["Squad Feedback", "7 - Colors"],
    [0.36,0.95,0.33],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorBlue", 
    "COLOR",
    ["Blue Team color", "Color used for units assigned to the blue player's team.\nThis option won't have any effect if colors are deactivated."], 
    ["Squad Feedback", "7 - Colors"],
    [0.33,0.65,0.9],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorYellow", 
    "COLOR",
    ["Yellow Team color", "Color used for units assigned to the yellow player's team.\nThis option won't have any effect if colors are deactivated."],
    ["Squad Feedback", "7 - Colors"],
    [0.95,0.9,0.3],
    nil,
    {} 
] call CBA_fnc_addSetting;

[
    "SQFB_opt_colorEnemy", 
    "COLOR",
    ["Enemy color", "Color used for enemy units.\nThis option won't have any effect if colors are deactivated."], 
    ["Squad Feedback", "7 - Colors"],
    [0.9,0.21,0.3],
    nil,
    {} 
] call CBA_fnc_addSetting;



