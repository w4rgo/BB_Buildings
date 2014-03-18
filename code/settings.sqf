// This file is for server specific settings. Refer to the documentation at
// development.dayztaviana.com site for further details.

diag_log "Started executing basebuilding settings file.";						// Log start

if (!isDedicated) then {
	//_null = [] execVM "\BB_Buildings\code\dy_work\take_itemFix.sqf"; 	// Take item dupe fix
	_null = [] execVM "\BB_Buildings\code\dy_work\player_bomb.sqf";		// Booby traps bomb
	//_null = [] execVM "\BB_Buildings\code\dy_work\initWall.sqf";		// Doesnt allow players to get out of vehicle through specified walls
	//_null = [] execVM "\BB_Buildings\code\dy_work\antiHeli.sqf";		// Makes player get out of vehicle of your choice
	_null = [] execVM "\BB_Buildings\code\dy_work\build_list.sqf";		// build_list for building arrays
	//_null = [] execVM "\BB_Buildings\code\helipad\helipadMonitor.sqf";        
        //_null = [] execVM "\BB_Buildings\code\dy_work\take_backPackfix.sqf"; //backpack dupe fix
};

diag_log "Finished executing basebuilding settings file.";						// Log finish