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

if (_mode == "squad") then {
    _sound = SQFB_opt_sounds_squad;
} else {
    call {
        if (SQFB_trackingGearCheck) exitWith {_sound = SQFB_opt_sounds_IFF;};
        if (!SQFB_trackingGearCheck) exitWith {_sound = SQFB_opt_sounds_noIFF;};
    };
};

if (_sound != "none") then {
    private _soundFinal = format ["SQFB_%1_%2", _sound, _type];
    playSound _soundFinal;
};

_sound
