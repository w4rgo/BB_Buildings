fnc_admin_actions= {

        _target = cursortarget;       
        _userId = (getPlayerUID vehicle player);
        _isAdmin = ((_userId) in baseAdmins);
        
        
        if(_isAdmin && bb_admin_activated) then {
            //ADMIN CHECK
            if (_isAdmin ) then {
                if (s_player_adminCheck <0 ) then {
                    _door2 = cursorTarget;
                    s_player_adminCheck = player addAction ["ADMIN: Check object", "\BB_Buildings\code\admin\adminCheck.sqf", _door2, 1, false, true,"", ""];
                };
            } else {
                player removeAction s_player_adminCheck;
                s_player_adminCheck = -1;
            };
            if((typeOf(cursortarget) in allbuildables_class)) then {
                _text = getText (configFile >> "CfgVehicles" >> typeOf cursorTarget >> "displayName");
                if (s_player_adeleteBuild < 0) then {
                    _okn=cursortarget;
                    s_player_adeleteBuild = player addAction [format["ADMIN: Remove object %1",_text], "\z\addons\dayz_code\actions\dialogs\player_remove_dialog.sqf",_okn, 1, true, true, "", ""];
                };
            } else {
                player removeAction s_player_adeleteBuild;
                s_player_adeleteBuild = -1;
            };
        } else {
            player removeAction s_player_adminCheck;
            s_player_adminCheck = -1;
            player removeAction s_player_adeleteBuild;
            s_player_adeleteBuild = -1;
        };
};

