 private ["_pos","_id","_door","_z"];

_character = _this select 1;
_id = _this select 2;
_door = _this select 3;
_sec = 10;

_pos = getPos _door;
_z = _pos select 2;

//_inMotion = _door getVariable ["inMotion",0];

_funcExitScript = {
	breakOut "exit";
};
if(clanTag == "0") then {
        cutText ["You need to be part of a clan to use door", "PLAIN DOWN"];call _funcExitScript;
};


if (!openingGates) then {

    _door setVariable ["inMotion", 1, true];
    _text = getText (configFile >> "CfgVehicles" >> (typeOf _door) >> "displayName");
    cutText [format["Lowering the %1, will raise after %2 sec",_text,_sec], "PLAIN DOWN"];
    [nil,_door,rSAY,["trap_bear_0",60]] call RE;
    //_pos set [2,-6.6];
    //_door setPos _pos;
    _nic = [nil, _door, "per", rHideObject, true] call RE;
    //_door hideObject true;
    
    sleep _sec;

    cutText [format["Raising the %1",_text,_sec], "PLAIN DOWN"];
    [nil,_door,rSAY,["trap_bear_0",60]] call RE;
    //_pos set [2,0];
    //_door setPos _pos;
    //_door hideObject false;
    _nic = [nil, _door, "per", rHideObject, false] call RE;
    _door setVariable ["inMotion", 0, true];
} else {
    cutText [format["You cannot open/close the door until it finish the last operation"], "PLAIN DOWN"];
};
    
//{dayz_myCursorTarget removeAction _x} forEach s_player_gateActions;s_player_gateActions = [];
//dayz_myCursorTarget = objNull;
alreadyDoorCode=false;