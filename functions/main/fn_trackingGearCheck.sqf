/*
  Author: kenoxite

  Description:
  Checks if the player has an enemy tracking device equipped 


  Parameter (s):


  Returns:


  Examples:

*/

if ((goggles player) in SQFB_enemyTrackingGoggles) exitWith { true };
if ((headgear player) in SQFB_enemyTrackingHeadgear) exitWith { true };
if ((hmd player) in SQFB_enemyTrackingHMD) exitWith { true };

false