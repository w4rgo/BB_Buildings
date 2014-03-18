bb_base_auxpanel = "Infostand_1_EP1";


fnc_bbactions_init = {

    //Acciones de panel auxiliar
    /*_condition = "typeOf(cursortarget)==bb_base_auxpanel";
    s_player_inflameBarrels = player addAction ["Lights ON", "\BB_Buildings\code\lights\inflameBarrels.sqf", cursortarget, 1, false, true, "", _condition];
    s_player_deflameBarrels = player addAction ["Lights OFF", "\BB_Buildings\code\lights\deflameBarrels.sqf", cursortarget, 1, false, true, "", _condition];
    s_player_activateNukeZed = player addAction ["Kill zombies (on/off)", "\BB_Buildings\code\actions\nuke_zeds.sqf", cursortarget, 1, false, true,"",  _condition];
    s_player_activatePerimeter = player addAction ["Start alarm system", "\BB_Buildings\code\perimeter\startPerimeterMonitor.sqf", cursortarget, 1, false, true,"", "typeOf(cursortarget)==bb_base_auxpanel and !perimeterActivated"];
    s_player_deactivatePerimeter = player addAction ["Stop alarm system", "\BB_Buildings\code\perimeter\stopPerimeterMonitor.sqf", cursortarget, 1, false, true,"",  "typeOf(cursorTarget) == bb_base_auxpanel && perimeterActivated"];
    s_player_activateSoundAlarm = player addAction ["Activate sound", "\BB_Buildings\code\perimeter\activateSoundAlarm.sqf", cursortarget, 1, false, true,"", "typeOf(cursorTarget) == bb_base_auxpanel && !soundAlarm"];
    s_player_deactivateSoundAlarm = player addAction ["Deactivate sound", "\BB_Buildings\code\perimeter\deactivateSoundAlarm.sqf", cursortarget, 1, false, true,"","(typeOf(cursorTarget) == bb_base_auxpanel) && soundAlarm"];
    */
    
    //Aniadir miembro a base
    s_player_addFriend = player addAction ["Add base member", "\BB_Buildings\code\perimeter\addMember.sqf", cursortarget, 1, false, true,"", "(cursorTarget isKindOf ""Man"")&& perimeterActivated &&!((name cursorTarget) in baseMembers)"];

    //Acciones de admin
};



//AUX PANEL
fnc_lights_on = {
    _lever = _this select 0;
    _nearestBarrels = nearestObjects [_lever, ["Land_Fire_Barrel","SearchLight_UN_EP1"], 200];

    {

        if (typeOf(_x) == "SearchLight_UN_EP1") then {
            player action["lighton",_x];
        } else {
            _x inflame true;
        };
    } foreach _nearestBarrels;
};
fnc_lights_off = {
    _lever = _this select 0;
    _nearestBarrels = nearestObjects [_lever, ["Land_Fire_Barrel","SearchLight_UN_EP1"], 200];

    {
    
        if (typeOf(_x) == "SearchLight_UN_EP1") then {
            player action["lightoff",_x];
        } else {
            _x inflame false;
        };


    } foreach _nearestBarrels;
};

fnc_alarm_on = {
    _panel = _this select 0;
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



};
fnc_alarm_off = {
    perimeterActivated = false;

};

fnc_sound_on = {
    cutText [format["Alarm sound activated."], "PLAIN DOWN",1];
    sleep 1;
    soundAlarm = true;

};

fnc_sound_off = {
    cutText [format["Alarm sound deactivated."], "PLAIN DOWN",1];
    sleep 1;
    soundAlarm = false;
    alarmOn = false;
};

fnc_kill_zombies = {
    private["_location","_radius","_nuker","_obj_text_string"];
 
    if(!isServer) exitwith{};
    
    if(nuke_zeds_activated) then {
        nuke_zeds_activated=false;
        cutText ["Nuke zeds deactivated", "PLAIN DOWN"];breakOut "exit";
    };
    
    _panel = _this select 0;
    
    cutText ["Nuke zeds activated", "PLAIN DOWN"];
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
};

fnc_start_camera = {

    //[_cam] call fnc_camera_startup;
    _panel = _this select 0;

    [_panel] call fnc_search_cameras;

    _numCam = count bb_base_cameras;
    if(_numCam> 0 ) then {
        cutText [format["Camera system activated: %1 cameras detected",_numCam], "PLAIN DOWN"];
        [] call fnc_camera_startup;
    } else {
        cutText [format["You have no cameras..."], "PLAIN DOWN"];

    };
};

//MAIN PANEL

fnc_authorize = {
    _panel = _this select 0;


    if(!bb_user_authorized) then {
        bb_user_authorized=true;
        cutText ["You can tow / remove / build restricted objects your base", "PLAIN DOWN"];
        
        
        _charPos = position player;
        _isBuildable=true;
        dayz_updateNearbyObjects = [_charPos, _isBuildable];
        publicVariableServer "dayz_updateNearbyObjects";
        if (isServer) then {
            dayz_updateNearbyObjects call server_updateNearbyObjects;
        };
        [_charPos, _isBuildable] call server_updateNearbyObjects;
        
        
        while{player distance _panel < baseSize}do {
    
            sleep 3;
    
        };
        cutText ["You cant tow / remove / build restricted objects anymore. You are too far.", "PLAIN DOWN"];
        bb_user_authorized=false;
    } else {
        cutText ["You are already bb_user_authorized!", "PLAIN DOWN"];
    };


};

[] call fnc_bbactions_init;