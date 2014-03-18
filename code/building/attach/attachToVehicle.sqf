_object = _this select 0;

_bucle = true;


if(bb_state_inProgress) exitWith {
    cutText ["You are already building!!!", "PLAIN DOWN"];
};

if(bb_state_attaching) exitWith {
    cutText [format["You are already attaching!!"], "PLAIN DOWN"];

};

cutText [format["Object selected: %1, now select a vehicle",typeOf(_object)], "PLAIN DOWN"];

bb_state_attaching=true;
bb_current_object=_object;

selectAction = player addAction ["Select vehicle", "\BB_Buildings\code\building\attach\selectVehicle.sqf",bb_current_object, 1, true, true, "", ""];
helpAction = player addAction [("<t color=""#0074E8"">" + ("Controls") +"</t>"),"\BB_Buildings\code\building\helpControls.sqf",bb_current_object, 1, true, true, "", ""];



waitUntil{!bb_state_attaching};
player removeAction selectAction;
cutText [format["Vehicle selected: %1 ,place now the object in the vehicle",str typeOf(bb_current_attachVehicle)], "PLAIN DOWN"];

disableSerialization;
closedialog 1;

_requirements=[];

_buildable = [typeOf(_object)] call fnc_getBuildableByClass;


_originalPos= getPos bb_current_object;
_originalDir= getDir bb_current_object;

deletevehicle _object;
_classname ="";hint _classname;
_classname = _buildable select 1;hint _classname;
_requirements=_buildable select 2;



//Get Requirements from build_list.sqf global array [_attachCoords, _startPos, _modDir, _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown];
bb_current_attachCoords 	= _requirements select 0;
_startPos 		= _requirements select 1;
_modDir 		= _requirements select 2;

// Get _startPos for object
_location 		= player modeltoworld _startPos;

//Get Building to build

_text = _classname;

player allowdamage false;
bb_current_object = createVehicle [_classname, _location, [], 0, "CAN_COLLIDE"];
bb_current_object setDir (getDir player);
if (_modDir > 0) then {
    bb_current_object setDir (getDir player) + _modDir;
};
player allowdamage true;


[] call fnc_build_start;

finishAction = player addAction ["Finish attachment!", "\BB_Buildings\code\actions\buildActions\finishBuild.sqf",bb_current_object, 1, true, true, "", ""];


waitUntil{!bb_state_building};

cutText [format["%1 attached to %2 !!",typeOf(bb_current_object),typeOf(bb_current_attachVehicle)], "PLAIN DOWN"];

_relativePos=  bb_current_attachVehicle worldToModel (getPos bb_current_object);
hint str _relativePos;

_x = _relativePos select 0;
_y = _relativePos select 1;
_z = _relativePos select 2;

_newRel= [_x,_y,_z+1];
detach bb_current_object;
_oldDir= (getdir bb_current_object - getdir bb_current_attachVehicle);


bb_current_object attachto [bb_current_attachVehicle, _newRel];
bb_current_object setdir _oldDir;


bb_state_cancel=false;

player removeAction finishAction;
player removeAction helpAction;
cancelAction = player addAction [("<t color=""#F01313"">" + ("Cancel") +"</t>"), "\BB_Buildings\code\building\cancel.sqf",bb_current_object, 1, true, true, "", ""];
acceptAction = player addAction [("<t color=""#0074E8"">" + ("Accept") +"</t>"), "\BB_Buildings\code\building\accept.sqf",bb_current_object, 1, true, true, "", ""];


cutText [format["You have 10 seconds to cancel"], "PLAIN DOWN"];
bb_state_decide = false;

_continue= true;
i=0;
while{_continue} do {
    
     
    if(i > 60) then{
        player removeAction acceptAction;
        player removeAction cancelAction;
        detach bb_current_object;
        bb_current_object setPos _originalPos;
        bb_current_object setDir _originalDir;
        cutText [format["The building expired... "], "PLAIN DOWN"];
        player removeAction acceptAction;
        player removeAction cancelAction;
        sleep 1;
        bb_current_object addAction ["Attach to vehicle", "\BB_Buildings\code\building\attach\attachToVehicle.sqf", bb_current_object, 1, false, true,"", ""];
        [] call fnc_build_finish;
        
        _continue= false;
    };
    
    if(bb_state_decide) then {
        player removeAction acceptAction;
        player removeAction cancelAction;
        if(bb_state_cancel) then {
            detach bb_current_object;
            bb_current_object setPos _originalPos;
            bb_current_object setDir _originalDir;
            bb_current_object addAction ["Attach to vehicle", "\BB_Buildings\code\building\attach\attachToVehicle.sqf", bb_current_object, 1, false, true,"", ""];
            
            cutText [format["Canceled..."], "PLAIN DOWN"];
            
            sleep 1;
            [] call fnc_build_finish;
            
        }else{
                 
            cutText [format["Object Attached!!"], "PLAIN DOWN"];
            sleep 1;
            [] call fnc_build_finish;   
        };
        _continue= false;
    };
    
    i=i+1;
    sleep 0.5;
};
   
   




