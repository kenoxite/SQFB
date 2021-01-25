/*
	Author: Killzone Kid

	Description:
	KK_fnc_trueZoom


	Parameter (s):
	_this select 0: _unit


	Returns:


	Examples:

*/

(
    [0.5,0.5] 
    distance2D  
    worldToScreen 
    positionCameraToWorld 
    [0,3,4]
) * (
    getResolution 
    select 5
) / 2