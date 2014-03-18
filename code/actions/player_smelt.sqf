/*

Smelting script : player_smelt.sqf 1.2 - By W4rGo

Changelog:

1.4 - Added Steel bolts
1.3 - Fixed dupe bug removing the action, on player_addActions.sqf i added a global var smeltAction
1.2 - Added more time to smelt.
1.1 - Added glass smelting
1.0 - Basic smelting 


*/

private ["_wait1","_wait2","_wait3","_tier11Count","_tier12Count","_tier13Count","_smeltedItem","_smelt","_removeTier1","_removeTier2","_removeTier3","_result","_tier11","_tier12","_tier13","_tier2","_tier3","_tier4","_countT1to2","_countT1to3","_countT2to3","_countT1to4","_countT2to4","_countT3to4","_mags","_tier1Count","_tier2Count","_tier3Count","_glassItemCount","_removeGlass","_glassItem","_glassResult","_glassCountNeeded","_prepareSmelt","_timeLeft","_animationCount","_sleepTime"];

_removeTier1=false;
_removeTier2=false;
_removeTier3=false;
_removeGlass=false;

_wait1=false;
_wait2=false;
_wait3=false;
_smelt=false;

_prepareSmelt=false;
_locationPlayer = player modeltoworld [0,0,0];

/*
EXPLANATION OF THE SCRIPT:

(Tier 1 Metal Item)x N ---smelt--> Tier 2 Metal Item
(Tier 1 Metal Item)x N + (Tier 2 Metal Item)x M ---smelt--> Tier 3 Metal Item
(Tier 1 Metal Item)x N + (Tier 2 Metal Item)x M  + (Tier 1 Metal Item)x P---smelt--> Tier 4 Metal Item

(Glass Item) x N ----smelt----> Glass item Result

Renwault Suggestion for example -
// 8 tin cans = tank trap - 
// 6 tin cans + 2 tank traps = scrap metal 
// 4 tin cans + 1 scrap metal + 1 tank trap = wire kit

Tier 1: TrashTinCan
Tier 1: ItemSodaEmpty
Tier 2: ScrapMetal
Tier 3: Wire Fences

*/

//----------------------- YOU CAN CHANGE THE CONFIG IN THIS VARS-------------------
//Metal Tier Setup:
_tier11 = "TrashTinCan";
_tier12 = "ItemSodaEmpty";
_tier13 = "BoltSteel";
_tier2= "ItemWire";
_tier3= "ItemTankTrap";
_tier4= "PartGeneric";


// _tier2 = "ItemTankTrap";
// _tier3 = "PartGeneric";
// _tier4 = "ItemWire";
//----------

//Tier 1 to tier 2 count
_countT1to2 = 6;//8

//Tier 2 to tier 3 count
_countT1to3 = 3;
_countT2to3 = 1;

//Tier 3 to tier 4 count
_countT1to4 = 3;
_countT2to4 = 0;
_countT3to4 = 1;

//Glass smelting:
_glassItem = "TrashJackDaniels";
_glassResult = "PartGlass";
//Number of bottles to smelt
_glassCountNeeded = 6;

if (remProc) then {cutText [format["Your already smelting!",_text], "PLAIN DOWN",1]; breakOut "exit";};
//---------------------------------END CONFIG---------------------------------------
remProc = true;
//Material Count
_mags = magazines player;
if(_tier11 in _mags) then {
	_tier11Count = {_x == _tier11} count magazines player;
} else {
	_tier11Count = 0; 
};

if(_tier12 in _mags) then {
	_tier12Count = {_x == _tier12} count magazines player;
} else {
	_tier12Count = 0; 
};

if(_tier13 in _mags) then {
	_tier13Count = {_x == _tier13} count magazines player;
} else {
	_tier13Count = 0; 
};

_tier1Count = _tier11Count + _tier12Count+ _tier13Count;

if(_tier2 in _mags) then {
	_tier2Count = {_x == _tier2} count magazines player;
} else {
	_tier2Count = 0; 
};

if(_tier3 in _mags) then {
	_tier3Count = {_x == _tier3} count magazines player;
} else {
	_tier3Count = 0; 
};

if(_glassItem in _mags) then {
	_glassItemCount = {_x == _glassItem} count magazines player;
} else {
	_glassItemCount = 0; 
};


//Tier 1 to 2
switch(true) do {
	//Tier 1 to 2
	case(_tier1Count == _countT1to2):
	{
		_smeltedItem=_tier2;
		_prepareSmelt=true;
		_removeTier1=true;
		_wait1=true;
	//Tier 2 to 3
	};
	
	case(_glassItemCount == _glassCountNeeded):
	{
		_smeltedItem=_glassResult;
		_prepareSmelt=true;
		_removeGlass=true;
		_wait1=true;
	//glass
	};
	
	case((_tier1Count == _countT1to3) && (_tier2Count == _countT2to3)) :
	{
		_smeltedItem=_tier3;
		_prepareSmelt=true;
		_removeTier1=true;
		_removeTier2=true;
		_wait2=true;
	//Tier 3 to 4
	};
	case ((_tier1Count == _countT1to4) && (_tier2Count == _countT2to4) && (_tier3Count == _countT3to4)):
	{
		_smeltedItem=_tier4;
		_prepareSmelt=true;
		_removeTier1=true;
		_removeTier2=true;
		_removeTier3=true;
		_wait3=true;

	};
	default
	{
		_prepareSmelt=false;
	};
};

//Begin smelt.


	
if(_prepareSmelt) then {

	_sleepTime = 5;
	switch(true) do {
		case(_wait1):
		{
			_timeLeft=_sleepTime;
			_animationCount=1;
		};
		case(_wait2):
		{
			_timeLeft=_sleepTime*2;
			_animationCount=2;
		};
		case(_wait3):
		{
			_timeLeft=_sleepTime*3;
			_animationCount=3;
		};
		default
		{
			_timeLeft=_sleepTime;
			_animationCount=1;
		};
	};
	
	cutText [format["You begin smelting. %1 seconds left.",_timeLeft], "PLAIN DOWN"];
	for "_i" from 0 to _animationCount do {
		player playActionNow "Medic";
		[player,"repair",0,false] call dayz_zombieSpeak;
		sleep _sleepTime;
		_timeLeft = _timeLeft - 5;
		if (player distance _locationPlayer > 0.2) then {cutText [format["You canceled smelting by moving",_text], "PLAIN DOWN",1]; remProc = false; breakOut "exit";};
		if(_timeLeft >0 ) then {
			cutText [format["You continue smelting. %1 seconds left.",_timeLeft], "PLAIN DOWN"];
		};
	};
	//Check again to see if the player didnt took any item away
	
	//Tier 1 to 2
	switch(true) do {
	//Tier 1 to 2
		case(_tier1Count == _countT1to2):
		{
			_smelt=true;
		//Tier 2 to 3
		};
		
		case(_glassItemCount == _glassCountNeeded):
		{
			_smelt=true;
		//glass
		};
		
		case((_tier1Count == _countT1to3) && (_tier2Count == _countT2to3)) :
		{
			_smelt=true;
		//Tier 3 to 4
		};
		case ((_tier1Count == _countT1to4) && (_tier2Count == _countT2to4) && (_tier3Count == _countT3to4)):
		{
			_smelt=true;
		};
		default
		{
			_smelt=false;
		};
	};	
	
	if(_smelt) then {	
	
	
	//Remove tier 1 items 
		if(_tier1Count>0 && _removeTier1 ) then {
			for "_i" from 0 to _tier11Count do {
				player removeMagazine _tier11;
			};
			for "_i" from 0 to _tier12Count do {
				player removeMagazine _tier12;
			};
            for "_i" from 0 to _tier13Count do {
				player removeMagazine _tier13;
			};
		};
		//Remove tier 2 items
		if(_tier2Count>0 && _removeTier2) then {
			for "_i" from 0 to _tier2Count do {
				player removeMagazine _tier2;
			};
		};
		//Remove tier 3 items
		if(_tier3Count>0 && _removeTier3) then {
			for "_i" from 0 to _tier3Count do {
				player removeMagazine _tier3;
			};
		};
		
		//Remove glass items
		if(_glassItemCount>0 && _removeGlass) then {
			for "_i" from 0 to _glassItemCount do {
				player removeMagazine _glassItem;
			};
		};
		remProc = false;
		_result = [player,_smeltedItem] call BIS_fnc_invAdd;
		if (_result) then {
			remProc = false;
			cutText ["Your items were smelted sucessfully!", "PLAIN DOWN"];
		} else {
			remProc = false;
			cutText ["Oops! Your smelting was canceled. Try again!", "PLAIN DOWN"];
		};
	
	} else {
		cutText ["You need the exact amount of items to smelt. Dont take items away!!", "PLAIN DOWN"];
		sleep 1;
		remProc = false;
	};
	
} else {
	cutText ["You need the exact amount of items to smelt.", "PLAIN DOWN"];
	sleep 1;
	remProc = false;
};
	