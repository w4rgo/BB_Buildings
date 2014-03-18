/*****************************BASE BUILDING CONFIGURATION**********************************/
baseSize=300;   //size of a base in arma 2 meters
baseAdmins = [ "3517312" , "8752772","19036806" , "22646726" , "31883910" , "9307078" , "3517312" ,"9529030","110791110","107446534","121814726"];  //Admins of the server
uniqueBase=true; // A clan only can own a base
baseObjectNumber=300;

/****************************DO NOT TOUCH ANYTHING BELOW***********************************/


//Strings
	globalSkin 			= "";
	//Arrays
	allbuildables_class = [];
	allbuildables 		= [];
	allbuild_notowns 	= [];
	allremovables 		= [];
	wallarray 			= [];
	structures			= [];
	CODEINPUT 			= [];
	keyCode 			= [];
	haloProc			= false;
	remProc 			= false;
	hasBuildItem 		= false;
	rem_procPart 		= false;
	procChop 			= false;
	repProc 			= false;
	keyValid 			= false;
	procBuild 			= false;
	removeObject		= false;
	currentBuildRecipe 	= 0;
//EXTENDED BASE BUILDING
        baseBuildingExtended=true;
        rotateDir = 0;
        objectHeight=0;
        objectDistance=0;
        objectParallelDistance=0;
        rotateIncrement=30;
        objectIncrement=0.3;
        objectTopHeight=8;
        objectLowHeight=-10;
        maxObjectDistance=6;
        minObjectDistance=-1;

        

//BASE BUILDING INDIVIDUAL DOOR CLASS
        individualDoorClass="Concrete_Wall_EP1";
	s_player_gateActions = [];
//DOORS
	doorActions = [];
	alreadyDoorCode=false;
	alreadyGateCode= false;
	alreadyAllDoors=false;
        cargoStorage="USVehicleBox_EP1";
        doorkeyValid=false;

//ALARMS
	perimeterActivated = false;
	soundAlarm = false;
	baseMembers=[(name player)];
	alreadyActivatedLevers=[];
	openingGates=false;
        openingRoofs = false;




//ADMIN

bb_admin_activated=false;
 
 //Nuke zeds
 nuke_zeds_activated=false
 
