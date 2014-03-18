private["_disarmChance","_kaBoom","_detonate","_objectID","_objectUID","_bomb","_cnt","_classname","_id","_tblProb","_locationPlayer","_randNum2","_smallWloop","_medWloop","_longWloop","_text","_wait","_longWait","_medWait","_smallWait","_highP","_medP","_lowP","_failRemove","_canRemove","_randNum","_classname","_dir","_pos","_text","_isWater","_inVehicle","_onLadder","_hasToolbox","_canDo","_hasEtool"];
_bomb = cursorTarget;
_dir = direction _bomb;
_pos = getposATL _bomb;

if (!isNull _bomb) then {
    _objectID = _bomb getVariable["ObjectID",0];
    _objectUID = _bomb getVariable["ObjectUID","0"];
};

//Player removes object successfully
cutText [format["You disarmed the %1 successfully!",_text], "PLAIN DOWN"];

if (!isNull _bomb) then {
    dayzDeleteObj = [_objectID,_objectUID];
    publicVariableServer "dayzDeleteObj";
    if (isServer) then {
        dayzDeleteObj call server_deleteObj;
    };
    deleteVehicle _bomb;
};        
