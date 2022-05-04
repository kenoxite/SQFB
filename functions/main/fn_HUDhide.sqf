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
    // Immediate update of friendly positions
    SQFB_friendliesTimeLastCheck = time;
    [] call SQFB_fnc_HUDupdate;
} else {
    SQFB_showEnemiesMinTime = 0;
    // Immediate update of enemy positions
    SQFB_enemiesTimeLastCheck = time;
    [] call SQFB_fnc_HUDupdate;
};
