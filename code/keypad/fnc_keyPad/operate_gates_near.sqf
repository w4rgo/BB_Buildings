private ["_isBuildable","_charPos","_character","_id","_pos","_z","_nearestGates","_inMotion","_lever","_text"];
_character = _this select 1;
_id = _this select 2;
_lever = _this select 3;
_isBuildable = true;
_charPos = getposATL _character;
_inMotion = _lever getVariable ["inMotion",0];



_nearestGates = nearestObjects [_lever, ["Hhedgehog_concrete","Concrete_Wall_EP1"], 10];
//dayz_updateNearbyObjects = [_charPos, _isBuildable];
//publicVariableServer "dayz_updateNearbyObjects";
//	if (isServer) then {
//		dayz_updateNearbyObjects call server_updateNearbyObjects;
//	};
//	{dayz_myCursorTarget removeAction _x} forEach s_player_gateActions;s_player_gateActions = [];
//[_charPos, _isBuildable] call server_updateNearbyObjects;

if (!openingGates) then {
    openingGates=true;
	//_lever setVariable ["inMotion", 1, true];
	
	{
		[_x,30] spawn fnc_open_door;
	} foreach _nearestGates;
    openingGates = false;
	//_lever setVariable ["inMotion", 0, true];
} else {
    cutText [format["You cannot open/close the door until it finish the last operation"], "PLAIN DOWN"];
};
