fnc_buildKeyDown={
    _ctrl = _this select 0;
    _dikCode = _this select 1;
    _shift = _this select 2;
    _ctrlKey = _this select 3;
    _alt = _this select 4;
    _handled = false;
    /*  Control de teclado para base building.
        Numpad:
        7-Rotate left 0x47 e
        8-Elevate 0x48 8
        9-Rotate right 0x49 q
        4-move left 0x4B .
        5-restablish 0x4C 5
        6-move right 0x4D ,
        2-lower 0x50 2
        0-attach to ground 0x52
    */
    //hint str _dikCode;
    
        
    if(_dikCode== 199 && !_shift  ) then {
        [] execVM "\BB_Buildings\code\buildRecipeBook\build_recipe_dialog.sqf";
    
    };
    
    if(_dikCode== 2 && _shift  ) then {
        [] call fnc_toggle_fps_fix;
    
    };
    if(_dikCode== 3 && _shift  ) then {
        [] call fnc_show_player_clan;
    
    };
    
    if(bb_state_building && !bb_state_limited) then {
        
        switch(_dikCode)do {
             
            case 71: {[] call fnc_object_rotate_left;_handled=true}; //Rotate left 7
            case 73: {[] call fnc_object_rotate_right;_handled=true}; //Rotate right 9
             
            case 72: {[] call fnc_object_elevate;_handled=true}; //Elevate n8
            case 201: {[] call fnc_object_push;_handled=true};//push pgup
            case 209: {[] call fnc_object_pull;_handled=true};//pull pgdown
            case 76: {[] call fnc_object_restablish;_handled=true};//Restablish n5
            //case 77: {hint "6";};
            //case 79: {hint "1";};
            case 80: {[] call fnc_object_lower;_handled=true}; // Lower n2
            case 75: {[] call fnc_object_move_left;_handled=true}; //move left  ,
            case 77: {[] call fnc_object_move_right;_handled=true};//move right  .
            case 82: {[] call fnc_object_attachToGround;_handled=true};//attach to ground /
            case 79: {_handled=true};//S -1
            case 81: {_handled=true};//S -3
            
        };  
    
    };
    //bb_state_limited
    if(bb_state_building && bb_state_limited) then {
        
        switch(_dikCode)do {
             
            case 71: {[] call fnc_object_rotate_left;_handled=true}; //Rotate left 7
            case 73: {[] call fnc_object_rotate_right;_handled=true}; //Rotate right 9
             
            //case 72: {[] call fnc_object_elevate;_handled=true}; //Elevate n8
            case 201: {[] call fnc_object_push;_handled=true};//push pgup
            case 209: {[] call fnc_object_pull;_handled=true};//pull pgdown
            case 76: {[] call fnc_object_restablish;_handled=true};//Restablish n5
            //case 77: {hint "6";};
            //case 79: {hint "1";};
            //case 80: {[] call fnc_object_lower;_handled=true}; // Lower n2
            case 75: {[] call fnc_object_move_left;_handled=true}; //move left  ,
            case 77: {[] call fnc_object_move_right;_handled=true};//move right  .
            case 82: {[] call fnc_object_attachToGround;_handled=true};//attach to ground /
            case 79: {_handled=true};//S -1
            case 81: {_handled=true};//S -3
            
        };  
    
    };
    
    if(bb_state_building && bb_state_totallylimited) then {
        
        switch(_dikCode)do {
             
            //case 72: {[] call fnc_object_elevate;_handled=true}; //Elevate n8
            // case 76: {[] call fnc_object_restablish;_handled=true};//Restablish n5
            //case 80: {[] call fnc_object_lower;_handled=true}; // Lower n2
            //case 82: {[] call fnc_object_attachToGround;_handled=true};//attach to ground /
            case 79: {_handled=true};//S -1
            case 81: {_handled=true};//S -3
            
        };  
    
    };
    
    //Sin ser en preview
    if(bb_state_inCamera && !bb_camera_preview) then {
        switch(_dikCode)do {
            case 16: {[] call fnc_camera_finish;_handled=true}; //Rotate left Q
            case 17: {_handled=true};//W
            case 31: {_handled=true};//S -
            case 30: {[3] call fnc_camera_rotateL;_handled=true};//A  Rotate left
            case 32: {[3] call fnc_camera_rotateR;_handled=true};//D -Rotate right
            case 2: {[0] call fnc_camera_switch;_handled=true};
            case 3: {[1] call fnc_camera_switch;_handled=true};
            case 4: {[2] call fnc_camera_switch;_handled=true};
            case 5: {[3] call fnc_camera_switch;_handled=true};
            case 6: {[4] call fnc_camera_switch;_handled=true};
            case 7: {[5] call fnc_camera_switch;_handled=true};           
            case 8: {[6] call fnc_camera_switch;_handled=true};
            case 9: {[7] call fnc_camera_switch;_handled=true};
            case 10:{[8] call fnc_camera_switch;_handled=true};
            case 35:{[] call fnc_camera_help;_handled=true};  
            case 25:{[] spawn fnc_camera_preview;_handled=true};
            
        }; 
    };
    //En preview
    if(bb_state_inCamera && bb_camera_preview) then {
        switch(_dikCode)do {
            case 16: {[] call fnc_camera_finish;_handled=true}; //Rotate left Q
            case 17: {_handled=true};//W
            case 31: {_handled=true};//S -
            case 30: {_handled=true};//A  Rotate left
            case 32: {_handled=true};//D -Rotate right
            case 35:{[] call fnc_camera_help;_handled=true};  
            case 25:{[] call fnc_stop_camera_preview;_handled=true};

        }; 
    
    };
    
    
    _handled;
};
