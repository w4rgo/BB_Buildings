fnc_veh_lock = {

    private["_vehicle"];
    _vehicle = _this select 0;
    _vehicle setVehicleInit "this lock true; this lockCargo true;";
    processInitCommands;
};

fnc_veh_unlock = {
    private["_vehicle"];
    _vehicle = _this select 0;
    _vehicle setVehicleInit "this lock false; this lockCargo false;";
    processInitCommands;
};