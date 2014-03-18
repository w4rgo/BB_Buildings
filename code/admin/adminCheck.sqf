 _object = cursorTarget;

_camoNetsClasses = ["Land_CamoNetB_EAST","Land_CamoNetB_NATO","Land_CamoNetVar_EAST","Land_CamoNetVar_NATO","Land_CamoNet_EAST","Land_CamoNet_NATO"];
if(isNull _object) then {
    _camoNets = nearestObjects [player, _camoNetsClasses, 10];
    if ((count _camoNets ) > 0) then {
        _nearestNet = _camoNets select 0;
        _object = _nearestNet;
    }; 

};


_classname = typeOf _object;
_code = _object getVariable ["ObjectID","0"];
keyCode = _code;
_location = str(getpos _object); 

_clan = _object getVariable["ClanID","0"];

if(_object isKindOf "CAManBase") then {
    _clan = _object getVariable ["clanTag","0"];
};

_clanAdmin = _object getVariable["clanAdmin",false];


//_text = format["%1 : %2 : %3 : %4 : %5,%6",_classname, _code,_location, _clan];
_text = [];
_text set [count _text, _classname];
_text set [count _text, _code];
_text set [count _text, _location];
_text set [count _text, _clan];
/*_text set [count _text, "Soy admin de clan?:"];
_text set [count _text, str(clanAdmin)];
_text set [count _text, "Es admin de clan?:"];
_text set [count _text, str(_clanAdmin)];*/

copyToClipboard _location;
"### Admin Check ###" hintC _text;