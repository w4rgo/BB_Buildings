fnc_get_freeslotsM = {
    
    private ["_tent","_freeslots","_class","_maxMagazines","_magazineCount_raw","_magazineCount"];
    _tent = _this select 0;
    _freeslots = 0;
    
    _class = typeOf _tent;
    
    // Get max magazines count
    _maxMagazines =    getNumber (configFile >> "CfgVehicles" >> _class >> "transportMaxMagazines");
    _magazineCount_raw = getMagazineCargo _tent;
    // Count and show magazines available space
    _magazineCount = (_magazineCount_raw select 1) call vehicle_gear_count;
      
    _freeslots = _maxMagazines - _magazineCount;  
    _freeslots;
      
};

fnc_get_freeslotsB = {
    
    private ["_tent","_freeslots","_class","_maxBackpacks","_backpackCount_raw","_backpackCount"];
    _tent = _this select 0;
    _freeslots = 0;
    
    _class = typeOf _tent;
    // Get max backpack count
    _maxBackpacks =    getNumber (configFile >> "CfgVehicles" >> _class >> "transportmaxbackpacks");
    // Count and show backpacks available space
    _backpackCount_raw = getBackpackCargo _tent;
    
    // Count and show weapons available space
    _backpackCount = (_backpackCount_raw select 1) call vehicle_gear_count;
    _freeslots = _maxBackpacks - _backpackCount;  
    _freeslots;
};

fnc_get_freeslotsW = {
    
    private ["_tent","_freeslots","_class","_weaponsCount_raw","_maxWeapons","_weaponsCount"];
    _tent = _this select 0;
    _freeslots = 0;
    _class = typeOf _tent;
    // Count and show weapons available space
    _weaponsCount_raw = getWeaponCargo _tent;
    // Get max weapon count
    _maxWeapons =    getNumber (configFile >> "CfgVehicles" >> _class >> "transportMaxWeapons");
    // Count and show weapons available space
    _weaponsCount = (_weaponsCount_raw select 1) call vehicle_gear_count;

    _freeslots = _maxWeapons - _weaponsCount;  
    _freeslots;
};

fnc_dump_backpack = {
    
    private ["_qty","_i","_backpack","_tent","_magazineCount_raw","_magClass","_magQty","_weaponsCount_raw","_weapClass","_weapQty","_backpackCount_raw","_backClass","_backQty","_freeSlotsM","_freeSlotsW","_freeSlotsB"];
    _backpack= _this select 0;
    _tent = _this select 1;
    //_bag = unitBackpack player;
    
    // Count and show magazines available space
    _magazineCount_raw = getMagazineCargo _backpack;
    _magClass=_magazineCount_raw select 0;
    _magQty=_magazineCount_raw select 1;
    // Count and show weapons available space
    _weaponsCount_raw = getWeaponCargo _backpack;
    _weapClass=_weaponsCount_raw select 0;
    _weapQty=_weaponsCount_raw select 1;
    // Count and show backpacks available space
    _backpackCount_raw = getBackpackCargo _backpack;
    _backClass=_backpackCount_raw select 0;
    _backQty=_backpackCount_raw select 1;
    
    _freeSlotsM = [_tent] call fnc_get_freeslotsM;
    _freeSlotsW = [_tent] call fnc_get_freeslotsW;
    _freeSlotsB = [_tent] call fnc_get_freeslotsB;
    
    _backpackCount = (_magazineCount_raw select 1) call vehicle_gear_count;
    
    _weaponCount = (_magazineCount_raw select 1) call vehicle_gear_count;
    
    _magazineCount = (_magazineCount_raw select 1) call vehicle_gear_count;
    
    if(_freeSlotsM >= _magazineCount  ) then {
        clearMagazineCargoGlobal _bag ;
        _i = 0;        
        {
            _qty = _magQty select _i;
            _tent addMagazineCargoGlobal [_x,_qty];
            _i = _i +1;
            
        } foreach _magClass;
    };
    
    if(_freeSlotsW >= _weaponCount) then {
        clearWeaponCargoGlobal _bag ;
        _i = 0;        
        {
            _qty = _weapQty select _i;
            _tent addWeaponCargoGlobal [_x,_qty];
            
           
            _i = _i +1;
            
        } foreach _weapClass;
        
    };
    
    if(_freeSlotsB >= _backpackCount) then {
        clearBackpackCargoGlobal _bag ;
        _i = 0;        
        {
            _qty = _backQty select _i;
            _tent addBackpackCargoGlobal [_x,_qty];
            _i = _i +1;
            
        } foreach _backClass;
    };


    
};

fnc_toggle_fps_fix ={

    if(bb_fps_fix) then {
        hint "FPS FIX DEACTIVATED! Actions should work again";
        bb_fps_fix=false;
    } else {
        bb_fps_fix=true;
        hint "FPS FIX ACTIVATED! No Actions";
    };
    

};

fnc_show_player_clan = {

    _current_players_clan = [];
    {
        if(isplayer _x && alive _x && _x != player) then {
    
            _playerClan="";
            _playerClan = format["%1 - %2",_x getVariable["clanTag","0"] ,name(_x)];
            _current_players_clan set [count _current_players_clan, _playerClan];
        };
    

    } foreach playableUnits;
    
    "Clan - Player name" hintC _current_players_clan;
    
        

};