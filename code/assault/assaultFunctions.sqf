bomb_radious=300;
bombTruckActive=false;
truckExploded=false;
bb_assault_toxic_gas=false;
bb_base_radious=300;
bb_bomb_activators=["BB_Flag_Pole","Small_Door","Medium_Door","Garage_Door"];
fnc_open_hangar_doors = {

    _hangar = _this select 0;
    
    _hangar setVariable["bb_assaulted",true,true];
    _hangar animate ["dvere1", 1];
    _hangar animate ["dvere2", 1];
    _hangar animate ["vrata1", 1];
    _hangar animate ["vrata2", 1];
    
    
};

fnc_truck_open_doors = {
    _loc = _this select 0;
    _radious = _this select 1;
    
    //_location = getpos _truck;
    _doorsNearby = nearestObjects  [_loc, ["Small_Door","Medium_Door","Garage_Door","e9","Land_Ind_Shed_01_main","BB_Hangar"],_radious ];
    
    {
    
            if(typeOf(_x) == "BB_Hangar") then {
                
                [_x] call fnc_open_hangar_doors;
            
            } else {
                deletevehicle _x;
            };
            
            
        //_nic = [nil, _x, "per", rHideObject, true] call RE;
    } foreach _doorsNearby;
    
    

};

getOwnersInBase = {
     
    _location = _this select 0;
    _baseRadio = 300;
    _truckRadio = 310;

    //Buscamos base
    //cutText [format["Looking for owners..."], "PLAIN DOWN"];
    _owners=[];
    _panelsNearby=[];
    _panelsNearby = nearestObjects [_location , bb_bomb_activators,_truckRadio];
    if ( count _panelsNearby >0 ) then {
        //Mirar si hay gente
        _playerNearby=[];
        _playerNearby = nearestObjects  [_location, ["CAManBase"],_baseRadio ];
      
       
        _baseClan= (_panelsNearby select 0) getVariable ["ClanID","0"];
        // cutText [format["There are %1 players in base of %1",str(_playerNearby),str(_baseClan)], "PLAIN DOWN"];
        if(count _playerNearby > 0) then {
          
            {
                _playerClan = _x getVariable["clanTag","0"];
                //_playerIDClan= (vehicle _x) getVariable ["clanTag","0"];
                //     _playerClan =  (clanTag != "0") && (_playerIDClan != "0") && (clanTag == _playerIDClan);
                //     cutText [format["%1:%1",str(_x),str(_playerClan)], "PLAIN DOWN"];
                if( (_playerClan != "0") && (_baseClan!="0") && (alive _x) && (_playerClan== _baseClan))then  {
                    //Miembro en base, sumamos
                    _owners set [count _owners, _x];
                };
            } foreach _playerNearby;
        };  
        _vehicleNearby=[];
        _vehicleNearby = nearestObjects [_location, ["AllVehicles"],_baseRadio];
        if(count _vehicleNearby > 0) then {
            {
                _crew = crew _x;
                if(count _crew > 0) then {
                    {
                        _playerClan = _x getVariable["clanTag","0"];
                        if( (_playerClan != "0") && (_baseClan!="0") && (alive _x) && (_playerClan== _baseClan))then  {
                            //Miembro en base, sumamos
                            _owners set [count _owners, _x];
                        };
                    } foreach _crew;
                };
           
            } foreach _vehicleNearby;
       
        };
        
    }; 
    _owners;
};

canAttackHere = {
    _numOwnersRequired=1;    
    
    _location= _this select 0;
    _canAttack=false;
    _owners = [];
    cutText [format["Lets see if we can plant bomb..."], "PLAIN DOWN"];
    sleep 1;
    _owners = [_location] call getOwnersInBase;
    _numOwners = count _owners;
    cutText [format["There are %1 players in base of %2",str(_numOwners),str(_numOwnersRequired)], "PLAIN DOWN"];
    sleep 1;
    if(_numOwners  >= _numOwnersRequired) then {
    
        _canAttack=true;

    } else {
        _canAttack=false;
    };

    _canAttack;
};

plantBomb = {
    
    private ["_location"];
    _truck = _this select 0;
    cutText [format["Bomb planted, 30 seconds to explosion"], "PLAIN DOWN"];
    sleep 30;
    _location =getPos _truck;
    
    if(damage _truck ==1) then {
        truckExploded=false;
        cutText [format["Truck was busted!!"], "PLAIN DOWN"];
    } else {
        truckExploded=true;
        _detonate = "grenade" createVehicle _location;
        _detonate = "grenade" createVehicle _location;
        _detonate = "grenade" createVehicle _location;
        _detonate = "grenade" createVehicle _location;
        _detonate = "grenade" createVehicle _location;
        _detonate = "grenade" createVehicle _location;
        _detonate = "grenade" createVehicle _location;
        _detonate = "grenade" createVehicle _location;
        _detonate = "grenade" createVehicle _location;
        _detonate = "grenade" createVehicle _location;
        
    };
    //Explode 10 grenades
    
    
    
};

plantBombTruckAndOpen = {
    private ["_location","_truck","_canAttack"];
    //cutText [format["Trying to setup bomb..."], "PLAIN DOWN"];
    
    _truck = _this select 0;
    
    _location =getPos _truck;

    if(!bombTruckActive) then {
        bombTruckActive=true;
        _canAttack = false;
        
        _canAttack = [_location] call canAttackHere;
        [_truck] call plantBomb;
       
        _truck setDamage 1;

        if(_canAttack && truckExploded) then {
            //Open Doors
            //[_location,bomb_radious] call fnc_operate_all_doors;
            //cutText [format["You have 30 minutes to loot this base"], "PLAIN DOWN"];
            // sleep 1800;
            [_location,bomb_radious] call fnc_truck_open_doors;
            
            //Crear objeto invisible que indica que la base esta abierta
            
            "BB_Base_Under_Attack" createVehicle _location;
           
        };
      
       
        deleteVehicle _truck;
      
        bombTruckActive=false;
        truckExploded=false;
    } else {
        cutText [format["The truck is already active."], "PLAIN DOWN"];
    };
};


bb_gas_barrel = "Land_Barrel_sand";

fnc_assault_explode_gas = {
    _panel = _this select 0;
        
    _location = getpos _panel;
    _gasBarrels = nearestObjects [_location, ["Land_Barrel_sand"],bb_base_radious];
    if(bb_assault_toxic_gas) exitWith {cutText [format["Already activated"], "PLAIN DOWN"];};
        
    bb_assault_toxic_gas = true;
        
    _starttime=time;
    diag_log(format["BB: Toxic gas started at: %1",_starttime]);
        
        
    cutText [format["Gas barrel exploded"], "PLAIN DOWN"];
    {
        _pos = getpos _x;
        deletevehicle _x;
        [_pos] spawn fnc_assault_toxic_gas;
            
    } foreach _gasBarrels;
        
    _currenttime = time;
    while{_currenttime < _starttime +300} do {
            
        _currenttime = time;
        sleep 1;
    };
        
    bb_assault_toxic_gas = false;
    diag_log(format["BB: Toxic gas ended at: %1",_currenttime]);
};

fnc_assault_toxic_gas = {
    _loc = _this select 0;
    [_loc] spawn fnc_assault_kill_gassed;
    
    while{bb_assault_toxic_gas} do {
        "SmokeShellGreen" createVehicle _loc;   
        sleep 25;
    };
};

fnc_assault_kill_gassed = {
    _loc = _this select 0;
    while{bb_assault_toxic_gas} do {
        _nearestPlayers = nearestObjects[_loc, ["CAManBase"], 30];
        {
            _weaps = weapons _x;
            _haveMask = "EB_S10" in _weaps;
             
            if(!_haveMask) then {
                 _x setDammage ( (getDammage _x) +0.1);
            };
         
        } foreach _nearestPlayers;
        sleep 0.3;
    };
};