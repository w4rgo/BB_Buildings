private ["_isBuildable","_charPos","_character","_id","_pos","_nearestGates","_inMotion","_lever","_text","_handlers"];
_character = _this select 1;
_id = _this select 2;
_lever = _this select 3;
_isBuildable = true;
_charPos = getposATL _character;
_inMotion = _lever getVariable ["inMotion",0];

_nearestGates = nearestObjects [_lever, ["Hhedgehog_concrete","Concrete_Wall_EP1"], 200];
//dayz_updateNearbyObjects = [_charPos, _isBuildable];
//publicVariableServer "dayz_updateNearbyObjects";
//if (isServer) then {
//    dayz_updateNearbyObjects call server_updateNearbyObjects;
//};
//[_charPos, _isBuildable] call server_updateNearbyObjects;
{dayz_myCursorTarget removeAction _x} forEach s_player_gateActions;s_player_gateActions = [];

if (!openingGates) then {
    openingGates=true;
    //_lever setVariable ["inMotion", 1, true];
	
    _handlers=[];
    {
        _hnd=  _x spawn {
            private["_pos","_z","_text","_x"];
            _x = _this;
            _pos = getPos _this;
            _z = _pos select 2;
		
            if (_z <= -2) then {
		
                _text = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
                cutText [format["Raising the %1",_text], "PLAIN DOWN"];
                _pos set [2,0];
                _x setPos _pos;
                [nil,_x,rSAY,["trap_bear_0",60]] call RE;
                sleep .5;
                [nil,_x,rSAY,["trap_bear_0",60]] call RE;
			
            } else {
		
                _text = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
                cutText [format["Lowering the %1",_text], "PLAIN DOWN"];
                _pos set [2,-6.6];
                _x setPos _pos;
                [nil,_x,rSAY,["trap_bear_0",60]] call RE;
            };
        };
        //_handlers set [count _handlers,_hnd];
    } foreach _nearestGates;
    openingGates = false;
    //_lever setVariable ["inMotion", 0, true];
} else {
    cutText [format["You cannot open/close the door until it finish the last operation"], "PLAIN DOWN"];
};

{dayz_myCursorTarget removeAction _x} forEach s_player_gateActions;s_player_gateActions = [];
dayz_myCursorTarget = objNull;
alreadyGateCode=false;