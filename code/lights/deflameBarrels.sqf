 private ["_isBuildable","_charPos","_character","_id","_pos","_z","_nearestGates","_inMotion","_lever","_text"];
_character = _this select 1;
_id = _this select 2;
_lever = _this select 3;
_lever removeAction _id;

_nearestBarrels = nearestObjects [_lever, ["Land_Fire_Barrel","SearchLight_UN_EP1"], 200];

{
    
     if (typeOf(_x) == "SearchLight_UN_EP1") then {
        player action["lightoff",_x];
    } else {
        _x inflame false;
    };


} foreach _nearestBarrels;
