bb_base_cameras=[];
//bb_current_camera=ObjNull;
bb_camera_actions=[];
bb_current_camera_index=0;
bb_camera_preview = false;
bb_camera_object= "ARP_Objects_cam1";
bb_camera_moving = false;

fnc_camera_help = {
    "Security camera controls" hintC [
    "Numbers 1,9 select camera",
    "Q Exit.",
    "Numpad A - Rotate left",
    "Numpad D - Rotate right",
    "P - Toggle preview all cameras"
    ];
    

};

fnc_camera_preview = {
    private["_i"];
    //Esta funcion realiza un barrido por todas las camaras de la base, se para 10 segundos en cada una girandola hacia un lado y al otro.
    
    cutText [format["Press P again to exit preview mode..."], "PLAIN DOWN"];
    if(!bb_camera_preview) then {
        _numCameras =  count bb_base_cameras;
        _i=0;
        bb_camera_preview = true;
        _sleepTime= 0.05;
        
        while{bb_camera_preview} do {
    
            _cam = [_i] call fnc_camera_switch;
            
            //Rotar izq
            for "_j" from 0 to 50 do {
        
                [1] call fnc_camera_rotateL;
                sleep _sleepTime;
                if(!bb_camera_preview) then {
                    breakOut "exit";
                };
        
            };
            //deshacer
            for "_j" from 0 to 50 do {
        
                [1] call fnc_camera_rotateR;
                sleep _sleepTime;
                if(!bb_camera_preview) then {
                    breakOut "exit";
                };
            };
            //Rotar dere
            for "_j" from 0 to 50 do {
        
                [1] call fnc_camera_rotateR;
                sleep _sleepTime;
                if(!bb_camera_preview) then {
                    breakOut "exit";
                };
            };
            //deshacer
            for "_j" from 0 to 50 do {
        
                [1] call fnc_camera_rotateL;
                sleep _sleepTime;
                if(!bb_camera_preview) then {
                    breakOut "exit";
                };
            };
            
            
            
            
            
            sleep 1;
            if(_i == _numCameras -1) then {
                _i = 0;
            };
            
            _i = _i +1;
        };

    };

};

fnc_stop_camera_preview = {
    bb_camera_preview = false;
    _numCam = bb_current_camera_index;
    _cam = [_numCam ] call fnc_camera_switch;
     
};
fnc_search_cameras = {
    _panel = _this select 0;
    
    bb_base_cameras = nearestObjects[_panel,[bb_camera_object],300];
    
};

fnc_camera_next = {
    if(bb_current_camera_index == 9) then {
        bb_current_camera_index =0;
    } else {
        bb_current_camera_index = bb_current_camera_index +1;
    };
};

fnc_camera_prev = {
    if(bb_current_camera_index == 0) then {
        bb_current_camera_index =9;
    } else {
        bb_current_camera_index = bb_current_camera_index -1;
    };
    
};

fnc_camera_switch = {
    _cameraNum = _this select 0;
    bb_current_camera_index= _cameraNum;
    if(bb_current_camera_index < count bb_base_cameras) then {
        _newCam = bb_base_cameras select bb_current_camera_index;
        //_newCam setdir (getDir _cam) + 180;
        //hint str _cameraNum;
        [_newCam] call fnc_camera_view;
    } else {
        cutText [format["Camera %1 does not exists",_cameraNum], "PLAIN DOWN"];
    };
    
    _newCam;
};

fnc_camera_rotateR = {
    _qty = _this select 0;
    if(!bb_camera_moving) then {
        bb_camera_moving= true;
        diag_log(format["cam: %1",str(getDir bb_current_camera)]);
        bb_current_camera setDir (getDir bb_current_camera) + _qty;
       
    };
    
    bb_camera_moving = false;
    
};

fnc_camera_rotateL = {
    _qty = _this select 0;
    if(!bb_camera_moving) then {
        bb_camera_moving= true;
         diag_log(format["cam: %1",str(getDir bb_current_camera)]);
        bb_current_camera setDir (getDir bb_current_camera) - _qty;
    };
    
    bb_camera_moving = false;
};

fnc_camera_view = {
    _cam = _this select 0;
    _classname = typeOf _cam;
    if(_cam != objNull and _classname != "") then {
        
        bb_current_camera = _cam;
        //_currentCam = bb_current_camera_index;
        //_cam setdir (getDir _cam) + 180;
        _cam switchCamera "Internal";
        //waitUntil{cameraOn!=_cam};
        //_cam setdir (getDir _cam) + 180;
    };

};

fnc_camera_startup={
    if(count bb_base_cameras > 0) then {
        
        bb_state_inCamera=true;
        /*{
            _x setDir(getDir _x) +180;
        } foreach bb_base_cameras;*/

        [0] call fnc_camera_switch;
        //bb_camera_help_action = player addAction ["Camera controls", "\BB_Buildings\code\camera\camera_help.sqf", _x, 1, false, true,"", ""];
        cutText [format["Press H for controls..."], "PLAIN DOWN"];

    }else {
        cutText [format["You need to build cameras, If using the radio then you need to activate the camera system in base once first."], "PLAIN DOWN"];
    };
};

fnc_camera_finish = {
    
    bb_camera_preview=false;
    bb_state_inCamera=false;
    
    /*{
        _x setDir(getDir _x) +180;
    } foreach bb_base_cameras;*/
    //objNull remoteControl bb_current_camera;
    player switchCamera "Internal";
    //player removeAction bb_camera_help_action;
    
};
/*
fnc_create_camera_menu = {
    _num = 1;
    {
        _actionName = format["Camera %1", _num];
        _action = player addAction [_actionName, "\BB_Buildings\code\camera\camera_init.sqf", _x, 1, false, true,"", ""];
        bb_camera_actions set [count bb_camera_actions, _action];
        
        _num= _num+1; 
    } foreach bb_base_cameras;
    _num=1;
    
    _action = player addAction ["Close camera menu", "\BB_Buildings\code\camera\camera_menu_close.sqf", "", 1, false, true,"", ""];
    bb_camera_actions set [count bb_camera_actions, _action];
};

fnc_delete_camera_menu = {
    {
        player removeAction _x;
    } foreach bb_camera_actions;
};*/