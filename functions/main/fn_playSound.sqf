/*
  Author: kenoxite

  Description:
  Plays a sound


  Parameter (s):


  Returns:


  Examples:

*/

params [["_mode", "squad"], ["_type", "on"]];

private _sound = "";
if (_mode == "squad" && !SQFB_opt_showSquad) exitWith { _sound };
if (_mode == "iff" && !SQFB_showFriendlies && !SQFB_showEnemies) exitWith { _sound };

if (isNil "SQFB_trackingGearCheck") then { SQFB_trackingGearCheck = call SQFB_fnc_trackingGearCheck };

private _inDrone = call SQFB_fnc_playerInDrone;
_sound = call {
    if (_mode == "squad") exitWith { SQFB_opt_sounds_squad };
    if (SQFB_trackingGearCheck || _inDrone) exitWith { SQFB_opt_sounds_IFF };
    if (!SQFB_trackingGearCheck && !_inDrone) exitWith { SQFB_opt_sounds_noIFF };
    ""
};

if (_sound != "none") then {
    private _soundFinal = format ["SQFB_%1_%2", _sound, _type];
    playSound _soundFinal;
};

_sound
