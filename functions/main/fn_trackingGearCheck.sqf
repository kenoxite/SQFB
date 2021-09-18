/*
  Author: kenoxite

  Description:
  Checks if the player has an enemy tracking device equipped 


  Parameter (s):


  Returns:


  Examples:

*/

private _return = false;

if (!_return && {(goggles player) in SQFB_enemyTrackingGoggles}) then { _return = true };
if (!_return && {(headgear player) in SQFB_enemyTrackingHeadgear}) then { _return = true };
if (!_return && {(hmd player) in SQFB_enemyTrackingHMD}) then { _return = true };

_return