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

    if (SQFB_opt_showEnemies != "always") then { SQFB_knownEnemies= []; };
    if (SQFB_opt_showFriendlies != "always") then { SQFB_knownFriendlies= []; };

    if (SQFB_opt_showEnemies == "always" || SQFB_opt_showFriendlies == "always") exitWith { call SQFB_fnc_HUDupdate; };

    // Clean taggers
    SQFB_knownIFF = [];
    call SQFB_fnc_cleanTaggers;
    SQFB_tagObjArr = [];
};
