/*
  Author: kenoxite

  Description:
  Checks if the player just equipped or unequipped an IFF device and activates the HUD if equipped


  Parameter (s):


  Returns:


  Examples:

*/

if (call SQFB_fnc_trackingGearCheck) then {
    if (!SQFB_showIFFHUD && SQFB_opt_IFFHUDkey_Toggle) then {
        SQFB_showIFFHUD = true;
        ["iff", "on"] call SQFB_fnc_playSound;
    };
};
