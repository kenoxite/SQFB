params ["_unit"];
if (_unit in agents) then {_unit = agent _unit};
if (typeName _unit != "OBJECT") exitWith {false};
if (isNull _unit) exitWith {false};
    
((count (["zombie", "dev_mutant_base","DSA_SpookBase","DSA_SpookBase2"] select { _unit isKindOf _x}) > 0) || !isNil {_unit getVariable "WBK_AI_ISZombie"} || !isNil {_unit getVariable "isMutant"})
