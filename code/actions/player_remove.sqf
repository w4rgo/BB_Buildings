
private ["_text","_objectID","_objectUID","_obj","_ownerID","_func_ownerRemove"];
disableserialization;


_obj = _this select 0;

if (_obj isKindof "Grave") then {
    _text = "Bomb";
    cutText [format["You can only disarm %1 to remove it",_text], "PLAIN DOWN",1];breakOut "exit";
};

//_isPlayerNear = [getpos player] call fnc_is_player_near;

//if(_isPlayerNear) then {cutText [format["You cannot remove with players near"], "PLAIN DOWN",1];breakOut "exit";};

if(bb_state_removing or (cursortarget getVariable["bb_object_preview",false])) then {cutText ["QUE HACES???, duper, Los admins han sido notificados.", "PLAIN DOWN"];breakOut "exit";};
_obj setVariable ["bb_object_preview",true,true];  


// Get ObjectID or UID


_ownerID = _obj getVariable ["characterID","0"];


// Do percentages

//Others


// This function is for owner removal either by code (line 109) or by ownerID (line 112)
_func_ownerRemove = {
    
    private ["_recipe","_qtyT","_qtyS","_qtyW","_qtyL","_qtyM","_qtyG","_result","_buildable","_classname","_objectID","_objectUID","_index","_obj"];
    _obj = _this select 0;
    
    if (!isNull _obj) then {
        _objectID = _obj getVariable["ObjectID","0"];
        _objectUID = _obj getVariable["ObjectUID","0"];
    };
    
    _qtyT = 0;
    _qtyS = 0; 
    _qtyW = 0;
    _qtyL = 0;
    _qtyM = 0;
    _qtyG = 0;

    _index= allbuildables_class find typeOf(_obj);
    if(_index >=0) then {
        
        _buildable = allbuildables select _index;
        _classname = _buildable select 1;
        _result = [typeOf(_obj),_classname] call BIS_fnc_areEqual;
        
        if (_result) then {
             
              
            _recipe = _buildable select 0;
            //[_qtyT, _qtyS, _qtyW, _qtyL, _qtyM, _qtyG]
            _qtyT = _recipe select 0;
            _qtyS = _recipe select 1;
            _qtyW = _recipe select 2;
            _qtyL = _recipe select 3;
            _qtyM = _recipe select 4;
            _qtyG = _recipe select 5;
        
        
            if(!isNull _obj) then {
                if (_qtyT > 0) then {
                    for "_i" from 1 to _qtyT do { _result = [player,"ItemTankTrap"] call BIS_fnc_invAdd;  };
                };
                if (_qtyS > 0) then {
                    for "_i" from 1 to _qtyS do { _result = [player,"ItemSandbag"] call BIS_fnc_invAdd;  };
                };
                if (_qtyW > 0) then {
                    for "_i" from 1 to _qtyW do { _result = [player,"ItemWire"] call BIS_fnc_invAdd;  };
                };
                if (_qtyL > 0) then {
                    for "_i" from 1 to _qtyL do { _result = [player,"PartWoodPile"] call BIS_fnc_invAdd; };
                };
                if (_qtyM > 0) then {
                    for "_i" from 1 to _qtyM do { _result = [player,"PartGeneric"] call BIS_fnc_invAdd;  };
                };
                if (_qtyG > 0) then {
                    for "_i" from 1 to _qtyG do { _result = [player,"HandGrenade_west"] call BIS_fnc_invAdd;  };
                };
            };
            
            _obj setVariable ["bb_object_preview",false,true];
            
            deletevehicle _obj;

            if( _classname  in bb_building_turret ) then {
                //Refund a M240
                _result = [player,"M240_DZ"] call BIS_fnc_invAdd;

            };
        };
        
        cutText [format["Owner refunded for object %1",_classname], "PLAIN DOWN",1];
        dayzDeleteObj = [_objectID,_objectUID];
        publicVariableServer "dayzDeleteObj";
        if (isServer) then {
            dayzDeleteObj call server_deleteObj;
        };
        
        
    } else {
        cutText [format["Cannot remove %1",_classname], "PLAIN DOWN",1];
    };
};


if ( (_ownerID == dayz_characterID) || bb_user_authorized || bb_admin_activated ) then { 
    [_obj] call _func_ownerRemove;
    bb_state_removing = true;
} else {
    cutText [format["Not allowed to remove %1",_classname], "PLAIN DOWN",1];
};

bb_state_removing = false;
_obj setVariable ["bb_object_preview",false,true];