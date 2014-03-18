private ["_isBuildable","_charPos","_character","_id","_pos","_z","_nearestGates","_inMotion","_lever","_text"];
_character = _this select 1;
_id = _this select 2;
_truck = _this select 3;

[_truck] spawn plantBombTruckAndOpen;