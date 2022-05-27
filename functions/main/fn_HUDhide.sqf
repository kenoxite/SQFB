/*
  Author: kenoxite

  Description:
  Things to do when it's hidden 


  Parameter (s):
 

  Returns:


  Examples:

*/

params [["_type", "squad"]];


if (_type == "squad") then {
    SQFB_showDeadMinTime = 0;
} else {
    SQFB_IFFTimeLastCheck = time;

    SQFB_knownEnemies= [];
    SQFB_knownFriendlies= [];

    // Clean taggers
    SQFB_knownIFF = [];
    call SQFB_fnc_cleanTaggers;
    SQFB_tagObjArr = [];
};
