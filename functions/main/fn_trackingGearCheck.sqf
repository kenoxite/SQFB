/*
  Author: kenoxite

  Description:
  Checks if the player has an enemy tracking device equipped 


  Parameter (s):


  Returns:


  Examples:

*/

private _hasGear = false;

private _goggles = goggles SQFB_player;
private _CfgGlasses = configFile >> "CfgGlasses";
{ if (_goggles isKindOf [_x, _CfgGlasses]) exitWith { _hasGear = true } } forEach SQFB_enemyTrackingGoggles;
// Check for excluded goggles
{ if (_goggles isKindOf [_x, _CfgGlasses]) exitWith { _hasGear = false } } forEach SQFB_enemyTrackingGogglesExcluded;

private _headgear = headgear SQFB_player;
private _CfgWeapons = configFile >> "CfgWeapons";
{ if (_headgear isKindOf [_x, _CfgWeapons]) exitWith { _hasGear = true } } forEach SQFB_enemyTrackingHeadgear;
// Check for excluded headgear
{ if (_headgear isKindOf [_x, _CfgWeapons]) exitWith { _hasGear = false } } forEach SQFB_enemyTrackingHeadgearExcluded;

private _hmd = hmd SQFB_player;
{ if (_hmd isKindOf [_x, _CfgWeapons]) exitWith { _hasGear = true } } forEach SQFB_enemyTrackingHMD;
// Check for excluded HMD
{ if (_hmd isKindOf [_x, _CfgWeapons]) exitWith { _hasGear = false } } forEach SQFB_enemyTrackingHMDExcluded;

_hasGear