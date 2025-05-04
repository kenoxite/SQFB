params ["_backpackStr"];

if ("radio" in _backpackStr) exitWith {true};

if (_unitIsVanilla) exitWith {false};

private _radios = [
    "prc77", "t884", "r129", "rf10", "r105m", "sem35", "r148",
    "anarc", "anprc", "bussole", "mr3000", "mr6000", "rt1523",
    "vn_b_pack_lw_06", "vn_b_pack_trp_04_02", "vn_b_pack_03",
    "vn_b_pack_trp_04", "vn_b_pack_m41_05"
];

if (_radios findIf {_x in _backpackStr} > -1) exitWith {true};

false
