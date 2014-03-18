 _panel = _this select 3;
if(!perimeterActivated) then {
    perimeterActivated = true;
    
    baseMembers=[(name player)];
    cutText [format["The alarm system start now!"], "PLAIN DOWN",1];
    sleep 1;
    
    _null = [_panel] execVM "\BB_Buildings\code\perimeter\perimeterMonitor.sqf";
} else {
        cutText [format["You can only start 1 alarm system."], "PLAIN DOWN",1];
        sleep 1;
};

