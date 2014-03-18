bb_material_1 = "ItemTankTrap";
bb_material_2 = "ItemSandbag";
bb_material_3 = "ItemWire";
bb_material_4 = "PartWoodPile";
bb_material_5 = "PartGeneric";
bb_material_6 = "HandGrenade_West";
bb_material_weapon = "";
bb_material_qty1=0;
bb_material_qty2=0;
bb_material_qty3=0;
bb_material_qty4=0;
bb_material_qty5=0;
bb_material_qty6=0;

bb_state_building=false;
bb_state_attaching=false;
bb_state_attached=false;
bb_state_inProgress=false;
bb_state_inCamera=false;
bb_state_removing = false;
bb_admin_free = true;

//RESTRICTED -ADD MORE OBJECTS HERE IF YOU WANT PLAYERS TO BE bb_user_authorized TO USE THEM ( AUTHORIZE IS IN THE BASE PANEL THIS ENSURES BUILDER IS OWNER OF BASE)
bb_user_authorized=false;
bb_restrictedObjects=["Land_komin","Land_ladder_half","Land_ladder","Land_Misc_Scaffolding","Land_A_Castle_Stairs_A"];
bb_allowedObjects=["BB_Wooden_Planks","Land_prebehlavka","Land_fort_rampart_EP1","Grave"];
bb_building_turret= ["ZU23_CDF","BAF_GPMG_Minitripod_D","M2StaticMG_US_EP1","KORD_high","Fort_Nest_M240"];
bb_machineGuns=["R3F_Minimi_EOT","R3F_Minimi_762_EOT_HG","M240_DZ","JWC_FL_PK","PK","Mk_48_DZ","M249_DZ","RPK_74","VIL_Mg3","VIL_FnMag","skaVIL_M60","Pecheneg","JWC_FL_RPK_74","JWC_FL_Pecheneg"];
bb_allowed_attach=["ZU23_CDF","BAF_GPMG_Minitripod_D","M2StaticMG_US_EP1","KORD_high"];
bb_state_limited=false;
bb_state_totallylimited=false;
bb_heightallowed=["Land_CamoNet_NATO","Land_CamoNet_EAST","Land_CamoNetVar_NATO","Land_CamoNetVar_EAST","Land_CamoNetB_NATO","Land_CamoNetB_EAST","BB_Cinderwall","Fort_Nest_M240","BAF_GPMG_Minitripod_D","KORD_high","ARP_Objects_cam1","Land_ladder_half","Land_ladder","Fence_Ind_long","Fence_Ind","BB_Small_Wall","BB_Small_Wall_V","BB_Small_Wall_H","Small_Door","Medium_Door","Garage_Door","BB_Wooden_Planks","Land_prebehlavka","Land_fort_bagfence_long","BB_Operate_Roof","BB_Small_Roof"];

modDir = 0;

rotateDir = 0;
objectHeight=0;
objectDistance=0;
objectParallelDistance=0;
rotateIncrement=10;
objectIncrement=0.1;
objectTopHeight=10;
objectLowHeight=-10;
maxObjectDistance=10;
minObjectDistance=-10;
last_building_class="";



fnc_build_hasRequeriments = {
    _requeriments = _this select 0;
    
    //[TankTrap, SandBags, Wires, Logs, Scrap Metal, Grenades], "Classname", [_attachCoords, _startPos, _modDir, _toolBox, _eTool, _removable _isDestructable];
    _hasEtool 		= "ItemEtool" in weapons player;
    _hasToolbox 	= 	"ItemToolbox" in items player;
    
    _result = true;
    
    _toolBox 		= _requirements select 3;
    _eTool 		= _requirements select 4;

    if(_toolBox) then {
        if(!_hasToolbox) then {
            cutText [format["You need a tool box!!"], "PLAIN DOWN",1];
            _result = false;
        };
    };
    
    if(_eTool) then {
        if(!_hasEtool) then {
            cutText [format["You need a entrenching tool!!"], "PLAIN DOWN",1];
            _result = false;
        };
    };
    if(bb_admin_activated && bb_admin_free) then {
        _result=true;
    };
    _result;

};

fnc_build_canHaveAction = {
    _mags = magazines player;
    _hasBuildItem=false;
    if ("ItemTankTrap" in _mags || "ItemSandbag" in _mags || "ItemWire" in _mags || "PartWoodPile" in _mags || "PartGeneric" in _mags || bb_material_6 in _mags) then {
        _hasBuildItem = true;
    } else { 
        _hasBuildItem = false;
    };
    _can = !bb_state_inProgress and _hasBuildItem;
    _can;
};

fnc_build_checkNumberOfClanObject = {

    _classname = _this select 0;
    _count = 0;
    
    _allObjects = nearestObjects [player, [_classname], 50000];
    {
        _objectClan = _x getVariable["ClanID","0"];
        if(_objectClan == clanTag) then {
            _count = _count + 1;
        };
    } foreach _allObjects;
    
    _count

};

fnc_build_countNearestObjects = {
    _count = 0;
    
    
    _count = count (nearestObjects [player, allbuildables_class, baseSize]);

    _count
};

fnc_build_canBuildHere = {
    _classname = _this select 0;
    
    _isMyBase=false;
    _canBuild=true;
    if(clanTag == "0") then {
        _canBuild = false;
        cutText ["You need to be part of a clan to build. Create one in www.zombiespain.es", "PLAIN DOWN"];
    };
    
    
    _numObjectsNear = [] call fnc_build_countNearestObjects;
    
    if(_numObjectsNear > baseObjectNumber) then {
        _canBuild = false;
        cutText ["You exceded the limit of objects for your base", "PLAIN DOWN"];
    };
    
    _hangarNearest = nearestObjects [player, ["BB_Flag_Pole"], baseSize+100];
    //Si hay un pole mirar si es mio, si es mio construir
    if(count _hangarNearest >0 ) then {
        _pole= _hangarNearest select 0;
        _objectClan = _x getVariable["ClanID","0"];
        if(_objectClan == clanTag) then {
            _isMyBase=true;
        };
    };
    
    
    //Only one base pole
    if(_classname == "BB_Flag_Pole") then {
       
        if(bb_state_inProgress) then {
            if(typeOf(bb_current_object) =="BB_Flag_Pole" ) then {
                _hangarNearest = _hangarNearest - [bb_current_object];
            };
        };
    
        if ( (count _hangarNearest > 0) ) then {
            cutText ["Only 1 Base Pole per base in a 300 meter radius!", "PLAIN DOWN"];
            _canBuild=false;
        };
        _numObjects = [_classname] call fnc_build_checkNumberOfClanObject;
        if (_numObjects >= 1) then {
            cutText ["Only 1 Base Pole per clan!", "PLAIN DOWN"];
            _canBuild=false;
        
        };
    } else {
        
        if(!(_classname in bb_allowedObjects) and !_isMyBase) then {

            if ( (count _hangarNearest == 0) ) then {
                cutText ["You need to build BB_Flag_Pole to build a base !", "PLAIN DOWN"];
                _canBuild=false;
            };
        
        };
    };
    //Only one base pole per clan
    
    //ONLY 2 Techo grande
    if(_classname == "BB_Operate_Roof") then {
        _hangarNearest = nearestObjects [player, ["BB_Operate_Roof"], baseSize];
        if(bb_state_inProgress) then {
            if(typeOf(bb_current_object) =="BB_Operate_Roof" ) then {
                _hangarNearest = _hangarNearest - [bb_current_object];
            };
        };
    
        if ( (count _hangarNearest >= 2) ) then {
            cutText ["Only 2 roofs per base in a 300 meter radius!", "PLAIN DOWN"];
            _canBuild=false;
        };
    };
    
    //ONLY 5 Techo peque
    if(_classname == "BB_Small_Roof") then {
        _hangarNearest = nearestObjects [player, ["BB_Small_Roof"], baseSize];
        if(bb_state_inProgress) then {
            if(typeOf(bb_current_object) =="BB_Small_Roof" ) then {
                _hangarNearest = _hangarNearest - [bb_current_object];
            };
        };
    
        if ( (count _hangarNearest >= 10) ) then {
            cutText ["Only 10 small roofs per base in a 300 meter radius!", "PLAIN DOWN"];
            _canBuild=false;
        };
    };
    
    
    
    
    //ONLY 1 AA
    if(_classname == "ZU23_CDF") then {
        _hangarNearest = nearestObjects [player, ["ZU23_CDF"], baseSize];
        if(bb_state_inProgress) then {
            if(typeOf(bb_current_object) =="ZU23_CDF" ) then {
                _hangarNearest = _hangarNearest - [bb_current_object];
            };
        };
    
        if ( (count _hangarNearest > 0) ) then {
            cutText ["Only 1 ZU23_CDF per base in a 300 meter radius!", "PLAIN DOWN"];
            _canBuild=false;
        };
    
    };

    
    //_panelNearest2 = nearestObjects [player, ["BB_Flag_Pole"], baseSize+100];
    //Check if other panels nearby
    /*if(_classname == "BB_Flag_Pole") then {
        
        if(bb_state_inProgress) then {
            if(typeOf(bb_current_object) =="BB_Flag_Pole" ) then {
                _panelNearest2 = _panelNearest2 - [bb_current_object];
            };
        };
    
        if ((count _panelNearest2 > 0)&& !bb_user_authorized) then {
            cutText ["Only 1 MAIN PANEL per base in a 300 meter radius!", "PLAIN DOWN"];
            _canBuild=false;
        };
    };*/
    
    
    
    /*  if (!(_classname in bb_allowedObjects) && !bb_user_authorized && (count _panelNearest2 > 0) ) then {
        cutText ["You have to be bb_user_authorized to build this object in this base!", "PLAIN DOWN"];
        _canBuild=false;
    };*/
        
    //SOLO 9 CAMARAS
    if(_classname == "ARP_Objects_cam1") then {
        _cameraNear = nearestObjects [player, ["ARP_Objects_cam1"], baseSize];
        if(bb_state_inProgress) then {
            if(typeOf(bb_current_object) =="ARP_Objects_cam1" ) then {
                _cameraNear = _cameraNear - [bb_current_object];
            };
        };
    
        if ((count_cameraNear > 9)) then {
            cutText ["Only 9 cameras per base in a 300 meter radius!", "PLAIN DOWN"];
            _canBuild=false;
        };
    };
    
    
    //SOLO 5 PUERTAS GRANDES
    if(_classname == "Garage_Door") then {
        _garageDoors = nearestObjects [player, ["Garage_Door"], baseSize];
        if(bb_state_inProgress) then {
            if(typeOf(bb_current_object) =="Garage_Door" ) then {
                _garageDoors = _garageDoors - [bb_current_object];
            };
        };
    
        if ((count _garageDoors > 5)) then {
            cutText ["Only 5 cameras per base in a 300 meter radius!", "PLAIN DOWN"];
            _canBuild=false;
        };
    };
   
    
    //MINAS NO CERCA DE OBJETOS DE CONSTRUCCION
    if(_classname == "Grave") then {
        _buildings = nearestObjects [player, allbuildables_class, 10];
        if(bb_state_inProgress) then {
            if(typeOf(bb_current_object) =="Grave" ) then {
                _buildings =_buildings - [bb_current_object];
            };
        };
    
        if ((count _buildings > 0)) then {
            cutText ["Cannot build mines near a building (10m))", "PLAIN DOWN"];
            _canBuild=false;
        };
    };
   

    if(_classname == "KORD_high") then {
        _aaNear = nearestObjects [player, ["KORD_high"], baseSize];
        if(bb_state_inProgress) then {
            if(typeOf(bb_current_object) =="KORD_high" ) then {
                _aaNear =_aaNear - [bb_current_object];
            };
        };
    
        if ((count _aaNear > 1)) then {
            cutText ["Only 2 AA in a 200 meter radius!", "PLAIN DOWN"];
            _canBuild=false;
        };
    };
    
    //PREVENIR CONSTRUCCION DURANTE BOMBA
    _baseEnAtaque = nearestObjects [player, ["BB_Base_Under_Attack"], baseSize];
    if((count _baseEnAtaque > 1)) then {
        cutText ["You cannot build during BOMB ATTACK!!!", "PLAIN DOWN"];
        _canBuild=false;
    };

    //
    //    _helipadNear = nearestObjects [player, ["HeliHCivil"], 300];
    //if (_classname == "HeliHCivil" && (count _helipadNear > 0)) then {cutText ["Only 1 helipad per base in a 300 meter radius!", "PLAIN DOWN"];call _funcExitScript;};

    /* if(bb_admin_activated && bb_admin_free) then {
        _canBuild=true;
    };*/
    
    
    
    
    if(_canBuild) then {
        _msg = format["You can build: %1 objects more.",(baseObjectNumber - _numObjectsNear)];
        hint _msg;
        //sleep 1;
    
    };
    
    _canBuild;

};

fnc_build_hasMats = {
    _result = true;
    _chosenRecipe = _this select 0;
    
    _mags = magazines player;
    _buildables = []; // reset original buildables
    if ("ItemTankTrap" in _mags) then {
        bb_material_qty1 = {_x == "ItemTankTrap"} count magazines player;
        _buildables set [count _buildables, bb_material_qty1]; 
    } else { bb_material_qty1 = 0; _buildables set [count _buildables, bb_material_qty1]; };
		
    if ("ItemSandbag" in _mags) then {
        bb_material_qty2 = {_x == "ItemSandbag"} count magazines player;
        _buildables set [count _buildables, bb_material_qty2]; 
    } else { bb_material_qty2 = 0; _buildables set [count _buildables, bb_material_qty2]; };
	
    if ("ItemWire" in _mags) then {
        bb_material_qty3= {_x == "ItemWire"} count magazines player;
        _buildables set [count _buildables, bb_material_qty3]; 
    } else { bb_material_qty3= 0; _buildables set [count _buildables, bb_material_qty3]; };
    if ("PartWoodPile" in _mags) then {
        bb_material_qty4 = {_x == "PartWoodPile"} count magazines player;
        _buildables set [count _buildables, bb_material_qty4]; 
    } else { bb_material_qty4 = 0; _buildables set [count _buildables, bb_material_qty4]; };
	
    if ("PartGeneric" in _mags) then {
        bb_material_qty5 = {_x == "PartGeneric"} count magazines player;
        _buildables set [count _buildables, bb_material_qty5]; 
    } else { bb_material_qty5 = 0; _buildables set [count _buildables, bb_material_qty5]; };
	
    if ("HandGrenade_West" in _mags) then {
        bb_material_qty6 = {_x == "HandGrenade_West"} count magazines player;
        _buildables set [count _buildables, bb_material_qty6]; 
    } else { bb_material_qty6 = 0; _buildables set [count _buildables, bb_material_qty6]; };

    // Check if it matches again
    _result = [_buildables,_chosenRecipe] call BIS_fnc_areEqual;

    bb_haveWeapon=false;
    bb_material_weapon="";
    if(_classname in bb_building_turret ) then {
        

        _weapons = weapons player;
        {
            if ( _x in _weapons) then {
                bb_material_weapon = _x;
                bb_haveWeapon = true;
            };
        } foreach bb_machineGuns;

        if (!bb_haveWeapon) then {
            cutText ["You need a light machine gun to build this!!", "PLAIN DOWN"];
            _result = false;
        };
    };

    
    if(bb_admin_activated && bb_admin_free) then {
        _result=true;
    };

    _result;

};

fnc_build_removeMats = {
    //Remove required magazines
    if (bb_material_qty1 > 0) then {
        for "_i" from 0 to bb_material_qty1 do
        {
            player removeMagazine bb_material_1;
        };
    };
    if (bb_material_qty2 > 0) then {
        for "_i" from 0 to bb_material_qty2 do
        {
            player removeMagazine bb_material_2;
        };
    };
    if (bb_material_qty3> 0) then {
        for "_i" from 0 to bb_material_qty3 do
        {
            player removeMagazine bb_material_3;
        };
    };
    if (bb_material_qty4 > 0) then {
        for "_i" from 0 to bb_material_qty4 do
        {
            player removeMagazine bb_material_4;
        };
    };
    if (bb_material_qty5 > 0) then {
        for "_i" from 0 to bb_material_qty5 do
        {
            player removeMagazine bb_material_5;
        };
    };
    //Grenade only is needed when building booby trap
    if (bb_material_qty6 > 0 ) then {
        for "_i" from 0 to bb_material_qty6 do
        {
            player removeMagazine bb_material_6;
        };
    };
    //diag_log("Trying to remove weapon");
    if(bb_haveWeapon) then {
           
        player removeWeapon bb_material_weapon;
    };
    diag_log(format["BB: remove %1",bb_qtyT,bb_material_1]);

};

fnc_build_canDo = {
    
    _canDo = true;
    _onLadder 		=	(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
    
    // _isWater 		=(surfaceIsWater _locationPlayer) or dayz_isSwimming;
    _inVehicle 		= (vehicle player != player);
    //_canDo 	        = (!r_drag_sqf and !r_player_onLadder_unconscious and !_onLadder); //USE!!
    
    _canDo = !_onLadder and !_inVehicle;
    _canDo;
};

fnc_build_help={
    
    "Base Building controls" hintC [
    "Numpad 7 / Numpad 9 - Rotate",
    "Numpad 4 / Numpad 6 - Move Right/Left",
    "Numpad 8 / Numpad 2 - Elevate/Lower",
    "AVPAG/REPAG (PGUP/PGDN) - Push/Pull",    
    "NUM 5 - Reestablish",
    "/ - Numpad 0"
    ];
};

fnc_build_create={
    private ["_classname,_location,_modDir"];
    _classname = _this select 0;
    _location = _this select 1;
    _modDir = _this select 2;
    modDir = _modDir;
    player allowdamage false;
    
    if(_classname in bb_heightallowed) then {
        bb_state_limited=false;
    } else {
        bb_state_limited=true;
    };
    
    if(_classname == "Grave") then {
        bb_state_totallylimited=true;
    } else {
        bb_state_totallylimited=false;
    };

    bb_current_object = createVehicle [_classname, _location, [], 0, "CAN_COLLIDE"];
    //bb_current_object setDir (getDir player);
    if (_modDir > 0) then {
        bb_current_object setDir (getDir bb_current_object) + _modDir;
    };
    player allowdamage true;
    
    
};

fnc_build_delete={
    deletevehicle bb_current_object;
    
};

fnc_build_deploy ={
    
    _isDestructable = _this select 0;
            
    detach bb_current_object;
    _classname = typeOf(bb_current_object);
    _tObjectPos = getposATL bb_current_object;
    _dir = getDir bb_current_object;
    sleep 0.1;
    deletevehicle bb_current_object; 

    bb_current_object = createVehicle [_classname, _tObjectPos, [], 0, "CAN_COLLIDE"];
    bb_current_object setDir _dir;
    
    _zpos=0;
    if(bb_state_limited or bb_state_totallylimited) then {
        _zpos=0;
    } else {
        _zpos=(getposATL bb_current_object select 2);
    };
    
    
    
    bb_current_object setpos [(getposATL bb_current_object select 0),(getposATL bb_current_object select 1), _zpos];
    hint format["ZPOS: %1",_zpos];
    
    if (typeOf(bb_current_object) in ["BB_Aux_Panel","BB_Main_Panel","Satelit"] ) then {
        bb_current_object enablesimulation false;
    };
    if (!_isDestructable) then {
        bb_current_object addEventHandler ["HandleDamage", {false}];
    };
    
    
};

fnc_build_start={
    _done=false;
    // bb_current_object =_this select 0;
    if(last_building_class != typeOf(bb_current_object)) then {
        [] call fnc_build_clear;
    };
    last_building_class = typeOf(bb_current_object);
    bb_state_building=true;
    bb_current_object setVariable ["bb_object_preview",true,true];
    bb_current_object attachto [player, bb_current_attachCoords];
    bb_state_inProgress=true;
    [] call fnc_object_applyChanges;
    
    finishAction = player addAction ["Finish building!", "\BB_Buildings\code\actions\buildActions\finishBuild.sqf",bb_current_object, 1, true, true, "", ""];
    helpAction = player addAction [("<t color=""#0074E8"">" + ("Controls") +"</t>"),"\BB_Buildings\code\building\helpControls.sqf",bb_current_object, 1, true, true, "", ""];
    _done = true;
    while{bb_state_building and _done} do {
        //Comprobar que no corra.
        _vel = speed player;
        if(_vel > 11 or _vel < -8) then {
            cutText [format["You cannot run while building."], "PLAIN DOWN"];
            _done= false;
                
        };
        //Si se mete en escalera o vehiculo.
        _canDo = [] call fnc_build_canDo;
        if(!_canDo) then {
            cutText [format["You cannot do that building"], "PLAIN DOWN"];
            _done= false;
        };
        
        sleep 0.1;
        //Comprobar que no entre en coche.
        //Comprobar que no entra en agua, ciudad, carretera
    };
    
    player removeAction finishAction;
    player removeAction helpAction;
    _done;
};

fnc_build_loop = {
    _chosenRecipe = _this select 0;
            
    _built = false;
    cancelAction = player addAction [("<t color=""#F01313"">" + ("Cancel") +"</t>"), "\BB_Buildings\code\building\cancel.sqf",bb_current_object, 1, true, true, "", ""];
    acceptAction = player addAction [("<t color=""#0074E8"">" + ("Accept") +"</t>"), "\BB_Buildings\code\building\accept.sqf",bb_current_object, 1, true, true, "", ""];

    bb_state_decide=false;
    bb_state_cancel=false;
    _i=0;
    _continue=true;
    while{_continue} do {
    
     
        if(_i > 60) then {
            player removeAction acceptAction;
            player removeAction cancelAction;
            deletevehicle bb_current_object;
            cutText [format["The building expired... "], "PLAIN DOWN"];
            sleep 1;
            [] call fnc_build_finish;
            _continue= false;
        };
    
        if(bb_state_decide) then {
            player removeAction acceptAction;
            player removeAction cancelAction;
            if(bb_state_cancel) then {
                deletevehicle bb_current_object;
                cutText [format["Canceled..."], "PLAIN DOWN"];
                sleep 1;
                [] call fnc_build_finish;
            }else {
                _hasMats = [_chosenRecipe] call fnc_build_hasMats;   
                _canBuildHere = [typeOf(bb_current_object)] call fnc_build_canBuildHere;
                //cutText [format["hasmats; %1 , canbuildhere; %2 , chosenrecipe :%3 y objecto;%4 ",str _hasMats,str _canBuildHere, str _chosenRecipe,str typeOf(bb_current_object)], "PLAIN DOWN"];
                //sleep 3;
                if(_hasMats && _canBuildHere ) then {
                    if(_classname in bb_allowed_attach) then {
                        bb_current_object addAction ["Attach to vehicle", "\BB_Buildings\code\building\attach\attachToVehicle.sqf", bb_current_object, 1, false, true,"", ""];
                    };
                    
                    bb_current_object setVariable["ClanID",clanTag,true];
                    cutText [format["Object built!!"], "PLAIN DOWN"];
                    // bb_base_cameras set [count bb_base_cameras, bb_current_object];
                    //Clear
                    _built=true;

                } else {
                    //Duper del carallo hizo algo raro.
                    cutText [format["You changed the materials or went to ilegal position, ADMIN WILL BE NOTIFIED"], "PLAIN DOWN"];
                };
                // [] call fnc_build_finish; 
                 
                            
            
            };
            _continue= false;
        };
    
        _i=_i+1;
        sleep 0.5;
    };

    _built;
};

fnc_build_create_menu = {
    elevateAction = player addAction ["Elevate", "\BB_Buildings\code\actions\buildActions\elevateObject.sqf",bb_current_object, 1, true, true, "", ""];
    lowerAction = player addAction ["Lower", "\BB_Buildings\code\actions\buildActions\lowerObject.sqf",bb_current_object, 1, true, true, "", ""];
    rotateAction = player addAction ["Rotate", "\BB_Buildings\code\actions\buildActions\rotateObject.sqf",bb_current_object, 1, true, true, "", ""];
    rotateAction2= player addAction ["Rotate inverse", "\BB_Buildings\code\actions\buildActions\rotateObjectInverse.sqf",bb_current_object, 1, true, true, "", ""];
    objectAwayAction = player addAction ["Push away", "\BB_Buildings\code\actions\buildActions\pushObject.sqf",bb_current_object, 1, true, true, "", ""];
    objectNearAction = player addAction ["Pull near", "\BB_Buildings\code\actions\buildActions\pullObject.sqf",bb_current_object, 1, true, true, "", ""];
    objectRightAction = player addAction ["Move left", "\BB_Buildings\code\actions\buildActions\rightObject.sqf",bb_current_object, 1, true, true, "", ""];
    objectLeftAction = player addAction ["Move right", "\BB_Buildings\code\actions\buildActions\leftObject.sqf",bb_current_object, 1, true, true, "", ""];
    restablishAction = player addAction ["Restablish", "\BB_Buildings\code\actions\buildActions\restablishObject.sqf",bb_current_object, 1, true, true, "", ""];
    attachGroundAction = player addAction["Attach to ground", "\BB_Buildings\code\actions\buildActions\attachGroundObject.sqf",bb_current_object, 1, true, true, "", ""];

};

fnc_build_delete_menu = {
    player removeAction attachGroundAction;
    player removeAction elevateAction;
    player removeAction lowerAction;			
    player removeAction rotateAction;
    player removeAction rotateAction2;	
    player removeAction objectAwayAction;
    player removeAction objectNearAction;
    player removeAction objectRightAction;
    player removeAction objectLeftAction;
    player removeAction restablishAction;

};

fnc_build_saveDB ={
    _object = bb_current_object;
    // Send to database
    // Send to database
    //HAY QUE EXPERIMENTAR CON LOS GET POS
    _dir = getDir _object;
    _location = getPosATL _object;
    
    _uid= (getPlayerUID vehicle player);
    //_object setVariable ["characterID",dayz_characterID,true];
    //dayzPublishObj = [dayz_characterID,_object,[_dir,_location],_classname,clanTag];
    
    _object setVariable ["characterID",_uid,true];
    dayzPublishObj = [_uid,_object,[_dir,_location],_classname,clanTag];
    
    publicVariableServer "dayzPublishObj";
    if (isServer) then {
        dayzPublishObj call server_publishObj;
    };
       
};

fnc_build_clear={
    rotateDir = 0;
    objectHeight=0;
    objectDistance=0;
    objectParallelDistance=0;  
};

fnc_build_finish={
    bb_state_building=false;
    bb_current_object=objNull;
    bb_current_attachCoords=[];
    bb_current_object setVariable ["bb_object_preview",false];
    bb_state_inProgress=false;
    
    bb_material_qty1=0;
    bb_material_qty2=0;
    bb_material_qty3=0;
    bb_material_qty4=0;
    bb_material_qty5=0;
    bb_material_qty6=0;
};


fnc_object_rotate_left = { 
    
    
    rotateDir = rotateDir + rotateIncrement;
    if(rotateDir >= 360) then {
        rotateDir = 0;
    };
    [] call fnc_object_applyChanges;
};

fnc_object_rotate_right = {
    
        
    rotateDir = rotateDir - rotateIncrement;
    if(rotateDir <= 0) then {
        rotateDir = 360;
    };
    [] call fnc_object_applyChanges;
};

fnc_object_elevate ={
    if(objectHeight<objectTopHeight) then {
        objectHeight= objectHeight + objectIncrement;
    };
    [] call fnc_object_applyChanges;
};
fnc_object_lower={
    if(objectHeight>objectLowHeight) then {
        objectHeight= objectHeight - objectIncrement;
    };
    [] call fnc_object_applyChanges;
};
fnc_object_move_left={
    if(objectParallelDistance>minObjectDistance) then {
        objectParallelDistance= objectParallelDistance - 0.1;
    };
    [] call fnc_object_applyChanges;
};
fnc_object_move_right={
    
    if(objectParallelDistance<maxObjectDistance) then {
        objectParallelDistance= objectParallelDistance + 0.1;
    };
    [] call fnc_object_applyChanges;
};
fnc_object_push={
    
    if(objectDistance<maxObjectDistance) then {
        objectDistance= objectDistance + 0.1;
    };
    [] call fnc_object_applyChanges;
};

fnc_object_pull={
    
    if(objectDistance>minObjectDistance) then {
        objectDistance= objectDistance - 0.1;
    };
    [] call fnc_object_applyChanges;
};

fnc_object_applyChanges={
    
    _newAttachCoords = [(objectParallelDistance+(bb_current_attachCoords select 0)),(objectDistance + (bb_current_attachCoords select 1)),(objectHeight + (bb_current_attachCoords select 2))];
    bb_current_object attachto [player, _newAttachCoords];
    bb_current_object setDir rotateDir + modDir;/* (getDir bb_current_object) + *///rotateDir;
};

fnc_object_restablish = {

    rotateDir = 0;
    objectHeight=0;
    objectDistance=0;
    objectParallelDistance=0;  
    [] call fnc_object_applyChanges;
};

fnc_object_attachToGround = {
    objectHeight=0;
    bb_current_object setpos [(getposATL _object select 0),(getposATL _object select 1), 0];
    [] call fnc_object_applyChanges;
};

fnc_getBuildableByClass = {
    _classname = _this select 0;
    i=0;
    _index=-1;
    _return=[];
    {

        if(_x == _classname) then{
            _index=i;
        };
        i=i+1;
    }foreach allbuildables_class;
    
    if(_index >=0) then {
        _return=allbuildables select _index;
    };
    
    _return;
    
};


fnc_is_player_near = {
    _loc = _this select 0;
    _isPlayerNear = false;
    
    _otherPlayers = nearestObjects [_loc, "CAManBase", 10];
 
    {
        if( !(alive _x) or (_x isKindof "zZombie_Base") or !(isplayer _x)) then  {
            _otherPlayers = _otherPlayers - [_x];
        };
    } foreach _otherPlayers;
    if(count _otherPlayers > 1) then {
        _isPlayerNear = true;
    };

    _isPlayerNear;
};
diag_log("BB: Build funcions loaded");