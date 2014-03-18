// ################################### BUILD LIST ARRAY SERVER SIDE ######################################## START
/*
Build list by Daimyo for SERVER side
Add and remove recipes, Objects(classnames), requirments to build, and town restrictions + extras
This method is used because we are referencing magazines from player inventory as buildables.
Main array (_buildlist) consist of 34 arrays within. These arrays contains parameters for player_build.sqf
From left to right, each array contains 3 elements, 1st: Recipe Array, 2nd: "Classname", 3rd: Requirements array. 
Check comments below for more info on parameters
*/
private["_classname","_isSimulated","_disableSims","_objectSims","_objectSim","_requirements","_isStructure","_structure","_wallType","_removable","_buildlist","_build_townsrestrict"];
// Count is 34
// Info on Parameters (Copy and Paste to add more recipes and their requirments!):
//[TankTrap, SandBags, Wires, Logs, Scrap Metal, Grenades], "Classname", [_attachCoords, _startPos, _modDir, _toolBox, _eTooldAllowed _removable, _isDestructable];
cargoStorage="USVehicleBox_EP1";
    

    _buildlist = [
    
    [[1, 0, 1, 0, 1, 0], "BB_Flag_Pole",		[[0,2.5,.6],[0,2,0], 0,	true, true, false, false]],//Booby Traps --1     
    [[1, 0, 1, 0, 1, 0], "BB_Main_Panel",		[[0,2.5,.6],[0,2,0], 0,	true, true, false, false]],//Booby Traps --1     
    [[2, 0, 2, 1, 0, 0], "Small_Door",                  [[0,3,1.75],[0,2,0], 0, true, true, false, false]],//Booby Traps --1 
    //[[2, 0, 2, 1, 0, 0], "Admin_Small_Door",                  [[0,3,1.75],[0,2,0], 0, true, true, false, false]],//Booby Traps --1 
    [[2, 0, 2, 1, 1, 0], "Medium_Door", 		[[0,5,1.75],[0,2,0], 0, true, true, false, false]],//Booby Traps --1 
    [[2, 1, 1, 1, 2, 0], "Garage_Door", 		[[0,5,1.75],[0,2,0], 0, true, true, false, false]],//Booby Traps --1 
    //[[2, 1, 1, 1, 2, 0], "Admin_Garage_Door", 		[[0,5,1.75],[0,2,0], 0, true, true, false, false]],//Booby Traps --1 
    [[2, 0, 1, 0, 1, 0], "BB_Aux_Panel",		[[0,2.5,.6],[0,2,0],0, 	true, true, false, false]],//lights Panel w/ KeyPad --3
    [[1, 0, 0, 0, 0, 0], "Land_CncBlock",		[[0,3,.4], [0,2,0],0, 	true, true, false, false]],//Booby Traps --1 
    [[2, 0, 0, 3, 1, 0], "Concrete_Wall_EP1", 		[[0,5,1.75],[0,2,0], 0, true, true, false, false]],//Booby Traps --1 
    [[0, 1, 0, 0, 1, 3], "Grave", 			[[0,2.5,.1],[0,2,0], 0,	true, true, true,  false]],//Booby Traps --1
    [[3, 3, 2, 2, 0, 0], "WarfareBDepot",		[[0,18,2], [0,15,0],90, true, true, false, false]],//Booby Traps --1 
    [[4, 1, 2, 2, 0, 0], "Base_WarfareBBarrier10xTall", [[0,10,1], [0,10,0], 0, true, true, false, false]],//Booby Traps --1 
    [[2, 1, 2, 1, 0, 0], "WarfareBCamp",		[[0,12,1], [0,10,0], 0, true, true, false, false]],//Booby Traps --1 
    [[2, 1, 1, 1, 0, 0], "Base_WarfareBBarrier10x", 	[[0,10,.6], [0,10,0],0, true, true, false, false]],//Booby Traps --1 
    [[2, 2, 0, 2, 0, 0], "Land_fortified_nest_big", 	[[0,12,1], [2,8,0], 180,true, true, false, false]],//Booby Traps --1 
    [[2, 1, 2, 2, 0, 0], "Land_Fort_Watchtower",	[[0,10,2.2],[0,8,0],90, true, true, false, false]],//Booby Traps --1 
    [[4, 1, 1, 3, 0, 0], "Land_fort_rampart_EP1", 	[[0,7,.2],[0,8,0], 0, 	true, true, false, false]],//Booby Traps --1 
    [[2, 1, 1, 0, 0, 0], "Land_HBarrier_large", 	[[0,7,1], [0,4,0],0, 	true, true, false, false]],//Booby Traps --1 
    [[2, 1, 0, 1, 0, 0], "Land_fortified_nest_small",	[[0,7,1], [0,3,0],90,   true, true, false, false]],//Booby Traps --1 
    [[0, 1, 1, 0, 0, 0], "Land_BagFenceRound",		[[0,4,.5], [0,2,0],180, true, true, false, false]],//Booby Traps --1 
    [[0, 1, 0, 0, 0, 0], "Land_fort_bagfence_long", 	[[0,4,.3], [0,2,0],0, 	true, true, false, false]],//Booby Traps --1 
    [[6, 0, 0, 0, 2, 0], "Land_Misc_Cargo2E",		[[0,7,2.6], [0,5,0],90, true, true, false, false]],//Booby Traps --1 
    [[5, 0, 0, 0, 1, 0], "Misc_Cargo1Bo_military",	[[0,7,1.3], [0,5,0],90, true, true, false, false]],//Booby Traps --1 
    [[3, 0, 0, 0, 1, 0], "Ins_WarfareBContructionSite",	[[0,7,1.3], [0,5,0],90, true, true, false, false]],//Booby Traps --1 
    [[1, 1, 0, 2, 1, 0], "Land_pumpa",			[[0,3,.4], [0,3,0],0, 	true, true, false, false]],//Booby Traps --1
    [[4, 0, 0, 0, 0, 0], "Hhedgehog_concrete",		[[0,5,.6], [0,4,0],0, 	true, true, false, false]],//Booby Traps --1 
    [[1, 0, 0, 0, 1, 0], "Misc_cargo_cont_small_EP1",	[[0,5,1.3], [0,4,0],90, true, true, false, false]],//Booby Traps --1 
    [[1, 0, 0, 2, 0, 0], "Land_prebehlavka",		[[0,6,.7],[0,3,0],  90, true, true, false, false]],//Booby Traps --1 
    [[2, 0, 0, 0, 0, 0], "Fence_corrugated_plate",	[[0,4,.6], [0,3,0],0,	true, true, false, false]],//Booby Traps --1 
    [[2, 0, 1, 0, 0, 0], "ZavoraAnim", 			[[0,5,4.0], [0,5,0],0, 	true, true, false, false]],//Booby Traps --1 
    [[0, 0, 7, 0, 1, 0], "Land_tent_east", 		[[0,8,1.7],[0,6,0], 0,  true, true, false, false]],//Booby Traps --1 
    [[0, 0, 6, 0, 1, 0], "Land_CamoNetB_EAST",		[[0,10,2], [0,10,0],0, 	true, true, false, false]],//Booby Traps --1 
    [[0, 0, 5, 0, 1, 0], "Land_CamoNetB_NATO", 		[[0,10,2], [0,10,0],0, 	true, true, false, false]],//Booby Traps --1 
    [[0, 0, 4, 0, 1, 0], "Land_CamoNetVar_EAST",	[[0,10,1.2],[0,7,0],0, 	true, true, false, false]],//Booby Traps --1 
    [[0, 0, 3, 0, 1, 0], "Land_CamoNetVar_NATO", 	[[0,10,1.2],[0,7,0],0, 	true, true, false, false]],//Booby Traps --1 
    [[0, 0, 2, 0, 1, 0], "Land_CamoNet_EAST",		[[0,8,1.2], [0,7,0],0, 	true, true, false, false]],//Booby Traps --1 
    [[0, 0, 1, 0, 1, 0], "Land_CamoNet_NATO",		[[0,8,1.2],[0,7,0], 0, 	true, true, false, false]],//Booby Traps --1 
    [[0, 0, 2, 2, 0, 0], "Fence_Ind_long",		[[0,5,.6],[-4,1.5,0],0, true, true, false, false]],//Booby Traps --1 
    [[0, 0, 2, 0, 0, 0], "Fort_RazorWire",		[[0,5,.8], [0,4,0], 0, 	true, true, false, false]],//Fort_RazorWire --33
    [[0, 0, 1, 0, 0, 0], "Fence_Ind",  			[[0,4,.7], [0,2,0], 0, 	true, true, false, false]], //Fence_Ind 	
    [[3, 0, 2, 2, 1, 0], "BB_Yellow_garage",               [[0,10,1], [0,12,0],0, 	true, true, false, false]], //Fence_Ind 	
    [[2, 0, 1, 1, 0, 0], "Land_Fire_barrel",		[[0,3,.4], [0,3,0],0, 	true, true, false, false]],//barrel --18
    [[8, 0, 0, 0, 1, 0], "Land_Ind_TankSmall",		[[0,7,1.3], [0,5,0],90, true, true, false, false]],//refuel
    [[3, 0, 2, 3, 0, 0], "Land_Nav_Boathouse_PierL",	[[0,7,1.3], [0,5,0],90, true, true, false, false]],//refuel
    //[[4, 0, 1, 2, 1, 0], "HeliHCivil",	                [[0,10,2.2],[0,8,0],90, true, true, false, false]],//refuel 
    [[2, 0, 2, 2, 0, 0], "Satelit",			[[0,5,1.3],[0,4,0], 0, 	true, true, false, false]],//lights Panel w/ KeyPad --3
    [[0, 0, 1, 4, 1, 0], "Loudspeakers_EP1",		[[0,5,1.3],[0,4,0], 0, 	true, true, false, false]],//lights Panel w/ KeyPad --3
    [[0, 0, 1, 3, 1, 0], "Land_ladder_half",		[[0,5,1.3],[0,4,0], 0, 	true, true, false, false]],//lights Panel w/ KeyPad --3
    [[0, 0, 1, 2, 1, 0], "Land_ladder",			[[0,5,1.3],[0,4,0], 0, 	true, true, false, false]],//lights Panel w/ KeyPad --
    [[1, 0, 1, 2, 2, 0], "Land_Misc_Scaffolding",	[[0,6,1.3],[0,6,0], 0, 	true, true, false, false]],//lights Panel w/ KeyPad --3
    [[0, 0, 0, 3, 2, 0], "BB_Big_Stairs",               [[0,18,2],[0,15,0], 0, 	true, true, false, false]],//lights Panel w/ KeyPad --3
    [[0, 0, 0, 0, 4, 0], "Land_komin",		        [[0,18,10],[0,15,0],0,  true, true, false, false]],//lights Panel w/ KeyPad --3
    [[2, 0, 2, 0, 1, 0], "SearchLight_UN_EP1",		[[0,5,1.3],[0,4,0], 0, 	true, true, false, false]],//lights Panel w/ KeyPad --3
    //[[1, 0, 2, 2, 0, 0], "Land_Ind_Shed_01_main",	[[0,7,1.3],[0,4,0], 0, 	true, true, false, false]],//lights Panel w/ KeyPad --3
    [[1, 0, 3, 1, 2, 0], "M2StaticMG_US_EP1",		[[0,3,.4], [0,3,0], 0, 	true, true, false, false]],//lights Panel w/ KeyPad --3
    [[3, 3, 3, 0, 0, 0], "Land_ConcreteBlock",          [[0,7,.2], [0,2,0], 0, 	true, true, false, false]],//Land_CncBlock --19
    [[1, 0, 0, 3, 0, 0], "Land_prolejzacka",            [[0,5,.8], [0,4,0], 0, 	true, true, false, false]],//Land_CamoNetVar_NATO --29
    [[0, 2, 0, 1, 0, 0], "Land_fort_bagfence_corner",   [[0,4,.6], [0,3,0], 0, 	true, true, false, false]],//Land_CamoNet_EAST --30
    [[0, 2, 0, 0, 0, 0], "Land_HBarrier1",		[[0,4,.6], [0,3,0], 0, 	true, true, false, false]],//Land_CamoNet_NATO --31
    [[0, 3, 0, 0, 0, 0], "Land_HBarrier3",		[[0,4,.6], [0,3,0], 0, 	true, true, false, false]], //Fence_Ind_long --32
    [[2, 0, 2, 1, 2, 0], "KORD_high",                   [[0,3,.4], [0,3,0], 0, 	true, true, false, false]],//lights Panel w/ KeyPad --3
    [[1, 1, 2, 1, 2, 0], "Fort_Nest_M240",              [[0,5,1.3], [0,4,0],0,  true, true, false, false]],//Misc_cargo_cont_small_EP1 --21
    [[2, 0, 1, 3, 0, 0], "Land_Wall_L3_gate_EP1", 	[[0,5,1.75],[0,2,0], 0,	true, true, false, false]],//Gate Concrete Wall --2
    [[2, 3, 0, 2, 0, 0], "Land_Wall_L3_5m_EP1", 	[[0,5,1.75],[0,2,0], 0,	true, true, false, false]],//Gate Concrete Wall --2
    [[1, 2, 0, 1, 0, 0], "Wall_L1_2m5_EP1", 		[[0,5,1.75],[0,2,0], 0,	true, true, false, false]],//Gate Concrete Wall --2
    [[2, 3, 0, 1, 0, 0], "Wall_L1_5m_EP1", 		[[0,5,1.75],[0,2,0], 0,	true, true, false, false]],//Gate Concrete Wall --2
    [[3, 3, 0, 2, 0, 0],"Land_A_Mosque_big_minaret_1_EP1",[[0,18,8],[0,15,0],0, true, true, false, false]],//Gate Concrete Wall --2
    [[2, 0, 0, 3, 0, 0], "Land_Wall_L1_gate_EP1", 	[[0,5,1.75],[0,2,0], 0,	true, true, false, false]],//Gate Concrete Wall --2
    [[3, 3, 0, 2, 0, 0], "mbg"                         ,[[0,10,1], [0,12,0],0, 	true, true, false, false]], //bunker 1	
    [[3, 3, 0, 2, 0, 0], "mbg2"                        ,[[0,10,1], [0,12,0],0, 	true, true, false, false]], //bunker 2
    [[1, 2, 0, 0, 0, 0], "BB_Small_Roof",               [[0,5,1.3], [0,4,0],0,  true, true, false, false]],//tejadin
    [[4, 1, 2, 2, 0, 0], "BB_Operate_Roof",             [[0,10,1], [0,10,0], 0, true, true, false, false]],//Tejao cata
    [[2, 1, 2, 2, 0, 0], "e10",                         [[0,10,2.2],[0,8,0],90, true, true, false, false]],//rampa cata
    [[1, 3, 0, 0, 0, 0], "BB_Small_Wall",               [[0,5,1.3], [0,4,0],0,  true, true, false, false]],//murete 
    [[1, 1, 0, 0, 0, 0], "BB_Small_Wall_V",               [[0,5,1.3], [0,4,0],0,  true, true, false, false]],//murete 
    [[1, 1, 0, 0, 0, 0], "BB_Small_Wall_H",               [[0,5,1.3], [0,4,0],0,  true, true, false, false]],//murete 
    [[1, 3, 2, 0, 0, 0], "BB_Cinderwall",               [[0,6,1.3], [0,4,0],0,  true, true, false, false]],//murete ladrillos
    //[[4, 1, 2, 2, 0, 0], "Helipadsmall",                [[0,10,1], [0,10,0], 0, true, true, false, false]],//Booby Traps --1 
    [[1, 0, 1, 2, 0, 0], "ARP_Objects_cam1",	        [[0,3,1.3],[0,2,0], 0, 	true, true, false, true]],//lights Panel w/ KeyPad --3
    [[2, 0, 2, 2, 0, 2], "Land_Barrel_sand",	        [[0,5,1.3],[0,4,0], 0, 	true, true, false, false]],//lights Panel w/ KeyPad --3
    [[2, 0, 2, 1, 2, 0], "land_x_vez_tex",		[[0,7,1.3],[0,4,0], 0, 	true, true, false, false]],//torre namalsk
    [[4, 0, 2, 2, 0, 0], "land_hlaska", 		[[0,5,1.3],[0,4,0], 0, 	true, true, false, false]],//torre namalsk 2
    [[2, 0, 2, 2, 0, 0], "land_seb_mine_maringotka",    [[0,5,1.3],[0,4,0], 0, 	true, true, false, false]],  //carrito amarillo
   // [[0, 0, 0, 0, 4, 0], "BB_Hangar",                   [[0,25,2], [0,15,0],90, true, true, false, false]],  //carrito amarillo
    [[2, 0, 2, 2, 0, 0], "lighthauseD", 		[[0,7,1.3],[0,4,0], 0, 	true, true, false, false]],//torre namalsk 2
    [[1, 0, 0, 0, 0, 0], "BB_Portatil", 		[[0,3,1.3],[0,4,0], 0, 	true, true, false, false]],
    [[2, 3, 0, 1, 0, 0], "BB_Stairs_Small", 		[[0,5,1.75],[0,2,0], 0,	true, true, false, false]],//Gate Concrete Wall --2
    [[2, 0, 2, 1, 2, 0], "BAF_GPMG_Minitripod_D",       [[0,3,.4], [0,3,0], 0, 	true, true, false, false]],//lights Panel w/ KeyPad --3
    [[3, 1, 2, 2, 0, 0], "SmallWallW",                  [[0,10,1], [0,10,0], 0, true, true, false, false]],//Booby Traps --1 
    [[2, 3, 0, 1, 0, 0], "BB_Stairs_Small2", 		[[0,5,1.75],[0,2,0], 0,	true, true, false, false]],//Gate Concrete Wall --2
    [[1, 0, 0, 2, 0, 0], "BB_Wooden_Planks",		[[0,6,.7],[0,3,0],  90, true, true, false, false]]//Booby Traps --1 

    ];
    
diag_log("build list : " + str _buildlist);
    
//TankTrap, SandBags, Wires, Logs, Scrap Metal, Grenades
// Build allremovables array for remove action
/*for "_i" from 0 to ((count _buildlist) - 1) do
{
	_removable = (_buildlist select _i) select _i - _i + 1;
	if (_removable != "Grave") then { // Booby traps have disarm bomb
	allremovables set [count allremovables, _removable];
	};
};*/
// Build classnames array for use later
allbuildables_class = [];
{
    _classname = _x select 1;
    allbuildables_class set [count allbuildables_class, _classname];
    //diag_log("ADDED : "+ _classname); 
} foreach _buildlist;

/*
*** Remember that the last element in ANY array does not get comma ***
Notice lines 47 and 62
*/
// Towns to restrict from building in. (Type exact name as shown on map, NOT Case-Sensitive but spaces important)
// ["Classname", range restriction];
_build_townsrestrict = [
//["Lyepestok", 1000],
//["Sabina", 900],
//["Branibor", 600],
//["Bilfrad na moru", 400],
//["Mitrovice", 350],
//["Bilfrad na moru", 300],
//["Stari Dovr", 150],
//["Kryvoe", 300],
//["Repkov", 150],
//["Sevastopol", 400],
//["Vodice", 200],
//["Bylov", 400],
//["Ekaterinburg", 400],
//["Chrveni Gradok", 400],
//["Doriyanov", 250],
//["Vinograd", 300],
//["Solibor", 400],
//["Novy Bor", 300],
//["Martin", 400],
//["Yaroslav", 400],
//["Jaroslavski Airport", 600],
//["Airport Dubovo", 600],
//["Krasnoznamen'sk Airport", 400],
//["Krasnoznamensk", 700],
//["Seven", 300],
//["Cernovar", 300], 
//["Chertova Syena", 300],
//["Blato", 300]
];
// Here we are filling the global arrays with this local list
allbuildables = _buildlist;
allbuild_notowns = _build_townsrestrict;


/*
This Area is for extra arrays that need to be built via above arrays
*/
//Determine Structure buildables to build structures array
/*for "_i" from 0 to ((count _buildlist) - 1) do
		{
			_requirements = (_buildlist select _i) select _i - _i + 2;
			_isStructure = _requirements select 11;
			_structure = (_buildlist select _i) select _i - _i + 1;
			if (_isStructure) then {
			structures set [count structures, _structure];
			};
		};*/
	
//Build all buildables (not just walls) for antiWall script
/*for "_i" from 0 to ((count _buildlist) - 1) do
	{
		_wallType = (_buildlist select _i) select _i - _i + 1;
		//Add more exceptions here so that when players get out of vehicles, they wont call anti-wall with these objects
		if (_walltype != "Grave" && _walltype != "Infostand_2_EP1" && _walltype != "Land_pumpa" && _walltype != "ZavoraAnim") then {
		wallarray set [count wallarray, _wallType];
		};
	};*/
//Disable physics locally on objects that we dont want moving (for now, gate panel)
/*_objectSims = [];
	for "_i" from 0 to ((count _buildlist) - 1) do
	{
		_requirements = (_buildlist select _i) select _i - _i + 2;
		_isSimulated = _requirements select 12;
		_objectSim = (_buildlist select _i) select _i - _i + 1;
		//Add more exceptions here so that when players get out of vehicles, they wont call anti-wall with these objects
		if (!_isSimulated) then {
		_objectSims set [count _objectSims, _objectSim];
		};
	};*/
//Now we have array, lets disable simulation locally on all objects that require it (basically disabling physics for these)
waitUntil {!(isNull player)};
_objectSims = ["BB_Main_Panel","BB_Aux_Panel","Satelit"];
_disableSims = nearestObjects [player, _objectSims, 30000];
{
    _x enableSimulation false;
} foreach _disableSims;
