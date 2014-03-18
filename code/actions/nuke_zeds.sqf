/*
    Author: Sarge
 
    Description:
    Kills all zombies in a given distance from a given point.
 
    Needs 2 parameters:
 
    _location = the exact x/y/z location of the center of the area that should be zed free
    _range = the radius within which zeds get killed
 
 
*/
 
    private["_location","_radius","_nuker","_obj_text_string"];
    
    if(nuke_zeds_activated) then {
        nuke_zeds_activated=false;
        cutText ["Nuke zeds deactivated", "PLAIN DOWN"];breakOut "exit";
    };
    
    _panel = _this select 3;
    
    cutText ["Nuke zeds activated", "PLAIN DOWN"];breakOut "exit";
    nuke_zeds_activated = true;
    _location = getPos _panel;
    _radius = 300;//_this select 1;
 
    //_nuker = createvehicle ["Sign_sphere25cm_EP1",[_location select 0,_location select 1,1] ,[],0,"NONE"];
    //_nuker allowDamage false;
    
    //_obj_text_string = format["#(argb,8,8,3)color(%1,%2,%3,%4,ca)",1,1,0,1];
    //[nil,nil,rSETOBJECTTEXTURE,_nuker,0,_obj_text_string] call RE;
 
    
    [_nuker,_radius] spawn {
 
        private ["_nuker","_radius","_entity_array"];
        _nuker = _this select 0;
        _radius = _this select 1;
     
        while {nuke_zeds_activated} do {
     
            _entity_array = (getPos _nuker) nearEntities ["CAManBase",_radius];
            {
                if (_x isKindof "zZombie_Base") then {
                    _x setDamage 1;
                };
            } forEach _entity_array;
            sleep 2;
        };
    };