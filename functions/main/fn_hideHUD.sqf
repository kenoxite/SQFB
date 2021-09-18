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
    SQFB_showHUD = false;
    SQFB_showDeadMinTime = 0;
} else {
    SQFB_showEnemyHUD = false;
    SQFB_showEnemiesMinTime = 0;
};
