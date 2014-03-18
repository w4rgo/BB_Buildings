radarObject = "Satelit";
mineObject = "Grave";
_panel= _this select 0;
_classname = typeOf _panel;

//VARS

_radarRadio = 30;
_panelRadio = 200;
_numRadars=0;
_knownZombos = ["Bronislav Brazda","Jaromir Martinek","Jaroslav Rybski",
"Marian Peterka","Daniel Nobski","Vadim Smolik",
"Vladimir Valenta","Daniel Nobski","Andrej Rybski",
"Viktor Novak","Nikola Hanak","Stanislav Skala","Filip Konopnik","Igor Kvapil","Boris Kulhanek","Andrej Brazda"
,"Viktor Hlinik","Daniel Antonov","Filip Hajek","Radim Grygar","Daniel Nedbal","Lukas Nobski"];
_radarsNearMe = [];

inIntruders = {
    _intruder = _this select 0;
    _isIn=false;
    {
        if( _intruder in _x) then {
            _isIn=true;
            
        };
    } foreach _intruders;
    _isIn;
};

checkIntruders ={
    _intruders = [];
    _panel = _this select 0;
    _radars = nearestObjects [_panel, [radarObject], 200];
    _radarsNearMe = [];
    _radarNum = 1;
    {
        _playerNearby = nearestObjects [getPos _x, ["AllVehicles","CAManBase"], _radarRadio];
        //sleep 1;hint "1";
        _numIntruders = count _playerNearby;
        //sleep 1;hint "2";
        _radarName = "R"+str(_radarNum);
        //sleep 1;hint "3";
        // hint format["%1",_numIntruders];
            
        if(_numIntruders >= 1) then {
            {
                if(_x isKindOf "CAManBase") then {
                        
                    _userId = (getPlayerUID vehicle _x);
                    //&& !(_x in _knownZombos)
                    //&& (_userID !="")
                    _alreadyIntruder= [_x] call inIntruders;
                    if(_x == player) then {
                        _radarsNearMe set [count _radarsNearMe , _radarName];
                    };
                    _playerIDClan= (vehicle _x) getVariable ["clanTag","0"];
                    _playerClan =  (clanTag != "0") && (_playerIDClan != "0") && (clanTag == _playerIDClan);
                    _nombreX= name _x;
                    if(_playerClan && !(_nombreX in baseMembers)) then {
                        baseMembers set [count baseMembers,_nombreX];
                    };
                    //&& (_userID !="")
                    if(!(_alreadyIntruder)&& (_userID !="")  && !(_nombreX in baseMembers) && (_nombreX != "Error: No unit") && (_nombreX != "Error: No vehicle")) then {
                        _intruders set [count _intruders,[_x,_radarName]];
                    };
                    
                } else {
                    //Vehicle
                    _crew = crew _x;
                    if(count _crew > 0) then {
                        {
                            _playerIDClan= _x getVariable ["clanTag","0"];
                            _playerClan =  (clanTag != "0") && (_playerIDClan != "0") && (clanTag == _playerIDClan);
                            _alreadyIntruder= [_x] call inIntruders;
                            _nombreX= name _x;
                            if(_playerClan && !(_nombreX in baseMembers)) then {
                                baseMembers set [count baseMembers,_nombreX];
                            };
                            if(!(_alreadyIntruder)&& (_userID !="")  && !(_nombreX in baseMembers) && (_nombreX != "Error: No unit") && (_nombreX != "Error: No vehicle")) then {
                                _intruders set [count _intruders,[_x,_radarName]];
                            };
                        } foreach _crew;
                    };
                    
                };
            } foreach _playerNearby;
            //hint str(_radarName);
            _radarNum = _radarNum +1;
        };
    } foreach _radars;
    _numRadars = count _radars;
    _intruders;
};

 
getRadars = {
    _radars = [];
    _panel = _this select 0;
    _radars = nearestObjects [_panel, [radarObject], 200];
    _numRadars = count _radars;
    _radars;
}; 
getMines = {
    _mines = [];
    _panel = _this select 0;
    _mines = nearestObjects [_panel, [mineObject], 200];
    _numMines = count _mines;
    _mines;
}; 
markMinesInMap = {
    _radars = _this select 0;
    _color = _this select 1;
    _minesNum = 1;
    _markers = [];
    {
        
        _markername = "playerMarker" + (str markernum);
        _marker = createMarkerLocal [_markername,position _x];        
        _marker setMarkerTypeLocal "warning";
        _marker setMarkerPosLocal ( position _x );
        _marker setMarkerColorLocal(_color);
        _marker setMarkerTextLocal format ["M%1", str(_radarNum)];

        _markers set [count _markers, _markername];
        markernum = markernum +1;
        _minesNum = _minesNum +1;
    } foreach _mines;
    _markers;
};


markIntrudersInMap ={
    _intruders = (_this select 0);
    _color = _this select 1;
    _markers = [];
    {
        //hint format["Intruder: %1" ,(name _x) ];
        _markername = (name (_x select 0));//"playerMarker" + (str _markernum);
        _marker = createMarkerLocal [_markername,position (_x select 0)];        
        _marker setMarkerTypeLocal "dot";
        _marker setMarkerPosLocal ( position (_x select 0) );
        _marker setMarkerColorLocal(_color);
        if((name (_x select 0))=="Error: No unit") then {
            _marker setMarkerTextLocal format ["%1", "RADAR"];
        } else {
            _marker setMarkerTextLocal format ["%1", "Intruder"/*name (_x select 0)*/];
        };
       
        _markers set [count _markers, _markername];
       
    } foreach _intruders;
    _markers;
};
markernum= 0;
markRadarsInMap ={
    _radars = _this select 0;
    _color = _this select 1;
    _radarNum = 1;
    _markers = [];
    {
        
        _markername = "playerMarker" + (str markernum);
        _marker = createMarkerLocal [_markername,position _x];        
        _marker setMarkerTypeLocal "dot";
        _marker setMarkerPosLocal ( position _x );
        _marker setMarkerColorLocal(_color);
        _marker setMarkerTextLocal format ["R%1", str(_radarNum)];

        //_markers set [count _markers, _markername];
        markernum = markernum +1;
        _radarNum = _radarNum +1;
    } foreach _radars;
    _markers;
};

startAlarms ={
    _panel = _this select 0;
    _startedAlarms = [];
    _nearestLoudspeakers = nearestObjects [_panel, ["Loudspeakers_EP1"],_panelRadio];
    {
        _soundOn = createSoundSource ["Sound_Alarm2",getPos _x , [], 0];
        _startedAlarms set [count _startedAlarms, _soundOn];
    }foreach _nearestLoudspeakers;
    _startedAlarms;
};

clearMarkers = {
    _markers = _this select 0;
    {
        deleteMarkerLocal _x ;
    } foreach _markers;
};

printIntruders = {
    _intruders = _this select 0;
    _radarsNear = "";
    {
        _radarsNear = _radarsNear + _x +" ";
    } foreach _radarsNearMe;
    // _radarsNear = _radarsNear - " ";
    
    _print = "<t size='1' font='Bitstream' align='center'color='#FF0000' >Alarm!! Intruders:</t><br />";
    {
        //_userId = (getPlayerUID vehicle _x);
        _dis = player distance (_x select 0);
        _name = "Intruder";//name (_x select 0);
        _radarName = _x select 1;
        _print = _print + _name +" : "+_radarName+" : "+ (str(round(_dis)))+ "m<br />";
    } foreach _intruders;
    
    
    //DEBUG
    _print = _print + "<t size='1' font='Bitstream' align='center'color='#FF0000' >Radars: "+ (str _numRadars)+" : " +_radarsNear +"</t><br />";
    _print = _print + "<t size='1' font='Bitstream' align='center'color='#FF0000' >Base Members</t><br />";
    {
        _print = _print + (_x) + "<br />";
    } foreach baseMembers;
    _print = _print + "<t size='1' font='Bitstream' align='center'color='#FF0000' >Alarm system by w4rgo</t><br />";
    hintSilent parseText format[_print];
};

stopAlarms = {
    _startedAlarms = _this select 0;
    {
        deletevehicle _x;
    }foreach _startedAlarms; 
};

_intrudersDet=false;
alarmOn=false;
_alarms = [];
_markers = [];
_control = 0 ; 

//mark the radars in the map.
_radars = [_panel] call getRadars ;
_radarmarkers = [_radars, "ColorRed"] call markRadarsInMap;

_mines = [_panel] call getMines ;
_minesmarkers = [_mines, "ColorRed"] call markMinesInMap;


while{perimeterActivated} do {
   
    _intruders= [_panel] call checkIntruders ;
    _num = count _intruders;
    
    
    if(_num >=1) then {
        if (soundAlarm && !alarmOn) then {
            _alarms =[_panel] call startAlarms;
            alarmOn=true;
        };
        _intrudersDet = true;
    } else {
        _intrudersDet = false;
    };

    if(!_intrudersDet) then {
        if(alarmOn)then {
            _null =[_alarms] call stopAlarms;
            
            alarmOn=false;
        };//Stop alarm
    } else {
        _null = [_markers] call clearMarkers;
        _markers = [_intruders, "ColorBlack"] call markIntrudersInMap;
    };

    _null = [_intruders] call printIntruders;
    sleep 2;
    
    
    
    if(!soundAlarm) then {
        _null =[_alarms] call stopAlarms;
    };
};

_null =[_alarms] call stopAlarms;
_null = [_markers] call clearMarkers;
_alarmOn=false;
cutText [format["The alarm system was stoped."], "PLAIN DOWN",1];
sleep 1;

