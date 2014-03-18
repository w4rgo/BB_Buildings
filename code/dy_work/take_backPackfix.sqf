private["_cnt","_playerClosest","_playerNearby","_item"];
_cnt = 0;
while {alive player} do {
        while {(cursortarget isKindOf "DZ_CivilBackpack_EP1" ||  
        cursortarget isKindOf "DZ_Patrol_Pack_EP1" ||
        cursortarget isKindOf "DZ_Assault_Pack_EP1" ||
        cursortarget isKindOf "DZ_ALICE_Pack_EP1" ||
        cursortarget isKindOf "DZ_Backpack_EP1"
    )} do {
        _playerNearby = nearestObjects [player, ["CAManBase"], 10];
                
                
                
        if (player in _playerNearby) then {
            _playerNearby set [0, player]; 
            _playerNearby = _playerNearby - [player];
        };
                
        {
            if( !(alive _x) or (_x isKindof "zZombie_Base") or !(isplayer _x)) then  {
                _playerNearby = _playerNearby - [_x];
            };
        } foreach _playerNearby;
                
        //if (animationstate player == "amovppnemstpsraswrfldnon") then {player playActionNow "PutDown";} else {
        _item = cursortarget;
	if (player distance _item < 8) then {
            for "_i" from 0 to ((count _playerNearby) - 1) do
            {
                _playerClosest = _playerNearby select _i;
                if (!(isNull _playerClosest)) then {
                    if (_playerClosest distance player < 6 ) then {
                        if (IsNull (FindDisplay 106)) then {
                            createGearDialog [player, "RscDisplayGear"];
                            cutText ["Players must be farther than 6 meters\nand not looking at backpack in order to pick up backpack", "PLAIN DOWN"];
                        };
                    };
                };
            };								
	};
        //};
        sleep .01;
    };
    sleep .03;
};