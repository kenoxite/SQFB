/*
  Author: kenoxite

  Description:
  Updates the information of the IFF units


  Parameter (s):


  Returns:


  Examples:

*/

if (call SQFB_fnc_trackingGearCheck) then {
    if (!SQFB_showIFFHUD) then {
        SQFB_showIFFHUD = true;
        playSound "FD_Timer_F";
    };
}; 