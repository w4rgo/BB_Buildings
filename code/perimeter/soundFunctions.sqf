bb_song_oncourse=objNull;
bb_song_activated=false;




//Checkea si hay una cancion sonando.
fnc_check_song = {
    _p = _this select 0;
    
    
    _cancionSonando= false;
    _canciones = nearestObjects [getPos _p, ["BB_Song_Oncourse"], 300];
    _cancionSonando = count _canciones > 0;
    if(_cancionSonando) then {
        bb_song_oncourse = _canciones select 0;
    };
    _cancionSonando;
};

fnc_song_stop = {
   _panel = _this select 0;
   
    _sonando = [_panel] call fnc_check_song;
    if(bb_song_activated or _sonando ) then {
        cutText [format["Song stopped!!!"], "PLAIN DOWN",1];
        bb_song_activated=false;
        
        
        
        deletevehicle bb_song_oncourse;
        bb_song_oncourse=objNull;
    };
};

fnc_song_start = {
    _panel = _this select 0;
    _song = _this select 1;

    _sonando = [_panel] call fnc_check_song;
     
    if(!bb_song_activated or _sonando) then {
        _nearestLoudspeakers = nearestObject [_panel, "Loudspeakers_EP1"];
        if(_nearestLoudspeakers != objNull) then {

            bb_song_activated = true;
            bb_song_oncourse = "BB_Song_Oncourse" createVehicle getpos _nearestLoudspeakers;
            [nil,bb_song_oncourse,rSAY,[_song,10,1]] call RE;
            
        };   

    } else {
        cutText [format["Only one song at time!!"], "PLAIN DOWN",1];
    };
};