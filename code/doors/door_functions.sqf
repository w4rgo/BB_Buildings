bb_roof_classes = ["e9","Land_Ind_Shed_01_main","BB_Operate_Roof"];

//Funciones relacionadas con puertas.
//Open door:
//[door,time] call fnc_open_door;


fnc_operate_roof = {
    _lever = _this select 0;
    _nearestGates = nearestObjects [_lever, bb_roof_classes, 30];
    //dayz_updateNearbyObjects = [_charPos, _isBuildable];
    //publicVariableServer "dayz_updateNearbyObjects";
    //	if (isServer) then {
    //		dayz_updateNearbyObjects call server_updateNearbyObjects;
    //	};
    //	{dayz_myCursorTarget removeAction _x} forEach s_player_gateActions;s_player_gateActions = [];
    //[_charPos, _isBuildable] call server_updateNearbyObjects;
    cutText [format["Opening roof.... 5 minutes open. Do not log out/die."], "PLAIN DOWN"];
    if (!openingRoofs) then {
        openingRoofs=true;
	//_lever setVariable ["inMotion", 1, true];
	
	{
            [_x,300] spawn fnc_open_door;
	} foreach _nearestGates;
        openingRoofs = false;
	//_lever setVariable ["inMotion", 0, true];
    } else {
        cutText [format["You cannot open/close the door until it finish the last operation"], "PLAIN DOWN"];
    };
};




fnc_open_door = {
    _door = _this select 0;
    _time = _this select 1;
    
    _pos = getPos _door;
    _door setVariable ["inMotion", 1, true];
    _text = getText (configFile >> "CfgVehicles" >> (typeOf _door) >> "displayName");
    cutText [format["Lowering the %1, will raise after %2 sec",_text,_time], "PLAIN DOWN"];
    [nil,_door,rSAY,["trap_bear_0",60]] call RE;
    _nic = [nil, _door, "per", rHideObject, true] call RE;
    //_door hideObject true;
    //_pos set [2,-6.6];
    //_door setPos _pos;
    sleep _time;

    cutText [format["Raising the %1",_text], "PLAIN DOWN"];
    [nil,_door,rSAY,["trap_bear_0",60]] call RE;
    _nic = [nil, _door, "per", rHideObject, false] call RE;
    //_door hideObject false; 
    //_pos set [2,0];
    //_door setPos _pos;
    _door setVariable ["inMotion", 0, true];

};


fnc_operate_all_doors = {

    private ["_isBuildable","_charPos","_character","_id","_pos","_nearestGates","_inMotion","_lever","_text","_handlers"];

    _location = _this select 0;
    _radious = _this select 1;
    _isBuildable = true;

    _nearestGates = nearestObjects [_location, ["Hhedgehog_concrete","Concrete_Wall_EP1"], _radious];
    //dayz_updateNearbyObjects = [_charPos, _isBuildable];
    //publicVariableServer "dayz_updateNearbyObjects";
    //if (isServer) then {
    //    dayz_updateNearbyObjects call server_updateNearbyObjects;
    //};
    //[_charPos, _isBuildable] call server_updateNearbyObjects;

    if (!openingGates) then {
        openingGates=true;

        _handlers=[];
        {
            _hnd=  _x spawn {
                private["_pos","_z","_text","_x"];
                _x = _this;
                _pos = getPos _this;
                _z = _pos select 2;

                if (_z <= -2) then {

                    _pos set [2,0];
                    _x setPos _pos;
                    [nil,_x,rSAY,["trap_bear_0",60]] call RE;

                } else {
                    _pos set [2,-6.6];
                    _x setPos _pos;
                    [nil,_x,rSAY,["trap_bear_0",60]] call RE;
                };
            };
            //_handlers set [count _handlers,_hnd];
        } foreach _nearestGates;
        openingGates = false;
    } else {
        cutText [format["You cannot open/close the door until it finish the last operation"], "PLAIN DOWN"];
    };
}
