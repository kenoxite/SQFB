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
} else {
    SQFB_showEnemiesMinTime = 0;
};
