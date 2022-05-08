/*
  Author: kenoxite

  Description:
  Things to do when it's hidden 


  Parameter (s):
 

  Returns:


  Examples:

*/

params [["_type", "friendly"]];


if (_type == "friendly") then {
    SQFB_showDeadMinTime = 0;

    SQFB_showFriendliesMinTime = 0;
    SQFB_IFFTimeLastCheck = time;

    // Clean taggers
    SQFB_knownFriendlies = [];
    [false] call SQFB_fnc_cleanTaggers;
    SQFB_friendlyTagObjArr = [];

} else {
    SQFB_showEnemiesMinTime = 0;
    SQFB_IFFTimeLastCheck = time;

    // Clean taggers
    SQFB_knownEnemies= [];
    [true] call SQFB_fnc_cleanTaggers;
    SQFB_enemyTagObjArr = [];
};

SQFB_knownIFF = [];
