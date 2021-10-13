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
{ if (_goggles isKindOf [_x, configFile >> "CfgGlasses"]) exitWith { _hasGear = true } } forEach SQFB_enemyTrackingGoggles;

private _headgear = headgear SQFB_player;
{ if (_headgear isKindOf [_x, configFile >> "CfgWeapons"]) exitWith { _hasGear = true } } forEach SQFB_enemyTrackingHeadgear;

private _hmd = hmd SQFB_player;
{ if (_hmd isKindOf [_x, configFile >> "CfgWeapons"]) exitWith { _hasGear = true } } forEach SQFB_enemyTrackingHMD;

_hasGear