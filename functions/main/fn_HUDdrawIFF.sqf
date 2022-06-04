/*
  Author: kenoxite

  Description:
  Draws the IFF HUD


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

private _SQFB_knownIFF = SQFB_knownIFF;

for "_i" from 0 to (count _SQFB_knownIFF) -1 do
{
    if ((typeName (_SQFB_knownIFF select _i)) == "STRING") then { continue };
    private _unit = _SQFB_knownIFF select _i;
    private _HUDdata = _unit getVariable "SQFB_HUDdata";
    if (isNil "_HUDdata") then { continue };
    private _texture = _HUDdata select 0;
    if (isNil "_texture") then { continue };

    drawIcon3D _HUDdata;
};
