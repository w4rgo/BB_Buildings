helipad_action = -1;
s_player_dumpback = -1;
s_player_addFriend = -1;
s_player_disarmBomb = -1;
s_player_deleteBuild = -1; 
s_player_addFriend = -1;

fnc_bb_actions = {
    
    _hasToolbox = 	"ItemToolbox" in items player;
    _text = getText (configFile >> "CfgVehicles" >> typeOf cursorTarget >> "displayName");
    _target = cursortarget;       
    /*_userId = (getPlayerUID vehicle player);
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
            if (s_player_adeleteBuild < 0) then {
                _okn=cursortarget;
                s_player_adeleteBuild = player addAction ["ADMIN: Remove object ", "\z\addons\dayz_code\actions\dialogs\player_remove_dialog.sqf",_okn, 1, true, true, "", ""];
            };
        } else {
            player removeAction s_player_adeleteBuild;
            s_player_adeleteBuild = -1;
        };
    };*/
    // Disarm Booby Trap Action
    if(_hasToolbox && !remProc && !procBuild && (cursortarget iskindof "Grave" && cursortarget distance player < 2.5 && !(cursortarget iskindof "Body" || cursortarget iskindof "GraveCross1" || cursortarget iskindof "GraveCross2" || cursortarget iskindof "GraveCrossHelmet" || cursortarget iskindof "Land_Church_tomb_1" || cursortarget iskindof "Land_Church_tomb_2" || cursortarget iskindof "Land_Church_tomb_3" || cursortarget iskindof "Mass_grave"))) then {
        if (s_player_disarmBomb < 0) then {
            s_player_disarmBomb = player addaction [("<t color=""#F01313"">" + ("Disarm Bomb") +"</t>"),"\BB_Buildings\code\actions\player_disarmBomb.sqf","",1,true,true,"", ""];
        };
    } else {
        player removeAction s_player_disarmBomb;
        s_player_disarmBomb = -1;
    };
    
    //------------------------------------------
    //             REMOVE OBJECTS
    //------------------------------------------
    //Remove Object Custom removal test
    if(_hasToolbox && (typeOf(cursortarget) in allbuildables_class) && !(cursortarget getVariable["bb_object_preview",false]) && !bb_state_inProgress ) then {
        if (s_player_deleteBuild < 0) then {
            _okn=cursortarget;
            s_player_deleteBuild = player addAction [format[localize "str_actions_delete",_text], "\z\addons\dayz_code\actions\dialogs\player_remove_dialog.sqf",_okn, 1, true, true, "", ""];
        };
    } else {
        player removeAction s_player_deleteBuild;
        s_player_deleteBuild = -1;
    };
    
    
    
    if ((cursorTarget isKindOf "Man")&& perimeterActivated &&!((name cursorTarget) in baseMembers) ) then {

        if (s_player_addFriend <0 ) then {
            _door2 = cursorTarget;
            s_player_addFriend = player addAction ["Add base member", "\BB_Buildings\code\perimeter\addMember.sqf", _door2, 1, false, true,"", ""];
        };
    } else {
        player removeAction s_player_addFriend;
        s_player_addFriend = -1;
    };


    //Helipad
    
    /*if(_target isKindOf "AllVehicles") then {
        _nearestVehicles = nearestObjects [position _target,["HeliHCivil","Helipadsmall"], 10];
        _inrepairzone = count _nearestVehicles > 0;
        if(_inrepairzone) then {
            if (helipad_action <0 ) then {    
                helipad_action = player addAction [("<t color=""#FF0000"">" + ("Refuel/Rearm/Repair") + "</t>"), "\BB_Buildings\code\helipad\repairVehicles.sqf", _target ,-1, false, false, "",""];
            };
        };
        
    } else {
        player removeAction helipad_action;
        helipad_action = -1;
    };    */
   
    if(cursorTarget isKindOf "TentStorage" and _canDo) then {
        if ((s_player_dumpback < 0) and (player distance cursorTarget < 3)) then {
            s_player_dumpback = player addAction ["Dump backpack in tent", "\BB_Buildings\code\actions\player_dumpBackpack.sqf",cursorTarget, 0, false, true, "",""];
        };
    } else {
        player removeAction s_player_dumpback;
        s_player_dumpback = -1;
    };

};
    
fnc_bb_actionsRemove = {
    //    player removeAction s_player_adminCheck;
    //    s_player_adminCheck = -1;
    //    player removeAction s_player_adeleteBuild;
    //    s_player_adeleteBuild = -1;
    player removeAction s_player_dumpback;
    s_player_dumpback = -1;
    player removeAction s_player_disarmBomb;
    s_player_disarmBomb = -1;
    player removeAction s_player_deleteBuild;
    s_player_deleteBuild = -1;
    player removeAction s_player_addFriend;
    s_player_addFriend = -1;
    
    player removeAction helipad_action;
    helipad_action = -1;
};


    
    
