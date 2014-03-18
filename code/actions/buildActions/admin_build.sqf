// Location placement declarations
_locationPlayer = player modeltoworld [0,0,0];
_location 		= player modeltoworld [0,0,0]; // Used for object start location and to keep track of object position throughout
_attachCoords = [0,0,0];
_dir 			= getDir player;
_building 		= nearestObject [player, "Building"];
_staticObj 		= nearestObject [player, "Static"];


// Other
_cntLoop 		= 0;
_chosenRecipe 	= [];
_requirements 	= [];
_buildable 		= [];
_buildables		= [];
_longWloop		= 2;
_medWloop		= 1;
_smallWloop 	= 0;
_cnt 			= 0;
_playerCombat = player;


disableSerialization;
closedialog 1;

_requirements=[];

_buildable = (allbuildables select currentBuildRecipe);
_classname ="";
_classname = _buildable select 1;
_requirements=_buildable select 2;

//Get Requirements from build_list.sqf global array [_attachCoords, _startPos, _modDir, _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown];
_attachCoords 	= _requirements select 0;
_startPos 		= _requirements select 1;
_modDir 		= _requirements select 2;

// Get _startPos for object
_location 		= player modeltoworld _startPos;

//Get Building to build

_text = _classname;

_buildCheck = false;
_buildReady = false;
player allowdamage false;
_object = createVehicle [_classname, _location, [], 0, "CAN_COLLIDE"];
_object setDir (getDir player);
if (_modDir > 0) then {
_object setDir (getDir player) + _modDir;
};

buildAction = player addAction ["Complete build", "tweaks\admin_build_ready.sqf",_object, 1, true, true, "", ""];
elevateAction = player addAction ["Elevate object", "tweaks\elevateObject.sqf",_object, 1, true, true, "", ""];
lowerAction = player addAction ["Lower object", "tweaks\lowerObject.sqf",_object, 1, true, true, "", ""];
rotateAction = player addAction ["Rotate object", "tweaks\rotateObject.sqf",_object, 1, true, true, "", ""];
rotateAction2= player addAction ["Rotate object inverse", "tweaks\rotateObjectInverse.sqf",_object, 1, true, true, "", ""];

objectAwayAction = player addAction ["Push object away", "tweaks\pushObject.sqf",_object, 1, true, true, "", ""];
objectNearAction = player addAction ["Pull object near", "tweaks\pullObject.sqf",_object, 1, true, true, "", ""];

modDir = _modDir;

player allowdamage true;
//cutText ["-Build process started.  Move around to re-position\n-Stay still to begin build timer", "PLAIN DOWN", 10];		
while {!buildReady} do {
	//hintsilent "-Build process started.  \n-Move around to re-position\n-Stay still to begin build timer";

	_dialog = findDisplay 106;//(speed player < 9 && speed player > 0) || (speed player > -7 && speed player < 0)
		if (true) then {

				//_newAttachCoords = [];
				_newAttachCoords = [_attachCoords select 0,(objectDistance + (_attachCoords select 1)),(objectHeight + (_attachCoords select 2))];
				//(objectHeight + (_attachCoords select 2))
				
                _object attachto [player, _newAttachCoords];
				
				_modDir=modDir; 
				_object setDir (getDir player) + _modDir ;
				_inProgress = true;
		} else { 
           // buildAction=player addAction["Complete build", "tweaks\admin_build_ready.sqf",cursorTarget, 1, true, true, "", ""];
   		};
		// Cancel build if rules broken
		if ((!(isNull _dialog) || (speed player > 9 || speed player < -7)) ) then {
			detach _object;
			deletevehicle _object;
            buildReady=false;
            player removeAction buildAction;
            player removeAction elevateAction;
            player removeAction lowerAction;
            player removeAction rotateAction;
            player removeAction rotateAction2;		
            player removeAction objectAwayAction;
            player removeAction objectNearAction;			
            cutText [format["Build canceled for %1. Player moving too fast, in combat or opened gear.",_text], "PLAIN DOWN",1];procBuild = false;_playerCombat setVariable["startcombattimer", 1, true];breakOut "exit";
    };
	sleep 0.1;
};

buildReady=false;
player removeAction buildAction;
player removeAction elevateAction;
player removeAction lowerAction;			
player removeAction rotateAction;
player removeAction rotateAction2;	
player removeAction objectAwayAction;
player removeAction objectNearAction;	
_tObjectPos = getposATL _object;
_dir = getDir _object;
sleep 0.1;
deletevehicle _object; 


_object = createVehicle [_classname, _tObjectPos, [], 0, "CAN_COLLIDE"];
_object setDir _dir;
_object setpos [(getposATL _object select 0),(getposATL _object select 1), (getposATL _object select 2)];


/ Send to database
//_object setVariable ["characterID",dayz_characterID,true];
//dayzPublishBld = _object;
//publicVariableServer "dayzPublishBld";
	//if (isServer) then {
		//dayzPublishBld call SAR_save2hive;
	//};
//} else {cutText ["You need the EXACT amount of whatever you are trying to build without extras.", "PLAIN DOWN"];call _funcExitScriptCombat;};


buildReady=false;
