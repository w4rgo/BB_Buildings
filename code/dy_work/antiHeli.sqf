private["_inVehicle","_isVehicle"];
while {true} do {
_inVehicle = (vehicle player != player);
_isVehicle = vehicle player;
//_noGunner = (vehicle player) emptyPositions "gunner";
	if (_inVehicle && (vehicle player) iskindof "Ka60_GL_NAC") then {
	_isVehicle lock false;
	sleep .1;
	player action ["eject", _isVehicle];
};
sleep 1;
};