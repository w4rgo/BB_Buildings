/*_vehicle = objNull;
vehicles_helipad = [];
diag_log "Running helipad monitor";

while {true} do
{
    
    
    _inrepairzone = count ( _nearestVehicles ) > 0;
    _target = cursortarget;
    if(_target isKindOf "AllVehicles") then {
        _nearestVehicles = nearestObjects [_target,["HeliHCivil","Helipadsmall"], 10];
            
        if(_inrepairzone) then {

            helipad_action = player addAction [("<t color=""#FF0000"">" + ("Refuel/Rearm/Repair") + "</t>"), "\BB_Buildings\code\helipad\repairVehicles.sqf", _target ,-1, false, false, "",""];

        };
        
    };            
};
sleep 5;
};*/