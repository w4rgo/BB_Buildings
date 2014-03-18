private["_object"];



bb_current_attachVehicle = cursortarget;

if(bb_current_attachVehicle!=objNull and bb_current_attachVehicle != bb_current_object and (bb_current_attachVehicle isKindOf "AllVehicles")) then {
    cutText ["Vehicle selected.", "PLAIN DOWN"];
    bb_state_attaching=false;

} else {
    
    cutText ["Select a vehicle!!", "PLAIN DOWN"];  
};
