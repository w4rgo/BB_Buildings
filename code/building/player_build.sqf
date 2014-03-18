
// Location placement declarations
if(bb_state_inProgress) exitWith {
    cutText ["You are already building!!!", "PLAIN DOWN"];
    
};


//Obtenemos informacion sobre la localizacion del jugador
_locationPlayer = player modeltoworld [0,0,0];
_location 		= player modeltoworld [0,0,0]; // Used for object start location and to keep track of object position throughout
_attachCoords = [0,0,0];
_dir 			= getDir player;
_building 		= nearestObject [player, "Building"];
_staticObj 		= nearestObject [player, "Static"];

//Cerramos el dialogo que haya abierto
disableSerialization;
closedialog 1;

//Obtenemos la clase seleccionada con sus requerimientos
_requirements=[];
_buildable = (allbuildables select currentBuildRecipe);
_classname ="";
_chosenRecipe = _buildable select 0;
_classname = _buildable select 1;
_requirements=_buildable select 2;


//Global build_list reference params:
//[_qtyT, _qtyS, _qtyW, _qtyL, _qtyM, _qtyG], "Classname", [_attachCoords, _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown];

//Esto es para que funcione con el boton derecho en el menu
// Check what object is returned from global array, then return classname

/*
for "_i" from 0 to ((count allbuildables) - 1) do
{
    _buildable = (allbuildables select _i) select _i - _i;
    _result = [_buildables,_buildable] call BIS_fnc_areEqual;
    if (_result) then {
        _classname = (allbuildables select _i) select _i - _i + 1;
        _requirements = (allbuildables select _i) select _i - _i + 2;
        _chosenRecipe = _buildable;
    };
    _buildable = [];
};*/
// Quit here if no proper recipe is acquired else set names properly
if (_classname == "") then {cutText ["You need the EXACT amount of whatever you are trying to build without extras.", "PLAIN DOWN"];breakOut "exit";};

//Extraemos los valores que nos importan de los requerimientos.
bb_current_attachCoords 	= _requirements select 0;
_startPos 		= _requirements select 1;
_modDir 		= _requirements select 2;
_isDestrutable	= _requirements select 6;



// Get _startPos for object
_location = player modeltoworld _startPos;

//Get Building to build

_text = _classname;

//Comprobamos que podamos construir este objeto en este lugar

_canBuildHere = [_classname] call fnc_build_canBuildHere;

if(!_canBuildHere) then {
    breakOut "exit";
};

_hasMats = [_chosenRecipe] call fnc_build_hasMats;
if(!_hasMats) then {
    breakOut "exit";
};
//Creamos el objeto.
[_classname,_location,_modDir] call fnc_build_create;
//Empezamos el emplazamiento.
_done = [] call fnc_build_start;
//Esperamos a que el jugador le de a finish.
//waitUntil{!bb_state_building};
//Si no se ha cancelado por algun motivo.
_built=false;
if(_done) then {
    //Desplegamos el objeto en su posicion final
    [_isDestrutable] call fnc_build_deploy;
    //Iniciamos el bucle en el que el jugador puede aceptar o cancelar, si hace algo ilegal se cancela tb.
    _built = [_chosenRecipe] call fnc_build_loop;
    
} else {
    [] call fnc_build_delete;
};
diag_log(format["BB: built %1",_built]);
if(_built) then {
    [] call fnc_build_removeMats;
    //Guardamos el objeto en la db
    [] call fnc_build_saveDB;
    
    [] call fnc_build_clear;
} else {
    [] call fnc_build_delete;
};

[] call fnc_build_finish;

