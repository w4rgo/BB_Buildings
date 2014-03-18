 private ["_isBuildable","_charPos","_character","_id","_pos","_z","_nearestGates","_inMotion","_lever","_text"];
_character = _this select 1;
_id = _this select 2;
_lever = _this select 3;
//_charPos = getposATL _character;



_funcExitScript = {
	breakOut "exit";
};
if(clanTag == "0") then {
    
        cutText ["You need to be part of a clan to use panel", "PLAIN DOWN"];call _funcExitScript;
};


_nearestGates = nearestObjects [_lever, ["Concrete_Wall_EP1","Hhedgehog_concrete","Infostand_2_EP1"], 200];

_isBuildable = true;

/*
dayz_updateNearbyObjects = [getPos player, _isBuildable];
publicVariableServer "dayz_updateNearbyObjects";
if (isServer) then {
    dayz_updateNearbyObjects call server_updateNearbyObjects;
};
[getPos player  , _isBuildable] call server_updateNearbyObjects;
*/
{
    if(!(_x in alreadyActivatedLevers)) then {
        if(typeOf(_x)=="Infostand_2_EP1") then {
            _noauth = !bb_user_authorized;
            //_handle = _x addAction ["Operate Gate", "\BB_Buildings\code\keypad\fnc_keyPad\operate_gates.sqf", _x, 1, false, true, "", ""];
            _handle = _x addAction ["Authorize", "\BB_Buildings\code\perimeter\authorize.sqf", _x, 1, false, true, "",""];//_noauth"];
            _handle = _x addAction ["Operate near doors", "\BB_Buildings\code\keypad\fnc_keyPad\operate_gates_near.sqf", _x, 1, false, true, "",""];//_noauth"];
            _handle = _x addAction ["Operate roof", "\BB_Buildings\code\keypad\fnc_keyPad\operate_roof.sqf", _x, 1, false, true, "",""];
        } else {
            _handle = _x addAction ["Operate Door", "\BB_Buildings\code\keypad\fnc_keyPad\operate_door.sqf", _x, 1, false, true, "", ""];
        };
        alreadyActivatedLevers set [count alreadyActivatedLevers, _x];
    };
} foreach _nearestGates;


alreadyAllDoors=true;

doorkeyValid = false;
keyValid = false;