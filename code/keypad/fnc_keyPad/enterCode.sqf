//addaction sends [target, caller, ID, (arguments)]
private ["_displayok","_lever","_objIDClan","_esMC"];
//_id = _this select 2;
//_lever removeAction _id;
diag_log(str(_this));
_args=_this select 3;
enterCodeAction = _args select 0;
_lever = cursortarget;
//_dir = direction _lever;
//_pos = getPosATL _lever;
//_uid 	= [_dir,_pos] call dayz_objectUID2;
_operacion=_args select 0;
_esMC=false;
_panel=cursortarget;
if(_operacion=="operateGate" || _operacion=="operateDoor") then {
    _objIDClan= _panel getVariable ["ClanID","0"];
    diag_log("validacion puertas automaticas clanObj:"+_objIDClan + " clantag:"+ clanTag);
    _esMC=(clanTag != "0") && (_objIDClan != "0") && (clanTag == _objIDClan);
    
};

//Si no es del mismo clan que el propietario que ponga la key
if(!_esMC) then {
    keyCode = cursortarget getVariable ["ObjectUID","0"];     
    _displayok = createdialog "KeypadGate";
    //de lo contrario le abrimos el acceso ;)
}else{
    switch (enterCodeAction) do 
    { 
        case "operateDoor": {           
            cutText ["### ACCESS GRANTED ###", "PLAIN DOWN"];
            playsound "beep";
            sleep 0.5;
            playsound "beep";
            sleep 0.5;
            playsound "beep";
            doorkeyValid = true;
            _gateAccess = true;
            
            cutText ["You have 30 seconds to look to the door to get the action.", "PLAIN DOWN"];
            sleep 30;
            /*while {_gateAccess} do 
            {
                _playerPos = getpos player;
                _panelPos = getpos _panel;               
                if (_playerPos distance _panelPos > baseSize) then {
                    _gateAccess = false;
                    keyValid = false;
                    doorkeyValid=false;
                    cutText [ format["Lost connection to panel > %1 meters away", baseSize], "PLAIN DOWN"];
                };
                sleep 3;
            };	*/         
            doorkeyValid=false;
        }; 
        case "operateGate": {            
            cutText ["### ACCESS GRANTED ###", "PLAIN DOWN"];
            playsound "beep";
            sleep 0.5;
            playsound "beep";
            sleep 0.5;
            playsound "beep";
            keyValid = true;
            _gateAccess = true;
            cutText ["You have 30 seconds to look to the panel to get the action.", "PLAIN DOWN"];
            sleep 30;
           /* while {_gateAccess} do 
            {
                _playerPos = getpos player;
                _panelPos = getpos _panel;
                //_inVehicle = (vehicle player != player);
                if (_playerPos distance _panelPos > 150) then {
                    _gateAccess = false;
                    keyValid = false;
                    doorkeyValid=false;
                    cutText ["Lost connection to panel > 150 meters away", "PLAIN DOWN"];
                };
                _cnt = _cnt - 1;
                // if (_cnt == 600 || _cnt == 590 || _cnt == 580 || _cnt == 570 || _cnt == 560 || _cnt == 550 || _cnt == 540 || _cnt == 530 || _cnt == 520 || _cnt == 510 || _cnt == 500 || _cnt == 490 || _cnt == 480 || _cnt == 470 || _cnt == 460 || _cnt == 450 || _cnt == 440 || _cnt == 430 || _cnt == 420 || _cnt == 410 || _cnt == 400 || _cnt == 390 || _cnt == 380 || _cnt == 370 || _cnt == 360 || _cnt == 350 || _cnt == 340 || _cnt == 330 || _cnt == 320 || _cnt == 310 || _cnt == 300 || _cnt == 290 || _cnt == 280 || _cnt == 270 || _cnt == 260 || _cnt == 250 || _cnt == 240 || _cnt == 230 || _cnt == 220 || _cnt == 210 || _cnt == 200 || _cnt == 190 || _cnt == 180 || _cnt == 170 || _cnt == 160 || _cnt == 150 || _cnt == 140 || _cnt == 130 || _cnt == 120 || _cnt == 110 || _cnt == 100 || _cnt == 90 || _cnt == 80 || _cnt == 70 || _cnt == 60 || _cnt == 50 || _cnt == 40 || _cnt == 30 || _cnt == 20 || _cnt == 10 || _cnt == 0) then {
                // cutText [format["Access to panel expires in %1 seconds",(_cnt / 10)], "PLAIN DOWN",1];
                // };	
                if (_cnt <= 0) then {
                    _gateAccess = false;
                    keyValid = false;
                    doorkeyValid=false;
                    cutText ["You no longer have gate access, type code in again to have access", "PLAIN DOWN"];
                    {dayz_myCursorTarget removeAction _x} forEach s_player_gateActions;s_player_gateActions = [];
                };
                sleep .1;
            };*/
            keyValid = false;        
        }; 
    }; 
};
